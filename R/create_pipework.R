

#' @importFrom cli cat_rule cat_line
#' @importFrom utils getFromNamespace
#' @importFrom rstudioapi isAvailable openProject hasFun
#' @importFrom usethis create_project
#' @importFrom fs dir_copy
create_pipework <- function(
  path,
  # check_name = TRUE,
  open = TRUE,
  overwrite = FALSE,
  package_name = basename(path)
) {

  # if (check_name) {
  #   cat_rule("Checking package name")
  #   getFromNamespace("check_package_name", "usethis")(package_name)
  #   cat_green_tick("Valid package name")
  # }

  if (dir.exists(path)) {
    if (!isTRUE(overwrite)) {
      stop(
        paste(
          "Project directory already exists. \n",
          "Set `create_pipework(overwrite = TRUE)` to overwrite anyway.\n",
          "Be careful this will restore a brand new golem. \n",
          "You might be at risk of losing your work !"
        ),
        call. = FALSE
      )
    } else {
      cat_red_bullet("Overwriting existing project.")
    }
  } else {
    cat_rule("Creating dir")
    usethis::create_project(
      path = path,
      open = FALSE,
    )
    cat_green_tick("Created package directory")
  }

  cat_rule("Copying package skeleton")
  pipeworkexample_path <- pipework_sys("pipeworkexample")
  dir_copy(
    path = pipeworkexample_path,
    new_path = path,
    overwrite = TRUE
  )
  # Listing copied files ***from source directory***
  copied_files <- list.files(
    path = pipeworkexample_path,
    full.names = FALSE,
    all.files = TRUE,
    recursive = TRUE
  )
  # Going through copied files to replace package name
  for (file in copied_files) {
    copied_file <- file.path(path, file)
    if (grepl("^REMOVEME", file)) {
      file.rename(
        from = copied_file,
        to = file.path(path, gsub("REMOVEME", "", file))
      )
      copied_file <- file.path(path, gsub("REMOVEME", "", file))
    }
    replace_word(
      file = copied_file,
      pattern = "pipeworkexample",
      replace = package_name
    )
  }
  cat_green_tick("Copied app skeleton")

  cat_rule("Done")
  cat_line(
    paste0(
      "A new pipework named ",
      package_name,
      " was created at ",
      normalizePath(path),
      " .\n" # ,
      # "To continue working on your app, start editing the 01_start.R file."
    )
  )

  if (isTRUE(open)) {
    if (rstudioapi::isAvailable() & rstudioapi::hasFun("openProject")) {
      rstudioapi::openProject(path = path)
    } else {
      setwd(path)
    }
  }

  return(
    invisible(
      normalizePath(path)
    )
  )
}
