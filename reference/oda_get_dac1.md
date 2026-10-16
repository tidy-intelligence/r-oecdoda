# Get OECD DAC1 Official Development Assistance (ODA) data

Retrieves data from the OECD DAC1 dataset using specified filters,
years, and optional pre-processing.

## Usage

``` r
oda_get_dac1(
  start_year = NULL,
  end_year = NULL,
  filters = NULL,
  pre_process = TRUE,
  version = "1.8"
)
```

## Arguments

- start_year:

  Integer. The starting year of the data query. If `NULL`, no lower
  bound is set. Defaults to `NULL`.

- end_year:

  Integer. The ending year of the data query. If `NULL`, no upper bound
  is set. Defaults to `NULL`.

- filters:

  List. A named list of filters to apply (e.g., donor codes, easure,
  flow type, unit measure, price base). Values must match OECD dotstat
  codes.

- pre_process:

  Logical. Whether to clean and rename columns into a standard format.
  If `FALSE`, returns raw output. Defaults to `TRUE`.

- version:

  Character. The version of the OECD dataflow to query, e.g. `"1.8"`.
  Defaults to `"1.8"`, the version the filters in
  [`oda_list_filters()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_list_filters.md)
  are ordered for. Other versions may order dimensions differently. If
  `NULL`, the latest version is used.

## Value

A data frame containing OECD DAC1 data

## Examples

``` r
# \donttest{
oda_get_dac1(
  start_year = 2018,
  end_year = 2022,
  filters = list(
    donor = c("FRA", "USA"),
    measure = 11017,
    flow_type = 1160,
    unit_measure = "XDC",
    price_base = "V"
  )
)
#> # A tibble: 5 × 14
#>   entity_id entity_name series_id series_name  flow_type_id flow_type_name  year
#>   <chr>     <chr>           <int> <chr>               <int> <chr>          <int>
#> 1 FRA       France          11017 Bilateral l…         1160 Grant equival…  2021
#> 2 FRA       France          11017 Bilateral l…         1160 Grant equival…  2018
#> 3 FRA       France          11017 Bilateral l…         1160 Grant equival…  2020
#> 4 FRA       France          11017 Bilateral l…         1160 Grant equival…  2019
#> 5 FRA       France          11017 Bilateral l…         1160 Grant equival…  2022
#> # ℹ 7 more variables: value <dbl>, unit_measure_id <chr>,
#> #   unit_measure_name <chr>, price_base_id <chr>, price_base_name <chr>,
#> #   unit_multiplier_id <int>, unit_multiplier_name <chr>
# }
```
