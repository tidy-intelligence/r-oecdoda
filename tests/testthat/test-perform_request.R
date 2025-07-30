# perform_request --------------------------------------------------------

test_that("perform_request returns response object on success", {
  mock_resp <- structure(list(status = 200), class = "response")

  # Mock httr2 functions
  with_mocked_bindings(
    perform_request = function(...) mock_resp,
    {
      result <- perform_request(mock_req)
      expect_s3_class(result, "response")
      expect_equal(result$status, 200)
    }
  )
})

test_that("perform_request throws warning on error", {
  with_mocked_bindings(
    req_perform = function(...) {
      stop("API connection error: Connection timed out")
    },
    expect_message(
      perform_request("abcd"),
      "Failed to retrieve data from OECD API."
    )
  )
})

# create_request ---------------------------------------------------------

test_that("create_request constructs correct request with params", {
  req <- create_request(
    resource = "DAC1",
    filters = NULL,
    start_year = 2000,
    end_year = 2020
  )

  expect_s3_class(req, "httr2_request")
  expect_true(grepl("DAC1", req$url))
  expect_true(grepl("startPeriod=2000", req$url))
  expect_true(grepl("endPeriod=2020", req$url))
})

test_that("create_request includes filters in request URL", {
  req <- create_request(
    resource = "DSD_DAC1@DF_DAC1",
    filters = list(donor = "USA")
  )

  expect_s3_class(req, "httr2_request")
  expect_true(grepl("USA.", req$url))
  expect_true(grepl("format=csvfilewithlabels", req$url))
  expect_true(grepl("dimensionAtObservation=AllDimensions", req$url))
})

# parse_response ---------------------------------------------------------

test_that("parse_response converts response body to tibble", {
  csv_text <- "col1,col2\n1,a\n2,b"
  mock_resp <- structure(
    list(
      body = charToRaw(csv_text)
    ),
    class = "httr2_response"
  )

  with_mocked_bindings(
    resp_body_string = function(resp) csv_text,
    {
      df <- parse_response(mock_resp)
      expect_s3_class(df, "tbl_df")
      expect_equal(nrow(df), 2)
      expect_equal(colnames(df), c("col1", "col2"))
    }
  )
})

# build_filters ----------------------------------------------------------

test_that("build_filters constructs correct filter string", {
  # Mock oda_list_filters
  with_mocked_bindings(
    `oda_list_filters` = function(resource) c("country", "sector", "md_dim"),
    {
      filters <- list(country = "USA", sector = c("A", "B"), md_dim = NULL)
      result <- build_filters(filters, "DAC1")
      expect_equal(result, "USA.A+B._T")
    }
  )
})

# to_filter --------------------------------------------------------------

test_that("to_filter_string joins filters with +", {
  expect_equal(to_filter_string(c("A", "B", "C")), "A+B+C")
})
