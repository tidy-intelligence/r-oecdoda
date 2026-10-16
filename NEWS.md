# oecdoda (development version)

* Fixed `oda_get_crs()` failing with "HTTP 404 Not Found" because OECD retired version 1.4 of the CRS dataflows (#4).
* `oda_get_crs()`, `oda_get_dac1()`, `oda_get_dac2a()`, and `oda_get_multisystem()` gain a `version` argument to choose the OECD dataflow version. Defaults are pinned to the current versions (DAC1 1.8; CRS, DAC2A, and Multisystem 1.7). Use `version = NULL` to query the latest version.
* Breaking: the DAC1 filters now follow the dimension order of DAC1 version 1.8, and the last DAC1 filter, previously misnamed `period`, is now `sector`.
* Breaking: the pre-processed `oda_get_crs()` output column `channelt_name` is renamed to `channel_name`.

# oecdoda 0.1.0

* Initial CRAN submission with `oda_get_dac1()`, `oda_get_dac2a()`, `oda_get_crs()`, `oda_get_multisystem()`, and `oda_list_filters()`.
