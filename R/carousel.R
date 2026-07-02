# Component: carousel -------------------------------------------------------

#' Bootstrap carousel
#'
#' A slideshow component for cycling through a series of items
#' ([bs_carousel_item()]s). The 0-based index of the active slide is reported
#' to the server as `input$id`, and can be driven server-side with
#' [update_bs_carousel()].
#'
#' @param id Carousel id; the active slide index is available as `input$id`.
#' @param ... Items built with [bs_carousel_item()] (and named HTML attributes).
#' @param indicators If `TRUE`, render the clickable slide indicators.
#' @param controls If `TRUE`, render the previous / next control buttons.
#' @param fade If `TRUE`, crossfade between slides instead of sliding
#'   (`.carousel-fade`).
#' @param autoplay If `TRUE` (default), start cycling on load
#'   (`data-bs-ride="carousel"`). When `FALSE`, the attribute is omitted so the
#'   carousel only ever advances on user interaction (Bootstrap's
#'   `data-bs-ride="true"` would resume autoplay after the first interaction).
#' @param interval Cycling interval in milliseconds (sets `data-bs-interval`).
#' @param dark If `TRUE`, the dark variant via `data-bs-theme="dark"` (the
#'   Bootstrap 5.3 idiom; `.carousel-dark` is deprecated).
#' @param class Extra classes.
#'
#' @return A carousel tag.
#' @export
#'
#' @examples
#' bs_carousel(
#'   "demo",
#'   bs_carousel_item(htmltools::img(src = "1.jpg"), active = TRUE),
#'   bs_carousel_item(htmltools::img(src = "2.jpg"))
#' )
bs_carousel <- function(
  id,
  ...,
  indicators = TRUE,
  controls = TRUE,
  fade = FALSE,
  autoplay = TRUE,
  interval = NULL,
  dark = FALSE,
  class = NULL
) {
  dots <- split_dots(
    ...
  )
  items <- Filter(
    Negate(
      is.null
    ),
    dots$children
  )
  attribs <- dots$attribs

  is_item <- vapply(
    items,
    has_class,
    logical(
      1
    ),
    cls = "carousel-item"
  )
  if (
    !all(
      is_item
    )
  ) {
    rlang::abort(
      "All unnamed `...` arguments to `bs_carousel()` must be `bs_carousel_item()`s."
    )
  }

  # Guarantee exactly one active item (default the first).
  active_flags <- vapply(
    items,
    has_class,
    logical(
      1
    ),
    cls = "active"
  )
  if (
    length(
      items
    ) >
      0L &&
      !any(
        active_flags
      )
  ) {
    items[[
      1
    ]] <- htmltools::tagAppendAttributes(
      items[[
        1
      ]],
      class = "active"
    )
    active_flags[
      1
    ] <- TRUE
  } else if (
    sum(
      active_flags
    ) >
      1L
  ) {
    keep <- which(
      active_flags
    )[
      1
    ]
    for (i in which(
      active_flags
    )) {
      if (
        i !=
          keep
      ) {
        items[[
          i
        ]]$attribs$class <- bs_classes(
          setdiff(
            unlist(strsplit(
              paste(
                unlist(
                  items[[
                    i
                  ]]$attribs$class
                ),
                collapse = " "
              ),
              "\\s+"
            )),
            "active"
          )
        )
      }
    }
    active_flags[] <- FALSE
    active_flags[
      keep
    ] <- TRUE
  }

  indicators_el <- if (
    isTRUE(
      indicators
    ) &&
      length(
        items
      ) >
        0L
  ) {
    btns <- lapply(
      seq_along(
        items
      ),
      function(
        i
      ) {
        is_active <- isTRUE(active_flags[
          i
        ])
        htmltools::tags$button(
          type = "button",
          `data-bs-target` = css_id_selector(
            id
          ),
          `data-bs-slide-to` = as.character(
            i -
              1L
          ),
          class = if (
            is_active
          )
            "active",
          `aria-current` = if (
            is_active
          )
            "true",
          `aria-label` = paste(
            "Slide",
            i
          )
        )
      }
    )
    htmltools::div(
      class = "carousel-indicators",
      btns
    )
  }

  inner_el <- htmltools::div(
    class = "carousel-inner",
    items
  )

  controls_el <- if (
    isTRUE(
      controls
    )
  ) {
    list(
      htmltools::tags$button(
        class = "carousel-control-prev",
        type = "button",
        `data-bs-target` = css_id_selector(
          id
        ),
        `data-bs-slide` = "prev",
        htmltools::span(
          class = "carousel-control-prev-icon",
          `aria-hidden` = "true"
        ),
        htmltools::span(
          class = "visually-hidden",
          "Previous"
        )
      ),
      htmltools::tags$button(
        class = "carousel-control-next",
        type = "button",
        `data-bs-target` = css_id_selector(
          id
        ),
        `data-bs-slide` = "next",
        htmltools::span(
          class = "carousel-control-next-icon",
          `aria-hidden` = "true"
        ),
        htmltools::span(
          class = "visually-hidden",
          "Next"
        )
      )
    )
  }

  root <- htmltools::div(
    id = id,
    class = bs_classes(
      "carousel",
      "slide",
      if (
        isTRUE(
          fade
        )
      )
        "carousel-fade",
      class
    ),
    # Bootstrap 5.3 colour modes (.carousel-dark is deprecated).
    `data-bs-theme` = if (
      isTRUE(
        dark
      )
    )
      "dark",
    `data-bootstrict` = "carousel",
    `data-bs-ride` = if (
      isTRUE(
        autoplay
      )
    )
      "carousel",
    `data-bs-interval` = if (
      !is.null(
        interval
      )
    )
      as.character(
        interval
      ),
    indicators_el,
    inner_el,
    controls_el
  )
  root <- do.call(
    htmltools::tagAppendAttributes,
    c(
      list(
        root
      ),
      attribs
    )
  )

  attach_deps(
    root
  )
}

#' @rdname bs_carousel
#' @param active If `TRUE`, this item is shown first. Exactly one item per
#'   carousel is active; [bs_carousel()] defaults the first item if none is set.
#' @param caption Optional caption content placed in a `.carousel-caption`
#'   (hidden on small screens, `d-none d-md-block`).
#' @export
bs_carousel_item <- function(
  ...,
  active = FALSE,
  interval = NULL,
  caption = NULL,
  class = NULL
) {
  caption_el <- if (
    !is.null(
      caption
    )
  ) {
    htmltools::div(
      class = "carousel-caption d-none d-md-block",
      caption
    )
  }
  htmltools::div(
    class = bs_classes(
      "carousel-item",
      if (
        isTRUE(
          active
        )
      )
        "active",
      class
    ),
    `data-bs-interval` = if (
      !is.null(
        interval
      )
    )
      as.character(
        interval
      ),
    ...,
    caption_el
  )
}

#' Control a carousel from the server
#'
#' @param id Carousel id (namespaced automatically inside modules).
#' @param to 0-based index of the slide to cycle to. Takes precedence over
#'   `slide` when both are supplied.
#' @param slide Direction to advance: `"next"` or `"prev"`.
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' \dontrun{
#' update_bs_carousel("demo", to = 2)
#' update_bs_carousel("demo", slide = "next")
#' }
update_bs_carousel <- function(
  id,
  to = NULL,
  slide = NULL,
  session = shiny::getDefaultReactiveDomain()
) {
  slide <- match_arg(
    slide,
    c(
      "next",
      "prev"
    )
  )
  bs_send(
    "carousel.update",
    id = bs_ns(
      id,
      session
    ),
    to = if (
      !is.null(
        to
      )
    )
      as.integer(
        to
      ),
    slide = slide,
    session = session
  )
}
