# Component: toast ----------------------------------------------------------

#' Bootstrap toast
#'
#' A lightweight, dismissible notification. The toast's visibility is reported
#' to the server as `input$id` (`TRUE` when shown), and can be driven
#' server-side with [show_bs_toast()] / [hide_bs_toast()]. Place one or more
#' toasts inside a [bs_toast_container()] to position them on screen, or push
#' transient notifications entirely from the server with [bs_notify_toast()].
#'
#' @param id Toast id; shown state available as `input$id`.
#' @param ... Toast body content and named HTML attributes applied to the root.
#' @param title Optional header title. When supplied, a `.toast-header` with the
#'   title and a close button is rendered.
#' @param icon Optional icon placed before the title in the header.
#' @param autohide If `TRUE` (default), hide the toast automatically after
#'   `delay` milliseconds.
#' @param delay Delay in milliseconds before auto-hiding (when `autohide`).
#' @param animation If `FALSE`, disable the fade animation.
#' @param class Extra classes.
#'
#' @return A toast tag.
#' @export
#'
#' @examples
#' bs_toast("hello", "Hello, world!", title = "Bootstrict")
bs_toast <- function(
  id,
  ...,
  title = NULL,
  icon = NULL,
  autohide = TRUE,
  delay = 5000,
  animation = TRUE,
  class = NULL
) {
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
      class = "toast-header",
      icon,
      htmltools::tags$strong(
        class = "me-auto",
        title
      ),
      bs_close_button(
        `data-bs-dismiss` = "toast"
      )
    )
  }

  root <- htmltools::div(
    id = id,
    class = bs_classes(
      "toast",
      class
    ),
    role = "alert",
    `aria-live` = "assertive",
    `aria-atomic` = "true",
    `data-bootstrict` = "toast",
    `data-bs-autohide` = if (
      !isTRUE(
        autohide
      )
    )
      "false",
    `data-bs-delay` = if (
      !is.null(
        delay
      )
    )
      as.character(
        delay
      ),
    `data-bs-animation` = if (
      !isTRUE(
        animation
      )
    )
      "false",
    header,
    htmltools::div(
      class = "toast-body",
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

#' Position toasts on screen
#'
#' A fixed-position container that holds and lays out one or more [bs_toast()]s.
#'
#' @param ... Toasts and named HTML attributes applied to the container.
#' @param placement Where to anchor the container. One of `"top-start"`,
#'   `"top-center"`, `"top-end"`, `"middle-start"`, `"middle-center"`,
#'   `"middle-end"`, `"bottom-start"`, `"bottom-center"` or `"bottom-end"`.
#' @param class Extra classes.
#'
#' @return A toast container tag.
#' @export
#'
#' @examples
#' bs_toast_container(
#'   bs_toast("hello", "Hi there", title = "Greeting"),
#'   placement = "top-end"
#' )
bs_toast_container <- function(
  ...,
  placement = "top-end",
  class = NULL
) {
  pos <- toast_placement_class(
    placement
  )
  attach_deps(htmltools::div(
    class = bs_classes(
      "toast-container",
      "position-fixed",
      "p-3",
      pos,
      class
    ),
    ...
  ))
}

#' Map a toast placement keyword to Bootstrap position utility classes.
#' @noRd
toast_placement_class <- function(
  placement
) {
  placement <- match_arg(
    placement,
    c(
      "top-start",
      "top-center",
      "top-end",
      "middle-start",
      "middle-center",
      "middle-end",
      "bottom-start",
      "bottom-center",
      "bottom-end"
    ),
    allow_null = FALSE
  )
  switch(
    placement,
    "top-start" = "top-0 start-0",
    "top-center" = "top-0 start-50 translate-middle-x",
    "top-end" = "top-0 end-0",
    "middle-start" = "top-50 start-0 translate-middle-y",
    "middle-center" = "top-50 start-50 translate-middle",
    "middle-end" = "top-50 end-0 translate-middle-y",
    "bottom-start" = "bottom-0 start-0",
    "bottom-center" = "bottom-0 start-50 translate-middle-x",
    "bottom-end" = "bottom-0 end-0"
  )
}

#' Control a toast from the server
#'
#' Show or hide a [bs_toast()] from server code.
#'
#' @param id Toast id (namespaced automatically inside modules).
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' if (interactive()) show_bs_toast("hello")
show_bs_toast <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "toast.show",
    id = bs_ns(
      id,
      session
    ),
    session = session
  )
}

#' @rdname show_bs_toast
#' @export
#'
#' @examples
#' if (interactive()) hide_bs_toast("hello")
hide_bs_toast <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "toast.hide",
    id = bs_ns(
      id,
      session
    ),
    session = session
  )
}

#' Pop a transient toast notification from the server
#'
#' Builds a toast on the client and shows it, much like
#' [shiny::showNotification()]. A toast container is created on demand at
#' `placement` if one is not already present, and the toast removes itself from
#' the DOM once hidden.
#'
#' @param body Notification body text. Plain text only (it is inserted with
#'   `textContent` client-side, so markup is not interpreted); tags raise an
#'   error.
#' @param ... Reserved for future extensions; must be empty.
#' @param title Optional header title. Plain text only, like `body`.
#' @param color Optional theme colour applied as a `.text-bg-*` background.
#' @param autohide If `TRUE` (default), hide the toast automatically after
#'   `delay` milliseconds. Use `FALSE` for a persistent notification the user
#'   must dismiss.
#' @param delay Delay in milliseconds before the toast auto-hides.
#' @param placement Container placement (see [bs_toast_container()]).
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' if (interactive()) bs_notify_toast("Saved!", title = "Status", color = "success")
bs_notify_toast <- function(
  body,
  ...,
  title = NULL,
  color = NULL,
  autohide = TRUE,
  delay = 5000,
  placement = "top-end",
  session = shiny::getDefaultReactiveDomain()
) {
  rlang::check_dots_empty()
  color <- check_color(
    color
  )
  placement <- match_arg(
    placement,
    c(
      "top-start",
      "top-center",
      "top-end",
      "middle-start",
      "middle-center",
      "middle-end",
      "bottom-start",
      "bottom-center",
      "bottom-end"
    ),
    allow_null = FALSE
  )
  bs_send(
    "toast.notify",
    body = as_scalar_text(
      body
    ),
    title = as_scalar_text(
      title
    ),
    color = color,
    autohide = isTRUE(
      autohide
    ),
    delay = delay,
    placement = placement,
    session = session
  )
}

#' Coerce a notification field to a single text string (or NULL).
#'
#' The client inserts these with `textContent`, so tags would be displayed as
#' literal markup (body) or serialize to `[object Object]` (title) — reject
#' them with an actionable message instead.
#' @noRd
as_scalar_text <- function(
  x,
  arg_nm = rlang::caller_arg(
    x
  )
) {
  if (
    is.null(
      x
    )
  ) {
    return(
      NULL
    )
  }
  if (
    !is.atomic(
      x
    ) ||
      length(
        x
      ) !=
        1L
  ) {
    rlang::abort(sprintf(
      paste0(
        "`%s` must be a single plain-text string (it is rendered as text, ",
        "not HTML). For rich content, declare a bs_toast() in the UI and ",
        "show it with show_bs_toast()."
      ),
      arg_nm
    ))
  }
  as.character(
    x
  )
}
