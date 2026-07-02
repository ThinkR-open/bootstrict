# Layout: containers, grid -------------------------------------------------

#' Bootstrap container
#'
#' @param ... Content, and named HTML attributes.
#' @param fluid If `TRUE`, a full-width `.container-fluid`. Ignored when
#'   `breakpoint` is set.
#' @param breakpoint One of `"sm"`, `"md"`, `"lg"`, `"xl"`, `"xxl"` for a
#'   responsive `.container-{breakpoint}`.
#' @param class Extra classes.
#'
#' @return A container tag.
#' @seealso [bs_row()], [bs_col()]
#' @export
#'
#' @examples
#' bs_container(bs_row(bs_col("a"), bs_col("b")))
bs_container <- function(
  ...,
  fluid = FALSE,
  breakpoint = NULL,
  class = NULL
) {
  breakpoint <- match_arg(
    breakpoint,
    bs_breakpoints
  )
  base <- if (
    !is.null(
      breakpoint
    )
  ) {
    paste0(
      "container-",
      breakpoint
    )
  } else if (
    isTRUE(
      fluid
    )
  ) {
    "container-fluid"
  } else {
    "container"
  }
  attach_deps(htmltools::div(
    class = bs_classes(
      base,
      class
    ),
    ...
  ))
}

#' Bootstrap grid row
#'
#' @param ... Columns ([bs_col()]) and named HTML attributes.
#' @param cols Number of equal-width columns per row (`row-cols-*`). A single
#'   value applies at all breakpoints; a named list (e.g. `list(sm = 1, md = 2)`)
#'   sets per-breakpoint counts.
#' @param gutters,gx,gy Gutter width `0`-`5`. `gutters` sets both axes; `gx`/`gy`
#'   override the horizontal / vertical gutter.
#' @param justify Horizontal alignment of columns: `"start"`, `"center"`,
#'   `"end"`, `"around"`, `"between"`, `"evenly"`.
#' @param align Vertical alignment of columns: `"start"`, `"center"`, `"end"`.
#' @param class Extra classes.
#'
#' @return A row tag.
#' @export
#'
#' @examples
#' bs_row(bs_col("a"), bs_col("b"), gutters = 3)
bs_row <- function(
  ...,
  cols = NULL,
  gutters = NULL,
  gx = NULL,
  gy = NULL,
  justify = NULL,
  align = NULL,
  class = NULL
) {
  cols <- check_scale_responsive(
    cols,
    "cols",
    lo = 1,
    hi = 6,
    extra = "auto"
  )
  gutters <- check_scale(
    gutters,
    "gutters",
    lo = 0,
    hi = 5
  )
  gx <- check_scale(
    gx,
    "gx",
    lo = 0,
    hi = 5
  )
  gy <- check_scale(
    gy,
    "gy",
    lo = 0,
    hi = 5
  )
  justify <- match_arg(
    justify,
    c(
      "start",
      "center",
      "end",
      "around",
      "between",
      "evenly"
    )
  )
  align <- match_arg(
    align,
    c(
      "start",
      "center",
      "end"
    )
  )

  attach_deps(htmltools::div(
    class = bs_classes(
      "row",
      responsive_classes(
        "row-cols",
        cols
      ),
      mod(
        "gx",
        gx %||%
          gutters
      ),
      mod(
        "gy",
        gy %||%
          gutters
      ),
      mod(
        "justify-content",
        justify
      ),
      mod(
        "align-items",
        align
      ),
      class
    ),
    ...
  ))
}

#' Bootstrap grid column
#'
#' @param ... Content, and named HTML attributes.
#' @param width Base column span: an integer `1`-`12`, `"auto"`, or `TRUE` for
#'   an equal-width column. `NULL` (default) yields a bare `.col`.
#' @param sm,md,lg,xl,xxl Per-breakpoint spans (integer, `"auto"` or `TRUE`).
#' @param offset Column offset. A single value applies at the base breakpoint;
#'   a named list sets per-breakpoint offsets (e.g. `list(md = 2)`).
#' @param order Column order (`order-*`): integer `0`-`5`, `"first"` or
#'   `"last"`. A named list sets per-breakpoint order.
#' @param align_self Vertical self-alignment: `"start"`, `"center"`, `"end"`.
#' @param class Extra classes.
#'
#' @return A column tag.
#' @export
#'
#' @examples
#' bs_col(width = 6, md = 4, "content")
bs_col <- function(
  ...,
  width = NULL,
  sm = NULL,
  md = NULL,
  lg = NULL,
  xl = NULL,
  xxl = NULL,
  offset = NULL,
  order = NULL,
  align_self = NULL,
  class = NULL
) {
  align_self <- match_arg(
    align_self,
    c(
      "start",
      "center",
      "end"
    )
  )

  offset <- check_scale_responsive(
    offset,
    "offset",
    lo = 0,
    hi = 11
  )
  order <- check_scale_responsive(
    order,
    "order",
    lo = 0,
    hi = 5,
    extra = c(
      "first",
      "last"
    )
  )

  col_class <- function(
    bp,
    val
  ) {
    if (
      is.null(
        val
      )
    ) {
      return(
        NULL
      )
    }
    arg_nm <- bp %||%
      "width"
    if (
      !isTRUE(
        val
      )
    ) {
      val <- check_scale(
        val,
        arg_nm,
        lo = 1,
        hi = 12,
        extra = "auto"
      )
    }
    base <- if (
      is.null(
        bp
      )
    )
      "col" else
      paste0(
        "col-",
        bp
      )
    if (
      isTRUE(
        val
      )
    ) {
      return(
        base
      )
    }
    paste0(
      base,
      "-",
      val
    )
  }

  # If no width/breakpoint given at all, fall back to a bare `.col`.
  any_span <- !is.null(
    width
  ) ||
    !is.null(
      sm
    ) ||
    !is.null(
      md
    ) ||
    !is.null(
      lg
    ) ||
    !is.null(
      xl
    ) ||
    !is.null(
      xxl
    )

  attach_deps(htmltools::div(
    class = bs_classes(
      if (
        !any_span
      )
        "col",
      col_class(
        NULL,
        width
      ),
      col_class(
        "sm",
        sm
      ),
      col_class(
        "md",
        md
      ),
      col_class(
        "lg",
        lg
      ),
      col_class(
        "xl",
        xl
      ),
      col_class(
        "xxl",
        xxl
      ),
      responsive_classes(
        "offset",
        offset
      ),
      responsive_classes(
        "order",
        order
      ),
      mod(
        "align-self",
        align_self
      ),
      class
    ),
    ...
  ))
}

#' Bootstrap stacks (horizontal / vertical flex layouts)
#'
#' Shorthand flex helpers added in Bootstrap 5.1. [bs_hstack()] lays children
#' out in a row, [bs_vstack()] in a column.
#'
#' @param ... Content, and named HTML attributes.
#' @param gap Spacing between items (`gap-*`), an integer `0`-`5`.
#' @param class Extra classes.
#'
#' @return A stack tag.
#' @export
#'
#' @examples
#' bs_hstack(bs_button(label = "A"), bs_button(label = "B"), gap = 2)
#' bs_vstack(bs_alert("one"), bs_alert("two"), gap = 3)
bs_hstack <- function(
  ...,
  gap = NULL,
  class = NULL
) {
  gap <- check_scale(
    gap,
    "gap",
    lo = 0,
    hi = 5
  )
  attach_deps(htmltools::div(
    class = bs_classes(
      "hstack",
      mod(
        "gap",
        gap
      ),
      class
    ),
    ...
  ))
}

#' @rdname bs_hstack
#' @export
bs_vstack <- function(
  ...,
  gap = NULL,
  class = NULL
) {
  gap <- check_scale(
    gap,
    "gap",
    lo = 0,
    hi = 5
  )
  attach_deps(htmltools::div(
    class = bs_classes(
      "vstack",
      mod(
        "gap",
        gap
      ),
      class
    ),
    ...
  ))
}

#' Validate a scalar utility value against an integer range (plus keywords).
#'
#' Bootstrap only ships classes for a bounded scale (e.g. `gap-0`..`gap-5`,
#' `col-1`..`col-12`); out-of-range values would silently produce classes that
#' do not exist.
#' @noRd
check_scale <- function(
  val,
  arg_nm,
  lo,
  hi,
  extra = character(
    0
  )
) {
  if (
    is.null(
      val
    )
  ) {
    return(
      NULL
    )
  }
  if (
    is.character(
      val
    ) &&
      length(
        val
      ) ==
        1L &&
      val %in%
        extra
  ) {
    return(
      val
    )
  }
  ok <- is.numeric(
    val
  ) &&
    length(
      val
    ) ==
      1L &&
    !is.na(
      val
    ) &&
    val ==
      as.integer(
        val
      ) &&
    val >=
      lo &&
    val <=
      hi
  if (
    !ok
  ) {
    rlang::abort(sprintf(
      "`%s` must be an integer between %d and %d%s.",
      arg_nm,
      as.integer(
        lo
      ),
      as.integer(
        hi
      ),
      if (
        length(
          extra
        )
      ) {
        paste0(
          ", or one of ",
          paste0(
            '"',
            extra,
            '"',
            collapse = ", "
          )
        )
      } else {
        ""
      }
    ))
  }
  as.integer(
    val
  )
}

#' Validate a scalar-or-per-breakpoint-list utility value (see check_scale).
#' @noRd
check_scale_responsive <- function(
  value,
  arg_nm,
  lo,
  hi,
  extra = character(
    0
  )
) {
  if (
    is.null(
      value
    )
  ) {
    return(
      NULL
    )
  }
  if (
    !is.list(
      value
    )
  ) {
    return(check_scale(
      value,
      arg_nm,
      lo,
      hi,
      extra
    ))
  }
  lapply(
    value,
    check_scale,
    arg_nm = arg_nm,
    lo = lo,
    hi = hi,
    extra = extra
  )
}

#' Build responsive utility classes from a scalar or named per-breakpoint list.
#'
#' `responsive_classes("row-cols", 2)` -> `"row-cols-2"`.
#' `responsive_classes("offset", list(md = 2, lg = 3))` -> `"offset-md-2 offset-lg-3"`.
#' @noRd
responsive_classes <- function(
  prefix,
  value
) {
  if (
    is.null(
      value
    )
  ) {
    return(
      NULL
    )
  }
  if (
    !is.list(
      value
    )
  ) {
    return(paste0(
      prefix,
      "-",
      value
    ))
  }
  bps <- names(
    value
  )
  out <- vapply(
    seq_along(
      value
    ),
    function(
      i
    ) {
      bp <- bps[[
        i
      ]]
      val <- value[[
        i
      ]]
      if (
        is.null(
          bp
        ) ||
          !nzchar(
            bp
          ) ||
          identical(
            bp,
            "xs"
          )
      ) {
        paste0(
          prefix,
          "-",
          val
        )
      } else {
        paste0(
          prefix,
          "-",
          bp,
          "-",
          val
        )
      }
    },
    character(
      1
    )
  )
  out
}
