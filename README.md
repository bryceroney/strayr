
<!-- README.md is generated from README.Rmd. Please edit that file -->

# strayr <img src="man/figures/apple-touch-icon-152x152.png" align="right" style="height:150px"/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/runapp-aus/strayr/workflows/R-CMD-check/badge.svg)](https://github.com/runapp-aus/strayr/actions)

<!-- badges: end -->

There are many great sources of Australian data for use by analysts.
This package aims to simplify access to those datasets by providing them
in a consistent and easy to use format. It also contains a number of
helper functions to assist with analysis work.

This package is currently **in development** and subject to change. The
lifecycle badge will be changed to `stable` when it is stable (should be
relatively soon).

**Contribute to this package**: This package is part of
[runapp](https://github.com/runapp-aus): the Australian R Users Network
of Australian Public Policy, people are actively encouraged to
contribute to this package.

## Installation

You can install the current version of `strayr` with:

``` r
if (!require("remotes")) install.packages("remotes")
remotes::install_github("runapp-aus/strayr")
```

## What’s in the box?

The `strayr` package provides tools to make working with Australian data
easier. This includes:

-   tidy versions of common structures used by the Australian Bureau of
    Statistics (ABS);
-   tidy versions of other helpful datasets like Australian public
    holidays; and
-   helper functions to help you work with your data.

### Structures

Current structures stored in `strayr` are:

| Dataset name  | Title                                                                       |
|---------------|-----------------------------------------------------------------------------|
| `?anzsco`     | Australian and New Zealand Standard Classification of Occupations           |
| `?anzsic`     | Australian and New Zealand Standard Industrial Classification               |
| `?asced_foe`  | Australian Standard Classification of Education - Field of education levels |
| `?asced_qual` | Australian Standard Classification of Education - Qualification levels      |

### Other datasets

-   `?auholidays` contains a tidy dataset of Australian public holidays
    and an associated helper function `is_holiday()`
-   The package also loads
    [`absmapsdata`](https://github.com/wfmackey/absmapsdata), which
    contains ASGS (like `absmapsdata::sa12016`) and non-ASGS structures
    (like `absmapsdata::ced2018`) *and their geometry* as `sf` objects.

### Helper functions

-   Functions to help clean data, including `clean_state()` and
    `clean_anzsco()`. An example of how to clean state names can be
    found in `vignette("clean_state")`
-   The `get_seifa()` function to download
    [SEIFA](https://www.abs.gov.au/AUSSTATS/abs@.nsf/Lookup/2033.0.55.001Main+Features12016?OpenDocument)
    data.
