#' Get the health of the API
#' 
#' @param req,res HTTP objects
#' @export
get_health <- function(req, res) {
  mariobox::mario_log(
    method = "GET",
    name = "health"
  )
  get_health_f()
}

get_health_f <- function(){
  return("ok")
}
