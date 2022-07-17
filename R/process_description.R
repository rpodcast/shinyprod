process_description <- function(exercise_id, user_name, app_path, displaymode = "Showcase") {

  # import template description file
  tmp_contents <- xfun::read_utf8(system.file("templates", "description_template.txt", package = "shinyprod"))

  # populate with variable using whisker package
  filled_tmp <- whisker::whisker.render(
    tmp_contents,
    data = list(
      exercise_id = exercise_id,
      user_name = user_name,
      displaymode = displaymode
    )
  )

  # write DESCRIPTION file to app directory
  cat(filled_tmp, file = fs::path(app_path, "DESCRIPTION"))
  invisible(fs::path(app_path, "DESCRIPTION"))
}
