#' Flatten list and convert to tibble
#' 
#' This function is a convenience function to handle deeply nested records usually 
#' returned by parsed JSON or XML that need to be converted into a data frame where 
#' each record represents a row in the data frame.
#' 
#' @importFrom tibble as_tibble_row
#' @importFrom purrr list_modify pluck
#' @importFrom rlist list.flatten
#' @param x \code{list}; a list to be extracted into a \code{tbl_df}.
#' @return \code{tbl_df} parsed from the flattened list.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
flatten_tbl_df <- function(x){
  
  # set aside errors
  errors <- x %>% pluck("errors")
  
  x_tbl <- x %>% 
    list_modify("errors" = NULL) %>% 
    list.flatten() %>% 
    as_tibble_row()
  
  # convert errors to list column (since it can have multiple elements)
  if(!is.null(errors)){
    x_tbl$errors <- list(errors) 
  }
  
  return(x_tbl)
}

#' Flatten list column
#' 
#' This function is a convenience function to handle a list column in a \code{tbl_df}. 
#' The column is unnested wide while preserving the row count.
#' 
#' @importFrom dplyr select all_of
#' @param df \code{tbl_df}; a data frame with list column to be extracted into 
#' multiple individual columns.
#' @param col \code{character}; the name of the column to unnest
#' @return \code{tbl_df} parsed from the flattened list.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
unnest_col <- function(df, col){
  key_rows <- df %>% select(-all_of(col))
  col_data <- df %>% select(all_of(col))
  safe_bind_rows(
    lapply(1:nrow(key_rows), 
           FUN=function(x, y, z){
             key_record <- y[x,]
             col_to_unnest <- flatten_tbl_df(z[x,,drop=FALSE])
             if(!is.null(col_to_unnest) && 
                is.tbl(key_record) && 
                is.tbl(col_to_unnest) && 
                (nrow(col_to_unnest) > 0)){
               combined <- bind_cols(key_record, col_to_unnest)  
             } else {
               combined <- key_record
             }
             return(combined)
           }, 
           key_rows, 
           col_data
    ))
}

#' Remove all zero-length elements from list ignoring AsIs elements
#' 
#' This function wraps the \code{\link[purrr:keep]{compact}} function to recursively 
#' remove elements from lists that have zero length, but spares the elements wrapped 
#' in \code{\link[base:AsIs]{I}} which mean something specific when passing as JSON.
#' 
#' @importFrom purrr as_mapper discard
#' @importFrom rlang is_empty
#' @param .x \code{list} or \code{vector}
#' @param .p \code{function}; predicate function that identifies elements to discard
#' @return \code{list} containing no empty elements, but does leave anything that 
#' has been wrapped in \code{I()} making the class \code{AsIs} which signals 
#' to \code{\link[jsonlite]{toJSON}} not to drop the value, but to set as null.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
compact2 <- function(.x, .p = identity) {
  .f <- as_mapper(.p)
  discard(.x, function(x) is_empty(.f(x)) & class(x) != "AsIs")
}

#' Remove all NULL or zero-length elements from list
#' 
#' This function wraps the \code{\link[purrr:keep]{compact}} function to recursively 
#' remove elements from lists that contain no information.
#' 
#' @importFrom purrr map_if compact
#' @param x \code{list}; a list to be cleaned.
#' @return \code{list} containing no empty elements.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
drop_empty_recursively <- function(x) {
  x %>% 
    map_if(is.list, drop_empty_recursively) %>% 
    compact2()
}

#' Set all NULL or zero-length elements from list to NA
#' 
#' This function is a simple \code{\link[purrr:modify]{modify_if}} function 
#' to replace zero-length elements (includes \code{NULL}) to \code{NA} in a 
#' one-level list.
#' 
#' @importFrom purrr modify_if
#' @param x \code{list}; a list to be cleaned.
#' @return \code{list} containing \code{NA} in place of \code{NULL} element values.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
set_null_elements_to_na <- function(x){
  x %>% modify_if(~(length(.x) == 0), .f=function(x){return(NA)})
}

#' Recursively set all NULL or zero-length elements from list to NA
#' 
#' This function wraps a simple \code{\link[purrr:modify]{modify_if}} function 
#' to recursively set NULL elements in a list to NA.
#' 
#' @importFrom purrr map_if
#' @param x \code{list}; a list to be cleaned.
#' @return \code{list} containing \code{NA} in place of \code{NULL} element values.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
set_null_elements_to_na_recursively <- function(x) {
  x %>%
    map_if(is.list, set_null_elements_to_na_recursively) %>% 
    set_null_elements_to_na()
}

#' Unlist all list elements of length 1 if they are not a list
#' 
#' This function wraps a simple \code{\link[purrr:modify]{modify_if}} function 
#' to "unbox" list elements. This is helpful when the \code{\link[xml2]{as_list}} 
#' returns elements of XML and the element value is kept as a list of length 1,
#' even though it could be a single primitive data type (e.g. \code{logical},
#' \code{character}, etc.).
#' 
#' @importFrom purrr modify_if
#' @param x \code{list}; a list to be cleaned.
#' @return \code{list} containing \code{NA} in place of \code{NULL} element values.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
unbox_list_elements <- function(x){
  x %>% 
    modify_if(~((length(.x) == 1) && (!is.list(.x[[1]]))), 
              .f = function(x){return(unlist(x))})  
}

#' Recursively unlist all list elements of length 1 if they are not a list
#' 
#' This function wraps a simple \code{\link[purrr:modify]{modify_if}} function 
#' to recursively "unbox" list elements. This is helpful when the 
#' \code{\link[xml2]{as_list}} returns elements of XML and the element value is 
#' kept as a list of length 1, even though it could be a single primitive data 
#' type (e.g. \code{logical}, \code{character}, etc.).
#' 
#' @importFrom purrr map_if
#' @param x \code{list}; a list to be cleaned.
#' @return \code{list} containing "unboxed" list elements.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
unbox_list_elements_recursively <- function(x) {
  x %>%
    map_if(is.list, unbox_list_elements_recursively) %>% 
    unbox_list_elements()
}

#' Remove Salesforce attributes data from list
#' 
#' This function removes elements from Salesforce data parsed to a list where 
#' the object type and the record url persists because they were attributes on 
#' the record and not part of the requested information.
#' 
#' @importFrom purrr modify_if
#' @param x \code{list}; a list to be cleaned.
#' @template object_name_append
#' @template object_name_as_col
#' @return \code{list} containing no 'attributes' elements.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
drop_attributes <- function(x,
                            object_name_append = FALSE, 
                            object_name_as_col = FALSE){
  result <- x %>% 
    modify_if(.p=function(x){
      ((is.list(x)) 
       && ("attributes" %in% names(x)) 
       && identical(names(x[["attributes"]]), c("type", "url")))
    }, 
    .f=function(x, obj_name_append, obj_name_as_col){
      if(obj_name_append | obj_name_as_col){
        obj_name <- x[["attributes"]][["type"]]
      }
      x[["attributes"]] <- NULL
      if(obj_name_append){
        names(x) <- paste(obj_name, names(x), sep='.')
      }
      if(obj_name_as_col){
        x$sObject <- obj_name
      }
      return(x)
    }, 
    obj_name_append = object_name_append, 
    obj_name_as_col = object_name_as_col
    )
  return(result)
}

#' Recursively remove attributes data from list
#' 
#' This function wraps the custom \code{drop_attributes} function that removes 
#' elements from Salesforce data parsed to a list where the object type and the 
#' record url persists because they were attributes on the record and not  
#' part of the requested information.
#' 
#' @importFrom purrr map_if
#' @param x \code{list}; a list to be cleaned.
#' @template object_name_append
#' @template object_name_as_col
#' @return \code{list} containing no 'attributes' elements with the object information 
#' in the column names or the values within an object entitled \code{'sObject'}.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
drop_attributes_recursively <- function(x, 
                                        object_name_append=FALSE, 
                                        object_name_as_col=FALSE){
  x %>% 
    map_if(is.list, .f=function(x, obj_name_append, obj_name_as_col){
        drop_attributes_recursively(x, obj_name_append, obj_name_as_col)
      }, 
      obj_name_append = object_name_append, 
      obj_name_as_col = object_name_as_col
    ) %>% 
    drop_attributes(object_name_append = object_name_append, 
                    object_name_as_col = object_name_as_col)
}

#' Drop \code{type} and \code{Id} attributes on XML queried records and unlist
#' 
#' This function will detect if there are metadata fields returned by the SOAP 
#' API XML from \code{\link{sf_query}} and remove them as well as unlisting (not recursively)
#' to unnest the record's values. Only tested on two-level child-to-parent relationships. 
#' For example, for every Contact (child) record return attributes from the 
#' Account (parent) as well (SOQL = "SELECT Name, Account.Name FROM Contact")
#' 
#' @importFrom purrr map modify_if
#' @importFrom rlist list.flatten
#' @importFrom utils head tail
#' @param x \code{list}; a list of xml content parsed into a list by xml2
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
xml_drop_and_unlist <- function(x){
  x <- x %>% 
    map(.f=function(x){
      x %>% 
        modify_if(~(is.list(.x) && length(.x) == 1), 
                  ~unlist(.x, recursive=FALSE))
    })
  
  if(identical(head(names(x), 2), c("type", "Id"))){
    x <- tail(x, -2)
  }
  
  x <- x %>% 
    modify_if(~(is.list(.x) & length(.x) == 1 & length(.x[1]) == 1), 
              ~unlist(.x, recursive=FALSE))
  
  x <- x %>% 
    modify_if(~(is.list(.x) & (identical(head(names(.x), 2), c("type", "Id")))), 
              ~tail(., -2))
  
  x <- unlist(x, recursive=FALSE)
  return(x)
}

#' Recursively Drop \code{type} and \code{Id} attributes and flatten a list
#' 
#' This function wraps the \code{\link{xml_drop_and_unlist}} function 
#' to recursively flatten and remove record type attributes from relationship
#' and nested queries.
#' 
#' @importFrom purrr map_if
#' @param x \code{list}; a list to be cleaned.
#' @return \code{list} containing without \code{type} and \code{Id} fields that 
#' are not requested as part of the query, but Salesforce provides.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
xml_drop_and_unlist_recursively <- function(x) {
  x %>%
    map_if(is.list, xml_drop_and_unlist_recursively) %>% 
    xml_drop_and_unlist()
}

#' Pulls out a tibble of record info from an XML node
#' 
#' This function accepts an \code{xml_node} assuming it already represents one 
#' record and formats that node into a single row \code{tbl_df}.
#' 
#' @importFrom dplyr tibble
#' @importFrom tibble as_tibble_row
#' @importFrom xml2 xml_find_all as_list xml_remove xml_find_first xml_text
#' @importFrom purrr map
#' @param node \code{xml_node}; the node to have records extracted into one row \code{tbl_df}.
#' @param object_name_append \code{logical}; whether to include the object type
#' (e.g. Account or Contact) as part of the column names (e.g. Account.Name).
#' @param object_name_as_col \code{logical}; whether to include the object type
#' (e.g. Account or Contact) as a new column.
#' @return \code{tbl_df} parsed from the supplied node
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal  
#' @export
extract_records_from_xml_node <- function(node, 
                                          object_name_append = FALSE, 
                                          object_name_as_col = FALSE){
  
  # TODO: Consider doing something with the duplicate match data because what is returned
  # in the duplicateResult element is very detailed. For now just remove it
  # if(length(xml_find_all(node, "//errors[@xsi:type='DuplicateError']")) > 0){
  error_nodes <- xml_find_all(node, ".//errors | .//error")
  if(length(error_nodes) > 0){
    errors_list <- error_nodes %>% 
      # convert to list
      as_list() %>%
      # "unbox" length 1 list elements
      map(unbox_list_elements_recursively) %>%
      # return as a length 1 list, which is what the row requires (a single element)
      list()
    xml_remove(error_nodes)
  } else {
    errors_list <- list()
  }
  
  if(object_name_append | object_name_as_col){
    object_name <- node %>% 
      xml_find_first('.//sf:type') %>% 
      xml_text()
  }
  
  if(length(node) > 0){
    x <- node %>% 
      as_list() %>%
      xml_drop_and_unlist_recursively() %>%
      drop_empty_recursively() %>%
      as_tibble_row()
    if(object_name_append){
      colnames(x) <- paste(object_name, colnames(x), sep='.')
    }
    if(object_name_as_col){
      x$sObject <- object_name
    } 
  } else {
    x <- tibble()
  }
  
  if(length(errors_list) == 1){
    x$errors <- errors_list
  }
  
  return(x)
}

#' Pulls out a tibble of record info from an XML node
#' 
#' This function accepts an \code{xml_nodeset} and searches for all './/records' 
#' in the document to format into a single tidy \code{tbl_df}.
#' 
#' @importFrom dplyr mutate_all as_tibble tibble
#' @importFrom xml2 xml_find_all as_list
#' @importFrom purrr modify_if map_df
#' @param nodeset \code{xml_nodeset}; nodeset to have records extracted into a \code{tbl_df}
#' @param object_name_append \code{logical}; whether to include the object type
#' (e.g. Account or Contact) as part of the column names (e.g. Account.Name).
#' @param object_name_as_col \code{logical}; whether to include the object type
#' (e.g. Account or Contact) as a new column.
#' @return \code{tbl_df} parsed from the supplied \code{xml_nodeset}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
extract_records_from_xml_nodeset <- function(nodeset, 
                                             object_name_append=FALSE, 
                                             object_name_as_col=FALSE){
  x <- nodeset %>% xml_find_all('.//records')
  if(object_name_append | object_name_as_col){
    object_name <- x %>% xml_find_first('.//sf:type') %>% xml_text()
  } else {
    object_name <- NULL
  }
  res <- extract_records_from_xml_nodeset_of_records(x, 
                                                     object_name = object_name, 
                                                     object_name_append, 
                                                     object_name_as_col)
  return(res)
}

#' Pulls out a tibble of record info from a nodeset of "records" elements
#' 
#' This function accepts an \code{xml_nodeset} and formats each record into 
#' a single row of a \code{tbl_df}.
#' 
#' @importFrom dplyr mutate_all as_tibble tibble
#' @importFrom tibble as_tibble_row
#' @importFrom xml2 as_list
#' @importFrom purrr modify_if map_df
#' @param x \code{xml_nodeset}; nodeset to have records extracted into a 
#' \code{tbl_df}.
#' @param object_name \code{character}; a list of character strings to prefix
#' each variable name in the event that we would like to tag the fields with 
#' the name of the object that they came from and/or store the object type as a 
#' separate column in the resultset.
#' @template object_name_append
#' @template object_name_as_col
#' @return \code{tbl_df} parsed from the supplied \code{xml_nodeset}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
extract_records_from_xml_nodeset_of_records <- function(x, 
                                                        object_name = NULL, 
                                                        object_name_append = FALSE, 
                                                        object_name_as_col = FALSE){
  if(length(x) > 0){
    x_list <- x %>% 
      as_list() %>% 
      map(xml_drop_and_unlist_recursively) %>% 
      map(drop_empty_recursively)
    x <- x_list %>% 
      map_df(.f=function(x, nms, obj_name_append, obj_name_as_col){
        y <- as_tibble_row(x)
        if(!is.null(nms) && !any(sapply(nms, is.null))){
          if(obj_name_append){
            colnames(y) <- paste(nms, colnames(y), sep='.')  
          }
          if(obj_name_as_col){
            y$sObject <- nms
          }
        }
        return(y)
      }, 
      nms = object_name, 
      obj_name_append = object_name_append, 
      obj_name_as_col = object_name_as_col)
  } else {
    x <- tibble()
  }
  return(x)
}

#' Extract tibble of a parent-child record from one XML node
#' 
#' This function accepts a node representing the result of an individual parent 
#' recordset from a nested parent-child query where there are zero or more child 
#' records to be joined to the parent. In this case the child and parent will be 
#' bound together to return one complete \code{tbl_df} of the query result for 
#' that parent record.
#' 
#' @param x \code{xml_node}; a \code{xml_node} from an xml2 parsed response 
#' representing one individual parent query record.
#' @importFrom xml2 xml_find_all xml_remove
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
xml_extract_parent_and_child_result <- function(x){
  # no more querying needed, just format these child records as dataframe
  child_records <- extract_records_from_xml_nodeset(x, object_name_append=TRUE)
  # drop the nested child query result node from each parent record
  invisible(x %>% xml_find_all(".//*[@xsi:type='QueryResult']") %>% xml_remove())
  parent_record <- extract_records_from_xml_node(x)
  resultset <- combine_parent_and_child_resultsets(parent_record, child_records) 
  return(resultset)
}

#' Extract nested child records in a record
#' 
#' This function accepts a single record from a nested query and "unpacks" the 
#' "records" which represent the child records belonging to the parent.
#' 
#' @importFrom purrr map map_depth pluck
#' @importFrom dplyr bind_rows
#' @param x \code{list}; a list parsed from an HTTP response and representing 
#' one individual parent query record.
#' @return \code{tbl_df}; a data frame with each row representing a child record.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
extract_nested_child_records <- function(x){
  
  child_records <- x %>%
    map(pluck("records")) %>%
    map(~drop_attributes(.x, object_name_append = TRUE)) %>%
    drop_attributes_recursively() %>%
    drop_empty_recursively() %>%
    map_depth(2, flatten_tbl_df) %>%
    pluck(1) %>%
    safe_bind_rows() %>%
    as_tibble()
  
  return(child_records)
}

#' Drop nested child records in a record
#' 
#' This function accepts a single record from a nested query and removes the element 
#' with nested "records" which represent the child records belonging to the parent.
#' 
#' @importFrom purrr modify
#' @param x \code{list}; a list parsed from JSON and representing one individual 
#' parent query record.
#' @return \code{list}; a list without any elements that have nested child records 
#' assuming they have already been extracted. 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
drop_nested_child_records <- function(x){
  # drop the nested child query result node from each parent record
  x <- x %>% 
    modify(.f = function(x){
      if(all(c("records", "totalSize", "done") %in% names(x))) NULL else x
    })
  return(x)
}

#' Extract tibble of a parent-child record from one JSON element
#' 
#' This function accepts a list representing the result of an individual parent 
#' recordset from a nested parent-child query where there are zero or more child 
#' records to be joined to the parent. In this case the child and parent will be 
#' bound together to return one complete \code{tbl_df} of the query result for 
#' that parent record.
#' 
#' @param x \code{list}; list of records parsed from JSON representing one 
#' individual parent query record.
#' @return \code{tbl_df}; a data frame with each row representing a parent-child 
#' record (i.e. at least one row per parent or more if cross joined with more 
#' than one child record).
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
list_extract_parent_and_child_result <- function(x){
  
  child_records <- extract_nested_child_records(x)
  x <- drop_nested_child_records(x)
  
  # now work forward with x containing only the parent record
  # we wrap with list() so that drop_attributes will pull off from the top level
  parent_record <- records_list_to_tbl(list(x))
  resultset <- combine_parent_and_child_resultsets(parent_record, child_records)
  
  return(resultset)
}

#' Bind the records from nested parent-to-child queries
#' 
#' This function accepts a \code{data.frame} with one row representing each 
#' parent record returned by a query with a corresponding list element in the 
#' list of child record results stored as \code{tbl_df} in a list.
#' 
#' @importFrom dplyr is.tbl bind_cols bind_rows
#' @param parents_df \code{tbl_df}; a dataset with 1 row per parent record from 
#' the query recordset, that can be joined with its corresponding child records.
#' @param child_df_list \code{list} of \code{tbl_df}; a list of child records that 
#' is the same length as the number of rows in the parent_df.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
combine_parent_and_child_resultsets <- function(parents_df, child_df_list){
  if(is.tbl(child_df_list)){
    child_df_list <- list(child_df_list)
  }
  safe_bind_rows(
    lapply(1:nrow(parents_df), 
           FUN=function(x, y, z){
             parent_record <- y[x,]
             child_records <- z[x][[1]]
             if(!is.null(child_records) && 
                is.tbl(parent_record) && 
                is.tbl(child_records) && 
                (nrow(child_records) > 0)){
               combined <- bind_cols(parent_record, child_records)  
             } else {
               combined <- parent_record
             }
             return(combined)
           }, 
           parents_df, 
           child_df_list
    ))
}

#' Stack data frames which may have differing types in the same column
#'
#' This function accepts a list of data frames and will stack them all and
#' return a \code{tbl_df} with missing values filled in and all columns stacked
#' regardless of if the datatypes were different within the same column.
#'
#' @importFrom dplyr as_tibble
#' @importFrom data.table rbindlist
#' @param l \code{list}; A list containing data frames or lists that can be coerced 
#' to data frames.
#' @param fill \code{logical}; \code{TRUE} fills missing columns with NA
#' (default \code{TRUE}). When \code{TRUE}, use.names is set to \code{TRUE}.
#' @param idcol \code{character}; Creates a column in the result showing which
#' list item those rows came from. TRUE names this column ".id". idcol="file"
#' names this column "file".
#' @param ... arguments passed to \code{\link[data.table]{rbindlist}}
#' @return \code{tbl_df}; all list elements stacked on top of each other to
#' form a single data frame
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
safe_bind_rows <- function(l, fill=TRUE, idcol=NULL, ...){
  rbindlist(l = l, fill = fill, idcol = idcol, ...) %>%
    as_tibble()
}

#' Extract tibble based on the "records" element of a list
#' 
#' This function accepts a list representing the parsed JSON recordset In this 
#' case the records are not nested, but can have relationship fields. Each element 
#' in the "records" element is bound to a single row after dropping the attributes 
#' and then returned as one complete \code{tbl_df} of all records.
#' 
#' @importFrom purrr map_df
#' @param x \code{list}; list of records parsed from JSON.
#' @template object_name_append
#' @template object_name_as_col
#' @return \code{tbl_df} a data frame with each row representing a single element 
#' from the "records" element of the list.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
records_list_to_tbl <- function(x, 
                                object_name_append = FALSE, 
                                object_name_as_col = FALSE){
  resultset <- x %>% 
    drop_attributes(object_name_append, object_name_as_col) %>%
    drop_attributes_recursively() %>%
    drop_empty_recursively() %>%
    map_df(flatten_tbl_df)
  
  return(resultset)
}

#' Bind the results of paginated queries
#' 
#' This function accepts two \code{tbl_df} arguments that should represent the 
#' data frames returned by two different paginated API requests. It will 
#' throw an error if the data frames cannot be bound as-is because of mismatched 
#' types and encourage the user to set other arguments in  \code{sf_query()} to 
#' work through the issues.
#' 
#' @importFrom dplyr bind_rows
#' @param resultset \code{tbl_df}; the first data frame to combine
#' @param next_records \code{tbl_df}; the second data frame where any columns 
#' matched by name have the same datatype as the data frame provided to the 
#' `resultset` argument, otherwise, the call will fail with an error message.
#' @return \code{tbl_df} of the results combined with next records, if successful.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
bind_query_resultsets <- function(resultset, next_records){
  
  deprecate_warn("0.2.2", "salesforcer::bind_query_resultsets()", "safe_bind_rows()",
                 details = paste0("Consider safe_bind_rows() which silently combines ",
                                  "all columns regardless if there are mixed datatypes ",
                                  "in a single column."))
  
  resultset <- tryCatch({
    bind_rows(resultset, next_records)  
  }, error=function(e){
    overlapping_cols <- intersect(names(resultset), names(next_records))
    mismatched_warn_str <- c()
    for(c in overlapping_cols){
      if(class(resultset[[c]]) != class(next_records[[c]])){
        new_warn <- sprintf("  - Column '%s' is `%s` type and `%s` type in new records.", 
                            c, class(resultset[[c]]), class(next_records[[c]]))
        mismatched_warn_str <- c(mismatched_warn_str, new_warn)
      }
    }
    stop(
      sprintf(paste0("While paginating the recordsets the most recent response ", 
                     "had different datatypes than prior records in the following columns:", 
                     "\n  - %s\n", 
                     "\n",
                     "Consider setting `bind_using_character_cols=TRUE` to cast the data to ", 
                     "character so that `bind_rows()` between pages will succeed and setting ",
                     "`guess_types=TRUE` which uses readr to determine the datatype based on ", 
                     "values in the column."), 
              paste0(mismatched_warn_str, collapse="\n  - "))
      , call. = FALSE
    )
  })
  return(resultset)
}

#' Reorder resultset columns to prioritize \code{sObject} and \code{Id}
#' 
#' This function accepts a \code{tbl_df} with columns rearranged.
#' 
#' @importFrom dplyr select any_of contains
#' @param df \code{tbl_df}; the data frame to rearrange columns in
#' @return \code{tbl_df} the formatted data frame
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_reorder_cols <- function(df){
  df %>% 
    # sort column names ...
    select(sort(names(.))) %>% 
    # ... then move Id and columns without dot up since those with are related 
    select(any_of(unique(c("sObject", 
                           "Id", "id", "sf__Id",
                           "Success", "success", "sf__Success",
                           "Created", "created", "sf__Created",
                           "Error", "error", "errors",
                           "errors.statusCode", "errors.fields", "errors.message", 
                           "sf__Error",
                           names(.)[which(!grepl("\\.", names(.)))]))), 
             contains("."))
}

#' Reorder resultset columns to prioritize \code{sObject} and \code{Id}
#' 
#' This function accepts a \code{tbl_df} with columns rearranged.
#' 
#' @importFrom dplyr mutate across
#' @importFrom readr type_convert cols col_guess
#' @param df \code{tbl_df}; the data frame to rearrange columns in
#' @return \code{tbl_df} the formatted data frame
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_guess_cols <- function(df, guess_types=TRUE, dataType=NULL){
  if(guess_types){
    if(is.null(dataType) || any(is.na(dataType)) || (length(dataType)== 0)){
      df <- df %>% 
        type_convert(col_types = cols(.default = col_guess()))      
    } else {
      col_spec <- sf_build_cols_spec(dataType)
      # if numeric but contains Salesforce "-" then preemptively change to NA
      if(grepl('i|n', col_spec)){
        numeric_col_idx <- which(strsplit(col_spec, split=character(0))[[1]] %in% c("i", "n"))
        df <- df %>% 
          mutate(across(all_of(numeric_col_idx), ~ifelse(.x == "-", NA_character_, .x)))
      }
      df <- df %>% 
        type_convert(col_types = col_spec)      
    }
  }
  return(df)
}

#' Produce spec to convert Salesforce data types to R data types
#' 
#' This function accepts a vector of Salesforce data types and maps them into 
#' a single string that can be passed to the \code{col_types} argument.
#' 
#' @param x \code{character}; the Salesforce data types to map
#' @return \code{character} the analogous R data types.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_build_cols_spec <- function(x){
  x %>% 
    sapply(map_sf_type_to_r_type, USE.NAMES = FALSE) %>% 
    paste0(collapse="")
}

#' Map Salesforce data types to R data types
#' 
#' This function is a simple one-to-many map of unique Salesforce data types to 
#' a specific data type in R.
#' 
#' @param x \code{character}; the Salesforce data type.
#' @return \code{character} the R data type.
#' @seealso \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/primitive_data_types.htm}{Primitive Data Types}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/field_types.htm}{Other Field Types}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/compound_fields.htm}{Compound Fields}
#' }
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
map_sf_type_to_r_type <- function(x){
  switch(tolower(x), 
        "accuracy" = "c",
        "address" = "c",
        "anytype" = "c",
        "base64" = "c",
        "boolean" = "l",
        "byte" = "c",
        "calculated" = "c",
        "city" = "c",
        "combobox" = "c",
        "country" = "c",
        "countrycode" = "c",
        "currency" = "c",
        "datacategorygroupreference" = "c",
        "date" = "D",
        "datetime" = "T",
        "double" = "n",
        "email" = "c",
        "encryptedstring" = "c",
        "html" = "c",
        "id" = "c",
        "int" = "i",
        "junctionidlist" = "c",
        "latitude" = "n",
        "location" = "c",
        "longitude" = "n",
        "masterrecord" = "c",
        "multipicklist" = "c",
        "percent" = "c",
        "phone" = "c",
        "picklist" = "c",
        "postalcode" = "c",
        "reference" = "c",
        "state" = "c",
        "statecode" = "c",
        "street" = "c",
        "string" = "c",
        "textarea" = "c",
        "time" = "t",
        "url" = "c")
}
