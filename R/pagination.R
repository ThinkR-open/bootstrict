# Component: pagination -----------------------------------------------------

#' Bootstrap pagination
#'
#' A list of page links, built from [bs_page_item()]s. For a quick numbered
#' pager use [bs_pagination_numbered()].
#'
#' @param ... Page items built with [bs_page_item()], plus named HTML
#'   attributes applied to the `<ul>`.
#' @param size Size modifier: `"sm"` or `"lg"` (`.pagination-sm`/`.pagination-lg`).
#' @param align Horizontal alignment of the pager: `"start"`, `"center"` or
#'   `"end"` (maps to `.justify-content-*`).
#' @param label Accessible label for the surrounding `<nav>` (`aria-label`).
#' @param class Extra classes for the `<ul>`.
#'
#' @return A `<nav>` pagination tag.
#' @export
#'
#' @examples
#' bs_pagination(
#'   bs_page_item("Previous", href = "#"),
#'   bs_page_item("1", href = "#", active = TRUE),
#'   bs_page_item("2", href = "#"),
#'   bs_page_item("Next", href = "#")
#' )
bs_pagination <- function(
  ...,
  size = NULL,
  align = NULL,
  label = "Page navigation",
  class = NULL
) {
  size <- match_arg(
    size,
    c(
      "sm",
      "lg"
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

  attach_deps(htmltools::tags$nav(
    `aria-label` = label,
    htmltools::tags$ul(
      class = bs_classes(
        "pagination",
        mod(
          "pagination",
          size
        ),
        mod(
          "justify-content",
          align
        ),
        class
      ),
      ...
    )
  ))
}

#' Bootstrap pagination item
#'
#' A single `<li class="page-item">` carrying a `.page-link` anchor. Use inside
#' [bs_pagination()].
#'
#' @param ... Link content (text or tags) and named HTML attributes applied to
#'   the `<a class="page-link">`.
#' @param href Link target.
#' @param active If `TRUE`, mark as the current page (`.active`,
#'   `aria-current="page"`).
#' @param disabled If `TRUE`, render as a non-interactive link
#'   (`.disabled`, `tabindex="-1"`, `aria-disabled="true"`).
#' @param class Extra classes for the `<li>`.
#'
#' @return A `<li>` page-item tag.
#' @export
#'
#' @examples
#' bs_page_item("1", href = "#", active = TRUE)
bs_page_item <- function(
  ...,
  href = "#",
  active = FALSE,
  disabled = FALSE,
  class = NULL
) {
  link <- htmltools::tags$a(
    class = "page-link",
    href = href,
    `aria-current` = if (
      isTRUE(
        active
      )
    )
      "page",
    tabindex = if (
      isTRUE(
        disabled
      )
    )
      "-1",
    `aria-disabled` = if (
      isTRUE(
        disabled
      )
    )
      "true",
    ...
  )

  htmltools::tags$li(
    class = bs_classes(
      "page-item",
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
      class
    ),
    link
  )
}

#' Build a numbered pager
#'
#' Convenience wrapper around [bs_pagination()] that lays out a "Previous"
#' control, page numbers `1..n` (the `current` one active) and a "Next" control.
#'
#' @param n Total number of pages.
#' @param current Currently active page number (1-based).
#' @param ... Additional named HTML attributes forwarded to [bs_pagination()]'s
#'   `<ul>`.
#' @param href_template Optional `sprintf()`-style template used to build each
#'   page's `href` from its page number, e.g. `"?page=%d"`. When `NULL`, every
#'   link uses `"#"`.
#' @param size Size modifier passed to [bs_pagination()].
#' @param align Alignment passed to [bs_pagination()].
#' @param label Accessible label passed to [bs_pagination()].
#' @param class Extra classes for the `<ul>`.
#'
#' @return A `<nav>` pagination tag.
#' @export
#'
#' @examples
#' bs_pagination_numbered(5, current = 2)
bs_pagination_numbered <- function(
  n,
  current = 1,
  ...,
  href_template = NULL,
  size = NULL,
  align = NULL,
  label = "Page navigation",
  class = NULL
) {
  n <- as.integer(
    n
  )
  current <- as.integer(
    current
  )
  if (
    length(
      n
    ) !=
      1L ||
      is.na(
        n
      ) ||
      n <
        1L
  ) {
    rlang::abort(
      "`n` must be a single positive integer."
    )
  }
  if (
    length(
      current
    ) !=
      1L ||
      is.na(
        current
      ) ||
      current <
        1L ||
      current >
        n
  ) {
    rlang::abort(sprintf(
      "`current` must be a single integer between 1 and `n` (%d).",
      n
    ))
  }

  page_href <- function(
    page
  ) {
    if (
      is.null(
        href_template
      )
    )
      "#" else
      sprintf(
        href_template,
        page
      )
  }

  prev_item <- bs_page_item(
    "Previous",
    href = page_href(max(
      current -
        1L,
      1L
    )),
    disabled = current <=
      1L
  )

  number_items <- lapply(
    seq_len(
      n
    ),
    function(
      page
    ) {
      bs_page_item(
        as.character(
          page
        ),
        href = page_href(
          page
        ),
        active = page ==
          current
      )
    }
  )

  next_item <- bs_page_item(
    "Next",
    href = page_href(min(
      current +
        1L,
      n
    )),
    disabled = current >=
      n
  )

  bs_pagination(
    prev_item,
    number_items,
    next_item,
    ...,
    size = size,
    align = align,
    label = label,
    class = class
  )
}
