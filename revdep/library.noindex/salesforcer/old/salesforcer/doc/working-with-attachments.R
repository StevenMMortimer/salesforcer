## ---- echo = FALSE------------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)
options(tibble.print_min = 5L, tibble.print_max = 5L)

## ----auth, include = FALSE----------------------------------------------------
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(here)))
library(salesforcer)
token_path <- Sys.getenv("SALESFORCER_TOKEN_PATH")
sf_auth(token = paste0(token_path, "salesforcer_token.rds"))

## ----load-package, eval=FALSE-------------------------------------------------
#  library(dplyr, warn.conflicts = FALSE)
#  library(salesforcer)
#  sf_auth()

## -----------------------------------------------------------------------------
# define the ParentIds where the attachments will be shown in Salesforce
parent_record_id1 <- "0016A0000035mJ4"
parent_record_id2 <- "0016A0000035mJ5"

# provide the file paths of where the attachments exist locally on your machine
# in this case we are referencing images included within the salesforcer package, 
# but any absolute or relative path locally will work
file_path1 <- system.file("extdata", "cloud.png", package="salesforcer")
file_path2 <- system.file("extdata", "logo.png", package="salesforcer")
file_path3 <- system.file("extdata", "old-logo.png", package="salesforcer")

# create a data.frame or tbl_df out of this information
attachment_details <- tibble(Body = rep(c(file_path1, 
                                          file_path2, 
                                          file_path3), 
                                        times=2),
                             ParentId = rep(c(parent_record_id1, 
                                              parent_record_id2), 
                                            each=3))

# create the attachments!
result <- sf_create_attachment(attachment_details)
result

## -----------------------------------------------------------------------------
# pull down all attachments associated with a particular record
queried_attachments <- sf_query(sprintf("SELECT Id, Body, Name, ParentId
                                         FROM Attachment
                                         WHERE ParentId IN ('%s', '%s')", 
                                         parent_record_id1, parent_record_id2))
queried_attachments

## -----------------------------------------------------------------------------
# create a new folder for each ParentId in the dataset
temp_dir <- tempdir()
for (pid in unique(queried_attachments$ParentId)){
  dir.create(file.path(temp_dir, pid), showWarnings = FALSE) # ignore if already exists
}

# create a new columns in the queried data so that we can pass this information 
# on to the function `sf_download_attachment()` that will actually perform the download
queried_attachments <- queried_attachments %>% 
  # Strategy 1: Unique file names (ununsed here, but shown as an example)
  mutate(unique_name = paste(Id, Name, sep='___')) %>% 
  # Strategy 2: Separate folders per parent
  mutate(Path = file.path(temp_dir, ParentId))

# download all of the attachments for a single ParentId record to their own folder
download_result <- mapply(sf_download_attachment, 
                          body = queried_attachments$Body, 
                          name = queried_attachments$Name, 
                          path = queried_attachments$Path)
download_result

## ----cleanup-1, include = FALSE-----------------------------------------------
sf_delete(queried_attachments$Id)

## -----------------------------------------------------------------------------
# upload a PDF to a particular record as an Attachment
file_path <- system.file("extdata",
                         "data-wrangling-cheatsheet.pdf",
                         package = "salesforcer")
parent_record_id <- "0036A000002C6MmQAK" # replace with your own ParentId!
attachment_details <- tibble(Body = file_path, ParentId = parent_record_id)
create_result <- sf_create_attachment(attachment_details)

# download, zip, and re-upload the PDF
pdf_path <- sf_download_attachment(sf_id = create_result$id[1])
zipped_path <- paste0(pdf_path, ".zip")
zip(zipped_path, pdf_path, flags = "-qq") # quiet zipping messages
attachment_details <- tibble(Id = create_result$id, Body = zipped_path)
sf_update_attachment(attachment_details)

## ----cleanup-2----------------------------------------------------------------
sf_delete_attachment(ids = create_result$id)
# sf_delete(ids = create_result$id) # would also work

## -----------------------------------------------------------------------------
# create the attachment metadata required (Name, Body, ParentId)
attachment_details <- queried_attachments %>% 
  mutate(Body = file.path(Path, Name)) %>% 
  select(Name, Body, ParentId) 

## -----------------------------------------------------------------------------
result <- sf_create_attachment(attachment_details, api_type="Bulk 1.0")
result

## ----cleanup-3, include = FALSE-----------------------------------------------
for (pid in unique(queried_attachments$ParentId)){
  unlink(file.path(temp_dir, pid), recursive=TRUE) # remove directories...
}
sf_delete(result$Id) #... and records in Salesforce

## -----------------------------------------------------------------------------
# the function supports inserting all types of blob content, just update the 
# object_name argument to add the PDF as a Document instead of an Attachment
document_details <- tibble(Name = "Data Wrangling Cheatsheet - Test 1",
                           Description = "RStudio cheatsheet covering dplyr and tidyr.",
                           Body = system.file("extdata", 
                                              "data-wrangling-cheatsheet.pdf",
                                              package="salesforcer"),
                           FolderId = "00l6A000001EgIwQAK",
                           Keywords = "test,cheatsheet,document")
result <- sf_create_attachment(document_details, object_name = "Document")
result

## ----cleanup-4, include = FALSE-----------------------------------------------
sf_delete(result$id)

## -----------------------------------------------------------------------------
cheatsheet_url <- "https://rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf"
document_details <- tibble(Name = "Data Wrangling Cheatsheet - Test 2",
                           Description = "RStudio cheatsheet covering dplyr and tidyr.",
                           Url = cheatsheet_url,  
                           FolderId = "00l6A000001EgIwQAK",
                           Keywords = "test,cheatsheet,document")
result <- sf_create_attachment(document_details, object_name = "Document")
result

## ----cleanup-5, include = FALSE-----------------------------------------------
sf_delete(result$id)

