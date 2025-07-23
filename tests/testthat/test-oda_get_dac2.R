test_that("oda_get_dac2a returns processed data by default", {
  with_mocked_bindings(
    `create_request` = function(resource, filters, start_year, end_year) {
      expect_equal(resource, "DSD_DAC2@DF_DAC2A,1.3")
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    `perform_request` = function(req, context) {
      expect_equal(context, "oda_get_dac2a")
      structure(list(status = 200), class = "httr2_response")
    },
    `parse_response` = function(resp) {
      tibble::tibble(
        DONOR = "USA",
        Donor = "United States",
        RECIPIENT = "NGA",
        Recipient = "Nigeria",
        MEASURE = 106,
        Measure = "USD",
        FLOW_TYPE = 1,
        `Flow.type` = "Grants",
        TIME_PERIOD = 2022,
        OBS_VALUE = 54321,
        UNIT_MEASURE = 1,
        `Unit.of.measure` = "USD",
        PRICE_BASE = "Q",
        `Price.base` = "2020 constant",
        UNIT_MULT = 1,
        `Unit.multiplier` = "Millions"
      )
    },
    {
      result <- oda_get_dac2a(
        start_year = 2020,
        end_year = 2022,
        filters = list(recipient = "NGA"),
        pre_process = TRUE
      )

      expect_s3_class(result, "tbl_df")
      # Check renamed columns
      expect_true(all(
        c(
          "entity_id",
          "entity_name",
          "counterpart_id",
          "counterpart_name",
          "series_id",
          "series_name",
          "flow_type_id",
          "flow_type_name",
          "year",
          "value"
        ) %in%
          colnames(result)
      ))
      # Validate a couple of values
      expect_equal(result$entity_id, "USA")
      expect_equal(result$counterpart_id, "NGA")
      expect_equal(result$value, 54321)
    }
  )
})

test_that("oda_get_dac2a returns raw data when pre_process = FALSE", {
  raw_data <- tibble::tibble(x = 1, y = 2)

  with_mocked_bindings(
    `create_request` = function(...) {
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    `perform_request` = function(req, context) {
      structure(list(status = 200), class = "httr2_response")
    },
    `parse_response` = function(resp) raw_data,
    {
      result <- oda_get_dac2a(pre_process = FALSE)
      expect_equal(result, raw_data)
    }
  )
})

test_that("oda_get_dac2a passes filters & year parameters to create_request", {
  with_mocked_bindings(
    `create_request` = function(resource, filters, start_year, end_year) {
      expect_equal(resource, "DSD_DAC2@DF_DAC2A,1.3")
      expect_equal(filters, list(recipient = "NGA"))
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
        RECIPIENT = "NGA",
        Recipient = "Nigeria",
        MEASURE = 106,
        Measure = "USD",
        FLOW_TYPE = 1,
        `Flow.type` = "Grants",
        TIME_PERIOD = 2022,
        OBS_VALUE = 54321,
        UNIT_MEASURE = 1,
        `Unit.of.measure` = "USD",
        PRICE_BASE = "Q",
        `Price.base` = "2020 constant",
        UNIT_MULT = 1,
        `Unit.multiplier` = "Millions"
      )
    },
    {
      result <- oda_get_dac2a(
        start_year = 2000,
        end_year = 2020,
        filters = list(recipient = "NGA"),
        pre_process = TRUE
      )
      expect_s3_class(result, "tbl_df")
    }
  )
})
