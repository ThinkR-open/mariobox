
#' A silent version of lapply used for its side effect
#'
#' Does not return any output. This is a dependency-free equivalent
#' of the {purrr} walk() function.
#'
#' @noRd
silent_lapply <- function(.x, .f, ...) {
  invisible(
    lapply(
      X = .x,
      FUN = .f,
      ...
    )
  )
}

mariobox_sys <- function(
  ...,
  lib.loc = NULL,
  mustWork = FALSE
) {
  system.file(
    ...,
    package = "mariobox",
    lib.loc = lib.loc,
    mustWork = mustWork
  )
}

#' @importFrom cli cat_bullet
#' @noRd
cat_green_tick <- function(...) {
  cat_bullet(
    ...,
    bullet = "tick",
    bullet_col = "green"
  )
}

#' @importFrom cli cat_bullet
#' @noRd
cat_red_bullet <- function(...) {
  cat_bullet(
    ...,
    bullet = "bullet",
    bullet_col = "red"
  )
}

replace_word <- function(
  file,
  pattern,
  replace
) {
  suppressWarnings(tx <- readLines(file))
  tx2 <- gsub(
    pattern = pattern,
    replacement = replace,
    x = tx
  )
  writeLines(
    tx2,
    con = file
  )
}
