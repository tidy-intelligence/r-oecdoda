test_that("oda_list_filters returns correct filters", {
  result <- oda_list_filters()
  expect_true(is.list(result))
})

test_that("oda_list_filters returns correct filters for a resource", {
  result <- oda_list_filters("DSD_DAC1@DF_DAC1")
  expect_true(is.character(result))
  expect_true("donor" %in% result)
  expect_true("measure" %in% result)
})

test_that("oda_list_filters throws error for unsupported resource", {
  expect_error(
    oda_list_filters("UNKNOWN_RESOURCE"),
    "Unsupported"
  )
})
