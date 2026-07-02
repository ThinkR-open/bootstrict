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
#' @param color_mode Initial Bootstrap colour mode (`data-bs-theme` on the
#'   page body): `"light"` or `"dark"`. Switch it from the server with
#'   [set_bs_color_mode()].
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
      "dark"
    )
  )
  attach_deps(
    bslib::page(
      ...,
      `data-bs-theme` = color_mode,
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
      "dark"
    )
  )
  attach_deps(
    bslib::page_fluid(
      ...,
      `data-bs-theme` = color_mode,
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
      "dark"
    )
  )
  attach_deps(
    bslib::page_fillable(
      ...,
      `data-bs-theme` = color_mode,
      title = title,
      theme = theme,
      lang = lang
    )
  )
}
