
#' Manage endpoints
#'
#' Add or remove endpoints in a mariobox project.
#'
#' @param name A character string. The name of the endpoint.
#' @param method A character string. The name of the rest method.
#' @param open A logical. Should the project be exported or not?
#' @param pkg A character string. The path to package root.
#'
#' @return Nothing. Used for its side effect.
#'
#' @importFrom yaml read_yaml write_yaml
#' @importFrom here here
#' @importFrom usethis use_r use_test
#' @importFrom fs path
#' @importFrom cli cli_alert_danger
#'
#' @export
#'
#' @rdname manage_endpoints
#'
#' @examples
#' \dontrun{
#' # Create a new mariobox project
#' path_pipo <- tempfile(pattern = "pipo")
#' create_mariobox(
#'   path = path_pipo,
#'   open = FALSE
#' )
#' # Add an endpoint
#' add_endpoint(
#'   name = "allo",
#'   method = "GET",
#'   open = FALSE,
#'   pkg = path_pipo
#' )
#' # Remove endpoint
#' remove_endpoint(
#'   name = "allo",
#'   pkg = path_pipo
#' )
#' }
add_endpoint <- function(
  name,
  method = "GET",
  open = TRUE,
  pkg = "."
) {
  name_yaml <- sprintf(
    "%s_%s",
    name,
    tolower(method)
  )

  mariobox_yaml_path <- file.path(
    pkg,
    "inst/mariobox.yml"
  )

  yml <- yaml::read_yaml(
    mariobox_yaml_path,
    eval.expr = FALSE
  )

  fct_name <- sprintf(
    "%s_%s",
    tolower(method),
    name
  )

  if (is.null(yml$handles[[name_yaml]])) {
    yml$handles[[name_yaml]] <- list(
      methods = method,
      path = sprintf("/%s", name),
      handler = fct_name
    )
  } else {
    cli_alert_danger(
      sprintf(
        "Endpoint '%s' already exists",
        name
      )
    )
    return(NULL)
  }

  yaml::write_yaml(
    yml,
    mariobox_yaml_path
  )


  usethis_use_r(
    name = fct_name,
    open = open,
    pkg = pkg
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
      "#' %s %s",
      method,
      name
    )
  )
  write_there("#' ")
  write_there("#' @param req,res HTTP objects")
  write_there("#' ")
  write_there("#' @export")
  write_there("#'  ")
  write_there(
    sprintf(
      "%s_%s <- function(req, res){",
      tolower(method),
      name
    )
  )
  write_there(
    "    mariobox::mario_log("
  )
  write_there(
    sprintf(
      "        method = \"%s\",",
      method
    )
  )
  write_there(
    sprintf(
      "        name = \"%s\"",
      name
    )
  )
  write_there("    )")
  write_there(
    sprintf(
      "    %s_%s_f()",
      tolower(method),
      name
    )
  )
  write_there("}")
  write_there(" ")
  write_there(
    sprintf(
      "#' %s %s internal",
      method,
      name
    )
  )
  write_there("#' ")
  write_there("#' @noRd")
  write_there("#'  ")
  write_there(
    sprintf(
      "%s_%s_f <- function(){",
      tolower(method),
      name
    )
  )
  write_there("    return('ok')")
  write_there("}")

  usethis_use_test(
    name = fct_name,
    open = open,
    pkg = pkg
  )

  cat_green_tick("Endpoint added")
}

#' @name manage_endpoints
#' @export
add_delete <- function(
  name,
  open = TRUE,
  pkg = "."
) {
  add_endpoint(
    name = name,
    method = "DELETE",
    open = open,
    pkg = pkg
  )
}

#' @name manage_endpoints
#' @export
add_get <- function(
  name,
  open = TRUE,
  pkg = "."
) {
  add_endpoint(
    name = name,
    method = "GET",
    open = open,
    pkg = pkg
  )
}

#' @name manage_endpoints
#' @export
add_patch <- function(
  name,
  open = TRUE,
  pkg = "."
) {
  add_endpoint(
    name = name,
    method = "PATCH",
    open = open,
    pkg = pkg
  )
}

#' @name manage_endpoints
#' @export
add_post <- function(
  name,
  open = TRUE,
  pkg = "."
) {
  add_endpoint(
    name = name,
    method = "POST",
    open = open,
    pkg = pkg
  )
}

#' @name manage_endpoints
#' @export
add_put <- function(
  name,
  open = TRUE,
  pkg = "."
) {
  add_endpoint(
    name = name,
    method = "PUT",
    open = open,
    pkg = pkg
  )
}

#' @name manage_endpoints
#' @export
remove_endpoint <- function(
  name,
  method,
  pkg = "."
) {
  name_yaml <- sprintf(
    "%s_%s",
    name,
    tolower(method)
  )

  mariobox_yaml_path <- file.path(
    pkg,
    "inst/mariobox.yml"
  )

  yml <- yaml::read_yaml(
    mariobox_yaml_path,
    eval.expr = FALSE
  )

  if (is.null(yml$handles[[name_yaml]])) {
    cli_alert_danger(
      sprintf(
        "There is no endpoint '%s' with method '%s' to delete",
        name,
        method
      )
    )
    return(NULL)
  }

  yml$handles[[name_yaml]] <- NULL

  yaml::write_yaml(
    yml,
    mariobox_yaml_path
  )

  fct_name <- sprintf(
    "%s_%s",
    tolower(method),
    name
  )

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
    file.path(
      "tests",
      "testthat",
      sprintf(
        "test-%s.R",
        fct_name
      )
    )
  )
  cat_green_tick("Endpoint removed")
}
