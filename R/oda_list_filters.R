#' List Available Filters for an ODA Resource
#'
#' @param resource A character string identifying the resource
#' (e.g., `"DSD_CRS@DF_CRS"`).
#'
#' @return A character vector of available filter names for the given resource.
#'
#' @examples
#' oda_list_filters("DSD_CRS@DF_CRS")
#'
#' oda_list_filters("DSD_DAC2@DF_DAC2A")
#'
#' @export
oda_list_filters <- function(resource) {
  resource_filters <- list(
    "DSD_DAC1@DF_DAC1" = c(
      "donor",
      "measure",
      "untied",
      "flow_type",
      "unit_measure",
      "price_base",
      "period"
    ),
    "DSD_DAC2@DF_DAC2A" = c(
      "donor",
      "recipient",
      "measure",
      "unit_measure",
      "price_base"
    ),
    "DSD_CRS@DF_CRS" = c(
      "donor",
      "recipient",
      "sector",
      "measure",
      "channel",
      "modality",
      "flow_type",
      "price_base",
      "md_dim",
      "md_id",
      "unit_measure"
    ),
    "DSD_GREQ@DF_CRS_GREQ" = c(
      "donor",
      "recipient",
      "sector",
      "measure",
      "channel",
      "modality",
      "flow_type",
      "price_base",
      "md_dim",
      "md_id",
      "unit_measure"
    ),
    "DSD_MULTI@DF_MULTI" = c(
      "donor",
      "recipient",
      "sector",
      "measure",
      "channel",
      "flow_type",
      "price_base",
      "md_dim",
      "md_id",
      "unit_measure"
    )
  )
  for (pattern in names(resource_filters)) {
    if (grepl(pattern, resource, fixed = FALSE)) {
      return(resource_filters[[pattern]])
    }
  }
  cli::cli_abort(paste0("Unsupported {.arg resource}: ", resource))
}
