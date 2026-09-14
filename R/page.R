# Page constructors ---------------------------------------------------------

#' A Bootstrap 5.3 page
#'
#' Shiny's page constructors wired to the Bootstrap bootstrict vendors, the
#' bootstrict dependency and a theme. Use these as the outermost call of a
#' Shiny UI.
#'
#' @param ... UI elements, and named HTML attributes for the page body.
#' @param title Page title (browser tab).
#' @param theme A [bootstrict_theme()]. Defaults to stock Bootstrap.
#' @param color_mode Initial Bootstrap colour mode: `"light"`, `"dark"`, or
#'   `"auto"` to follow the operating system. A mode the user later chose is
#'   remembered in the browser and wins over this initial value. Switch it
#'   from the server with [set_bs_color_mode()], and read the mode in force as
#'   `input$bootstrict_color_mode`.
#' @param lang Document language (`<html lang>`).
#'
#' @return A UI definition.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   bs_page(
#'     theme = bootstrict_theme(primary = "#ff6600"),
#'     bs_container(bs_card(bs_card_body("Hello")))
#'   )
#'   bs_page_fluid(bs_container("Full width", fluid = TRUE))
#'   bs_page_fillable(bs_container("Fills the viewport"))
#' }
bs_page <- function(
  ...,
  title = NULL,
  theme = bootstrict_theme(),
  color_mode = NULL,
  lang = "en"
) {
  color_mode <- match_arg(
    color_mode,
    c(
      "light",
      "dark",
      "auto"
    )
  )
  attach_page_deps(
    shiny::bootstrapPage(
      htmltools::tags$body(
        ...,
        `data-bs-theme` = if (
          !identical(
            color_mode,
            "auto"
          )
        )
          color_mode,
        if (
          !is.null(
            color_mode
          )
        ) {
          color_mode_boot(
            color_mode
          )
        }
      ),
      title = title,
      lang = lang
    ),
    theme
  )
}

#' @rdname bs_page
#' @export
bs_page_fluid <- function(
  ...,
  title = NULL,
  theme = bootstrict_theme(),
  color_mode = NULL,
  lang = "en"
) {
  color_mode <- match_arg(
    color_mode,
    c(
      "light",
      "dark",
      "auto"
    )
  )
  attach_page_deps(
    shiny::fluidPage(
      ...,
      `data-bs-theme` = if (
        !identical(
          color_mode,
          "auto"
        )
      )
        color_mode,
      if (
        !is.null(
          color_mode
        )
      ) {
        color_mode_boot(
          color_mode
        )
      },
      title = title,
      lang = lang
    ),
    theme
  )
}

#' @rdname bs_page
#' @export
bs_page_fillable <- function(
  ...,
  title = NULL,
  theme = bootstrict_theme(),
  color_mode = NULL,
  lang = "en"
) {
  bs_page(
    ...,
    class = "bootstrict-page-fill",
    title = title,
    theme = theme,
    color_mode = color_mode,
    lang = lang
  )
}

#' Attach the Bootstrap stylesheet and the bootstrict bindings to a page.
#'
#' Appended rather than set, so Shiny's own dependencies survive; the
#' Bootstrap 5 dependency shares its name with the Bootstrap 3 one
#' `shiny::bootstrapPage()` attaches and supersedes it on version.
#' @noRd
attach_page_deps <- function(
  x,
  theme
) {
  htmltools::attachDependencies(
    x,
    list(
      bootstrap_dep(
        theme
      ),
      bootstrict_dep()
    ),
    append = TRUE
  )
}

#' Apply the colour mode before the page paints.
#'
#' The stored preference and the operating system are only knowable in the
#' browser, so the mode has to be resolved there -- and early, or the page
#' flashes light before turning dark. Runs as the first thing in the body,
#' ahead of any content.
#' @noRd
color_mode_boot <- function(
  color_mode
) {
  # Only ever emitted when the caller asked for a mode: an app that says
  # nothing keeps Bootstrap's default rather than quietly following the OS.

  htmltools::tags$script(htmltools::HTML(sprintf(
    paste0(
      "(function(){try{",
      "var r=document.documentElement,",
      "s=window.localStorage.getItem('bootstrict-color-mode'),",
      "m=s||%s;",
      "r.setAttribute('data-bootstrict-color-mode',m);",
      "r.setAttribute('data-bs-theme',m==='auto'?",
      "(window.matchMedia('(prefers-color-scheme: dark)').matches?",
      "'dark':'light'):m);",
      "}catch(e){}})();"
    ),
    if (
      is.null(
        color_mode
      )
    )
      "'auto'" else
      paste0(
        "'",
        color_mode,
        "'"
      )
  )))
}
