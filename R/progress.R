# Component: progress -------------------------------------------------------
#
# A progress bar is not a Shiny input (it reports no value): it is purely a
# server-updatable display. Build faithful Bootstrap 5.3 markup — the
# `role="progressbar"` and `aria-value*` attributes live on the `.progress`
# wrapper, the inner `.progress-bar` is purely visual, and several bars
# compose into a `.progress-stacked` group — and drive it with
# update_bs_progress(), which dispatches to the `progress.update` handler in
# binding-progress.js.

#' Bootstrap progress
#'
#' A progress display. [bs_progress_bar()] builds one bar (a `.progress`
#' track with its `.progress-bar`); [bs_progress()] finalises it, or stacks
#' several bars into a Bootstrap 5.3 `.progress-stacked` group. Progress is
#' display-only (it reports no value to the server); drive it from the server
#' with [update_bs_progress()].
#'
#' @param ... One or more [bs_progress_bar()]s and named HTML attributes.
#'   With two or more bars, the group renders as `.progress-stacked`.
#' @param height CSS height of the progress track(s) (e.g. `"20px"`, `"1rem"`).
#' @param class Extra classes.
#'
#' @return A progress tag.
#' @export
#'
#' @examples
#' bs_progress(bs_progress_bar(value = 25, id = "load"))
#' # stacked (Bootstrap 5.3):
#' bs_progress(
#'   bs_progress_bar(value = 15, color = "success"),
#'   bs_progress_bar(value = 30, color = "danger")
#' )
bs_progress <- function(
  ...,
  height = NULL,
  class = NULL
) {
  dots <- split_dots(
    ...
  )
  bars <- Filter(
    Negate(
      is.null
    ),
    dots$children
  )
  ok <- vapply(
    bars,
    has_class,
    logical(
      1
    ),
    cls = "progress"
  )
  if (
    !all(
      ok
    )
  ) {
    rlang::abort(
      "All unnamed `...` arguments to `bs_progress()` must be `bs_progress_bar()`s."
    )
  }

  height_style <- if (
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

  if (
    length(
      bars
    ) <=
      1L
  ) {
    root <- if (
      length(
        bars
      ) ==
        1L
    ) {
      bars[[
        1
      ]]
    } else {
      htmltools::div(
        class = "progress",
        role = "progressbar",
        `aria-valuenow` = 0,
        `aria-valuemin` = 0,
        `aria-valuemax` = 100
      )
    }
    root <- htmltools::tagAppendAttributes(
      root,
      class = class,
      style = height_style
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
    return(attach_deps(
      root
    ))
  }

  # Stacked (Bootstrap 5.3): the width moves from the inner bar to each
  # `.progress` segment; Bootstrap's CSS makes the inner bar fill it.
  bars <- lapply(
    bars,
    function(
      w
    ) {
      pct <- bs_progress_pct(
        as.numeric(
          htmltools::tagGetAttribute(
            w,
            "aria-valuenow"
          ) %||%
            0
        ),
        as.numeric(
          htmltools::tagGetAttribute(
            w,
            "aria-valuemin"
          ) %||%
            0
        ),
        as.numeric(
          htmltools::tagGetAttribute(
            w,
            "aria-valuemax"
          ) %||%
            100
        )
      )
      w <- htmltools::tagAppendAttributes(
        w,
        style = paste0(
          "width: ",
          pct,
          "%"
        ),
        style = height_style
      )
      w$children <- lapply(
        w$children,
        strip_bar_width
      )
      w
    }
  )

  root <- htmltools::div(
    class = bs_classes(
      "progress-stacked",
      class
    ),
    bars
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

#' Remove the inline width from a `.progress-bar` (stacked layout).
#' @noRd
strip_bar_width <- function(
  x
) {
  if (
    !inherits(
      x,
      "shiny.tag"
    ) ||
      !has_class(
        x,
        "progress-bar"
      )
  ) {
    return(
      x
    )
  }
  styles <- unlist(
    x$attribs[
      names(
        x$attribs
      ) ==
        "style"
    ],
    use.names = FALSE
  )
  x$attribs[
    names(
      x$attribs
    ) ==
      "style"
  ] <- NULL
  styles <- sub(
    "width:[^;]*;?",
    "",
    styles
  )
  styles <- styles[nzchar(trimws(
    styles
  ))]
  if (
    length(
      styles
    )
  ) {
    x <- htmltools::tagAppendAttributes(
      x,
      style = paste(
        styles,
        collapse = "; "
      )
    )
  }
  x
}

#' @rdname bs_progress
#' @param value Current value of the bar.
#' @param min,max Lower and upper bounds of the scale.
#' @param color Bar theme colour (`.bg-*`), one of the Bootstrap theme colours.
#' @param striped If `TRUE`, apply the striped variant (`.progress-bar-striped`).
#' @param animated If `TRUE`, animate the stripes (`.progress-bar-animated`).
#' @param label Text shown inside the bar.
#' @param aria_label Accessible name of the progress track (`aria-label`).
#' @param id Id of the `.progress` track; required to target it with
#'   [update_bs_progress()].
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
  aria_label = NULL,
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
  bar <- htmltools::div(
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
    style = paste0(
      "width: ",
      pct,
      "%"
    ),
    ...,
    label
  )
  # Bootstrap 5.3 markup: role and aria-value* live on the `.progress`
  # wrapper; the inner `.progress-bar` is purely visual.
  htmltools::div(
    id = id,
    class = "progress",
    role = "progressbar",
    `aria-label` = aria_label,
    `aria-valuenow` = value,
    `aria-valuemin` = min,
    `aria-valuemax` = max,
    bar
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
      is.na(
        span
      ) ||
      span ==
        0
  ) {
    return(
      0
    )
  }
  pct <- round(
    100 *
      (value -
        min) /
      span
  )
  # NB: pmin/pmax, as the min/max *parameters* shadow the base functions here.
  pmin(
    100,
    pmax(
      0,
      pct
    )
  )
}

#' Update a progress bar from the server
#'
#' @param id Id of the [bs_progress_bar()] track to update (namespaced
#'   automatically inside modules).
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
