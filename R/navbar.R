# Component: navbar ---------------------------------------------------------

#' Bootstrap navbar
#'
#' A responsive navigation header. Compose with [bs_navbar_brand()],
#' [bs_navbar_nav()] (containing `bs_nav_item()` / `bs_nav_link()` from the
#' nav-tabs group), [bs_navbar_text()] and, optionally, `bs_dropdown()`. The
#' navbar collapses behind a toggler below the `expand` breakpoint.
#'
#' @param ... Navbar content (brand, nav lists, text, ...) placed inside the
#'   collapsible container, plus named HTML attributes for the `<nav>`.
#' @param brand Optional brand element, typically [bs_navbar_brand()], rendered
#'   before the toggler so it stays visible when collapsed.
#' @param id Navbar id; used to wire the toggler to its collapsible region
#'   (`"<id>-collapse"`). Defaults to a unique auto-generated id so multiple
#'   navbars on a page never collide.
#' @param expand Breakpoint at which the navbar expands: one of
#'   `"sm"`, `"md"`, `"lg"`, `"xl"`, `"xxl"`, or `TRUE` to always expand
#'   (`.navbar-expand`). Use `FALSE`/`NULL` to never expand (always collapsed).
#' @param bg Background colour (`.bg-*`): one of the Bootstrap theme colours,
#'   or `"body"`, `"body-secondary"`, `"body-tertiary"` (the Bootstrap 5.3
#'   navbar default), `"white"`, `"black"`, `"transparent"`.
#' @param theme Colour scheme applied via `data-bs-theme` (the Bootstrap 5.3
#'   colour-modes idiom; `.navbar-light`/`.navbar-dark` are deprecated):
#'   `"light"` or `"dark"`.
#' @param placement Fixed/sticky placement: one of `"fixed-top"`,
#'   `"fixed-bottom"`, `"sticky-top"`, `"sticky-bottom"`.
#' @param fluid If `TRUE` (default) use a full-width `.container-fluid`,
#'   otherwise a fixed-width `.container`.
#' @param class Extra classes for the `<nav>`.
#'
#' @return A navbar tag.
#' @export
#'
#' @examples
#' bs_navbar(brand = bs_navbar_brand("Navbar"), bg = "light", theme = "light")
bs_navbar <- function(
  ...,
  brand = NULL,
  id = NULL,
  expand = "lg",
  bg = NULL,
  theme = NULL,
  placement = NULL,
  fluid = TRUE,
  class = NULL
) {
  # Default to a unique id so several navbars on one page don't share the same
  # `<id>-collapse` target (which would break the toggler / duplicate ids).
  if (
    is.null(
      id
    )
  ) {
    id <- bs_auto_id(
      "navbar"
    )
  }
  bg <- match_arg(
    bg,
    c(
      bs_theme_colors,
      "body",
      "body-secondary",
      "body-tertiary",
      "white",
      "black",
      "transparent"
    )
  )
  theme <- match_arg(
    theme,
    c(
      "light",
      "dark"
    )
  )
  placement <- match_arg(
    placement,
    c(
      "fixed-top",
      "fixed-bottom",
      "sticky-top",
      "sticky-bottom"
    )
  )

  if (
    isTRUE(
      expand
    )
  ) {
    expand_class <- "navbar-expand"
  } else if (
    isFALSE(
      expand
    ) ||
      is.null(
        expand
      )
  ) {
    expand_class <- NULL
  } else {
    expand <- match_arg(
      expand,
      bs_breakpoints,
      allow_null = FALSE
    )
    expand_class <- paste0(
      "navbar-expand-",
      expand
    )
  }

  collapse_id <- paste0(
    id,
    "-collapse"
  )

  # Named `...` decorate the <nav>; unnamed `...` fill the collapsible region.
  dots <- split_dots(
    ...
  )

  toggler <- htmltools::tags$button(
    class = "navbar-toggler",
    type = "button",
    `data-bs-toggle` = "collapse",
    `data-bs-target` = css_id_selector(
      collapse_id
    ),
    `aria-controls` = collapse_id,
    `aria-expanded` = "false",
    `aria-label` = "Toggle navigation",
    htmltools::tags$span(
      class = "navbar-toggler-icon"
    )
  )

  collapse <- htmltools::div(
    class = "collapse navbar-collapse",
    id = collapse_id,
    dots$children
  )

  container <- htmltools::div(
    class = bs_classes(
      if (
        isTRUE(
          fluid
        )
      )
        "container-fluid" else
        "container"
    ),
    brand,
    toggler,
    collapse
  )

  root <- htmltools::tags$nav(
    id = id,
    class = bs_classes(
      "navbar",
      expand_class,
      mod(
        "bg",
        bg
      ),
      placement,
      class
    ),
    # Bootstrap 5.3 colour modes (.navbar-light/.navbar-dark are deprecated).
    `data-bs-theme` = theme,
    container
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

#' @rdname bs_navbar
#' @param href Link target for the brand.
#' @export
#'
#' @examples
#' bs_navbar_brand("Acme", href = "/")
bs_navbar_brand <- function(
  ...,
  href = "#",
  class = NULL
) {
  htmltools::tags$a(
    class = bs_classes(
      "navbar-brand",
      class
    ),
    href = href,
    ...
  )
}

#' @rdname bs_navbar
#' @param scroll If `TRUE`, enable vertical scrolling within the collapsed
#'   navbar nav (`.navbar-nav-scroll`, Bootstrap 5.1).
#' @param scroll_height Max scroll height (sets `--bs-scroll-height`), e.g.
#'   `"75vh"` or `"200px"`. Only applies when `scroll = TRUE`.
#' @export
#'
#' @examples
#' bs_navbar_nav(bs_nav_item(bs_nav_link("Home", active = TRUE)))
bs_navbar_nav <- function(
  ...,
  scroll = FALSE,
  scroll_height = NULL,
  class = NULL
) {
  htmltools::tags$ul(
    class = bs_classes(
      "navbar-nav",
      if (
        isTRUE(
          scroll
        )
      )
        "navbar-nav-scroll",
      class
    ),
    style = if (
      isTRUE(
        scroll
      ) &&
        !is.null(
          scroll_height
        )
    ) {
      paste0(
        "--bs-scroll-height: ",
        scroll_height,
        ";"
      )
    },
    ...
  )
}

#' @rdname bs_navbar
#' @export
#'
#' @examples
#' bs_navbar_text("Signed in as Mark Otto")
bs_navbar_text <- function(
  ...,
  class = NULL
) {
  htmltools::tags$span(
    class = bs_classes(
      "navbar-text",
      class
    ),
    ...
  )
}
