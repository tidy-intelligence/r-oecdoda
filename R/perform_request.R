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
  if (resource == "DSD_DAC1@DF_DAC1,1.5") {
    filters_processed <- list(
      donor = to_filter_string(filters$donor),
      measure = to_filter_string(filters$measure),
      untied = "",
      flow_type = to_filter_string(filters$flow_type),
      unit_measure = to_filter_string(filters$unit_measure),
      price_base = to_filter_string(filters$price_base),
      period = ""
    )
    filters_combined <- paste(c(filters_processed, "."), collapse = ".")
  }
  filters_combined
}

#' @keywords internal
#' @noRd
to_filter_string <- function(filters) {
  paste(filters, collapse = "+")
}
