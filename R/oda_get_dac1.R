#' Get OECD DAC1 Official Development Assistance (ODA) data
#'
#' Retrieves data from the OECD DAC1 dataset using specified filters, years,
#' and optional pre-processing.
#'
#' @param start_year Integer. The starting year of the data query. If `NULL`,
#' no lower bound is set. Defaults to `NULL`.
#' @param end_year Integer. The ending year of the data query. If `NULL`,
#' no upper bound is set. Defaults to `NULL`.
#' @param filters List. A named list of filters to apply (e.g., donor codes,
#' easure, flow type, unit measure, price base). Values must match OECD dotstat
#' codes.
#' @param pre_process Logical. Whether to clean and rename columns into a
#' standard format. If `FALSE`, returns raw output. Defaults to `TRUE`.
#'
#' @return A data frame containing OECD DAC1 data
#'
#' @examplesIf curl::has_internet()
#' \donttest{
#' oda_get_dac1(
#'   start_year = 2018,
#'   end_year = 2022,
#'   filters = list(
#'     donor = c("FRA", "USA"),
#'     measure = 11017,
#'     flow_type = 1160,
#'     unit_measure = "XDC",
#'     price_base = "V"
#'   )
#' )
#' }
#'
#' @export
oda_get_dac1 <- function(
  start_year = NULL,
  end_year = NULL,
  filters = NULL,
  pre_process = TRUE
) {
  req <- create_request(
    resource = "DSD_DAC1@DF_DAC1,1.5",
    start_year = start_year,
    end_year = end_year,
    filters = filters
  )
  resp <- perform_request(req)

  if (is.null(resp)) {
    return(invisible(NULL))
  }

  dac1_raw <- parse_response(resp)

  if (isFALSE(pre_process)) {
    dac1_processed <- dac1_raw
  } else {
    dac1_processed <- dac1_raw[, c(
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
    colnames(dac1_processed) <- c(
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

  dac1_processed
}
