context("Utils")

test_that("testing sf_download_attachment", {
  queried_attachments <- sf_query("SELECT Body, Name
                                   FROM Attachment
                                   WHERE ParentId = '0016A0000035mJB'")
  res <- mapply(sf_download_attachment, 
                queried_attachments[["Body"]], 
                queried_attachments[["Name"]], 
                tempdir())
  expect_true(all(res))
})

test_that("testing input_data validation", {
  input_data <- 1:3
  res1a <- sf_input_data_validation(input_data)
  expect_equal(res1a, data.frame(`X1.3`=1:3, check.names = FALSE))
  res1b <- sf_input_data_validation(input_data, operation='delete')
  expect_equal(res1b, data.frame(Id=1:3))
  
  input_data <- list(1,2,3)
  res2a <- sf_input_data_validation(input_data)
  expect_equal(res2a, data.frame(`unlist(input_data)`=1:3, check.names = FALSE))
  res2b <- sf_input_data_validation(input_data, operation='delete')
  expect_equal(res2b, data.frame(Id=1:3))
  
  input_data <- c(Id=1,b=2,c=3)
  res3a <- sf_input_data_validation(input_data)
  expect_equal(res3a, data.frame(Id=1,b=2,c=3))
  res3b <- sf_input_data_validation(input_data, operation='delete')
  expect_equal(res3b, data.frame(Id=1,b=2,c=3))
  input_data <- input_data[-which(names(input_data)=="Id")]
  expect_error(sf_input_data_validation(input_data, operation='update'))
  
  input_data <- list(Id=1,b=2,c=3)
  res4a <- sf_input_data_validation(input_data)
  expect_equal(res4a, data.frame(Id=1,b=2,c=3))
  res4b <- sf_input_data_validation(input_data, operation='delete')
  expect_equal(res4b, data.frame(Id=1,b=2,c=3))
  input_data$Id <- NULL
  expect_error(sf_input_data_validation(input_data, operation='update'))
  
  input_data <- data.frame(Id=1,b=2,c=3)
  res5a <- sf_input_data_validation(input_data)
  expect_equal(res5a, input_data)
  res5b <- sf_input_data_validation(input_data, operation='delete')
  expect_equal(res5b, input_data)  
  input_data <- input_data[,c('b','c')]
  expect_error(sf_input_data_validation(input_data, operation='update'))  
})
