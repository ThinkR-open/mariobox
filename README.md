
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {mariobox}

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/mariobox)](https://CRAN.R-project.org/package=mariobox)
<!-- badges: end -->

\[DISCLAIMER\] This is a Work In Progress, please use at your own risk.

The goal of `{mariobox}` is to provide a framework for packaging
{plumber} APIs. Think of it as the “`{golem}` for `{plumber}`”

## Installation

You can install the development version of `{mariobox}` from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("ThinkR-Open/mariobox")
```

## Example

``` r
library(mariobox)
```

### Creating a new {mariobox} project:

``` r
path_pipo <- tempfile(pattern = "pipo")

# The create mariobox function will generate a new prefilled project
# with everything you need to get your started
create_mariobox(
  path = path_pipo,
  open = FALSE
)
#> ── Creating dir ────────────────────────────────────────────────────────────────
#> ✔ Creating '/var/folders/5z/rm2h62lj45d332kfpj28c8zm0000gn/T/Rtmpm2dkp4/pipo9ab06dce5435/'
#> ✔ Setting active project to '/private/var/folders/5z/rm2h62lj45d332kfpj28c8zm0000gn/T/Rtmpm2dkp4/pipo9ab06dce5435'
#> ✔ Creating 'R/'
#> ✔ Writing a sentinel file '.here'
#> • Build robust paths within your project via `here::here()`
#> • Learn more at <https://here.r-lib.org>
#> ✔ Setting active project to '<no active project>'
#> ✔ Created package directory
#> ── Copying package skeleton ────────────────────────────────────────────────────
#> ✔ Copied app skeleton
#> ── Done ────────────────────────────────────────────────────────────────────────
#> A new mariobox named pipo9ab06dce5435 was created at /private/var/folders/5z/rm2h62lj45d332kfpj28c8zm0000gn/T/Rtmpm2dkp4/pipo9ab06dce5435 .
```

By default, you’ll find the following structure:

``` r
fs::dir_tree(path_pipo)
#> /var/folders/5z/rm2h62lj45d332kfpj28c8zm0000gn/T//Rtmpm2dkp4/pipo9ab06dce5435
#> ├── DESCRIPTION
#> ├── NAMESPACE
#> ├── R
#> │   ├── get_health.R
#> │   └── run_plumber.R
#> ├── dev
#> │   └── run_dev.R
#> ├── inst
#> │   └── mariobox.yml
#> ├── man
#> │   └── run_api.Rd
#> └── tests
#>     ├── testthat
#>     │   ├── test-health.R
#>     │   └── test-run_plumber.R
#>     └── testthat.R
```

The default API comes with one default endpoint, `/health`, which
returns a 200 with the “ok” text.

We’ve made the choice to organise your API inside a YAML, so that you
can be as close as possible to a package structure. `{mariobox}` will
then do a little bit of its magic and parse this YAML to build the
`{plumber}` API.

    #> metadata:
    #>    title: mariobox API
    #>  handles:
    #>    health_get:
    #>      methods: GET
    #>      path: /health
    #>      handler: health

### Add/Remove endpoints

`{mariobox}` comes with a series of functions to add endpoints to your
app. The generic one is `add_endpoint`, that allows you to pass any HTTP
verb, and add_get and friends are wrappers around this function.

``` r
add_endpoint(
  name = "allo",
  method = "GET",
  open = FALSE,
  pkg = path_pipo
)
#> ✔ Endpoint added
```

This will produce the following R file:

    #> #' GET allo
    #> #' 
    #> #' @param req,res HTTP objects
    #> #' 
    #> #' @export
    #> #'  
    #> get_allo <- function(req, res){
    #>     mariobox::mario_log(
    #>         method = "GET",
    #>         name = "allo"
    #>     )
    #>     get_allo_f()
    #> }
    #>  
    #> #' GET allo internal
    #> #' 
    #> #' @noRd
    #> #'  
    #> get_allo_f <- function(){
    #>     return('ok')
    #> }

``` r
add_get(
  name = "hey",
  open = FALSE,
  pkg = path_pipo
)
#> ✔ Endpoint added
```

``` r
fs::dir_tree(path_pipo)
#> /var/folders/5z/rm2h62lj45d332kfpj28c8zm0000gn/T//Rtmpm2dkp4/pipo9ab06dce5435
#> ├── DESCRIPTION
#> ├── NAMESPACE
#> ├── R
#> │   ├── get_allo.R
#> │   ├── get_health.R
#> │   ├── get_hey.R
#> │   └── run_plumber.R
#> ├── dev
#> │   └── run_dev.R
#> ├── inst
#> │   └── mariobox.yml
#> ├── man
#> │   └── run_api.Rd
#> └── tests
#>     ├── testthat
#>     │   ├── test-get_allo.R
#>     │   ├── test-get_hey.R
#>     │   ├── test-health.R
#>     │   └── test-run_plumber.R
#>     └── testthat.R
```

    #> metadata:
    #>    title: mariobox API
    #>  handles:
    #>    health_get:
    #>      methods: GET
    #>      path: /health
    #>      handler: health
    #>    allo_get:
    #>      methods: GET
    #>      path: /allo
    #>      handler: allo
    #>    hey_get:
    #>      methods: GET
    #>      path: /hey
    #>      handler: hey

``` r
remove_endpoint(
  name = "allo",
  method = "GET",
  pkg = path_pipo
)
#> ✔ Endpoint removed
```

``` r
fs::dir_tree(path_pipo)
#> /var/folders/5z/rm2h62lj45d332kfpj28c8zm0000gn/T//Rtmpm2dkp4/pipo9ab06dce5435
#> ├── DESCRIPTION
#> ├── NAMESPACE
#> ├── R
#> │   ├── get_health.R
#> │   ├── get_hey.R
#> │   └── run_plumber.R
#> ├── dev
#> │   └── run_dev.R
#> ├── inst
#> │   └── mariobox.yml
#> ├── man
#> │   └── run_api.Rd
#> └── tests
#>     ├── testthat
#>     │   ├── test-get_allo.R
#>     │   ├── test-get_hey.R
#>     │   ├── test-health.R
#>     │   └── test-run_plumber.R
#>     └── testthat.R
```

    #> metadata:
    #>    title: mariobox API
    #>  handles:
    #>    health_get:
    #>      methods: GET
    #>      path: /health
    #>      handler: health
    #>    hey_get:
    #>      methods: GET
    #>      path: /hey
    #>      handler: hey

### About endpoint functions

All endpoint functions will be in the following format:

``` r
METHOD_NAME <- function(req, res) {
  METHOD_NAME_f()
}

METHOD_NAME_f <- function() {
  return("ok")
}
```

where `METHOD` is the HTTP verb and `name` is the name you’ve set in
your function.

This format might seem weird, but the idea is to separate the concerns
in the following format:

-   METHOD_NAME() will handle the http elements (login, headers..)
-   METHOD_NAME_f() will be a standard function returning data.

That way, you can handle the data manipulation function just like a
plain standard one, test it, interact with it, etc, without having to
care about the HTTP part.

## Running the API

In dev, you can launch the file at dev/run_dev.R. Note that
`golem::run_dev()` will also launch this file:

``` r
golem::run_dev()
```

In production, the `run_api()` is in charge of running the API.

If you want to deloy to RStudio Connect, the `build_plumber_file()`
function will create a `plumber.R` file at the root of your folder. You
can deploy using this file.

``` r
build_plumber_file(pkg = path_pipo)
#> ℹ Loading pipo9ab06dce5435
#> ✔ plumber.R file created
```

``` r
readLines(
  file.path(
    path_pipo,
    "plumber.R"
  )
) |> cat(sep = "\n")
#> library(plumber)
#>  
#> #* @apiTitle mariobox API
#>  
#> pkgload::load_all()
#>  
#>  
#> #* @get /health
#> health
#>  
#> #* @get /hey
#> hey
```
