# Component: behaviors ------------------------------------------------------
#
# Helpers and small utilities that decorate or wrap existing UI rather than
# build a standalone widget: tooltips, popovers, scrollspy, plus a handful of
# Bootstrap 5 helper/utility elements (visually-hidden text, fixed aspect
# ratios, vertical rules).
#
# Tooltips and popovers are NOT auto-initialised by Bootstrap, so each decorated
# tag is marked with `data-bootstrict-tip` and initialised by
# `binding-behaviors.js` on bind.

#' Add a Bootstrap tooltip to a UI element
#'
#' Decorates an existing tag with the data attributes Bootstrap needs to render
#' a tooltip. Tooltips are initialised client-side by bootstrict (Bootstrap does
#' not auto-initialise them).
#'
#' @param tag A UI element (a `shiny.tag`) to attach the tooltip to.
#' @param title Tooltip text (or HTML, when `html = TRUE`).
#' @param ... Extra named attributes applied to `tag`.
#' @param placement Tooltip placement: one of `"top"`, `"right"`, `"bottom"`,
#'   `"left"`.
#' @param html If `TRUE`, allow HTML content in the tooltip (`data-bs-html`).
#' @param trigger How the tooltip is triggered (e.g. `"hover focus"`,
#'   `"click"`, `"manual"`); `NULL` uses the Bootstrap default.
#'
#' @return The decorated tag, with the bootstrict dependency attached.
#' @export
#'
#' @examples
#' bs_tooltip(shiny::tags$button("Hover me"), "Tooltip text")
bs_tooltip <- function(
  tag,
  title,
  ...,
  placement = "top",
  html = FALSE,
  trigger = NULL
) {
  placement <- match_arg(
    placement,
    c(
      "top",
      "right",
      "bottom",
      "left"
    ),
    allow_null = FALSE
  )
  tag <- htmltools::tagAppendAttributes(
    tag,
    `data-bs-toggle` = "tooltip",
    # Bootstrap 5.3 idiom — also avoids the native browser tooltip that a
    # plain `title` attribute would trigger before Bootstrap takes over.
    `data-bs-title` = title,
    `data-bs-placement` = placement,
    `data-bs-html` = if (
      isTRUE(
        html
      )
    )
      "true",
    `data-bs-trigger` = trigger,
    `data-bootstrict-tip` = "tooltip",
    ...
  )
  attach_deps(
    tag
  )
}

#' Add a Bootstrap popover to a UI element
#'
#' Decorates an existing tag with the data attributes Bootstrap needs to render
#' a popover. Popovers are initialised client-side by bootstrict (Bootstrap does
#' not auto-initialise them).
#'
#' @param tag A UI element (a `shiny.tag`) to attach the popover to.
#' @param content Popover body content (or HTML, when `html = TRUE`).
#' @param ... Extra named attributes applied to `tag`.
#' @param title Optional popover header.
#' @param placement Popover placement: one of `"top"`, `"right"`, `"bottom"`,
#'   `"left"`.
#' @param trigger How the popover is triggered (e.g. `"click"`, `"hover"`,
#'   `"focus"`, `"manual"`).
#' @param html If `TRUE`, allow HTML content in the popover (`data-bs-html`).
#'
#' @return The decorated tag, with the bootstrict dependency attached.
#' @export
#'
#' @examples
#' bs_popover(shiny::tags$button("Click me"), "Popover body", title = "Heads up")
bs_popover <- function(
  tag,
  content,
  ...,
  title = NULL,
  placement = "right",
  trigger = "click",
  html = FALSE
) {
  placement <- match_arg(
    placement,
    c(
      "top",
      "right",
      "bottom",
      "left"
    ),
    allow_null = FALSE
  )
  tag <- htmltools::tagAppendAttributes(
    tag,
    `data-bs-toggle` = "popover",
    `data-bs-content` = content,
    `data-bs-title` = title,
    `data-bs-placement` = placement,
    `data-bs-trigger` = trigger,
    `data-bs-html` = if (
      isTRUE(
        html
      )
    )
      "true",
    `data-bootstrict-tip` = "popover",
    ...
  )
  attach_deps(
    tag
  )
}

#' Bootstrap scrollspy container
#'
#' Wraps content in a scrollable region whose nav (identified by `target`) is
#' updated as the user scrolls.
#'
#' @param target Id (without `#`) of the nav / list-group that scrollspy drives.
#' @param ... Scrollable content and named HTML attributes.
#' @param id Optional container id. The href of the currently active nav link
#'   is reported as `input$id`. Defaults to a unique auto-generated id (an id
#'   is required for bootstrict to initialise scrollspy, including inside
#'   `renderUI()` — Bootstrap only auto-initialises on full page load).
#' @param offset Pixels from the top to offset link activation
#'   (`data-bs-offset`).
#' @param smooth If `TRUE`, enable smooth scrolling (`data-bs-smooth-scroll`).
#' @param class Extra classes.
#'
#' @return A scrollspy container tag, with the bootstrict dependency attached.
#' @export
#'
#' @examples
#' bs_scrollspy("nav-menu", shiny::tags$h4("Section"), offset = 100)
bs_scrollspy <- function(
  target,
  ...,
  id = NULL,
  offset = NULL,
  smooth = TRUE,
  class = NULL
) {
  if (
    is.null(
      id
    )
  ) {
    id <- bs_auto_id(
      "bs-scrollspy"
    )
  }
  attach_deps(htmltools::div(
    id = id,
    `data-bs-spy` = "scroll",
    `data-bs-target` = css_id_selector(
      target
    ),
    `data-bs-offset` = offset,
    `data-bs-smooth-scroll` = if (
      isTRUE(
        smooth
      )
    )
      "true",
    tabindex = "0",
    `data-bootstrict` = "scrollspy",
    class = bs_classes(
      class
    ),
    ...
  ))
}

#' Visually hidden text
#'
#' Renders content available to assistive technologies but hidden from sighted
#' users (`.visually-hidden`).
#'
#' @param ... Content and named HTML attributes.
#' @param class Extra classes.
#'
#' @return A `<span>` tag.
#' @export
#'
#' @examples
#' bs_visually_hidden("Loading, please wait")
bs_visually_hidden <- function(
  ...,
  class = NULL
) {
  htmltools::tags$span(
    class = bs_classes(
      "visually-hidden",
      class
    ),
    ...
  )
}

#' Fixed aspect-ratio container
#'
#' Wraps an embedded element (image, iframe, video, ...) so it keeps a fixed
#' aspect ratio (`.ratio`).
#'
#' @param ... The embedded element and named HTML attributes.
#' @param ratio Aspect ratio: one of `"1x1"`, `"4x3"`, `"16x9"`, `"21x9"`.
#' @param class Extra classes.
#'
#' @return A `<div>` tag.
#' @export
#'
#' @examples
#' bs_ratio(shiny::tags$iframe(src = "https://example.com"), ratio = "16x9")
bs_ratio <- function(
  ...,
  ratio = "16x9",
  class = NULL
) {
  ratio <- match_arg(
    ratio,
    c(
      "1x1",
      "4x3",
      "16x9",
      "21x9"
    ),
    allow_null = FALSE
  )
  htmltools::div(
    class = bs_classes(
      "ratio",
      paste0(
        "ratio-",
        ratio
      ),
      class
    ),
    ...
  )
}

#' Vertical rule
#'
#' A vertical divider (`.vr`), the vertical counterpart of `<hr>`.
#'
#' @param class Extra classes.
#'
#' @return A `<div>` tag.
#' @export
#'
#' @examples
#' bs_vr()
bs_vr <- function(
  class = NULL
) {
  htmltools::div(
    class = bs_classes(
      "vr",
      class
    )
  )
}
