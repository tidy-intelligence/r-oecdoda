# List Available Filters for an ODA Resource

List Available Filters for an ODA Resource

## Usage

``` r
oda_list_filters(resource = NULL)
```

## Arguments

- resource:

  A character string identifying the resource (e.g.,
  `"DSD_CRS@DF_CRS"`).

## Value

A character vector of available filter names for the given resource.

## Examples

``` r
oda_list_filters()
#> $`DSD_DAC1@DF_DAC1`
#> [1] "donor"        "sector"       "measure"      "untied"       "flow_type"   
#> [6] "unit_measure" "price_base"  
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
#> 

oda_list_filters("DSD_DAC2@DF_DAC2A")
#> [1] "donor"        "recipient"    "measure"      "unit_measure" "price_base"  
```
