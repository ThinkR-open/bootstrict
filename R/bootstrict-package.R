#' bootstrict: Strict Bootstrap 5.3 Widgets for Shiny
#'
#' `bootstrict` re-implements the Bootstrap 5.3 layout, content, forms and
#' component library as Shiny UI functions. Each widget mirrors the Bootstrap
#' 5.3 HTML structure one-to-one, theming is delegated to `bslib` (which ships
#' the Bootstrap 5.3 runtime, so a designer's SASS variable sheet drops
#' straight in) and interactive components report their state to the server,
#' with server-side `update_*()` controls.
#'
#' @section Conventions:
#' * Every constructor is `snake_case` and prefixed `bs_` (e.g. [bs_card()]).
#' * `...` follows the Shiny/htmltools convention: named arguments become HTML
#'   attributes, unnamed arguments become children. Extra `class` values passed
#'   through `...` are merged with the component's own classes.
#' * Interactive constructors take a leading `id` so their value is available as
#'   `input$id`.
#'
#' @keywords internal
"_PACKAGE"
