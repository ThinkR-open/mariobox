#' A data frame with HTTP error codes
#'
#' @noRd
http_error_codes <- structure(
  list(category = c("Client Error", "Client Error", "Client Error", 
  "Client Error", "Client Error", "Client Error", "Client Error", 
  "Client Error", "Client Error", "Client Error", "Client Error", 
  "Client Error", "Client Error", "Client Error", "Client Error", 
  "Client Error", "Client Error", "Client Error", "Client Error", 
  "Client Error", "Client Error", "Client Error", "Client Error", 
  "Client Error", "Client Error", "Client Error", "Client Error", 
  "Client Error", "Client Error", "Server Error", "Server Error", 
  "Server Error", "Server Error", "Server Error", "Server Error", 
  "Server Error", "Server Error", "Server Error", "Server Error", 
  "Server Error"), status = c(400L, 401L, 402L, 403L, 404L, 405L, 
  406L, 407L, 408L, 409L, 410L, 411L, 412L, 413L, 414L, 415L, 416L, 
  417L, 418L, 421L, 422L, 423L, 424L, 425L, 426L, 428L, 429L, 431L, 
  451L, 500L, 501L, 502L, 503L, 504L, 505L, 506L, 507L, 508L, 510L, 
  511L), message = c("Bad Request", "Unauthorized", "Payment Required", 
  "Forbidden", "Not Found", "Method Not Allowed", "Not Acceptable", 
  "Proxy Authentication Required", "Request Timeout", "Conflict", 
  "Gone", "Length Required", "Precondition Failed", "Payload Too Large", 
  "URI Too Long", "Unsupported Media Type", "Range Not Satisfiable", 
  "Expectation Failed", "I'm a teapot", "Misdirected Request", 
  "Unprocessable Entity", "Locked", "Failed Dependency", "Too Early", 
  "Upgrade Required", "Precondition Required", "Too Many Requests", 
  "Request Header Fields Too Large", "Unavailable For Legal Reasons", 
  "Internal Server Error", "Not Implemented", "Bad Gateway", "Service Unavailable", 
  "Gateway Timeout", "HTTP Version Not Supported", "Variant Also Negotiates", 
  "Insufficient Storage", "Loop Detected", "Not Extended", "Network Authentication Required"
  )), row.names = c(400L, 401L, 402L, 403L, 404L, 405L, 406L, 407L, 
  408L, 409L, 410L, 411L, 412L, 413L, 414L, 415L, 416L, 417L, 418L, 
  421L, 422L, 423L, 424L, 425L, 426L, 428L, 429L, 431L, 451L, 500L, 
  501L, 502L, 503L, 504L, 505L, 506L, 507L, 508L, 510L, 511L), class = "data.frame")

#' Produce HTTP errors
#'
#' This function is similar to [stop()] and is used to automatically
#' distinguish server vs. client errors in a Plumber API.
#'
#' @param status Integer, HTTP status code for the error (4xx or 5xx).
#' @param message Character, the error message (can be a vector).
#' 
#' @return A condition object of class `"http_error"`.
#'
#' @export
#'
#' @examples
#' ## R's default error
#' str(attr(try(stop("Hey, stop!")), "condition"))
#' 
#' ## default status code 500 with default error message
#' str(attr(try(http_error()), "condition"))
#' 
#' ## custom status code with default error message
#' str(attr(try(http_error(501L)), "condition"))
#' 
#' ## custom status code for client error
#' str(attr(try(http_error(400L, "Provide valid email address.")), "condition"))
#'
http_error <- function(status = 500L, message = NULL) {
  status <- as.integer(status)
  if (!(status %in% http_error_codes$status))
    stop("Unrecognized status code.")
  i <- as.list(http_error_codes[as.character(status),])
  if (!is.null(message))
    i[["message"]] <- message
  x <- structure(i, class = c("http_error", "error", "condition"))
  stop(x)
}
