#' @keywords internal
#' @importFrom htmltools tags tag div span tagList tagAppendAttributes tagAppendChild htmlDependency HTML validateCssUnit
#' @importFrom rlang list2 arg_match `%||%`
#' @importFrom utils modifyList packageVersion
NULL

# --- internal infix --------------------------------------------------------

# rlang provides `%||%`; re-export for internal use only (not user facing).

# --- auto ids --------------------------------------------------------------

# Monotonic counter so widgets that need an internal id (e.g. a navbar's
# collapse target) get a unique one when the user doesn't supply it. Several
# such widgets on one page would otherwise collide on a shared default id.
bs_id_counter <- new.env(
  parent = emptyenv()
)

#' Generate a process-unique id of the form `prefix-N`.
#' @noRd
bs_auto_id <- function(
  prefix = "bs"
) {
  n <- (bs_id_counter[[
    prefix
  ]] %||%
    0L) +
    1L
  bs_id_counter[[
    prefix
  ]] <- n
  paste0(
    prefix,
    "-",
    n
  )
}

# --- list helpers ----------------------------------------------------------

#' Drop `NULL` elements of a list
#' @noRd
drop_nulls <- function(
  x
) {
  x[
    !vapply(
      x,
      is.null,
      logical(
        1
      )
    )
  ]
}

#' Are all of `...` `NULL`/length 0?
#' @noRd
is_empty <- function(
  x
) {
  is.null(
    x
  ) ||
    length(
      x
    ) ==
      0L
}

# --- class string building -------------------------------------------------

#' Build a space separated class string from pieces
#'
#' Drops `NULL`/`NA`/empty pieces, splits any internal spaces, de-duplicates
#' while preserving order, and returns a single string (or `NULL` if empty).
#' @noRd
bs_classes <- function(
  ...
) {
  pieces <- unlist(
    list(
      ...
    ),
    use.names = FALSE
  )
  pieces <- pieces[
    !is.na(
      pieces
    )
  ]
  pieces <- pieces[nzchar(
    pieces
  )]
  if (
    length(
      pieces
    ) ==
      0L
  ) {
    return(
      NULL
    )
  }
  pieces <- unlist(
    strsplit(
      pieces,
      "\\s+"
    ),
    use.names = FALSE
  )
  pieces <- pieces[nzchar(
    pieces
  )]
  pieces <- unique(
    pieces
  )
  paste(
    pieces,
    collapse = " "
  )
}

#' Prefix-builder for modifier classes, e.g. `mod("btn", "primary")` -> "btn-primary"
#' Returns `NULL` when `value` is `NULL`.
#' @noRd
mod <- function(
  prefix,
  value,
  sep = "-"
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
  paste0(
    prefix,
    sep,
    value
  )
}

# --- enum validation -------------------------------------------------------

#' Validate a scalar argument against a set of allowed values.
#'
#' Thin wrapper over [rlang::arg_match()] that also tolerates `NULL` (returns
#' `NULL`) so optional modifier args can be passed straight through.
#' @noRd
match_arg <- function(
  arg,
  values,
  allow_null = TRUE,
  arg_nm = rlang::caller_arg(
    arg
  )
) {
  if (
    is.null(
      arg
    )
  ) {
    if (
      allow_null
    ) {
      return(
        NULL
      )
    }
    rlang::abort(sprintf(
      "`%s` must be one of %s.",
      arg_nm,
      paste0(
        '"',
        values,
        '"',
        collapse = ", "
      )
    ))
  }
  rlang::arg_match0(
    as.character(
      arg
    ),
    values,
    arg_nm = arg_nm
  )
}

# Canonical Bootstrap 5 theme colours, reused across components.
bs_theme_colors <- c(
  "primary",
  "secondary",
  "success",
  "danger",
  "warning",
  "info",
  "light",
  "dark"
)

# Validate a theme colour, allowing `NULL`.
check_color <- function(
  color,
  values = bs_theme_colors,
  arg_nm = rlang::caller_arg(
    color
  )
) {
  match_arg(
    color,
    values,
    arg_nm = arg_nm
  )
}

# Bootstrap responsive breakpoints.
bs_breakpoints <- c(
  "sm",
  "md",
  "lg",
  "xl",
  "xxl"
)

# --- attribute helpers -----------------------------------------------------

#' Coerce a logical/character flag into a `data-bs-*` attribute value.
#' @noRd
bs_bool_attr <- function(
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
  if (
    isTRUE(
      x
    )
  ) {
    return(
      "true"
    )
  }
  if (
    isFALSE(
      x
    )
  ) {
    return(
      "false"
    )
  }
  as.character(
    x
  )
}

# --- tag tree walking ------------------------------------------------------

#' Does a tag carry a given class?
#' @noRd
has_class <- function(
  tag,
  cls
) {
  if (
    !inherits(
      tag,
      "shiny.tag"
    )
  ) {
    return(
      FALSE
    )
  }
  classes <- tag$attribs$class
  if (
    is.null(
      classes
    )
  ) {
    return(
      FALSE
    )
  }
  classes <- unlist(strsplit(
    paste(
      unlist(
        classes
      ),
      collapse = " "
    ),
    "\\s+"
  ))
  cls %in%
    classes
}

#' Recursively apply `fn` to every tag in a tree for which `predicate` is TRUE.
#'
#' Works across `shiny.tag`, `shiny.tag.list` and bare child lists while
#' preserving their classes/structure. The cornerstone of bootstrict's "delegate
#' to shiny, then enhance" form strategy.
#' @noRd
tag_modify_where <- function(
  x,
  predicate,
  fn
) {
  if (
    inherits(
      x,
      "shiny.tag"
    )
  ) {
    if (
      isTRUE(predicate(
        x
      ))
    ) {
      x <- fn(
        x
      )
    }
    if (
      !is.null(
        x$children
      )
    ) {
      x$children <- lapply(
        x$children,
        tag_modify_where,
        predicate,
        fn
      )
    }
    return(
      x
    )
  }
  if (
    inherits(
      x,
      "shiny.tag.list"
    )
  ) {
    x[] <- lapply(
      unclass(
        x
      ),
      tag_modify_where,
      predicate,
      fn
    )
    return(
      x
    )
  }
  # Only descend into *bare* lists. S3-classed lists such as `html_dependency`
  # must be left intact (recursing would strip their class and render them as
  # text), as must `shiny.tag.function` and other tag-like objects.
  if (
    is.list(
      x
    ) &&
      !is.object(
        x
      )
  ) {
    return(lapply(
      x,
      tag_modify_where,
      predicate,
      fn
    ))
  }
  x
}

#' Return the first tag in a tree for which `predicate` is TRUE (or NULL).
#' @noRd
find_first_tag <- function(
  x,
  predicate
) {
  if (
    inherits(
      x,
      "shiny.tag"
    )
  ) {
    if (
      isTRUE(predicate(
        x
      ))
    ) {
      return(
        x
      )
    }
    if (
      !is.null(
        x$children
      )
    ) {
      for (ch in x$children) {
        found <- find_first_tag(
          ch,
          predicate
        )
        if (
          !is.null(
            found
          )
        )
          return(
            found
          )
      }
    }
    return(
      NULL
    )
  }
  if (
    inherits(
      x,
      "shiny.tag.list"
    ) ||
      (is.list(
        x
      ) &&
        !is.object(
          x
        ))
  ) {
    for (ch in x) {
      found <- find_first_tag(
        ch,
        predicate
      )
      if (
        !is.null(
          found
        )
      )
        return(
          found
        )
    }
  }
  NULL
}

#' Does any tag in the tree satisfy `predicate`?
#' @noRd
tag_contains <- function(
  x,
  predicate
) {
  !is.null(find_first_tag(
    x,
    predicate
  ))
}

#' Add Bootstrap sizing + label classes to a shiny-delegated form control.
#'
#' @param tag A tag tree (typically the return value of a `shiny::*Input()`).
#' @param size `"sm"`/`"lg"` or `NULL`.
#' @param select If `TRUE`, treat the control as a `<select>` (`.form-select`).
#' @noRd
enhance_form_control <- function(
  tag,
  size = NULL,
  select = FALSE
) {
  size <- match_arg(
    size,
    c(
      "sm",
      "lg"
    )
  )

  # Promote shiny's `.control-label` to also be a Bootstrap `.form-label`.
  tag <- tag_modify_where(
    tag,
    function(
      t
    )
      has_class(
        t,
        "control-label"
      ),
    function(
      t
    )
      htmltools::tagAppendAttributes(
        t,
        class = "form-label"
      )
  )

  if (
    isTRUE(
      select
    )
  ) {
    tag <- tag_modify_where(
      tag,
      function(
        t
      )
        identical(
          t$name,
          "select"
        ),
      function(
        t
      ) {
        # Swap shiny's `.form-control` for the Bootstrap 5 `.form-select`.
        cls <- unlist(strsplit(
          paste(
            unlist(
              t$attribs$class
            ),
            collapse = " "
          ),
          "\\s+"
        ))
        cls <- setdiff(
          cls,
          "form-control"
        )
        t$attribs[
          names(
            t$attribs
          ) ==
            "class"
        ] <- NULL
        htmltools::tagAppendAttributes(
          t,
          class = bs_classes(
            cls,
            "form-select"
          )
        )
      }
    )
  }

  if (
    !is.null(
      size
    )
  ) {
    ctrl_class <- if (
      isTRUE(
        select
      )
    )
      "form-select" else
      "form-control"
    tag <- tag_modify_where(
      tag,
      function(
        t
      )
        has_class(
          t,
          "form-control"
        ) ||
          has_class(
            t,
            "form-select"
          ),
      function(
        t
      ) {
        htmltools::tagAppendAttributes(
          t,
          class = paste0(
            ctrl_class,
            "-",
            size
          )
        )
      }
    )
  }
  tag
}

#' Append Bootstrap help text (`.form-text`) to a form control container.
#' @noRd
add_form_help <- function(
  tag,
  help
) {
  if (
    is.null(
      help
    )
  ) {
    return(
      tag
    )
  }
  htmltools::tagAppendChild(
    tag,
    htmltools::div(
      class = "form-text",
      help
    )
  )
}

#' Spread extra named attributes onto the inner form control of a tag tree.
#' @noRd
add_control_attribs <- function(
  tag,
  ...
) {
  attrs <- rlang::list2(
    ...
  )
  if (
    length(
      attrs
    ) ==
      0L
  ) {
    return(
      tag
    )
  }
  tag_modify_where(
    tag,
    function(
      t
    ) {
      has_class(
        t,
        "form-control"
      ) ||
        has_class(
          t,
          "form-select"
        ) ||
        has_class(
          t,
          "form-check-input"
        ) ||
        identical(
          t$name,
          "textarea"
        )
    },
    function(
      t
    )
      do.call(
        htmltools::tagAppendAttributes,
        c(
          list(
            t
          ),
          attrs
        )
      )
  )
}

#' Split a `...` capture into (named -> attributes, unnamed -> children).
#'
#' Mirrors htmltools' own behaviour but lets a component inspect/augment the
#' attributes before constructing the tag.
#' @noRd
split_dots <- function(
  ...
) {
  dots <- rlang::list2(
    ...
  )
  nms <- names(
    dots
  )
  if (
    is.null(
      nms
    )
  ) {
    nms <- rep(
      "",
      length(
        dots
      )
    )
  }
  is_attr <- nzchar(
    nms
  )
  list(
    attribs = dots[
      is_attr
    ],
    children = unname(dots[
      !is_attr
    ])
  )
}
