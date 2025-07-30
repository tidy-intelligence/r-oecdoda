#' Get OECD Creditor Reporting System (CRS) data
#'
#' Retrieves data from the OECD CRS dataset using specified filters, years,
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
#' @param as_grant_equivalent Logical. Whether the 'flows' or 'grant equivalent'
#' version of the CRS should be returned.
#'
#' @return A data frame containing OECD CRS data
#'
#' @examplesIf curl::has_internet()
#' \donttest{
#' oda_get_crs(
#'   start_year = 2018,
#'   end_year = 2022,
#'   filters = list(
#'     donor = c("AUT", "FRA", "USA"),
#'     recipient = "BIH",
#'     measure = 100,
#'     channel = 60000,
#'     price_base = "Q"
#'   )
#' )
#' }
#'
#' @export
oda_get_crs <- function(
  start_year = NULL,
  end_year = NULL,
  filters = NULL,
  pre_process = TRUE,
  as_grant_equivalent = FALSE
) {
  req <- create_request(
    base_url = "https://sdmx.oecd.org/dcd-public/rest/data/OECD.DCD.FSD",
    resource = ifelse(
      as_grant_equivalent,
      "DSD_GREQ@DF_CRS_GREQ,1.4",
      "DSD_CRS@DF_CRS,1.4"
    ),
    start_year = start_year,
    end_year = end_year,
    filters = filters
  )
  resp <- perform_request(req)

  if (is.null(resp)) {
    return(invisible(NULL))
  }

  crs_raw <- parse_response(resp)

  if (isFALSE(pre_process)) {
    crs_processed <- crs_raw
  } else {
    crs_processed <- crs_raw[, c(
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
      "MODALITY",
      "Modality",
      "TIME_PERIOD",
      "OBS_VALUE",
      "UNIT_MEASURE",
      "Unit.of.measure",
      "PRICE_BASE",
      "Price.base",
      "UNIT_MULT",
      "Unit.multiplier"
    )]
    colnames(crs_processed) <- c(
      "entity_id",
      "entity_name",
      "counterpart_id",
      "counterpart_name",
      "series_id",
      "series_name",
      "flow_type_id",
      "flow_type_name",
      "channel_id",
      "channelt_name",
      "modality_id",
      "modality_name",
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
  crs_processed
}
