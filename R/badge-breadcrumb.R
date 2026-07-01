# Component: badge & breadcrumb ---------------------------------------------

#' Bootstrap badge
#'
#' A small count / labelling component rendered as a `<span class="badge">`.
#'
#' @param ... Badge content and named HTML attributes.
#' @param color Theme colour (`.text-bg-*`). Defaults to `"primary"`.
#' @param pill If `TRUE`, render with fully rounded corners (`.rounded-pill`).
#' @param class Extra classes.
#'
#' @return A badge tag.
#' @export
#'
#' @examples
#' bs_badge("New", color = "success")
bs_badge <- function(
  ...,
  color = "primary",
  pill = FALSE,
  class = NULL
) {
  color <- check_color(
    color
  )
  htmltools::tags$span(
    class = bs_classes(
      "badge",
      mod(
        "text-bg",
        color
      ),
      if (
        isTRUE(
          pill
        )
      )
        "rounded-pill",
      class
    ),
    ...
  ) |>
    attach_deps()
}

#' Bootstrap breadcrumb
#'
#' A navigation hierarchy. Compose with [bs_breadcrumb_item()].
#'
#' @param ... Breadcrumb items built with [bs_breadcrumb_item()], plus named
#'   HTML attributes applied to the `<nav>`.
#' @param divider Optional custom divider character (e.g. `">"`). When a string,
#'   it is set via the `--bs-breadcrumb-divider` CSS variable on the `<nav>`.
#' @param label Accessible label for the `<nav>` (`aria-label`).
#' @param class Extra classes applied to the `<nav>`.
#'
#' @return A breadcrumb `<nav>` tag.
#' @export
#'
#' @examples
#' bs_breadcrumb(
#'   bs_breadcrumb_item("Home", href = "#"),
#'   bs_breadcrumb_item("Library", active = TRUE)
#' )
bs_breadcrumb <- function(
  ...,
  divider = NULL,
  label = "breadcrumb",
  class = NULL
) {
  dots <- split_dots(
    ...
  )
  style <- if (
    is.character(
      divider
    ) &&
      length(
        divider
      ) ==
        1L
  ) {
    paste0(
      "--bs-breadcrumb-divider: '",
      divider,
      "';"
    )
  }
  nav <- do.call(
    htmltools::tags$nav,
    c(
      list(
        class = bs_classes(
          class
        ),
        `aria-label` = label,
        style = style
      ),
      dots$attribs,
      list(htmltools::tags$ol(
        class = "breadcrumb",
        dots$children
      ))
    )
  )
  attach_deps(
    nav
  )
}

#' @rdname bs_breadcrumb
#' @param active If `TRUE`, mark the item as the current page (no link).
#' @param href Optional link target. Ignored when `active = TRUE`.
#' @export
bs_breadcrumb_item <- function(
  ...,
  active = FALSE,
  href = NULL,
  class = NULL
) {
  dots <- split_dots(
    ...
  )
  content <- if (
    !is.null(
      href
    ) &&
      !isTRUE(
        active
      )
  ) {
    list(htmltools::tags$a(
      href = href,
      dots$children
    ))
  } else {
    dots$children
  }
  do.call(
    htmltools::tags$li,
    c(
      list(
        class = bs_classes(
          "breadcrumb-item",
          if (
            isTRUE(
              active
            )
          )
            "active",
          class
        ),
        `aria-current` = if (
          isTRUE(
            active
          )
        )
          "page"
      ),
      dots$attribs,
      content
    )
  )
}
