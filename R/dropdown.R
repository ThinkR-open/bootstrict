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
#' Give the dropdown itself an `id` and its open state is reported as
#' `input$id` (`TRUE` while the menu is open), and it can be driven from the
#' server with [show_bs_dropdown()], [hide_bs_dropdown()] and
#' [toggle_bs_dropdown()].
#'
#' @param label Toggle button label (text or tags).
#' @param ... Menu contents (dropdown items, dividers, headers, text) and named
#'   HTML attributes (forwarded to the wrapper).
#' @param id Optional dropdown id. Its open state is reported as `input$id`.
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
#' @seealso [show_bs_dropdown()], [bs_nav_dropdown()]
#' @export
#'
#' @examples
#' bs_dropdown("Menu", bs_dropdown_item("Action", id = "act"))
bs_dropdown <- function(
  label,
  ...,
  id = NULL,
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

  align <- dropdown_align_class(
    align
  )

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
    id = id,
    `data-bootstrict` = if (
      !is.null(
        id
      )
    )
      "dropdown",
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

#' Bootstrap dropdown inside a nav or a navbar
#'
#' The dropdown a designer draws in a navbar: an `<li class="nav-item
#' dropdown">` whose toggle is a `.nav-link`, not a button. [bs_dropdown()]
#' builds the standalone, button-triggered menu, which is invalid as a direct
#' child of the `<ul class="navbar-nav">` that [bs_navbar_nav()] and [bs_nav()]
#' produce, and renders as a grey button rather than a nav link.
#'
#' Fill it with the same items as [bs_dropdown()]: [bs_dropdown_item()],
#' [bs_dropdown_header()], [bs_dropdown_divider()], [bs_dropdown_text()].
#'
#' @param label Toggle text.
#' @param ... Menu content (unnamed) and named HTML attributes applied to the
#'   `<li>`.
#' @param active If `TRUE`, mark the toggle as the active page (`.active` and
#'   `aria-current="page"`).
#' @param disabled If `TRUE`, mark the toggle disabled.
#' @param align Menu alignment: `"end"`, or a named list per breakpoint (e.g.
#'   `list(lg = "end")`).
#' @param dark If `TRUE`, render a dark menu (`data-bs-theme="dark"`, the
#'   Bootstrap 5.3 idiom).
#' @param id Optional dropdown id. Its open state is reported as `input$id`,
#'   and it can be driven with [show_bs_dropdown()] and friends.
#' @param class Extra classes for the `<li>`.
#'
#' @return An `<li>` tag, ready to drop into [bs_navbar_nav()] or [bs_nav()].
#' @seealso [bs_dropdown()], [bs_navbar_nav()], [bs_nav()]
#' @export
#'
#' @examples
#' bs_navbar_nav(
#'   bs_nav_item(bs_nav_link("Home", active = TRUE)),
#'   bs_nav_dropdown("More", bs_dropdown_item("Settings"))
#' )
bs_nav_dropdown <- function(
  label,
  ...,
  active = FALSE,
  disabled = FALSE,
  align = NULL,
  dark = FALSE,
  id = NULL,
  class = NULL
) {
  dots <- split_dots(
    ...
  )
  responsive_align <- is.list(
    align
  )

  toggle <- htmltools::tags$a(
    class = bs_classes(
      "nav-link",
      "dropdown-toggle",
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
        "disabled"
    ),
    href = "#",
    role = "button",
    `data-bs-toggle` = "dropdown",
    `data-bs-display` = if (
      responsive_align
    )
      "static",
    `aria-expanded` = "false",
    `aria-current` = if (
      isTRUE(
        active
      )
    )
      "page",
    `aria-disabled` = if (
      isTRUE(
        disabled
      )
    )
      "true",
    label
  )

  menu <- htmltools::tags$ul(
    class = bs_classes(
      "dropdown-menu",
      dropdown_align_class(
        align
      )
    ),
    dots$children
  )

  root <- htmltools::tags$li(
    class = bs_classes(
      "nav-item",
      "dropdown",
      class
    ),
    id = id,
    `data-bootstrict` = if (
      !is.null(
        id
      )
    )
      "dropdown",
    # Bootstrap 5.3 colour modes (.dropdown-menu-dark is deprecated).
    `data-bs-theme` = if (
      isTRUE(
        dark
      )
    )
      "dark",
    toggle,
    menu
  )
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

#' Alignment classes for a `.dropdown-menu`.
#'
#' A scalar `"end"` gives `.dropdown-menu-end`; a named list such as
#' `list(lg = "end")` gives the responsive `.dropdown-menu-lg-end`. Responsive
#' alignment only takes effect when Popper's dynamic positioning is turned off
#' on the toggle, which is why the caller also emits `data-bs-display="static"`.
#' @noRd
dropdown_align_class <- function(
  align
) {
  if (
    is.list(
      align
    )
  ) {
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
  }
}

#' Open, close or toggle a dropdown from the server
#'
#' Drives the [bs_dropdown()] or [bs_nav_dropdown()] registered under `id`.
#' Its open state is reported back as `input$id`.
#'
#' @param id Dropdown id.
#' @param session The Shiny session.
#'
#' @return Nothing, called for their side effect.
#' @seealso [bs_dropdown()]
#' @export
#'
#' @examples
#' if (interactive()) show_bs_dropdown("menu")
show_bs_dropdown <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "dropdown.show",
    id = bs_ns(
      id,
      session
    ),
    session = session
  )
}

#' @rdname show_bs_dropdown
#' @export
hide_bs_dropdown <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "dropdown.hide",
    id = bs_ns(
      id,
      session
    ),
    session = session
  )
}

#' @rdname show_bs_dropdown
#' @export
toggle_bs_dropdown <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "dropdown.toggle",
    id = bs_ns(
      id,
      session
    ),
    session = session
  )
}
