#' Get OECD Members Total Use of the Multilateral System (Multisystem)
#'
#' Retrieves data from the OECD Multisystem dataset using specified filters,
#' years, and optional pre-processing.
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
#' @return A data frame containing OECD DAC2A data
#'
#' @examplesIf curl::has_internet()
#' \donttest{
#' oda_get_multisystem(
#'   start_year = 2018,
#'   end_year = 2022,
#'   filters = list(
#'     donor = "DAC",
#'     recipient = "DPGC",
#'     sector = 1000,
#'     measure = 10
#'   )
#' )
#' }
#'
#' @export
oda_get_multisystem <- function(
  start_year = NULL,
  end_year = NULL,
  filters = NULL,
  pre_process = TRUE
) {
  req <- create_request(
    base_url = "https://sdmx.oecd.org/dcd-public/rest/data/OECD.DCD.FSD",
    resource = "DSD_MULTI@DF_MULTI",
    start_year = start_year,
    end_year = end_year,
    filters = filters
  )
  resp <- perform_request(req, "oda_get_multisystem")
  multisystem_raw <- parse_response(resp)

  if (isFALSE(pre_process)) {
    multisystem_processed <- multisystem_raw
  } else {
    multisystem_processed <- multisystem_raw[, c(
      "DONOR",
      "Donor",
      "RECIPIENT",
      "Recipient",
      "MEASURE",
      "Measure",
      "FLOW_TYPE",
      "Flow.type",
      "CHANNEL",
      "Channel",
      "TIME_PERIOD",
      "OBS_VALUE",
      "UNIT_MEASURE",
      "Unit.of.measure",
      "PRICE_BASE",
      "Price.base",
      "UNIT_MULT",
      "Unit.multiplier"
    )]
    colnames(multisystem_processed) <- c(
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
      "value",
      "unit_measure_id",
      "unit_measure_name",
      "price_base_id",
      "price_base_name",
      "unit_multiplier_id",
      "unit_multiplier_name"
    )
  }
  multisystem_processed
}
