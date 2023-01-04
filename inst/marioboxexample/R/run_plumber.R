#' Run the API server
#'
#' Read the yaml file listing all endpoints and
#' deploy them
#'
#' @export
run_api <- function() {
  generate_api()$run()
}

generate_api <- function() {
  mariobox::new_api(
    yaml_file = system.file(
      "mariobox.yml",
      package = "marioboxexample"
    )
  )
}