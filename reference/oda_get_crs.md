# Get OECD Creditor Reporting System (CRS) data

Retrieves data from the OECD CRS dataset using specified filters, years,
and optional pre-processing.

## Usage

``` r
oda_get_crs(
  start_year = NULL,
  end_year = NULL,
  filters = NULL,
  pre_process = TRUE,
  as_grant_equivalent = FALSE,
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

- as_grant_equivalent:

  Logical. Whether the 'flows' or 'grant equivalent' version of the CRS
  should be returned.

- version:

  Character. The version of the OECD dataflow to query, e.g. `"1.7"`.
  Defaults to `"1.7"`, the version the filters in
  [`oda_list_filters()`](https://tidy-intelligence.github.io/r-oecdoda/reference/oda_list_filters.md)
  are ordered for. Other versions may order dimensions differently. If
  `NULL`, the latest version is used.

## Value

A data frame containing OECD CRS data

## Examples

``` r
# \donttest{
oda_get_crs(
  start_year = 2018,
  end_year = 2022,
  filters = list(
    donor = c("AUT", "FRA", "USA"),
    recipient = "BIH",
    measure = 100,
    channel = 60000,
    price_base = "Q"
  )
)
#> # A tibble: 1,257 × 20
#>    entity_id entity_name   counterpart_id counterpart_name series_id series_name
#>    <chr>     <chr>         <chr>          <chr>                <int> <chr>      
#>  1 USA       United States BIH            Bosnia and Herz…       100 Official D…
#>  2 USA       United States BIH            Bosnia and Herz…       100 Official D…
#>  3 USA       United States BIH            Bosnia and Herz…       100 Official D…
#>  4 USA       United States BIH            Bosnia and Herz…       100 Official D…
#>  5 USA       United States BIH            Bosnia and Herz…       100 Official D…
#>  6 USA       United States BIH            Bosnia and Herz…       100 Official D…
#>  7 USA       United States BIH            Bosnia and Herz…       100 Official D…
#>  8 USA       United States BIH            Bosnia and Herz…       100 Official D…
#>  9 USA       United States BIH            Bosnia and Herz…       100 Official D…
#> 10 USA       United States BIH            Bosnia and Herz…       100 Official D…
#> # ℹ 1,247 more rows
#> # ℹ 14 more variables: flow_type_id <chr>, flow_type_name <chr>,
#> #   channel_id <int>, channel_name <chr>, modality_id <chr>,
#> #   modality_name <chr>, year <int>, value <dbl>, unit_measure_id <chr>,
#> #   unit_measure_name <chr>, price_base_id <chr>, price_base_name <chr>,
#> #   unit_multiplier_id <int>, unit_multiplier_name <chr>
# }
```
