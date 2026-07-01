# Component: content (typography, tables, images, figures) -----------------

#' Bootstrap table
#'
#' Render a faithful Bootstrap 5 `<table class="table">`. Pass a data frame or
#' matrix in `data` to have the header and body built automatically from its
#' column names and rows; otherwise supply `<thead>`/`<tbody>` markup (or any
#' table children) through `...`.
#'
#' @param data A data frame or matrix to render. When `NULL`, the unnamed
#'   `...` arguments are used as the table's children instead.
#' @param ... Manual table children (when `data` is `NULL`) and named HTML
#'   attributes applied to the `<table>` element.
#' @param striped Add zebra-striping to table rows (`.table-striped`).
#' @param bordered Add borders on all sides (`.table-bordered`).
#' @param borderless Remove all borders (`.table-borderless`).
#' @param hover Enable a hover state on rows (`.table-hover`).
#' @param small Make the table more compact (`.table-sm`).
#' @param variant Theme colour for the whole table (`.table-*`), one of the
#'   Bootstrap theme colours.
#' @param responsive Make the table scroll horizontally on small devices. Use
#'   `TRUE` for `.table-responsive`, or a breakpoint string (`"sm"`, `"md"`,
#'   `"lg"`, `"xl"`, `"xxl"`) for `.table-responsive-{bp}`.
#' @param align Vertical alignment of cells (`.align-*`), e.g. `"middle"`,
#'   `"top"`, `"bottom"`.
#' @param caption Optional table caption text rendered in a `<caption>`.
#' @param class Extra classes.
#'
#' @return A table tag (wrapped in a responsive container when `responsive` is
#'   set).
#' @export
#'
#' @examples
#' bs_table(head(mtcars), striped = TRUE, hover = TRUE)
bs_table <- function(
  data = NULL,
  ...,
  striped = FALSE,
  bordered = FALSE,
  borderless = FALSE,
  hover = FALSE,
  small = FALSE,
  variant = NULL,
  responsive = FALSE,
  align = NULL,
  caption = NULL,
  class = NULL
) {
  variant <- check_color(
    variant,
    arg_nm = "variant"
  )

  table_class <- bs_classes(
    "table",
    if (
      isTRUE(
        striped
      )
    )
      "table-striped",
    if (
      isTRUE(
        bordered
      )
    )
      "table-bordered",
    if (
      isTRUE(
        borderless
      )
    )
      "table-borderless",
    if (
      isTRUE(
        hover
      )
    )
      "table-hover",
    if (
      isTRUE(
        small
      )
    )
      "table-sm",
    mod(
      "table",
      variant
    ),
    mod(
      "align",
      align
    ),
    class
  )

  caption_tag <- if (
    !is.null(
      caption
    )
  ) {
    htmltools::tags$caption(
      caption
    )
  }

  if (
    !is.null(
      data
    )
  ) {
    body <- bs_table_from_data(
      data
    )
    parts <- split_dots(
      ...
    )
    contents <- drop_nulls(list(
      caption_tag,
      body$head,
      body$body
    ))
    table <- do.call(
      htmltools::tags$table,
      c(
        list(
          class = table_class
        ),
        parts$attribs,
        contents
      )
    )
  } else {
    table <- htmltools::tags$table(
      class = table_class,
      caption_tag,
      ...
    )
  }

  out <- if (
    isFALSE(
      responsive
    ) ||
      is.null(
        responsive
      )
  ) {
    table
  } else {
    wrapper_class <- if (
      isTRUE(
        responsive
      )
    ) {
      "table-responsive"
    } else {
      responsive <- match_arg(
        responsive,
        bs_breakpoints,
        arg_nm = "responsive"
      )
      paste0(
        "table-responsive-",
        responsive
      )
    }
    htmltools::div(
      class = wrapper_class,
      table
    )
  }

  attach_deps(
    out
  )
}

#' Build `<thead>`/`<tbody>` from a data frame or matrix.
#' @noRd
bs_table_from_data <- function(
  data
) {
  if (
    is.matrix(
      data
    )
  ) {
    data <- as.data.frame(
      data,
      stringsAsFactors = FALSE
    )
  }
  cols <- colnames(
    data
  )
  if (
    is.null(
      cols
    )
  ) {
    cols <- paste0(
      "V",
      seq_len(NCOL(
        data
      ))
    )
  }

  head <- htmltools::tags$thead(
    htmltools::tags$tr(
      lapply(
        cols,
        function(
          nm
        )
          htmltools::tags$th(
            scope = "col",
            nm
          )
      )
    )
  )

  n_rows <- NROW(
    data
  )
  rows <- lapply(
    seq_len(
      n_rows
    ),
    function(
      i
    ) {
      cells <- lapply(
        seq_along(
          cols
        ),
        function(
          j
        ) {
          htmltools::tags$td(format_cell(data[
            i,
            j
          ]))
        }
      )
      htmltools::tags$tr(
        cells
      )
    }
  )
  body <- htmltools::tags$tbody(
    rows
  )

  list(
    head = head,
    body = body
  )
}

#' Coerce a single data cell to a character string for display.
#' @noRd
format_cell <- function(
  x
) {
  if (
    is.null(
      x
    ) ||
      (length(
        x
      ) ==
        1L &&
        is.na(
          x
        ))
  ) {
    return(
      ""
    )
  }
  as.character(
    x
  )
}

#' Bootstrap image
#'
#' @param src Image source URL.
#' @param ... Extra named HTML attributes applied to the `<img>`.
#' @param fluid Make the image responsive (`.img-fluid`).
#' @param thumbnail Render with a rounded thumbnail border (`.img-thumbnail`).
#' @param rounded Add rounded corners (`.rounded`).
#' @param alt Alternative text.
#' @param class Extra classes.
#'
#' @return An image tag.
#' @export
#'
#' @examples
#' bs_img("logo.png", alt = "Logo", fluid = TRUE)
bs_img <- function(
  src,
  ...,
  fluid = FALSE,
  thumbnail = FALSE,
  rounded = FALSE,
  alt = NULL,
  class = NULL
) {
  attach_deps(htmltools::tags$img(
    src = src,
    alt = alt,
    class = bs_classes(
      if (
        isTRUE(
          fluid
        )
      )
        "img-fluid",
      if (
        isTRUE(
          thumbnail
        )
      )
        "img-thumbnail",
      if (
        isTRUE(
          rounded
        )
      )
        "rounded",
      class
    ),
    ...
  ))
}

#' Bootstrap figure
#'
#' Group an image with a caption. Compose [bs_figure()] with [bs_figure_img()]
#' and [bs_figure_caption()].
#'
#' @param ... Figure content (image, caption) and named HTML attributes.
#' @param class Extra classes.
#'
#' @return A figure tag.
#' @export
#'
#' @examples
#' bs_figure(
#'   bs_figure_img("photo.jpg", alt = "A photo"),
#'   bs_figure_caption("A caption for the image.")
#' )
bs_figure <- function(
  ...,
  class = NULL
) {
  attach_deps(htmltools::tags$figure(
    class = bs_classes(
      "figure",
      class
    ),
    ...
  ))
}

#' @rdname bs_figure
#' @param src Image source URL.
#' @param alt Alternative text.
#' @export
bs_figure_img <- function(
  src,
  ...,
  alt = NULL,
  class = NULL
) {
  htmltools::tags$img(
    src = src,
    alt = alt,
    class = bs_classes(
      "figure-img",
      "img-fluid",
      "rounded",
      class
    ),
    ...
  )
}

#' @rdname bs_figure
#' @export
bs_figure_caption <- function(
  ...,
  class = NULL
) {
  htmltools::tags$figcaption(
    class = bs_classes(
      "figure-caption",
      class
    ),
    ...
  )
}

#' Bootstrap blockquote
#'
#' @param ... Quote content and named HTML attributes applied to the
#'   `<blockquote>`.
#' @param footer Optional source/attribution rendered in a
#'   `.blockquote-footer`.
#' @param class Extra classes applied to the `<blockquote>`.
#'
#' @return A figure tag wrapping the blockquote.
#' @export
#'
#' @examples
#' bs_blockquote("A well-known quote.", footer = "Someone famous")
bs_blockquote <- function(
  ...,
  footer = NULL,
  class = NULL
) {
  quote <- htmltools::tags$blockquote(
    class = bs_classes(
      "blockquote",
      class
    ),
    ...
  )
  caption <- if (
    !is.null(
      footer
    )
  ) {
    htmltools::tags$figcaption(
      class = "blockquote-footer",
      footer
    )
  }
  attach_deps(htmltools::tags$figure(
    quote,
    caption
  ))
}

#' Bootstrap display heading
#'
#' A larger, slightly more opinionated heading style (`.display-*`).
#'
#' @param ... Heading content and named HTML attributes.
#' @param level Display size / heading level (1-6).
#' @param class Extra classes.
#'
#' @return A heading tag.
#' @export
#'
#' @examples
#' bs_display_heading("Display heading", level = 2)
bs_display_heading <- function(
  ...,
  level = 1,
  class = NULL
) {
  attach_deps(htmltools::tag(
    paste0(
      "h",
      level
    ),
    list(
      class = bs_classes(
        paste0(
          "display-",
          level
        ),
        class
      ),
      ...
    )
  ))
}

#' Bootstrap lead paragraph
#'
#' A standout opening paragraph (`.lead`).
#'
#' @param ... Paragraph content and named HTML attributes.
#' @param class Extra classes.
#'
#' @return A paragraph tag.
#' @export
#'
#' @examples
#' bs_lead("This is a lead paragraph.")
bs_lead <- function(
  ...,
  class = NULL
) {
  attach_deps(htmltools::tags$p(
    class = bs_classes(
      "lead",
      class
    ),
    ...
  ))
}

#' Bootstrap unstyled / inline lists
#'
#' Remove a list's default styling (`.list-unstyled`) or lay items out inline
#' (`.list-inline`). Each unnamed `...` argument becomes one `<li>`; named
#' arguments become attributes of the `<ul>`.
#'
#' @param ... List items (unnamed) and named HTML attributes for the `<ul>`.
#' @param class Extra classes.
#'
#' @return An unordered list tag.
#' @export
#'
#' @examples
#' bs_list_unstyled("First", "Second", "Third")
bs_list_unstyled <- function(
  ...,
  class = NULL
) {
  parts <- split_dots(
    ...
  )
  items <- lapply(
    parts$children,
    function(
      child
    )
      htmltools::tags$li(
        child
      )
  )
  attach_deps(do.call(
    htmltools::tags$ul,
    c(
      list(
        class = bs_classes(
          "list-unstyled",
          class
        )
      ),
      parts$attribs,
      items
    )
  ))
}

#' @rdname bs_list_unstyled
#' @export
#'
#' @examples
#' bs_list_inline("One", "Two", "Three")
bs_list_inline <- function(
  ...,
  class = NULL
) {
  parts <- split_dots(
    ...
  )
  items <- lapply(
    parts$children,
    function(
      child
    ) {
      htmltools::tags$li(
        class = "list-inline-item",
        child
      )
    }
  )
  attach_deps(do.call(
    htmltools::tags$ul,
    c(
      list(
        class = bs_classes(
          "list-inline",
          class
        )
      ),
      parts$attribs,
      items
    )
  ))
}
