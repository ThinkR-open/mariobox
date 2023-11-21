#' Run the API server
#'
#' Read the yaml file listing all endpoints and
#' deploy them
#'
#' @param host The IPv4 address that the plumber should listen on.
#' Defaults to the plumber.host option, if set, or "127.0.0.1" if not. 
#'
#' @export
run_api <- function(host = getOption("plumber.host",default = "127.0.0.1")) {
  generate_api()$run(host = host)
}

generate_api <- function() {
  mariobox::new_api(
    yaml_file = system.file(
      "mariobox.yml",
      package = "marioboxexample"
    )
  )
}