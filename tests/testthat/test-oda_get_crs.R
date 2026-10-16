test_that("oda_get_crs returns processed data by default", {
  with_mocked_bindings(
    create_request = function(
      base_url,
      resource,
      version,
      filters,
      start_year,
      end_year
    ) {
      expect_equal(
        base_url,
        "https://sdmx.oecd.org/dcd-public/rest/data/OECD.DCD.FSD"
      )
      expect_equal(resource, "DSD_CRS@DF_CRS")
      expect_equal(version, "1.7")
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    perform_request = function(...) {
      structure(list(status = 200), class = "httr2_response")
    },
    parse_response = function(resp) {
      tibble::tibble(
        DONOR = "USA",
        Donor = "United States",
        RECIPIENT = "BIH",
        Recipient = "Bosnia",
        MEASURE = 100,
        Measure = "USD",
        FLOW_TYPE = 1,
        `Flow.type` = "Grants",
        CHANNEL = 60000,
        Channel = "Gov",
        MODALITY = 10,
        Modality = "Bilateral",
        TIME_PERIOD = 2022,
        OBS_VALUE = 12345,
        UNIT_MEASURE = 1,
        `Unit.of.measure` = "USD",
        PRICE_BASE = "Q",
        `Price.base` = "2020 constant",
        UNIT_MULT = 1,
        `Unit.multiplier` = "Millions"
      )
    },
    {
      result <- oda_get_crs(
        start_year = 2020,
        end_year = 2022,
        filters = list(donor = "USA"),
        pre_process = TRUE
      )

      expect_s3_class(result, "tbl_df")
      expect_true(all(
        c(
          "entity_id",
          "entity_name",
          "counterpart_id",
          "counterpart_name",
          "series_id",
          "series_name",
          "channel_id",
          "channel_name",
          "year",
          "value"
        ) %in%
          colnames(result)
      ))
      expect_equal(result$entity_id, "USA")
      expect_equal(result$value, 12345)
    }
  )
})

test_that("oda_get_crs returns raw data when pre_process = FALSE", {
  raw_data <- tibble::tibble(col1 = 1, col2 = 2)

  with_mocked_bindings(
    create_request = function(...) {
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    perform_request = function(...) {
      structure(list(status = 200), class = "httr2_response")
    },
    parse_response = function(resp) raw_data,
    {
      result <- oda_get_crs(pre_process = FALSE)
      expect_equal(result, raw_data)
    }
  )
})

test_that("oda_get_crs uses grant equivalent when as_grant_equivalent = TRUE", {
  with_mocked_bindings(
    create_request = function(
      base_url,
      resource,
      version,
      filters,
      start_year,
      end_year
    ) {
      expect_equal(resource, "DSD_GREQ@DF_CRS_GREQ") # Grant equivalent dataset
      expect_equal(version, "1.7")
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    perform_request = function(...) {
      structure(list(status = 200), class = "httr2_response")
    },
    parse_response = function(resp) {
      tibble(
        DONOR = "USA",
        Donor = "United States",
        RECIPIENT = "BIH",
        Recipient = "Bosnia",
        MEASURE = 100,
        Measure = "USD",
        FLOW_TYPE = 1,
        `Flow.type` = "Grants",
        CHANNEL = 60000,
        Channel = "Gov",
        MODALITY = 10,
        Modality = "Bilateral",
        TIME_PERIOD = 2022,
        OBS_VALUE = 12345,
        UNIT_MEASURE = 1,
        `Unit.of.measure` = "USD",
        PRICE_BASE = "Q",
        `Price.base` = "2020 constant",
        UNIT_MULT = 1,
        `Unit.multiplier` = "Millions"
      )
    },
    {
      result <- oda_get_crs(as_grant_equivalent = TRUE)
      expect_s3_class(result, "tbl_df")
    }
  )
})

test_that("oda_get_crs returns nothing if request was unsuccessful", {
  with_mocked_bindings(
    `perform_request` = function(...) NULL,
    {
      result <- oda_get_crs(
        start_year = 2000,
        end_year = 2020,
        filters = list(donor = "USA"),
        pre_process = TRUE
      )
      expect_equal(result, NULL)
    }
  )
})

test_that("oda_get_crs passes a custom version to create_request", {
  with_mocked_bindings(
    create_request = function(version, ...) {
      expect_null(version)
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    perform_request = function(...) NULL,
    {
      expect_null(oda_get_crs(version = NULL))
    }
  )
})
