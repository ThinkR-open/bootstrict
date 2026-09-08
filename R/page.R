# Page constructors ---------------------------------------------------------

#' A Bootstrap 5 page
#'
#' Thin wrappers over [bslib::page()] / [bslib::page_fluid()] pinned to
#' Bootstrap 5 that wire in the bootstrict dependency and default theme. Use
#' these as the outermost call of a Shiny UI.
#'
#' @param ... UI elements, and named HTML attributes for the page body.
#' @param title Page title (browser tab).
#' @param theme A [bootstrict_theme()] / [bslib::bs_theme()] object. Defaults to
#'   a stock Bootstrap 5 theme.
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
  attach_deps(
    bslib::page(
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
      theme = theme,
      lang = lang
    )
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
  attach_deps(
    bslib::page_fluid(
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
      theme = theme,
      lang = lang
    )
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
  color_mode <- match_arg(
    color_mode,
    c(
      "light",
      "dark",
      "auto"
    )
  )
  attach_deps(
    bslib::page_fillable(
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
      theme = theme,
      lang = lang
    )
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
