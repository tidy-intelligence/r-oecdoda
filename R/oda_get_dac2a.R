oda_get_dac2a <- function(
  start_year,
  end_year,
  filters,
  pre_process,
  dotstat_codes,
  dataflow_version
) {
  req <- create_request(
    resource = "DSD_DAC1@DF_DAC1,1.5",
    start_year = start_year,
    end_year = end_year,
    filters = filters
  )
  resp <- perform_request(req, "oda_get_dac2a")
  dac2a_raw <- parse_response(resp)

  if (isFALSE(pre_process)) {
    dac2a_processed <- dac2a_raw
  } else {
    dac2a_processed <- dac2a_raw[, c(
      "DONOR",
      "Donor",
      "MEASURE",
      "Measure",
      "FLOW_TYPE",
      "Flow.type",
      "TIME_PERIOD",
      "OBS_VALUE",
      "UNIT_MEASURE",
      "Unit.of.measure",
      "PRICE_BASE",
      "Price.base",
      "UNIT_MULT",
      "Unit.multiplier"
    )]
    colnames(dac2a_processed) <- c(
      "entity_id",
      "entity_name",
      "series_id",
      "series_name",
      "flow_type_id",
      "flow_type_name",
      "year",
      "value",
      "unit_measure_id",
      "unit_measure_name",
      "price_base_id",
      "price_base_name",
      "unit_multiplier_id",
      "unit_multiplier_name"
    )
  }

  dac2a_processed
}
