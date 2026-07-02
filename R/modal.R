# Component: modal ----------------------------------------------------------

#' Bootstrap modal
#'
#' A faithful Bootstrap 5 modal dialog. The modal's open/closed state is
#' reported to the server as `input$id` (`TRUE` when shown), and can be driven
#' server-side with [show_bs_modal()], [hide_bs_modal()] and [toggle_bs_modal()].
#'
#' For full control over the dialog structure (in place of the `title` and
#' `footer` shortcuts) compose the body yourself with [bs_modal_header()],
#' [bs_modal_body()] and [bs_modal_footer()].
#'
#' @param id Modal id; open state available as `input$id`.
#' @param ... Modal body content and named HTML attributes applied to the root.
#' @param title Optional header title. When supplied, a `.modal-header` with a
#'   title and a close button is rendered.
#' @param footer Optional footer content (e.g. buttons), placed in a
#'   `.modal-footer`.
#' @param size Dialog size: `"sm"`, `"lg"` or `"xl"`.
#' @param centered If `TRUE`, vertically centre the dialog
#'   (`.modal-dialog-centered`).
#' @param scrollable If `TRUE`, scroll long bodies inside the dialog
#'   (`.modal-dialog-scrollable`).
#' @param fullscreen `TRUE` for an always-fullscreen modal, or a breakpoint
#'   (`"sm"`/`"md"`/`"lg"`/`"xl"`/`"xxl"`) for fullscreen below that breakpoint
#'   (`.modal-fullscreen-{bp}-down`).
#' @param backdrop Backdrop behaviour: `TRUE` (backdrop shown, dismiss on
#'   outside click), `"static"` (backdrop shown, do not dismiss on outside
#'   click) or `FALSE` (no backdrop at all).
#' @param keyboard If `FALSE`, the modal cannot be closed with the Escape key.
#' @param class Extra classes.
#'
#' @return A modal tag.
#' @export
#'
#' @examples
#' bs_modal("info", "Modal body text.", title = "Heads up")
bs_modal <- function(
  id,
  ...,
  title = NULL,
  footer = NULL,
  size = NULL,
  centered = FALSE,
  scrollable = FALSE,
  fullscreen = FALSE,
  backdrop = TRUE,
  keyboard = TRUE,
  class = NULL
) {
  size <- match_arg(
    size,
    c(
      "sm",
      "lg",
      "xl"
    )
  )

  fullscreen_class <- if (
    isTRUE(
      fullscreen
    )
  ) {
    "modal-fullscreen"
  } else if (
    !isFALSE(
      fullscreen
    ) &&
      !is.null(
        fullscreen
      )
  ) {
    bp <- match_arg(
      fullscreen,
      bs_breakpoints,
      arg_nm = "fullscreen"
    )
    paste0(
      "modal-fullscreen-",
      bp,
      "-down"
    )
  }

  dots <- split_dots(
    ...
  )
  title_id <- if (
    !is.null(
      title
    )
  ) {
    paste0(
      id,
      "-title"
    )
  }

  dialog <- htmltools::div(
    class = bs_classes(
      "modal-dialog",
      mod(
        "modal",
        size
      ),
      if (
        isTRUE(
          centered
        )
      )
        "modal-dialog-centered",
      if (
        isTRUE(
          scrollable
        )
      )
        "modal-dialog-scrollable",
      fullscreen_class
    ),
    htmltools::div(
      class = "modal-content",
      if (
        !is.null(
          title
        )
      )
        bs_modal_header(bs_modal_title(
          title,
          id = title_id
        )),
      bs_modal_body(
        dots$children
      ),
      if (
        !is.null(
          footer
        )
      )
        bs_modal_footer(
          footer
        )
    )
  )

  # Bootstrap distinguishes "static" (backdrop shown, click outside does not
  # dismiss) from "false" (no backdrop at all).
  backdrop_attr <- if (
    identical(
      backdrop,
      "static"
    )
  ) {
    "static"
  } else if (
    isFALSE(
      backdrop
    )
  ) {
    "false"
  }

  root <- htmltools::div(
    id = id,
    class = bs_classes(
      "modal",
      "fade",
      class
    ),
    tabindex = "-1",
    `aria-hidden` = "true",
    `aria-labelledby` = title_id,
    `data-bootstrict` = "modal",
    `data-bs-backdrop` = backdrop_attr,
    `data-bs-keyboard` = if (
      !isTRUE(
        keyboard
      )
    )
      "false",
    dialog
  )
  # Named `...` become attributes of the modal root (e.g. `data-bs-focus`).
  if (
    length(
      dots$attribs
    ) >
      0L
  ) {
    root <- do.call(
      htmltools::tagAppendAttributes,
      c(
        list(
          root
        ),
        dots$attribs
      )
    )
  }
  attach_deps(
    root
  )
}

#' @rdname bs_modal
#' @export
bs_modal_header <- function(
  ...,
  class = NULL
) {
  htmltools::div(
    class = bs_classes(
      "modal-header",
      class
    ),
    ...,
    bs_close_button(
      `data-bs-dismiss` = "modal"
    )
  )
}

#' @rdname bs_modal
#' @param level Heading level (1-6) for the modal title.
#' @export
bs_modal_title <- function(
  ...,
  level = 1,
  class = NULL
) {
  level <- check_heading_level(
    level
  )
  # Bootstrap 5.3 reference markup: <h1 class="modal-title fs-5"> (semantic
  # heading level decoupled from the visual size).
  htmltools::tag(
    paste0(
      "h",
      level
    ),
    list(
      class = bs_classes(
        "modal-title",
        "fs-5",
        class
      ),
      ...
    )
  )
}

#' @rdname bs_modal
#' @export
bs_modal_body <- function(
  ...,
  class = NULL
) {
  htmltools::div(
    class = bs_classes(
      "modal-body",
      class
    ),
    ...
  )
}

#' @rdname bs_modal
#' @export
bs_modal_footer <- function(
  ...,
  class = NULL
) {
  htmltools::div(
    class = bs_classes(
      "modal-footer",
      class
    ),
    ...
  )
}

#' Trigger a modal from the UI
#'
#' Renders a button that opens the modal whose id matches `target`, using
#' Bootstrap's declarative `data-bs-toggle="modal"` attributes (no server round
#' trip required).
#'
#' @param target Id of the [bs_modal()] to open.
#' @param ... Content (label) and named HTML attributes, forwarded to
#'   [bs_button()].
#' @param class Extra classes.
#'
#' @return A button tag.
#' @export
#'
#' @examples
#' bs_modal_trigger("info", "Open modal", color = "primary")
bs_modal_trigger <- function(
  target,
  ...,
  class = NULL
) {
  bs_button(
    id = NULL,
    ...,
    `data-bs-toggle` = "modal",
    `data-bs-target` = css_id_selector(
      target
    ),
    class = class
  )
}

#' Control a modal from the server
#'
#' Show, hide or toggle a [bs_modal()] from server code.
#'
#' @param id Modal id (namespaced automatically inside modules).
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' if (interactive()) show_bs_modal("info")
show_bs_modal <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "modal.show",
    id = bs_ns(
      id,
      session
    ),
    session = session
  )
}

#' @rdname show_bs_modal
#' @export
#'
#' @examples
#' if (interactive()) hide_bs_modal("info")
hide_bs_modal <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "modal.hide",
    id = bs_ns(
      id,
      session
    ),
    session = session
  )
}

#' @rdname show_bs_modal
#' @export
#'
#' @examples
#' if (interactive()) toggle_bs_modal("info")
toggle_bs_modal <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "modal.toggle",
    id = bs_ns(
      id,
      session
    ),
    session = session
  )
}
