
# Comment this if you don't want the app to be served on a random port
options(plumber.port = httpuv::randomPort())

rlang::check_installed("devtools", "to load the dev")
rlang::check_installed("pkgload", "to load the dev")

devtools::document()
pkgload::load_all()

# Run the application
run_api()
