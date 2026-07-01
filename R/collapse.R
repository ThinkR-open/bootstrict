# Component: collapse -------------------------------------------------------

#' Bootstrap collapse
#'
#' A toggleable container that shows or hides content. Pair it with a
#' [bs_collapse_trigger()] (declarative, no server round trip) and/or drive it
#' from the server with [update_bs_collapse()]. Its shown/hidden state is
#' reported to the server as `input$id` (`TRUE` when visible).
#'
#' @param id Collapse id; visibility state available as `input$id`.
#' @param ... Collapse content and named HTML attributes.
#' @param open If `TRUE`, the collapse is visible initially (`.show`).
#' @param horizontal If `TRUE`, collapse transitions width instead of height
#'   (`.collapse-horizontal`).
#' @param class Extra classes.
#'
#' @return A collapse tag.
#' @export
#'
#' @examples
#' bs_collapse("more", "Hidden content revealed on toggle.")
bs_collapse <- function(
  id,
  ...,
  open = FALSE,
  horizontal = FALSE,
  class = NULL
) {
  attach_deps(htmltools::div(
    id = id,
    class = bs_classes(
      "collapse",
      if (
        isTRUE(
          open
        )
      )
        "show",
      if (
        isTRUE(
          horizontal
        )
      )
        "collapse-horizontal",
      class
    ),
    `data-bootstrict` = "collapse",
    ...
  ))
}

#' Trigger a collapse from the UI
#'
#' Renders a control that toggles the [bs_collapse()] whose id matches
#' `target`, using Bootstrap's declarative `data-bs-toggle="collapse"`
#' attributes (no server round trip required).
#'
#' @param target Id of the [bs_collapse()] to toggle.
#' @param ... Content (label) and named HTML attributes.
#' @param button If `TRUE` (default), render a `<button class="btn">`;
#'   otherwise render an `<a role="button">`.
#' @param class Extra classes.
#'
#' @return A button (or anchor) tag.
#' @export
#'
#' @examples
#' bs_collapse_trigger("more", "Toggle")
bs_collapse_trigger <- function(
  target,
  ...,
  button = TRUE,
  class = NULL
) {
  if (
    isTRUE(
      button
    )
  ) {
    htmltools::tags$button(
      class = bs_classes(
        "btn",
        class
      ),
      type = "button",
      `data-bs-toggle` = "collapse",
      `data-bs-target` = paste0(
        "#",
        target
      ),
      `aria-expanded` = "false",
      `aria-controls` = target,
      ...
    )
  } else {
    htmltools::tags$a(
      class = bs_classes(
        class
      ),
      `data-bs-toggle` = "collapse",
      href = paste0(
        "#",
        target
      ),
      role = "button",
      `aria-expanded` = "false",
      `aria-controls` = target,
      ...
    )
  }
}

#' Control a collapse from the server
#'
#' Show, hide or toggle a [bs_collapse()] from server code.
#'
#' @param id Collapse id (namespaced automatically inside modules).
#' @param action One of `"toggle"`, `"show"` or `"hide"`.
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' if (interactive()) update_bs_collapse("more", "show")
update_bs_collapse <- function(
  id,
  action = c(
    "toggle",
    "show",
    "hide"
  ),
  session = shiny::getDefaultReactiveDomain()
) {
  action <- match.arg(
    action
  )
  bs_send(
    "collapse.update",
    id = bs_ns(
      id,
      session
    ),
    action = action,
    session = session
  )
}
