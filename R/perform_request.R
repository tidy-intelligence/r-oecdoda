#' @keywords internal
#' @noRd
perform_request <- function(req, context) {
  tryCatch(
    {
      resp <- req |>
        httr2::req_throttle(capacity = 20, fill_time_s = 60) |>
        httr2::req_perform()
      resp
    },
    error = function(e) {
      cli::cli_abort(
        c(
          "Failed to retrieve data from OECD API.",
          "i" = "Error message: {conditionMessage(e)}"
        ),
        call = call(context)
      )
    }
  )
}

#' @keywords internal
#' @noRd
create_request <- function(
  base_url = "https://sdmx.oecd.org/public/rest/data/OECD.DCD.FSD",
  resource,
  filters = NULL,
  start_year = NULL,
  end_year = NULL
) {
  if (is.null(filters)) {
    filters_processed <- ""
  } else {
    filters_processed <- build_filters(filters, resource)
  }

  # Build url parameters
  params <- list(
    format = "csvfilewithlabels",
    dimensionAtObservation = "AllDimensions"
  )
  if (!is.null(start_year)) {
    params$startPeriod <- start_year
  }
  if (!is.null(end_year)) {
    params$endPeriod <- end_year
  }

  # Construct request
  url <- paste0(base_url, ",", resource)
  req <- httr2::request(url) |>
    httr2::req_url_path_append(filters_processed) |>
    httr2::req_url_query(!!!params) |>
    httr2::req_user_agent(
      "oecdoda R package (https://github.com/tidy-intelligence/r-oecdoda)"
    )
  req
}

#' @keywords internal
#' @noRd
parse_response <- function(resp) {
  httr2::resp_body_string(resp) |>
    textConnection() |>
    read.csv() |>
    tibble::as_tibble()
}

#' @keywords internal
#' @noRd
build_filters <- function(filters, resource) {
  if (grepl("DSD_DAC1@DF_DAC1", resource, fixed = TRUE)) {
    filters_processed <- list(
      donor = to_filter_string(filters$donor),
      measure = to_filter_string(filters$measure),
      untied = "",
      flow_type = to_filter_string(filters$flow_type),
      unit_measure = to_filter_string(filters$unit_measure),
      price_base = to_filter_string(filters$price_base),
      period = ""
    )
  } else if (grepl("DSD_DAC2@DF_DAC2A", resource, fixed = TRUE)) {
    filters_processed <- list(
      donor = to_filter_string(filters$donor),
      recipient = to_filter_string(filters$recipient),
      measure = to_filter_string(filters$measure),
      unit_measure = to_filter_string(filters$unit_measure),
      price_base = to_filter_string(filters$price_base)
    )
  } else if (grepl("DSD_CRS@DF_CRS|DSD_GREQ@DF_CRS_GREQ", resource)) {
    filters_processed <- list(
      donor = to_filter_string(filters$donor),
      recipient = to_filter_string(filters$recipient),
      sector = to_filter_string(filters$sector),
      measure = to_filter_string(filters$measure),
      channel = to_filter_string(filters$channel),
      modality = to_filter_string(filters$modality),
      flow_type = to_filter_string(filters$flow_type),
      price_base = to_filter_string(filters$price_base),
      md_dim = to_filter_string(
        ifelse(is.null(filters$md_dim), "_T", filters$md_dim)
      ),
      md_id = to_filter_string(filters$md_id),
      unit_measure = to_filter_string(filters$unit_measure)
    )
  } else {
    cli::cli_abort(
      paste0("Unsupported {.arg resource}: ", resource)
    )
  }
  paste(filters_processed, collapse = ".")
}

#' @keywords internal
#' @noRd
to_filter_string <- function(filters) {
  paste(filters, collapse = "+")
}
