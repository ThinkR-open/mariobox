#' Log endpoint
#'
#' Log Sys.time() and endpoint name
#'
#' @param method HTTP verb
#' @param name Name of the endpoint
#'
#' @export
#'
#' @examples
#' mario_log("GET", "health")
mario_log <- function(
  method,
  name
) {
  cli::cat_rule(
    sprintf(
      "[%s] %s - %s",
      Sys.time(),
      method,
      name
    )
  )
}
