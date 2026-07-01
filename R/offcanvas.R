# Component: offcanvas ------------------------------------------------------

#' Bootstrap offcanvas
#'
#' A hidden sidebar panel that slides in from an edge of the viewport. The
#' open/closed state is reported to the server as `input$id` (`TRUE` when
#' shown), and can be driven server-side with [show_bs_offcanvas()],
#' [hide_bs_offcanvas()] and [toggle_bs_offcanvas()]. Open it declaratively from
#' the UI with [bs_offcanvas_trigger()].
#'
#' @param id Offcanvas id; open state available as `input$id`.
#' @param ... Offcanvas body content and named HTML attributes applied to the
#'   root.
#' @param title Optional header title. When supplied, an `.offcanvas-header`
#'   with a title and a close button is rendered.
#' @param placement Edge the panel slides in from: `"start"` (left), `"end"`
#'   (right), `"top"` or `"bottom"`.
#' @param backdrop Backdrop behaviour: `TRUE` (default, dismiss on outside
#'   click), `FALSE` (no backdrop) or `"static"` (backdrop that does not dismiss
#'   on outside click).
#' @param scroll If `TRUE`, allow body scrolling while the offcanvas is open.
#' @param responsive Optional breakpoint (`"sm"`, `"md"`, `"lg"`, `"xl"`,
#'   `"xxl"`). Below it the panel behaves as an offcanvas; at or above it the
#'   content is shown inline (Bootstrap 5.2 responsive offcanvas).
#' @param class Extra classes.
#'
#' @return An offcanvas tag.
#' @export
#'
#' @examples
#' bs_offcanvas("menu", "Sidebar content.", title = "Menu")
#' bs_offcanvas("nav", "Shown inline on lg+.", responsive = "lg")
bs_offcanvas <- function(
  id,
  ...,
  title = NULL,
  placement = "start",
  backdrop = TRUE,
  scroll = FALSE,
  responsive = NULL,
  class = NULL
) {
  placement <- match_arg(
    placement,
    c(
      "start",
      "end",
      "top",
      "bottom"
    ),
    allow_null = FALSE
  )
  responsive <- match_arg(
    responsive,
    bs_breakpoints
  )
  # 5.2: a responsive offcanvas uses `.offcanvas-{bp}` *instead of* `.offcanvas`.
  base_class <- if (
    !is.null(
      responsive
    )
  ) {
    paste0(
      "offcanvas-",
      responsive
    )
  } else {
    "offcanvas"
  }

  backdrop_attr <- if (
    isFALSE(
      backdrop
    )
  ) {
    "false"
  } else if (
    identical(
      backdrop,
      "static"
    )
  ) {
    "static"
  }

  # Named `...` decorate the root; unnamed `...` are body content.
  dots <- split_dots(
    ...
  )

  header <- if (
    !is.null(
      title
    )
  ) {
    htmltools::div(
      class = "offcanvas-header",
      htmltools::tags$h5(
        class = "offcanvas-title",
        title
      ),
      bs_close_button(
        `data-bs-dismiss` = "offcanvas"
      )
    )
  }

  root <- htmltools::div(
    class = bs_classes(
      base_class,
      paste0(
        "offcanvas-",
        placement
      ),
      class
    ),
    tabindex = "-1",
    id = id,
    `data-bootstrict` = "offcanvas",
    `data-bs-backdrop` = backdrop_attr,
    `data-bs-scroll` = if (
      isTRUE(
        scroll
      )
    )
      "true",
    header,
    htmltools::div(
      class = "offcanvas-body",
      dots$children
    )
  )
  root <- do.call(
    htmltools::tagAppendAttributes,
    c(
      list(
        root
      ),
      dots$attribs
    )
  )

  attach_deps(
    root
  )
}

#' Trigger an offcanvas from the UI
#'
#' Renders a button that opens the offcanvas whose id matches `target`, using
#' Bootstrap's declarative `data-bs-toggle="offcanvas"` attributes (no server
#' round trip required).
#'
#' @param target Id of the [bs_offcanvas()] to open.
#' @param ... Content (label) and named HTML attributes applied to the button.
#' @param class Extra classes.
#'
#' @return A button tag.
#' @export
#'
#' @examples
#' bs_offcanvas_trigger("menu", "Open menu")
bs_offcanvas_trigger <- function(
  target,
  ...,
  class = NULL
) {
  htmltools::tags$button(
    class = bs_classes(
      "btn",
      class
    ),
    type = "button",
    `data-bs-toggle` = "offcanvas",
    `data-bs-target` = paste0(
      "#",
      target
    ),
    `aria-controls` = target,
    ...
  )
}

#' Control an offcanvas from the server
#'
#' Show, hide or toggle a [bs_offcanvas()] from server code.
#'
#' @param id Offcanvas id (namespaced automatically inside modules).
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' if (interactive()) show_bs_offcanvas("menu")
show_bs_offcanvas <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "offcanvas.show",
    id = bs_ns(
      id,
      session
    ),
    session = session
  )
}

#' @rdname show_bs_offcanvas
#' @export
#'
#' @examples
#' if (interactive()) hide_bs_offcanvas("menu")
hide_bs_offcanvas <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "offcanvas.hide",
    id = bs_ns(
      id,
      session
    ),
    session = session
  )
}

#' @rdname show_bs_offcanvas
#' @export
#'
#' @examples
#' if (interactive()) toggle_bs_offcanvas("menu")
toggle_bs_offcanvas <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "offcanvas.toggle",
    id = bs_ns(
      id,
      session
    ),
    session = session
  )
}
