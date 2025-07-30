test_that("oda_get_multisystem returns processed data by default", {
  with_mocked_bindings(
    `create_request` = function(
      base_url,
      resource,
      filters,
      start_year,
      end_year
    ) {
      expect_equal(resource, "DSD_MULTI@DF_MULTI")
      expect_equal(
        base_url,
        "https://sdmx.oecd.org/dcd-public/rest/data/OECD.DCD.FSD"
      )
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    `perform_request` = function(...) {
      structure(list(status = 200), class = "httr2_response")
    },
    `parse_response` = function(resp) {
      tibble::tibble(
        DONOR = "DAC",
        Donor = "OECD DAC Members",
        RECIPIENT = "DPGC",
        Recipient = "UN Peacebuilding Fund",
        MEASURE = 10,
        Measure = "USD",
        FLOW_TYPE = 1,
        `Flow.type` = "Grants",
        CHANNEL = 500,
        Channel = "UN",
        TIME_PERIOD = 2021,
        OBS_VALUE = 9999,
        UNIT_MEASURE = 1,
        `Unit.of.measure` = "USD",
        PRICE_BASE = "Q",
        `Price.base` = "2020 constant",
        UNIT_MULT = 1,
        `Unit.multiplier` = "Millions"
      )
    },
    {
      result <- oda_get_multisystem(
        start_year = 2020,
        end_year = 2021,
        filters = list(donor = "DAC", recipient = "DPGC"),
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
          "flow_type_id",
          "flow_type_name",
          "channel_id",
          "channel_name",
          "year",
          "value"
        ) %in%
          colnames(result)
      ))
      # Check value correctness
      expect_equal(result$entity_id, "DAC")
      expect_equal(result$counterpart_id, "DPGC")
      expect_equal(result$value, 9999)
    }
  )
})

test_that("oda_get_multisystem returns raw data when pre_process = FALSE", {
  raw_data <- tibble::tibble(x = 1, y = 2)

  with_mocked_bindings(
    `create_request` = function(...) {
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    `perform_request` = function(...) {
      structure(list(status = 200), class = "httr2_response")
    },
    `parse_response` = function(resp) raw_data,
    {
      result <- oda_get_multisystem(pre_process = FALSE)
      expect_equal(result, raw_data)
    }
  )
})

test_that("oda_get_multisystem passes filters & year to create_request", {
  with_mocked_bindings(
    `create_request` = function(
      base_url,
      resource,
      filters,
      start_year,
      end_year
    ) {
      expect_equal(resource, "DSD_MULTI@DF_MULTI")
      expect_equal(filters, list(donor = "DAC", recipient = "DPGC"))
      expect_equal(start_year, 2010)
      expect_equal(end_year, 2020)
      structure(list(url = "mock_url"), class = "httr2_request")
    },
    `perform_request` = function(...) {
      structure(list(status = 200), class = "httr2_response")
    },
    `parse_response` = function(resp) {
      tibble(
        DONOR = "DAC",
        Donor = "OECD DAC Members",
        RECIPIENT = "DPGC",
        Recipient = "UN Peacebuilding Fund",
        MEASURE = 10,
        Measure = "USD",
        FLOW_TYPE = 1,
        `Flow.type` = "Grants",
        CHANNEL = 500,
        Channel = "UN",
        TIME_PERIOD = 2021,
        OBS_VALUE = 9999,
        UNIT_MEASURE = 1,
        `Unit.of.measure` = "USD",
        PRICE_BASE = "Q",
        `Price.base` = "2020 constant",
        UNIT_MULT = 1,
        `Unit.multiplier` = "Millions"
      )
    },
    {
      result <- oda_get_multisystem(
        start_year = 2010,
        end_year = 2020,
        filters = list(donor = "DAC", recipient = "DPGC"),
        pre_process = TRUE
      )
      expect_s3_class(result, "tbl_df")
    }
  )
})

test_that("oda_get_multisystem returns nothing if request was unsuccessful", {
  with_mocked_bindings(
    `perform_request` = function(...) NULL,
    {
      result <- oda_get_multisystem(
        start_year = 2000,
        end_year = 2020,
        filters = list(donor = "USA"),
        pre_process = TRUE
      )
      expect_equal(result, NULL)
    }
  )
})
