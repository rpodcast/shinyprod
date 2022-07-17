#' Deploy workshop app
#' @param tag string for tag of the content. Default is "shinyprod"
#' @param displaymode type of display to use in app deployment. Default
#'   is "Showcase", meaning the application code will be displayed
#'   alongside the app. To disable this mode, set to "Normal" instead.
#' @import cli
#' @import connectapi
#' @importFrom rstudioapi getSourceEditorContext
#' @importFrom rsconnect writeManifest accounts
#' @export
shinyprod_deploy <- function(tag = "shinyprod", displaymode = "Showcase") {
  # obtain user ID of connect account
  user_id <- accounts()$name
  cli_alert_info("User ID on RStudio Connect: {user_id}")

  # check that app.R is active in source pane of RStudio
  editor_contents <- rstudioapi::getSourceEditorContext()
  if (fs::path_file(editor_contents$path) != "app.R") {
    cli_abort("Please select the app.R file for your application in RStudio")
  }

  # obtain full path to directory of app
  app_path <- fs::path_dir(editor_contents$path)

  # obtain directory name of app path (this will correspond to exercise)
  app_dir <- fs::path_file(app_path)

  cli_alert_info("application exercise: {app_dir}")

  # establish connection to rstudio connect
  client <- connect(
    server = Sys.getenv("CONNECT_SERVER"),
    api_key = Sys.getenv("CONNECT_API_KEY")
  )

  # grab user full name from connectapi
  user_name <- client$GET("v1/user")[c("first_name", "last_name")] %>%
    paste(., collapse = " ")

  cli_alert_info("user name: {user_name}")


  desc_path <- process_description(
    exercise_id = app_dir,
    user_name = user_name,
    app_path = app_path,
    displaymode = displaymode
  )

  # use rsconnect to write manifest file
  if (!fs::file_exists(fs::path(app_path, "manifest.json"))) {
    writeManifest(appDir = app_path)
  }

  # prepare for deployment
  cat_rule("Beginning your application deployment (verbose messages incoming)")
  bundle <- bundle_dir(app_path)
  content <- client %>%
    deploy(
      bundle,
      name = glue::glue("{app_dir}-{user_id}"),
      title = glue::glue("Exercise {app_dir} app from {user_name}"),
      access_type = "logged_in"
    ) %>%
    poll_task()

  # remove description file
  fs::file_delete(desc_path)

  # remove manifest
  fs::file_delete(fs::path(app_path, "manifest.json"))

  cat_rule("Initial deployment completed")

  # obtain the tag_id in the rstudio connect server based on tag string
  tag_id <- get_tag_data(client) %>%
    dplyr::filter(name == tag) %>%
    dplyr::pull(id)

  # set tag
  set_content_tags(content, tag_id = tag_id)

  # obtain URL of content
  app_url <- content$get_content()$url

  cli_alert_success("Application deployed! Visit {.url {app_url}}.")
  invisible(app_url)
}
