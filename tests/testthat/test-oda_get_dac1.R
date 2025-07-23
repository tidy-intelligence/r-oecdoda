test_that("oda_get_dac1 returns processed data by default", {
  with_mocked_bindings(
    `create_request` = function(resource, filters, start_year, end_year) {
      expect_equal(resource, "DSD_DAC1@DF_DAC1,1.5")
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    `perform_request` = function(req, context) {
      expect_equal(context, "oda_get_dac1")
      structure(list(status = 200), class = "httr2_response")
    },
    `parse_response` = function(resp) {
      tibble::tibble(
        DONOR = "USA",
        Donor = "United States",
        MEASURE = 100,
        Measure = "USD",
        FLOW_TYPE = 1,
        `Flow.type` = "Grants",
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
      result <- oda_get_dac1(
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
          "series_id",
          "series_name",
          "flow_type_id",
          "flow_type_name",
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

test_that("oda_get_dac1 returns raw data when pre_process = FALSE", {
  raw_data <- tibble::tibble(a = 1, b = 2)

  with_mocked_bindings(
    `create_request` = function(...) {
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    `perform_request` = function(req, context) {
      structure(list(status = 200), class = "httr2_response")
    },
    `parse_response` = function(resp) raw_data,
    {
      result <- oda_get_dac1(pre_process = FALSE)
      expect_equal(result, raw_data)
    }
  )
})

test_that("oda_get_dac1 passes filters and year parameters to create_request", {
  with_mocked_bindings(
    `create_request` = function(resource, filters, start_year, end_year) {
      expect_equal(resource, "DSD_DAC1@DF_DAC1,1.5")
      expect_equal(filters, list(donor = "USA"))
      expect_equal(start_year, 2000)
      expect_equal(end_year, 2020)
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    `perform_request` = function(req, context) {
      structure(list(status = 200), class = "httr2_response")
    },
    `parse_response` = function(resp) {
      tibble(
        DONOR = "USA",
        Donor = "United States",
        MEASURE = 100,
        Measure = "USD",
        FLOW_TYPE = 1,
        `Flow.type` = "Grants",
        TIME_PERIOD = 2020,
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
      result <- oda_get_dac1(
        start_year = 2000,
        end_year = 2020,
        filters = list(donor = "USA"),
        pre_process = TRUE
      )
      expect_s3_class(result, "tbl_df")
    }
  )
})
