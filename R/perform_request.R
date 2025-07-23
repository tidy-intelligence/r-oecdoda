#' @keywords internal
#' @noRd
perform_request <- function(req, context) {
  tryCatch(
    {
      req |>
        httr2::req_throttle(capacity = 20, fill_time_s = 60) |>
        httr2::req_perform()
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
  filter_keys <- oda_list_filters(resource)

  filters_processed <- lapply(filter_keys, function(key) {
    value <- filters[[key]]

    if (key == "md_dim" && is.null(value)) {
      value <- "_T"
    }

    to_filter_string(value)
  })

  paste(filters_processed, collapse = ".")
}

#' @keywords internal
#' @noRd
to_filter_string <- function(filters) {
  paste(filters, collapse = "+")
}
