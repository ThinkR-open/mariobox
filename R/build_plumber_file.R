#' Build the plumber.R file
#'
#' @param pkg path to package
#'
#' @export
build_plumber_file <- function(pkg = ".") {
  pkgload_load_all(path = pkg)
  plum_file <- file.path(
    pkg,
    "plumber.R"
  )

  write_there <- function(x) {
    write(x, plum_file, append = TRUE)
  }

  mariobox_yaml_path <- file.path(
    pkg,
    "inst/mariobox.yml"
  )

  api_definition <- read_yaml(
    mariobox_yaml_path,
    eval.expr = TRUE
  )

  write_there("library(plumber)")
  write_there(" ")

  write_there(
    sprintf(
      "#* @apiTitle %s",
      api_definition$metadata$title
    )
  )

  write_there(" ")
  write_there("pkgload::load_all()")
  write_there(" ")
  for (handle in api_definition$handles) {
    write_there(" ")
    write_there(
      sprintf(
        "#* @%s %s",
        tolower(handle$methods),
        handle$path
      )
    )
    write_there(handle$handler)
  }
  cat_green_tick("plumber.R file created")
}
