# Component: accordion ------------------------------------------------------

#' Bootstrap accordion
#'
#' A vertically collapsing set of panels. The value(s) of the currently open
#' panel(s) are reported to the server as `input$id`, and can be driven
#' server-side with [update_bs_accordion()].
#'
#' @param id Accordion id; open panel value(s) available as `input$id`.
#' @param ... Panels built with [bs_accordion_panel()].
#' @param open Panel value(s) open initially. Use `TRUE` to open all (only
#'   sensible with `multiple = TRUE`), `FALSE`/`NULL` for none.
#' @param multiple If `TRUE`, panels stay open independently
#'   (Bootstrap "always open"). Otherwise opening one closes the others.
#' @param flush If `TRUE`, render edge-to-edge without borders (`.accordion-flush`).
#' @param class Extra classes.
#'
#' @return An accordion tag.
#' @export
#'
#' @examples
#' bs_accordion(
#'   "acc",
#'   bs_accordion_panel("First", "Panel one body", value = "one"),
#'   bs_accordion_panel("Second", "Panel two body", value = "two"),
#'   open = "one"
#' )
bs_accordion <- function(
  id,
  ...,
  open = NULL,
  multiple = FALSE,
  flush = FALSE,
  class = NULL
) {
  panels <- Filter(
    Negate(
      is.null
    ),
    rlang::list2(
      ...
    )
  )
  ok <- vapply(
    panels,
    inherits,
    logical(
      1
    ),
    what = "bs_accordion_panel"
  )
  if (
    !all(
      ok
    )
  ) {
    rlang::abort(
      "All `...` arguments to `bs_accordion()` must be `bs_accordion_panel()`s."
    )
  }

  values <- vapply(
    panels,
    function(
      p
    )
      p$value,
    character(
      1
    )
  )
  if (
    anyDuplicated(
      values
    )
  ) {
    rlang::abort(
      "`bs_accordion_panel()` values must be unique within an accordion."
    )
  }

  open_all <- isTRUE(
    open
  )
  open_vals <- if (
    open_all
  ) {
    values
  } else if (
    isFALSE(
      open
    ) ||
      is.null(
        open
      )
  ) {
    character(
      0
    )
  } else {
    as.character(
      open
    )
  }

  items <- lapply(
    seq_along(
      panels
    ),
    function(
      i
    ) {
      p <- panels[[
        i
      ]]
      panel_id <- paste0(
        id,
        "-panel-",
        i
      )
      is_open <- p$value %in%
        open_vals

      header_btn <- htmltools::tags$button(
        class = bs_classes(
          "accordion-button",
          if (
            !is_open
          )
            "collapsed"
        ),
        type = "button",
        `data-bs-toggle` = "collapse",
        `data-bs-target` = css_id_selector(
          panel_id
        ),
        `aria-expanded` = if (
          is_open
        )
          "true" else
          "false",
        `aria-controls` = panel_id,
        p$icon,
        p$title
      )

      collapse <- htmltools::div(
        id = panel_id,
        class = bs_classes(
          "accordion-collapse",
          "collapse",
          if (
            is_open
          )
            "show"
        ),
        `data-value` = p$value,
        `data-bs-parent` = if (
          !isTRUE(
            multiple
          )
        )
          css_id_selector(
            id
          ),
        htmltools::div(
          class = bs_classes(
            "accordion-body",
            p$body_class
          ),
          p$body
        )
      )

      htmltools::div(
        class = bs_classes(
          "accordion-item",
          p$class
        ),
        htmltools::tags$h2(
          class = "accordion-header",
          header_btn
        ),
        collapse
      )
    }
  )

  attach_deps(htmltools::div(
    id = id,
    class = bs_classes(
      "accordion",
      if (
        isTRUE(
          flush
        )
      )
        "accordion-flush",
      class
    ),
    `data-bootstrict` = "accordion",
    items
  ))
}

#' @rdname bs_accordion
#' @param title Panel header content.
#' @param value Panel identifier reported to the server (defaults to `title`).
#' @param icon Optional icon placed before the title.
#' @param body_class Extra classes for the panel body.
#' @export
bs_accordion_panel <- function(
  title,
  ...,
  value = NULL,
  icon = NULL,
  class = NULL,
  body_class = NULL
) {
  structure(
    list(
      title = title,
      value = as.character(
        value %||%
          title
      ),
      icon = icon,
      body = rlang::list2(
        ...
      ),
      class = class,
      body_class = body_class
    ),
    class = "bs_accordion_panel"
  )
}

#' Control an accordion from the server
#'
#' @param id Accordion id (namespaced automatically inside modules).
#' @param open Panel value(s) to open. Use `TRUE` to open all (sensible with
#'   `multiple = TRUE`); `FALSE`/`NULL` is a no-op.
#' @param close Panel value(s) to close. Use `TRUE` to close all;
#'   `FALSE`/`NULL` is a no-op.
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
update_bs_accordion <- function(
  id,
  open = NULL,
  close = NULL,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "accordion.update",
    id = bs_ns(
      id,
      session
    ),
    open = as_msg_flag_list(
      open
    ),
    close = as_msg_flag_list(
      close
    ),
    session = session
  )
}

#' `TRUE` -> the "__all__" sentinel, `FALSE` -> no-op, else a JSON array.
#' @noRd
as_msg_flag_list <- function(
  x
) {
  if (
    isTRUE(
      x
    )
  ) {
    return(
      "__all__"
    )
  }
  if (
    isFALSE(
      x
    )
  ) {
    return(
      NULL
    )
  }
  as_msg_list(
    x
  )
}

#' Coerce an R vector to a JSON array (so length-1 stays an array client-side).
#' @noRd
as_msg_list <- function(
  x
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
  as.list(as.character(
    x
  ))
}
