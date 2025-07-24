.onLoad <- function(libname, pkgname) {
  op <- options()
  op_pkg <- list(
    oecdoda.rate_capacity = 20,
    oecdoda.rate_fill_time = 60
  )
  toset <- !(names(op_pkg) %in% names(op))
  if (any(toset)) {
    options(op_pkg[toset])
  }
  invisible()
}
