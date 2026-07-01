# Component: spinner & placeholder ------------------------------------------

#' Bootstrap spinner
#'
#' An animated loading indicator. Render either a spinning border
#' (`type = "border"`) or a pulsing dot (`type = "grow"`), optionally tinted
#' with a theme colour and shrunk to the small variant.
#'
#' @param type Spinner style: `"border"` (default) or `"grow"`.
#' @param color Theme colour (`.text-*`), one of the Bootstrap theme colours.
#' @param size Spinner size; only `"sm"` (small) is accepted, `NULL` for the
#'   default size.
#' @param label Visually hidden text announced to assistive technology.
#' @param ... Additional named HTML attributes applied to the spinner element.
#' @param class Extra classes.
#'
#' @return A spinner tag.
#' @export
#'
#' @examples
#' bs_spinner(type = "border", color = "primary")
bs_spinner <- function(
  type = c(
    "border",
    "grow"
  ),
  color = NULL,
  size = NULL,
  label = "Loading...",
  ...,
  class = NULL
) {
  type <- match.arg(
    type
  )
  color <- check_color(
    color
  )
  size <- match_arg(
    size,
    "sm"
  )
  base <- paste0(
    "spinner-",
    type
  )
  attach_deps(htmltools::div(
    class = bs_classes(
      base,
      mod(
        "text",
        color
      ),
      if (
        !is.null(
          size
        )
      )
        paste0(
          base,
          "-",
          size
        ),
      class
    ),
    role = "status",
    ...,
    htmltools::span(
      class = "visually-hidden",
      label
    )
  ))
}

#' Bootstrap placeholder
#'
#' Loading placeholders ("skeletons") that mimic the shape of content while it
#' loads. Use [bs_placeholder()] for an individual placeholder and wrap one or
#' more in [bs_placeholder_glow()] or [bs_placeholder_wave()] to animate them.
#'
#' @param ... Additional named HTML attributes (and, for the wrappers, child
#'   content) applied to the element.
#' @param width Column count (integer 1-12) controlling the placeholder width
#'   via the grid (`.col-*`).
#' @param color Background theme colour (`.bg-*`), one of the Bootstrap theme
#'   colours.
#' @param size Placeholder size, one of `"lg"`, `"sm"` or `"xs"`; `NULL` for the
#'   default size.
#' @param class Extra classes.
#'
#' @return A placeholder tag.
#' @export
#'
#' @examples
#' bs_placeholder_glow(bs_placeholder(width = 6))
bs_placeholder <- function(
  ...,
  width = NULL,
  color = NULL,
  size = NULL,
  class = NULL
) {
  color <- check_color(
    color
  )
  size <- match_arg(
    size,
    c(
      "lg",
      "sm",
      "xs"
    )
  )
  if (
    !is.null(
      width
    )
  ) {
    width <- as.integer(
      width
    )
    if (
      length(
        width
      ) !=
        1L ||
        is.na(
          width
        ) ||
        width <
          1L ||
        width >
          12L
    ) {
      rlang::abort(
        "`width` must be a single integer between 1 and 12."
      )
    }
  }
  attach_deps(htmltools::span(
    class = bs_classes(
      "placeholder",
      mod(
        "col",
        width
      ),
      mod(
        "bg",
        color
      ),
      mod(
        "placeholder",
        size
      ),
      class
    ),
    ...
  ))
}

#' @rdname bs_placeholder
#' @export
bs_placeholder_glow <- function(
  ...,
  class = NULL
) {
  attach_deps(htmltools::tags$p(
    class = bs_classes(
      "placeholder-glow",
      class
    ),
    ...
  ))
}

#' @rdname bs_placeholder
#' @export
bs_placeholder_wave <- function(
  ...,
  class = NULL
) {
  attach_deps(htmltools::tags$p(
    class = bs_classes(
      "placeholder-wave",
      class
    ),
    ...
  ))
}
