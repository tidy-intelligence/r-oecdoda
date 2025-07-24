
<!-- README.md is generated from README.Rmd. Please edit that file -->

# oecdoda

<!-- badges: start -->

![R CMD
Check](https://github.com/tidy-intelligence/r-oecdoda/actions/workflows/R-CMD-check.yaml/badge.svg)
![Lint](https://github.com/tidy-intelligence/r-oecdoda/actions/workflows/lint.yaml/badge.svg)
[![Codecov test
coverage](https://codecov.io/gh/tidy-intelligence/r-oecdoda/graph/badge.svg)](https://app.codecov.io/gh/tidy-intelligence/r-oecdoda)
<!-- badges: end -->

Access and Analyze Official Development Assistance (ODA) using the [OECD
API](https://gitlab.algobank.oecd.org/public-documentation/dotstat-migration/-/raw/main/OECD_Data_API_documentation.pdf).
ODA data includes sovereign-level aid data such as key aggregates
(DAC1), geographical distributions (DAC2A), project-level data (CRS),
and multilateral contributions (Multisystem).

The package is part of the
[EconDataverse](https://www.econdataverse.org/) family of packages aimed
at helping economists and financial professionals work with
sovereign-level economic data. For a Python implementation with a
similar interface, see
[`oda-reader`](https://github.com/ONEcampaign/oda_reader).

This package is a product of Christoph Scheuch and not sponsored by or
affiliated with the OECD in any way, except for the use of the OECD API.

## Installation

You can install `oecdoda` from CRAN via:

``` r
install.packages("oecdoda")
```

You can install the development version of `oecdoda` from
[GitHub](https://github.com/tidy-intelligence/r-oecdoda) with:

``` r
# install.packages("pak")
pak::pak("tidy-intelligence/r-oecdoda")
```

## Usage

Load the package:

``` r
library(oecdoda)
```

`oecdoda` simplifies access to multiple datasets from the OECD API. Each
dataset provides specific filters, which can be listed using:

``` r
oda_list_filters()
#> $`DSD_DAC1@DF_DAC1`
#> [1] "donor"        "measure"      "untied"       "flow_type"    "unit_measure"
#> [6] "price_base"   "period"      
#> 
#> $`DSD_DAC2@DF_DAC2A`
#> [1] "donor"        "recipient"    "measure"      "unit_measure" "price_base"  
#> 
#> $`DSD_CRS@DF_CRS`
#>  [1] "donor"        "recipient"    "sector"       "measure"      "channel"     
#>  [6] "modality"     "flow_type"    "price_base"   "md_dim"       "md_id"       
#> [11] "unit_measure"
#> 
#> $`DSD_GREQ@DF_CRS_GREQ`
#>  [1] "donor"        "recipient"    "sector"       "measure"      "channel"     
#>  [6] "modality"     "flow_type"    "price_base"   "md_dim"       "md_id"       
#> [11] "unit_measure"
#> 
#> $`DSD_MULTI@DF_MULTI`
#>  [1] "donor"        "recipient"    "sector"       "measure"      "channel"     
#>  [6] "flow_type"    "price_base"   "md_dim"       "md_id"        "unit_measure"
```

### Downloading DAC1 Data

The DAC1 dataset includes key aggregates of ODA flows and grant
equivalents from DAC members and other providers, as well as other
resource flows to developing countries.

``` r
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
#> 1 FRA       France          11017 Bilateral l…         1160 Grant equival…  2018
#> 2 FRA       France          11017 Bilateral l…         1160 Grant equival…  2020
#> 3 FRA       France          11017 Bilateral l…         1160 Grant equival…  2019
#> 4 FRA       France          11017 Bilateral l…         1160 Grant equival…  2022
#> 5 FRA       France          11017 Bilateral l…         1160 Grant equival…  2021
#> # ℹ 7 more variables: value <dbl>, unit_measure_id <chr>,
#> #   unit_measure_name <chr>, price_base_id <chr>, price_base_name <chr>,
#> #   unit_multiplier_id <int>, unit_multiplier_name <chr>
```

### Downloading DAC2A Data

The DAC2A dataset provides data on the geographical distribution of
bilateral and multilateral ODA disbursements to developing countries and
territories on the DAC List of ODA recipients. Data is available by
donor, recipient, and aid type (e.g., grants, loans, technical
cooperation, or philanthropic flows).

``` r
oda_get_dac2a(
  start_year = 2018,
  end_year = 2022,
  filters = list(
    donor = "GBR",
    recipient = c("GTM", "CHN"),
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
```

### Downloading CRS Data

The CRS dataset provides granular, activity-level statistics on who
provides what aid, to where, and for what purpose, on a flow basis or a
grant-equivalent basis.

``` r
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
#> #   channel_id <int>, channelt_name <chr>, modality_id <chr>,
#> #   modality_name <chr>, year <int>, value <dbl>, unit_measure_id <chr>,
#> #   unit_measure_name <chr>, price_base_id <chr>, price_base_name <chr>,
#> #   unit_multiplier_id <int>, unit_multiplier_name <chr>
```

### Downloading Multisystem Data

The Multisystem dataset presents providers’ total use of the
multilateral system, including both core contributions to multilateral
organizations and bilateral aid channeled through these organizations.

``` r
oda_get_multisystem(
  start_year = 2018,
  end_year = 2022,
  filters = list(
    donor = "DAC",
    recipient = "DPGC",
    sector = 1000,
    measure = 10
  )
)
#> # A tibble: 3,152 × 18
#>    entity_id entity_name   counterpart_id counterpart_name series_id series_name
#>    <chr>     <chr>         <chr>          <chr>                <int> <chr>      
#>  1 DAC       DAC countries DPGC           Developing coun…        10 Core contr…
#>  2 DAC       DAC countries DPGC           Developing coun…        10 Core contr…
#>  3 DAC       DAC countries DPGC           Developing coun…        10 Core contr…
#>  4 DAC       DAC countries DPGC           Developing coun…        10 Core contr…
#>  5 DAC       DAC countries DPGC           Developing coun…        10 Core contr…
#>  6 DAC       DAC countries DPGC           Developing coun…        10 Core contr…
#>  7 DAC       DAC countries DPGC           Developing coun…        10 Core contr…
#>  8 DAC       DAC countries DPGC           Developing coun…        10 Core contr…
#>  9 DAC       DAC countries DPGC           Developing coun…        10 Core contr…
#> 10 DAC       DAC countries DPGC           Developing coun…        10 Core contr…
#> # ℹ 3,142 more rows
#> # ℹ 12 more variables: flow_type_id <chr>, flow_type_name <chr>,
#> #   channel_id <int>, channel_name <chr>, year <int>, value <dbl>,
#> #   unit_measure_id <chr>, unit_measure_name <chr>, price_base_id <chr>,
#> #   price_base_name <chr>, unit_multiplier_id <int>, unit_multiplier_name <chr>
```

### Rate Limiting

`oecdoda` automatically handles the limits of the OECD API of **20 calls
per hour** (as of July 2025). According to the OECD Service Team, this
limit will be relaxed eventually. If you want to manually change the
limits for your session, use the following options:

``` r
options(
  oecdoda.rate_capacity = 10,
  oecdoda.rate_fill_time = 60
)
```

## Contributing

Contributions to `oecdoda` are welcome! If you’d like to contribute,
please follow these steps:

1.  **Create an issue**: Before making changes, create an issue
    describing the bug or feature you’re addressing.
2.  **Fork the repository**: After receiving supportive feedback from
    the package authors, fork the repository to your GitHub account.
3.  **Create a branch**: Create a branch for your changes with a
    descriptive name.
4.  **Make your changes**: Implement your bug fix or feature.
5.  **Test your changes**: Run tests to ensure your changes don’t break
    existing functionality.
6.  **Submit a pull request**: Push your changes to your fork and submit
    a pull request to the main repository.
