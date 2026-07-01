# golem integration ---------------------------------------------------------

#' Scaffold a bootstrict app as a golem project hook
#'
#' A [golem::create_golem()] `project_hook` that turns a freshly created golem
#' skeleton into a minimal bootstrict application:
#'
#' * `R/app_ui.R` is rewritten to use [bs_page()] and shows a "Hello world"
#'   inside a [bs_container()].
#' * An (empty by default) `inst/app/www/_variables.sass` designer variable
#'   sheet is created and wired into [bootstrict_theme()], so a designer can
#'   drop Sass variables in and have them picked up automatically.
#'
#' golem sets the working directory to the new project before calling the hook,
#' so every path below is relative to the application root.
#'
#' @param path Path of the newly created golem project. Unused, kept for
#'   compatibility with the golem hook interface.
#' @param package_name Name of the package / application being created.
#' @param ... Reserved for compatibility with the golem hook interface.
#'
#' @return Invisibly `NULL`. Called for its side effects on the project files.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   golem::create_golem(
#'     "my.app",
#'     project_hook = bootstrict::use_bootstrict_golem
#'   )
#' }
use_bootstrict_golem <- function(
  path,
  package_name,
  ...
) {
  www <- file.path(
    "inst",
    "app",
    "www"
  )
  dir.create(
    www,
    recursive = TRUE,
    showWarnings = FALSE
  )

  # 1. An empty-by-default designer SASS variable sheet.
  variables_file <- file.path(
    www,
    "_variables.sass"
  )
  if (
    !file.exists(
      variables_file
    )
  ) {
    file.create(
      variables_file
    )
  }

  # 2. A minimal "Hello world" UI built on a bootstrict page.
  template <- c(
    "#' The application User-Interface",
    "#'",
    "#' @param request Internal parameter for `{shiny}`.",
    "#'     DO NOT REMOVE.",
    "#' @import shiny",
    "#' @noRd",
    "app_ui <- function(request) {",
    "  tagList(",
    "    # Leave this function for adding external resources",
    "    golem_add_external_resources(),",
    "    # bootstrict page: theme reads the designer's _variables.sass sheet",
    "    bootstrict::bs_page(",
    "      title = \"{{package_name}}\",",
    "      theme = bootstrict::bootstrict_theme(",
    "        variables = app_sys(\"app/www/_variables.sass\")",
    "      ),",
    "      bootstrict::bs_container(",
    "        shiny::h1(\"Hello world\")",
    "      )",
    "    )",
    "  )",
    "}",
    "",
    "#' Add external Resources to the Application",
    "#'",
    "#' This function is internally used to add external",
    "#' resources inside the Shiny application.",
    "#'",
    "#' @import shiny",
    "#' @importFrom golem add_resource_path activate_js favicon bundle_resources",
    "#' @noRd",
    "golem_add_external_resources <- function() {",
    "  add_resource_path(",
    "    \"www\",",
    "    app_sys(\"app/www\")",
    "  )",
    "",
    "  tags$head(",
    "    favicon(),",
    "    bundle_resources(",
    "      path = app_sys(\"app/www\"),",
    "      app_title = \"{{package_name}}\"",
    "    )",
    "    # Add here other external resources",
    "    # for example, you can add shinyalert::useShinyalert()",
    "  )",
    "}"
  )
  template <- gsub(
    "{{package_name}}",
    package_name,
    template,
    fixed = TRUE
  )
  writeLines(
    template,
    file.path(
      "R",
      "app_ui.R"
    )
  )

  invisible(
    NULL
  )
}
