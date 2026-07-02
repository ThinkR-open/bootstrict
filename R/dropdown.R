# Component: dropdown -------------------------------------------------------
#
# Bootstrap handles the show/hide toggle entirely through its own JS
# (`data-bs-toggle="dropdown"`), so no custom binding is needed. A dropdown
# item given an `id` reuses shiny's action-button binding (`.action-button`),
# making its click count available as `input$id`.

#' Bootstrap dropdown
#'
#' A toggleable menu of links, headers and dividers. Compose the menu with
#' [bs_dropdown_item()], [bs_dropdown_divider()], [bs_dropdown_header()] and
#' [bs_dropdown_text()]. Bootstrap drives the toggle; give an item an `id` to
#' wire it as a Shiny action button (`input$id`).
#'
#' @param label Toggle button label (text or tags).
#' @param ... Menu contents (dropdown items, dividers, headers, text) and named
#'   HTML attributes (forwarded to the wrapper).
#' @param color Toggle button theme colour, one of the Bootstrap theme colours
#'   or `"link"`.
#' @param outline If `TRUE`, an outline toggle button (`.btn-outline-*`).
#' @param size Toggle button size: `"sm"` or `"lg"`.
#' @param split If `TRUE`, render a split button (a normal action button plus a
#'   separate toggle caret).
#' @param direction Menu drop direction: `"down"`, `"up"`, `"end"` or
#'   `"start"`.
#' @param dark If `TRUE`, a dark dropdown via `data-bs-theme="dark"` on the
#'   wrapper (the Bootstrap 5.3 idiom; `.dropdown-menu-dark` is deprecated).
#' @param align Menu alignment. `"end"` right-aligns the menu
#'   (`.dropdown-menu-end`); a named list such as `list(lg = "end")` produces a
#'   responsive alignment (`.dropdown-menu-lg-end`).
#' @param class Extra classes for the wrapper.
#'
#' @return A dropdown tag.
#' @export
#'
#' @examples
#' bs_dropdown("Menu", bs_dropdown_item("Action", id = "act"))
bs_dropdown <- function(
  label,
  ...,
  color = "secondary",
  outline = FALSE,
  size = NULL,
  split = FALSE,
  direction = "down",
  dark = FALSE,
  align = NULL,
  class = NULL
) {
  color <- match_arg(
    color,
    c(
      bs_theme_colors,
      "link"
    ),
    allow_null = FALSE
  )
  size <- match_arg(
    size,
    c(
      "sm",
      "lg"
    )
  )
  direction <- match_arg(
    direction,
    c(
      "down",
      "up",
      "end",
      "start"
    ),
    allow_null = FALSE
  )

  dots <- split_dots(
    ...
  )

  # Responsive alignment classes only take effect when Popper's dynamic
  # positioning is disabled on the toggle (Bootstrap requirement).
  responsive_align <- is.list(
    align
  )

  variant <- if (
    isTRUE(
      outline
    ) &&
      color !=
        "link"
  ) {
    paste0(
      "btn-outline-",
      color
    )
  } else {
    paste0(
      "btn-",
      color
    )
  }
  btn_classes <- bs_classes(
    "btn",
    variant,
    mod(
      "btn",
      size
    )
  )

  toggle <- htmltools::tags$button(
    type = "button",
    class = bs_classes(
      btn_classes,
      "dropdown-toggle",
      if (
        isTRUE(
          split
        )
      )
        "dropdown-toggle-split"
    ),
    `data-bs-toggle` = "dropdown",
    `data-bs-display` = if (
      responsive_align
    )
      "static",
    `aria-expanded` = "false",
    if (
      isTRUE(
        split
      )
    ) {
      htmltools::tags$span(
        class = "visually-hidden",
        "Toggle Dropdown"
      )
    } else {
      label
    }
  )

  buttons <- if (
    isTRUE(
      split
    )
  ) {
    list(
      htmltools::tags$button(
        type = "button",
        class = btn_classes,
        label
      ),
      toggle
    )
  } else {
    list(
      toggle
    )
  }

  align <- if (
    is.list(
      align
    )
  ) {
    # e.g. list(lg = "end") -> "dropdown-menu-lg-end"
    responsive_classes(
      "dropdown-menu",
      align
    )
  } else if (
    identical(
      align,
      "end"
    )
  ) {
    "dropdown-menu-end"
  } else {
    NULL
  }

  menu <- htmltools::tags$ul(
    class = bs_classes(
      "dropdown-menu",
      align
    ),
    dots$children
  )

  wrapper_base <- switch(
    direction,
    down = "dropdown",
    up = "dropup",
    end = "dropend",
    start = "dropstart"
  )

  root <- htmltools::div(
    class = bs_classes(
      wrapper_base,
      if (
        isTRUE(
          split
        )
      )
        "btn-group",
      class
    ),
    # Bootstrap 5.3 colour modes (.dropdown-menu-dark is deprecated).
    `data-bs-theme` = if (
      isTRUE(
        dark
      )
    )
      "dark",
    buttons,
    menu
  )
  # Named `...` become attributes of the wrapper (passing the list
  # positionally would render the values as children).
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

#' @rdname bs_dropdown
#' @param id Optional input id. When set, the item becomes a Shiny action
#'   button and its click count is reported as `input$id`.
#' @param href Link target.
#' @param active If `TRUE`, mark the item active (`.active`).
#' @param disabled If `TRUE`, mark the item disabled (`.disabled`).
#' @export
bs_dropdown_item <- function(
  ...,
  id = NULL,
  href = "#",
  active = FALSE,
  disabled = FALSE,
  class = NULL
) {
  htmltools::tags$li(
    htmltools::tags$a(
      id = id,
      class = bs_classes(
        "dropdown-item",
        if (
          isTRUE(
            active
          )
        )
          "active",
        if (
          isTRUE(
            disabled
          )
        )
          "disabled",
        if (
          !is.null(
            id
          )
        )
          "action-button",
        class
      ),
      href = href,
      `aria-current` = if (
        isTRUE(
          active
        )
      )
        "true",
      `aria-disabled` = if (
        isTRUE(
          disabled
        )
      )
        "true",
      ...
    )
  )
}

#' @rdname bs_dropdown
#' @export
bs_dropdown_divider <- function(
  class = NULL
) {
  htmltools::tags$li(
    htmltools::tags$hr(
      class = bs_classes(
        "dropdown-divider",
        class
      )
    )
  )
}

#' @rdname bs_dropdown
#' @param level Heading level (1-6) for the dropdown header.
#' @export
bs_dropdown_header <- function(
  ...,
  level = 6,
  class = NULL
) {
  level <- check_heading_level(
    level
  )
  htmltools::tags$li(
    htmltools::tag(
      paste0(
        "h",
        level
      ),
      list(
        class = bs_classes(
          "dropdown-header",
          class
        ),
        ...
      )
    )
  )
}

#' @rdname bs_dropdown
#' @export
bs_dropdown_text <- function(
  ...,
  class = NULL
) {
  htmltools::tags$li(
    htmltools::tags$span(
      class = bs_classes(
        "dropdown-item-text",
        class
      ),
      ...
    )
  )
}
