
#' @importFrom yaml read_yaml write_yaml
#' @importFrom here here
#' @importFrom usethis use_r use_test
#' @importFrom fs path
#' @importFrom cli cli_alert_danger
#'
#' @export
pw_add_endpoint <- function(
  name,
  methods = "GET",
  open = TRUE,
  pkg = "."
) {
  pipework_yaml_path <- file.path(pkg, "inst/pipework.yml")

  yml <- yaml::read_yaml(
    pipework_yaml_path,
    eval.expr = FALSE
  )

  if (is.null(yml$handles[[name]])) {
    yml$handles[[name]] <- list(
      methods = methods,
      path = sprintf("/%s", name),
      handler = name
    )
  } else {
    cli_alert_danger(
      sprintf("Endpoint '%s' already created", name)
    )
    return(NULL)
  }

  yaml::write_yaml(
    yml,
    pipework_yaml_path
  )

  fct_name <- sprintf("fct_%s", name)
  usethis::use_r(
    name = fct_name,
    open = open
  )

  f_path <- file.path(
    pkg,
    "R",
    paste0(fct_name, ".R")
  )

  write_there <- function(x) {
    write(x, file = f_path, append = TRUE)
  }
  write_there(
    sprintf(
      "%s <- function(req){",
      name
    )
  )
  write_there("    return(\"ok\")")
  write_there("}")

  usethis::use_test(
    name = fct_name,
    open = open
  )
  return(invisible(f_path))
}

pw_remove_endpoint <- function(
  name,
  pkg = "."
) {
  pipework_yaml_path <- file.path(pkg, "inst/pipework.yml")

  yml <- yaml::read_yaml(
    pipework_yaml_path,
    eval.expr = FALSE
  )

  if (is.null(yml$handles[[name]])) {
    cli_alert_danger(
      sprintf("There is no endpoint '%s' to delete", name)
    )
    return(NULL)
  }

  yml$handles[[name]] <- NULL

  yaml::write_yaml(
    yml,
    pipework_yaml_path
  )

  fct_name <- sprintf("fct_%s", name)
  f_path <- file.path(
    pkg,
    "R",
    paste0(fct_name, ".R")
  )

  unlink(
    x = f_path,
    recursive = TRUE,
    force = TRUE
  )
  unlink(
    file.path("tests", "testthat", sprintf("test-%s.R", fct_name))
  )
}
