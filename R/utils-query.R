#' Remove Salesforce attributes data from list
#' 
#' This function removes elements from Salesforce data parsed to a list where 
#' the object type and the record url persists because they were attributes on 
#' the record and not part of the requested information.
#' 
#' @importFrom purrr modify_if
#' @param x \code{list}; a list to be cleaned.
#' @return \code{list} containing no 'attributes' elements.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
drop_attributes <- function(l, object_name_append=FALSE) {
  result <- l %>% 
    modify_if(.p=function(x){
      ((is.list(x)) 
       && ("attributes" %in% names(x)) 
       && (identical(names(x[["attributes"]]), c("type", "url"))))
    }, 
    .f=function(x, obj_name_append){
      if(obj_name_append){
        obj_name <- x[["attributes"]][["type"]]
      }
      x[["attributes"]] <- NULL
      if(obj_name_append){
        names(x) <- paste(obj_name, names(x), sep='.')
      }      
      return(x)
    }, obj_name_append = object_name_append
    )
  return(result)
}

#' Recursively remove Salesforce attributes data from list
#' 
#' This function wraps the custom \code{drop_attributes} function that removes 
#' elements from Salesforce data parsed to a list where the object type and the 
#' record url persists because they were attributes on the record and not  
#' part of the requested information.
#' 
#' @importFrom purrr map_if
#' @param x \code{list}; a list to be cleaned.
#' @return \code{list} containing no 'attributes' elements.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
drop_attributes_recursively <- function(x, object_name_append=FALSE) {
  x %>% 
    map_if(is.list, 
           .f=function(x, obj_name_append){
             drop_attributes_recursively(x, obj_name_append)
             }, obj_name_append = object_name_append) %>% 
    drop_attributes(object_name_append = object_name_append)
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
    compact()
}

#' Flatten list and convert to tibble
#' 
#' This function is a convenience function to handle deeply nested records usually 
#' returned by parsed JSON or XML that need to be converted into a data frame where 
#' each record represents a row in the data frame.
#' 
#' @importFrom dplyr as_tibble tibble
#' @importFrom rlist list.flatten
#' @param x \code{list}; a list to be extracted into a \code{tbl_df}.
#' @return \code{tbl_df} parsed from the flattened list.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
flatten_to_tbl_df <- function(x){
  list.flatten(x) %>% as_tibble()
}


#' Drop Id and type metadata present on every queried record and unlist
#' 
#' This function will detect if there are metadata fields returned by the SOAP 
#' API XML from \code{sf_query} and remove them as well as unlisting (not recursively)
#' to unnest the record's values. Only tested on two-level child-to-parent relationships. 
#' For example, for every Contact (child) record return attributes from the 
#' Account (parent) as well (SOQL = "SELECT Name, Account.Name FROM Contact")
#' 
#' @param x \code{list}; a list of \code{xml_node} from an xml2 parsed response 
#' @importFrom purrr map modify_if
#' @importFrom utils head tail
#' @keywords internal
#' @export
xml_drop_and_unlist <- function(x){
  x <- map(x, ~modify_if(.x, ~(length(.x) == 1 && is.list(.x)), 
                         unlist, recursive=FALSE))
  if(identical(head(names(x), 2), c("type", "Id"))){
    x <- tail(x, -2)
  }
  x <- modify_if(x, ~(length(.x) == 1 & is.list(.x) & 
                        length(.x[1]) == 1), 
                 unlist, recursive=FALSE)
  x <- modify_if(x, ~(is.list(.x) && 
                        (identical(head(names(.x), 2), c("type", "Id")))), 
                 ~tail(., -2))
  x <- unlist(x, recursive=FALSE)
  return(x)
}

#' Pulls out a tibble of record info from an XML node
#' 
#' This function accepts an \code{xml_node} and searches for all './/records' 
#' in the document to format into a single tidy \code{tbl_df}.
#' 
#' @importFrom dplyr mutate_all as_tibble tibble
#' @importFrom tibble as_tibble_row
#' @importFrom xml2 xml_find_all as_list
#' @importFrom purrr modify_if map_df
#' @param node \code{xml_node}; the node to have records extracted into one row \code{tbl_df}.
#' @param object_name_append \code{logical}; an indicator for whether to append the 
#' name of the object onto the the front of the field names of the records.
#' @return \code{tbl_df} parsed from the supplied node
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
extract_records_from_xml_node <- function(node, object_name_append=FALSE){
  object_name <- node %>% xml_find_first('.//sf:type') %>% xml_text()
  if(length(node) > 0){
    x_list <- as_list(node)
    x_list <- xml_drop_and_unlist(x_list)
    while(any(sapply(x_list, is.list))){
      x_list <- modify_if(x_list, ~is.list(.x), xml_drop_and_unlist)  
    }
    if(is.list(x_list)){
      x <- x_list %>% 
        map_df(~as_tibble_row(.x))    
    } else {
      x <- as_tibble_row(x_list)
    }
    if(object_name_append){
      colnames(x) <- paste(object_name, colnames(x), sep='.')
    }
  } else {
    x <- tibble()
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
#' @return \code{tbl_df} parsed from the supplied \code{xml_nodeset}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
extract_records_from_xml_nodeset <- function(nodeset, object_name_append=FALSE){
  x <- nodeset %>% xml_find_all('.//records')
  if(object_name_append){
    object_name <- x %>% xml_find_first('.//sf:type') %>% xml_text()
  } else {
    object_name <- NULL
  }
  res <- extract_records_from_xml_nodeset_of_records(x, object_name=object_name)
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
#' @param x \code{xml_nodeset}; nodeset to have records extracted into a \code{tbl_df}
#' @param object_name \code{character}; a list of character strings to pre-pend
#' to each variable name in the event that we would like to tag the fields with 
#' the name of the object that they came from.
#' @return \code{tbl_df} parsed from the supplied \code{xml_nodeset}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
extract_records_from_xml_nodeset_of_records <- function(x, object_name=NULL){
  if(length(x) > 0){
    x_list <- as_list(x)
    while(any(sapply(x_list, is.list))){
      x_list <- modify_if(x_list, ~is.list(.x), xml_drop_and_unlist)  
    }
    x <- x_list %>% 
      map_df(.f=function(x, nms){
        y <- as_tibble_row(x)
        if(!is.null(nms) && !any(sapply(nms, is.null))){
          colnames(y) <- paste(nms, colnames(y), sep='.')
        }
        return(y)
      }, nms=object_name)
  } else {
    x <- tibble()
  }
  return(x)
}

#' Bind the records from nested parent-to-child queries
#' 
#' This function accepts a \code{data.frame} with one row representing each parent record 
#' returned by a query with a corresponding list element in the list of child 
#' record results stored as \code{tbl_df} in a list.
#' 
#' @param parents_df \code{tbl_df}; a dataset with 1 row per parent record from 
#' the query recordset, that can be joined with its corresponding child records.
#' @param child_df_list \code{list} of \code{tbl_df}; a list of child records that 
#' is the same length as the number of rows in the parent_df.
#' @importFrom dplyr is.tbl bind_cols bind_rows
#' @keywords internal
#' @export
combine_parent_and_child_resultsets <- function(parents_df, child_df_list){
  if(is.tbl(child_df_list)){
    child_df_list <- list(child_df_list)
  }
  bind_rows(
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

#' Extract tibble of a parent-child record from one node
#' 
#' This function accepts a node representing the result of an individual parent 
#' recordset from a nested parent-child query where there are zero or more child 
#' records to be joined to the parent. In this case the child and parent will be 
#' bound together to return one complete \code{tbl_df} of the query result for 
#' that parent record.
#' 
#' @param x \code{xml_node}; a \code{xml_node} from an xml2 parsed response representing 
#' one individual parent query record
#' @importFrom xml2 xml_find_all xml_remove
#' @keywords internal
#' @export
extract_parent_and_child_result <- function(x){
  # no more querying needed, just format these child records as dataframe
  child_records <- extract_records_from_xml_nodeset(x, object_name_append=TRUE)
  # drop the nested child query result node from each parent record
  invisible(x %>% xml_find_all(".//*[@xsi:type='QueryResult']") %>% xml_remove())
  parent_record <- extract_records_from_xml_node(x)
  resultset <- combine_parent_and_child_resultsets(parent_record, child_records) 
  return(resultset)
}

#' Extract tibble of a parent-child record from one node
#' 
#' This function accepts a list representing the result of an individual parent 
#' recordset from a nested parent-child query where there are zero or more child 
#' records to be joined to the parent. In this case the child and parent will be 
#' bound together to return one complete \code{tbl_df} of the query result for 
#' that parent record.
#' 
#' @param x \code{list}; list of records parsed from response representing 
#' one individual parent query record
#' @keywords internal
#' @export
list_extract_parent_and_child_result <- function(x){
  child_records <- pluck(x, 3, "records") %>% 
    drop_attributes_recursively(object_name_append=TRUE) %>% 
    drop_empty_recursively() %>% 
    map_df(flatten_to_tbl_df)
  # drop the nested child query result node from each parent record
  pluck(x, 3) <- NULL
  parent_record <- list(x) %>% 
    drop_attributes_recursively() %>% 
    drop_empty_recursively() %>% 
    map_df(flatten_to_tbl_df)
  resultset <- combine_parent_and_child_resultsets(parent_record, child_records) 
  return(resultset)
}

#' Bind the results of paginated queries
#' 
#' This function accepts two \code{tbl_df} arguments that should represent the 
#' data frames returned by two different paginated API requests. It will 
#' throw an error if the data frams cannot be bound as-is because of mismatched 
#' types and encourage the user to set other arguments in  \code{sf_query()} to 
#' work through the issues.
#' 
#' @importFrom dplyr bind_rows
#' @param resultset \code{tbl_df}; the first data frame to combine
#' @param next_records \code{tbl_df}; the second data frame where any columns 
#' matched by name have the same datatype as the data frame provided to the 
#' `resultset` argument, otherwise, the call will fail with an error message.
#' @return \code{tbl_df} of the results combined with next records, if sucessful.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
bind_query_resultsets <- function(resultset, next_records){
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
    mismatched_warn_str <- paste0(mismatched_warn_str, collapse="\n")
    stop(
      sprintf(paste0("While paginating the recordsets the most recent JSON ", 
                     "had different datatypes than prior records in the following columns:\n%s\n\n",
                     "Consider setting `bind_using_character_cols=TRUE` to cast the data to ", 
                     "character so that `bind_rows()` between pages will succeed and setting ",
                     "`guess_types=TRUE` which uses readr to determine the datatype based on ", 
                     "values in the column."), 
              mismatched_warn_str)
      , call. = FALSE
    )
  })
  return(resultset)
}