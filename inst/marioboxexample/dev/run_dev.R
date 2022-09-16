
# Comment this if you don't want the app to be served on a random port
options(plumber.port = httpuv::randomPort())

# Detach all loaded packages and clean your environment
golem::detach_all_attached()

# Document and reload your package
golem::document_and_reload()

# Run the application
run_api()
