# Changelog

## oecdoda (development version)

- Fixed
  [`oda_get_crs()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_get_crs.md)
  failing with “HTTP 404 Not Found” because OECD retired version 1.4 of
  the CRS dataflows
  ([\#4](https://github.com/tidy-intelligence/r-oecdoda/issues/4)).
- [`oda_get_crs()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_get_crs.md),
  [`oda_get_dac1()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_get_dac1.md),
  [`oda_get_dac2a()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_get_dac2a.md),
  and
  [`oda_get_multisystem()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_get_multisystem.md)
  gain a `version` argument to choose the OECD dataflow version.
  Defaults are pinned to the current versions (DAC1 1.8; CRS, DAC2A, and
  Multisystem 1.7). Use `version = NULL` to query the latest version.
- Breaking: the DAC1 filters now follow the dimension order of DAC1
  version 1.8, and the last DAC1 filter, previously misnamed `period`,
  is now `sector`.
- Breaking: the pre-processed
  [`oda_get_crs()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_get_crs.md)
  output column `channelt_name` is renamed to `channel_name`.

## oecdoda 0.1.0

CRAN release: 2025-07-25

- Initial CRAN submission with
  [`oda_get_dac1()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_get_dac1.md),
  [`oda_get_dac2a()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_get_dac2a.md),
  [`oda_get_crs()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_get_crs.md),
  [`oda_get_multisystem()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_get_multisystem.md),
  and
  [`oda_list_filters()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_list_filters.md).
