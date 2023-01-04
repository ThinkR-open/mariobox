#' Launch the API
#'
#' @param yaml_file path to the yaml
#' @importFrom plumber Plumber
#' @importFrom yaml read_yaml
#' @export
new_api <- function(yaml_file) {
  api <- Plumber$new()
  api_definition <- read_yaml(
    yaml_file,
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
