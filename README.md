
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {pipework}

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/pipework)](https://CRAN.R-project.org/package=pipework)
<!-- badges: end -->

The goal of pipework is to provide a framework for packaging {plumber}
APIs, the same way {golem} is a framework for packaging {shiny} apps.

## Installation

You can install the development version of pipework from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("ThinkR-Open/pipework")
```

## Example

``` r
library(pipework)
```

### Creating a new pipework project:

``` r
path_pipo <- tempfile(pattern = "pipo")
create_pipework(
  path = path_pipo,
  open = FALSE
)
#> ── Creating dir ────────────────────────────────────────────────────────────────
#> ✔ Creating '/tmp/RtmpaExIU6/pipofc3e355c5196/'
#> ✔ Setting active project to '/tmp/RtmpaExIU6/pipofc3e355c5196'
#> ✔ Creating 'R/'
#> ✔ Writing a sentinel file '.here'
#> • Build robust paths within your project via `here::here()`
#> • Learn more at <https://here.r-lib.org>
#> ✔ Setting active project to '<no active project>'
#> ✔ Created package directory
#> ── Copying package skeleton ────────────────────────────────────────────────────
#> ✔ Copied app skeleton
#> ── Done ────────────────────────────────────────────────────────────────────────
#> A new pipework named pipofc3e355c5196 was created at /tmp/RtmpaExIU6/pipofc3e355c5196 .
```

``` r
fs::dir_tree(path_pipo)
#> /tmp/RtmpaExIU6/pipofc3e355c5196
#> ├── DESCRIPTION
#> ├── NAMESPACE
#> ├── R
#> │   ├── fct_health.R
#> │   └── run_plumber.R
#> ├── dev
#> │   └── run_dev.R
#> ├── inst
#> │   └── pipework.yml
#> ├── man
#> │   └── run_api.Rd
#> └── tests
#>     ├── testthat
#>     │   ├── test-health.R
#>     │   └── test-run_plumber.R
#>     └── testthat.R
```

    #> handles:
    #>    health:
    #>      methods: GET
    #>      path: /health
    #>      handler: health

### Add/Remove endpoints

``` r
pw_add_endpoint(
  name = "allo",
  methods  = "GET",
  open = FALSE,
  pkg = path_pipo
)
#> ✔ Setting active project to '/home/bob/projects/pipework'
#> • Edit 'R/fct_allo.R'
#> • Call `use_test()` to create a matching test file
#> ✔ Writing 'tests/testthat/test-fct_allo.R'
#> • Edit 'tests/testthat/test-fct_allo.R'
```

``` r
fs::dir_tree(path_pipo)
#> /tmp/RtmpaExIU6/pipofc3e355c5196
#> ├── DESCRIPTION
#> ├── NAMESPACE
#> ├── R
#> │   ├── fct_allo.R
#> │   ├── fct_health.R
#> │   └── run_plumber.R
#> ├── dev
#> │   └── run_dev.R
#> ├── inst
#> │   └── pipework.yml
#> ├── man
#> │   └── run_api.Rd
#> └── tests
#>     ├── testthat
#>     │   ├── test-health.R
#>     │   └── test-run_plumber.R
#>     └── testthat.R
```

    #> handles:
    #>    health:
    #>      methods: GET
    #>      path: /health
    #>      handler: health
    #>    allo:
    #>      methods: GET
    #>      path: /allo
    #>      handler: allo

``` r
pw_remove_endpoint(
  name = "allo",
  pkg = path_pipo
)
```

``` r
fs::dir_tree(path_pipo)
#> /tmp/RtmpaExIU6/pipofc3e355c5196
#> ├── DESCRIPTION
#> ├── NAMESPACE
#> ├── R
#> │   ├── fct_health.R
#> │   └── run_plumber.R
#> ├── dev
#> │   └── run_dev.R
#> ├── inst
#> │   └── pipework.yml
#> ├── man
#> │   └── run_api.Rd
#> └── tests
#>     ├── testthat
#>     │   ├── test-health.R
#>     │   └── test-run_plumber.R
#>     └── testthat.R
```

    #> handles:
    #>    health:
    #>      methods: GET
    #>      path: /health
    #>      handler: health
