# Component: progress -------------------------------------------------------
#
# A progress bar is not a Shiny input (it reports no value): it is purely a
# server-updatable display. Build faithful Bootstrap 5 markup and drive it with
# update_bs_progress(), which dispatches to the `progress.update` handler in
# binding-progress.js.

#' Bootstrap progress
#'
#' A progress container wrapping one or more [bs_progress_bar()]s. Progress is
#' display-only (it reports no value to the server); drive it from the server
#' with [update_bs_progress()].
#'
#' @param ... One or more [bs_progress_bar()]s and named HTML attributes.
#' @param height CSS height of the progress track (e.g. `"20px"`, `"1rem"`).
#' @param class Extra classes.
#'
#' @return A progress tag.
#' @export
#'
#' @examples
#' bs_progress(bs_progress_bar(value = 25, id = "load"))
bs_progress <- function(
  ...,
  height = NULL,
  class = NULL
) {
  style <- if (
    !is.null(
      height
    )
  ) {
    paste0(
      "height: ",
      htmltools::validateCssUnit(
        height
      )
    )
  }
  attach_deps(htmltools::div(
    class = bs_classes(
      "progress",
      class
    ),
    role = "progressbar",
    style = style,
    ...
  ))
}

#' @rdname bs_progress
#' @param value Current value of the bar.
#' @param min,max Lower and upper bounds of the scale.
#' @param color Bar theme colour (`.bg-*`), one of the Bootstrap theme colours.
#' @param striped If `TRUE`, apply the striped variant (`.progress-bar-striped`).
#' @param animated If `TRUE`, animate the stripes (`.progress-bar-animated`).
#' @param label Text shown inside the bar.
#' @param id Bar id; required to target it with [update_bs_progress()].
#' @export
#'
#' @examples
#' bs_progress_bar(value = 75, color = "success", striped = TRUE)
bs_progress_bar <- function(
  value = 0,
  ...,
  min = 0,
  max = 100,
  color = NULL,
  striped = FALSE,
  animated = FALSE,
  label = NULL,
  id = NULL,
  class = NULL
) {
  color <- check_color(
    color
  )
  pct <- bs_progress_pct(
    value,
    min,
    max
  )
  htmltools::div(
    id = id,
    class = bs_classes(
      "progress-bar",
      mod(
        "bg",
        color
      ),
      if (
        isTRUE(
          striped
        ) ||
          isTRUE(
            animated
          )
      )
        "progress-bar-striped",
      if (
        isTRUE(
          animated
        )
      )
        "progress-bar-animated",
      class
    ),
    role = "progressbar",
    style = paste0(
      "width: ",
      pct,
      "%"
    ),
    `aria-valuenow` = value,
    `aria-valuemin` = min,
    `aria-valuemax` = max,
    ...,
    label
  )
}

#' Compute a clamped progress percentage from value/min/max.
#' @noRd
bs_progress_pct <- function(
  value,
  min = 0,
  max = 100
) {
  span <- max -
    min
  if (
    is.null(
      span
    ) ||
      length(
        span
      ) ==
        0L ||
      span ==
        0
  ) {
    return(
      0
    )
  }
  round(
    100 *
      (value -
        min) /
      span
  )
}

#' Update a progress bar from the server
#'
#' @param id Id of the [bs_progress_bar()] to update (namespaced automatically
#'   inside modules).
#' @param value New value.
#' @param label New text shown inside the bar.
#' @param color New theme colour (`.bg-*`).
#' @param min,max New lower / upper bounds of the scale.
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' \dontrun{
#' update_bs_progress("load", value = 80)
#' }
update_bs_progress <- function(
  id,
  value = NULL,
  label = NULL,
  color = NULL,
  min = NULL,
  max = NULL,
  session = shiny::getDefaultReactiveDomain()
) {
  color <- check_color(
    color
  )
  bs_send(
    "progress.update",
    id = bs_ns(
      id,
      session
    ),
    value = value,
    label = label,
    color = color,
    min = min,
    max = max,
    session = session
  )
}
