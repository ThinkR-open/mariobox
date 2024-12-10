run_quietly_in_a_dummy_mariobox <- function(expr) {
  on.exit(
    {
      dir_remove(
        dummy_mariobox
      )
    },
    add = TRUE
  )
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      dummy_mariobox <- create_dummy_mariobox()
      withr::with_dir(
        dummy_mariobox,
        expr
      )
    }
  )
}

dir_remove <- function(path) {
  unlink(
    x = path,
    recursive = TRUE,
    force = TRUE
  )
}

create_dummy_mariobox <- function(){
  copy_empty_mariobox(
    file.path(
      tempdir(),
      "dummymariobox"
    ),
    "dummymariobox"
  )
}