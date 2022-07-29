
#' @importFrom plumber Plumber
#' @importFrom yaml read_yaml
#' @noRd
new_api <- function(
    yam = system.file(
      "pipework.yml",
      package = "pipeworkexample"
    )
) {
  api <- Plumber$new()
  api_definition <- read_yaml(
    yam,
    eval.expr = TRUE
  )
  for (handle in api_definition$handles) {
    api$handle(
      methods = handle$methods,
      path = handle$path,
      handler = get(handle$handler)
    )
  }
  return(api)
}


#' Run the API server
#'
#' Read the yaml file listing all endpoints and
#' deploy them
#'
#' @export
run_api <- function() {
  new_api()$run()
}
