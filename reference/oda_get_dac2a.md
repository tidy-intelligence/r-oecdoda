# Get OECD DAC2A Official Development Assistance (ODA) data

Retrieves data from the OECD DAC2A dataset using specified filters,
years, and optional pre-processing.

## Usage

``` r
oda_get_dac2a(
  start_year = NULL,
  end_year = NULL,
  filters = NULL,
  pre_process = TRUE,
  version = "1.7"
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

  Character. The version of the OECD dataflow to query, e.g. `"1.7"`.
  Defaults to `"1.7"`, the version the filters in
  [`oda_list_filters()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_list_filters.md)
  are ordered for. Other versions may order dimensions differently. If
  `NULL`, the latest version is used.

## Value

A data frame containing OECD DAC2A data

## Examples

``` r
# \donttest{
oda_get_dac2a(
  start_year = 2018,
  end_year = 2022,
  filters = list(
    donor = "GBR",
    recipient = c("GTM","CHN"),
    measure = 106,
    price_base = "Q"
  )
)
#> # A tibble: 10 × 16
#>    entity_id entity_name   counterpart_id counterpart_name series_id series_name
#>    <chr>     <chr>         <chr>          <chr>                <int> <chr>      
#>  1 GBR       United Kingd… CHN            China (People’s…       106 Imputed mu…
#>  2 GBR       United Kingd… GTM            Guatemala              106 Imputed mu…
#>  3 GBR       United Kingd… CHN            China (People’s…       106 Imputed mu…
#>  4 GBR       United Kingd… GTM            Guatemala              106 Imputed mu…
#>  5 GBR       United Kingd… CHN            China (People’s…       106 Imputed mu…
#>  6 GBR       United Kingd… GTM            Guatemala              106 Imputed mu…
#>  7 GBR       United Kingd… CHN            China (People’s…       106 Imputed mu…
#>  8 GBR       United Kingd… GTM            Guatemala              106 Imputed mu…
#>  9 GBR       United Kingd… CHN            China (People’s…       106 Imputed mu…
#> 10 GBR       United Kingd… GTM            Guatemala              106 Imputed mu…
#> # ℹ 10 more variables: flow_type_id <chr>, flow_type_name <chr>, year <int>,
#> #   value <dbl>, unit_measure_id <chr>, unit_measure_name <chr>,
#> #   price_base_id <chr>, price_base_name <chr>, unit_multiplier_id <int>,
#> #   unit_multiplier_name <chr>
# }
```
