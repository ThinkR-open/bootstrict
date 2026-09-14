#' bootstrict: Strict Bootstrap 5.3 Widgets for Shiny
#'
#' `bootstrict` re-implements the Bootstrap 5.3 layout, content, forms and
#' component library as Shiny UI functions. Each widget mirrors the Bootstrap
#' 5.3 HTML structure one-to-one, Bootstrap itself is vendored and compiled
#' with `sass` (so a designer's SASS variable sheet drops straight in, against
#' a Bootstrap version this package pins -- see [bootstrap_version()]) and
#' interactive components report their state to the server, with server-side
#' `update_*()` controls.
#'
#' @section Conventions:
#' * Every constructor is `snake_case` and prefixed `bs_` (e.g. [bs_card()]).
#' * `...` follows the Shiny/htmltools convention: named arguments become HTML
#'   attributes, unnamed arguments become children. Extra `class` values passed
#'   through `...` are merged with the component's own classes. Bootstrap's
#'   utility classes are therefore written as themselves rather than wrapped in
#'   arguments, so a mockup's `class` list transfers verbatim.
#' * Interactive constructors take a leading `id` so their value is available as
#'   `input$id`. Where a component is useful without one -- an alert, a nav, a
#'   dropdown -- the `id` is optional and the widget stays static markup until
#'   it is given one.
#' * Server helpers take the `id` first and the `session` last and optional,
#'   and namespace the id themselves inside a Shiny module. The UI triggers
#'   ([bs_modal_trigger()] and friends) point at a target element, so those
#'   need `ns()` applied by the caller.
#'
#' @section Known deviations:
#' If it is not in the Bootstrap documentation it is not in `bootstrict`, even
#' where that loses a Shiny feature. One thing falls short, inherited from the
#' Shiny inputs the package delegates to: every delegated input keeps Shiny's
#' `div.form-group.shiny-input-container` wrapper, which is why validation
#' feedback needs [bs_feedback()] rather than a bare [bs_invalid_feedback()]
#' placed after the control. No third-party widget library is shipped.
#'
#' @keywords internal
"_PACKAGE"
