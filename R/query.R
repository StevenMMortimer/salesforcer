#' Perform SOQL Query
#' 
#' Executes a query against the specified object and returns data that matches 
#' the specified criteria.
#' 
#' @template soql
#' @template object_name
#' @template queryall
#' @template guess_types
#' @template api_type
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}} or further downstream 
#' to \code{\link{sf_query_bulk}}.
#' @param next_records_url \code{character} (leave as NULL); a string used internally 
#' by the function to paginate through to more records until complete
#' @template bind_using_character_cols
#' @template verbose
#' @return \code{tbl_df} of records
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note Bulk API query doesn't support the following SOQL:
#' \itemize{
#'    \item COUNT
#'    \item ROLLUP
#'    \item SUM
#'    \item GROUP BY CUBE
#'    \item OFFSET
#'    \item Nested SOQL queries
#'    \item Relationship fields
#'    }
#' Additionally, Bulk API can't access or query compound address or compound geolocation fields.
#' @examples
#' \dontrun{
#' sf_query("SELECT Id, Account.Name, Email FROM Contact LIMIT 10")
#' }
#' @export
sf_query <- function(soql,
                     object_name = NULL,
                     queryall = FALSE,
                     guess_types = TRUE,
                     api_type = c("REST", "SOAP", "Bulk 1.0", "Bulk 2.0"),
                     control = list(...), ...,
                     next_records_url = NULL,
                     bind_using_character_cols = FALSE,
                     verbose = FALSE){
  
  api_type <- match.arg(api_type)
  # determine how to pass along the control args 
  all_args <- list(...)
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- if(queryall) "queryall" else "query"
  if("page_size" %in% names(all_args)){
    # warn then set it in the control list
    warning(paste0("The `page_size` argument has been deprecated.\n", 
                   "Please pass QueryOptions=list(batchSize=200) argument or ",
                   "use the `sf_control` function."), 
            call. = FALSE)
    control_args$QueryOptions = list(batchSize = as.integer(all_args$page_size))
  }
  
  if(api_type == "REST"){
    resultset <- sf_query_rest(soql = soql,
                               object_name = object_name,
                               queryall = queryall,
                               guess_types = guess_types,
                               control = control_args,
                               next_records_url = next_records_url,
                               bind_using_character_cols = bind_using_character_cols,
                               verbose = verbose)
  } else if(api_type == "SOAP"){
    resultset <- sf_query_soap(soql = soql,
                               object_name = object_name,
                               queryall = queryall,
                               guess_types = guess_types,
                               control = control_args,
                               next_records_url = next_records_url,
                               bind_using_character_cols = bind_using_character_cols,
                               verbose = verbose)
  } else if(api_type == "Bulk 1.0"){
    if(is.null(object_name)){
      object_name <- guess_object_name_from_soql(soql)
    }
    resultset <- sf_query_bulk_v1(soql = soql,
                                  object_name = object_name,
                                  queryall = queryall,
                                  guess_types = guess_types,
                                  control = control_args,
                                  verbose = verbose, ...)
  } else if(api_type == "Bulk 2.0"){
    resultset <- sf_query_bulk_v2(soql = soql,
                                  object_name = object_name,
                                  queryall = queryall,
                                  guess_types = guess_types,
                                  control = control_args,
                                  verbose = verbose, ...)
  } else {
    stop("Unknown API type.")
  }
  return(resultset)
}

#' @importFrom dplyr bind_rows tibble select any_of contains mutate_all
#' @importFrom httr content
#' @importFrom readr type_convert cols col_guess
#' @importFrom purrr pluck pluck<-
sf_query_rest <- function(soql,
                          object_name = NULL,
                          queryall = FALSE,
                          guess_types = TRUE,
                          control = list(),
                          next_records_url = NULL,
                          bind_using_character_cols = FALSE,
                          verbose = FALSE){
  
  control <- filter_valid_controls(control)
  
  query_url <- make_query_url(soql, queryall, next_records_url)
  request_headers <- c("Accept"="application/json", 
                       "Content-Type"="application/json")
  if("QueryOptions" %in% names(control)){
    query_batch_size <- as.integer(control$QueryOptions$batchSize)
    stopifnot(is.integer(query_batch_size))
    request_headers <- c(request_headers, 
                         c("Sforce-Query-Options" = sprintf("batchSize=%s", 
                                                            query_batch_size)))
  }
  
  # GET the url with the q (query) parameter set to the escaped SOQL string
  httr_response <- rGET(url = query_url, headers = request_headers)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method,
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, "parsed", encoding="UTF-8")
  
  if(length(response_parsed$records) > 0){
    # determine if there are parent-child relationship query results contained within 
    # each parent record. If so, check that the query result is "done" meaning 
    # there are no additional child records to obtain for that parent record. 
    # Note that only one level of parent-to-child relationship can be specified in 
    # a query so this only needs to be done for one level of records
    nested_queries <- unlist(lapply(response_parsed$records, function(x){pluck(x, 3, "done")}))
    nested_queries_exist <- !is.null(nested_queries)
    if(nested_queries_exist){
      if(any(!nested_queries)){
        resultset <- map_df(response_parsed$records, function(x){
          done_status <- pluck(x, 3, "done")
          if(!is.null(done_status) && !done_status){
            query_locator <- pluck(x, 3, "nextRecordsUrl")
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
            if(!is.null(query_locator) && query_locator != ''){
              next_child_records <- sf_query_rest(next_records_url = query_locator,
                                                  object_name = object_name,
                                                  queryall = queryall,
                                                  guess_types = FALSE,
                                                  bind_using_character_cols = bind_using_character_cols,
                                                  control = control,
                                                  verbose = verbose)
              child_records <- bind_rows(child_records, next_child_records)
            }
            y <- combine_parent_and_child_resultsets(parent_record, child_records) 
          } else {
            y <- list_extract_parent_and_child_result(x)
          }
          return(y)
        })
      } else {
        resultset <- map_df(response_parsed$records, list_extract_parent_and_child_result)
      }
    } else {
      resultset <- response_parsed$records %>% 
        drop_attributes_recursively() %>% 
        drop_empty_recursively() %>% 
        map_df(flatten_to_tbl_df)
    }
  } else {
    resultset <- tibble()
  }
    
  # TODO: Consider switching to all character if guess_types was provided or flipped on 
  # in the case where the types do not match between pages and then bind_rows 
  # fails. Casting all as character and switching to guess types allows all 
  # pages to be pulled without breaking and then trying to reconcile why 
  # the types were different between the paginated API calls
  if(bind_using_character_cols){
    resultset <- resultset %>% mutate_all(as.character)
  }    
  
  # check whether the query has more results to pull via pagination 
  if(!response_parsed$done){
    next_records <- sf_query_rest(next_records_url = response_parsed$nextRecordsUrl,
                                  object_name = object_name,
                                  queryall = queryall,
                                  guess_types = FALSE,
                                  control = control,
                                  bind_using_character_cols = bind_using_character_cols,
                                  verbose = verbose)
    resultset <- bind_query_resultsets(resultset, next_records)
  }
  
  # handle the final iteration
  if((response_parsed$done) & (nrow(resultset) > 0)){
    resultset <- resultset %>% 
      # sort column names ...
      select(sort(names(.))) %>% 
      # ... then move Id and columns without dot up since those with are related
      select(any_of(unique(c("Id", "id", names(.)[which(!grepl("\\.", names(.)))]))), contains("."))
    # cast the types if requested
    if (guess_types){  
      resultset <- resultset %>% 
        type_convert(col_types = cols(.default = col_guess()))
    }    
  }
  return(resultset)
}

#' @importFrom dplyr bind_rows select any_of contains mutate_all tibble as_tibble
#' @importFrom httr content
#' @importFrom purrr map_df modify_if
#' @importFrom readr type_convert cols col_guess
#' @importFrom xml2 xml_find_first xml_find_all xml_text xml_ns_strip
sf_query_soap <- function(soql,
                          object_name = NULL,
                          queryall = FALSE,
                          guess_types = TRUE,
                          control = list(),
                          next_records_url = NULL,
                          bind_using_character_cols = FALSE,
                          verbose = FALSE){
  
  control <- filter_valid_controls(control)
  
  if(!is.null(next_records_url)){
    soap_action <- "queryMore"
    records_xpath <- './/soapenv:Body/queryMoreResponse/result/records'
    r <- make_soap_xml_skeleton(soap_headers = control)
    xml_dat <- build_soap_xml_from_list(input_data = next_records_url,
                                        operation = "queryMore",
                                        root = r)
  } else {
    soap_action <- "query"
    records_xpath <- './/soapenv:Body/queryResponse/result/records'
    r <- make_soap_xml_skeleton(soap_headers = control)
    xml_dat <- build_soap_xml_from_list(input_data = soql,
                                        operation = "query",
                                        root = r)
  }
  
  base_soap_url <- make_base_soap_url()
  request_body <- as(xml_dat, "character") 
  httr_response <- rPOST(url = base_soap_url,
                         headers = c("SOAPAction"=soap_action,
                                     "Content-Type"="text/xml"),
                         body = request_body)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method,
                              httr_response$request$url, 
                              httr_response$request$headers, 
                              request_body)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as='parsed', encoding="UTF-8")
  
  resultset <- response_parsed %>%
    xml_ns_strip() %>%  
    xml_find_all(records_xpath)
  
  # determine if there are parent-child relationship query results contained within 
  # each parent record. If so, check that the query result is "done" meaning 
  # there are no additional child records to obtain for that parent record. 
  # Note that only one level of parent-to-child relationship can be specified in 
  # a query so this only needs to be done for one level of records
  nested_queries <- sapply(resultset, function(x){
    x %>% xml_find_first('.//done') %>% xml_text()
  })
  
  nested_queries_exist <- any(!is.na(nested_queries))
  if(nested_queries_exist){
    if(any(nested_queries == "false")){
      resultset <- map_df(resultset, function(x){
        done_status <- x %>% xml_find_first('.//done') %>% xml_text()
        if(!is.na(done_status) && done_status == "false"){
          query_locator <- x %>% xml_find_first('.//queryLocator') %>% xml_text()
          child_records <- extract_records_from_xml_nodeset(x)
          # drop the nested child query result node from each parent record
          invisible(x %>% xml_find_all(".//*[@xsi:type='QueryResult']") %>% xml_remove())
          parent_record <- extract_records_from_xml_node(x)
          if(!is.na(query_locator) && query_locator != ''){
            next_child_records <- sf_query_soap(next_records_url = query_locator,
                                                object_name = object_name,
                                                queryall = queryall,
                                                guess_types = FALSE,
                                                bind_using_character_cols = bind_using_character_cols,
                                                control = control,
                                                verbose = verbose)
            child_records <- bind_rows(child_records, next_child_records)
          }
          y <- combine_parent_and_child_resultsets(parent_record, child_records) 
        } else {
          y <- extract_parent_and_child_result(x)
        }
        return(y)
      })
    } else {
      resultset <- map_df(resultset, extract_parent_and_child_result)
    }
  } else {
    resultset <- extract_records_from_xml_nodeset_of_records(resultset)
  }
  
  # NOTE: Because of the way that XML data is returned it is not clear the datatype
  # of the value. For example, a character will not be surrounded by quotes and 
  # neither will a number, so the `as_list()` function will return all values as 
  # characters, which is why we should have the default value of the `guess_types`
  # argument to be set to TRUE
  if(bind_using_character_cols){
    resultset <- resultset %>% 
      mutate_all(as.character)
  }
  
  done_status <- response_parsed %>% 
    xml_ns_strip() %>%
    xml_find_first('.//done') %>%
    xml_text()
  
  if(done_status == "false"){
    query_locator <- response_parsed %>% 
      xml_ns_strip() %>%
      xml_find_first('.//queryLocator') %>%
      xml_text()
    next_records <- sf_query_soap(next_records_url = query_locator, 
                                  object_name = object_name,
                                  queryall = queryall,
                                  guess_types = FALSE,
                                  control = control,
                                  bind_using_character_cols = bind_using_character_cols,
                                  verbose = verbose)
    resultset <- bind_query_resultsets(resultset, next_records)
  }
  
  # handle the final iteration
  if((done_status == "true") & (nrow(resultset) > 0)){
    resultset <- resultset %>% 
      # sort column names ...
      select(sort(names(.))) %>% 
      # ... then move Id and columns without dot up since those with are related
      select(any_of(unique(c("Id", "id", names(.)[which(!grepl("\\.", names(.)))]))), contains("."))
    # cast the types if requested
    if (guess_types){  
      resultset <- resultset %>% 
        type_convert(col_types = cols(.default = col_guess()))
    }
  }

  return(resultset)
}
