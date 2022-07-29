
dir_remove <- function(path) {
  unlink(
    x = path,
    recursive = TRUE,
    force = TRUE
  )
}
