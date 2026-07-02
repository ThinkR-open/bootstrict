# Component: list group -----------------------------------------------------

#' Bootstrap list group
#'
#' A flexible container for displaying a series of content. Compose with
#' [bs_list_group_item()]. When `id` is supplied the group becomes selectable:
#' clicking an action item (`action = TRUE` or `href`) reports that item's
#' `value` (its `data-value`) as `input$id`, and the selection can be driven
#' server-side with [update_bs_list_group()].
#'
#' @param id Optional list group id. When set, the active item's value is
#'   reported as `input$id` and the group is wired for selection.
#' @param ... List items built with [bs_list_group_item()], plus named HTML
#'   attributes.
#' @param flush If `TRUE`, render edge-to-edge without an outer border and
#'   rounded corners (`.list-group-flush`).
#' @param numbered If `TRUE`, render a numbered list (`<ol class="list-group
#'   list-group-numbered">`).
#' @param horizontal Lay items out horizontally. `TRUE` for
#'   `.list-group-horizontal`, or a breakpoint string (`"sm"`, `"md"`, `"lg"`,
#'   `"xl"`, `"xxl"`) for `.list-group-horizontal-{bp}`.
#' @param class Extra classes.
#'
#' @return A list group tag.
#' @export
#'
#' @examples
#' bs_list_group(
#'   bs_list_group_item("An item"),
#'   bs_list_group_item("A second item", active = TRUE)
#' )
bs_list_group <- function(
  id = NULL,
  ...,
  flush = FALSE,
  numbered = FALSE,
  horizontal = FALSE,
  class = NULL
) {
  dots <- split_dots(
    ...
  )
  children <- dots$children
  attribs <- dots$attribs

  # `id` is optional and leading, so an items-only call passes the first item
  # positionally. Only treat `id` as an id when it is a length-1 string;
  # otherwise it is really a leading child (a tag / tag list / list of items).
  if (
    !is.null(
      id
    ) &&
      !(is.character(
        id
      ) &&
        length(
          id
        ) ==
          1L)
  ) {
    children <- c(
      list(
        id
      ),
      children
    )
    id <- NULL
  }

  horizontal_class <- if (
    isTRUE(
      horizontal
    )
  ) {
    "list-group-horizontal"
  } else if (
    is.character(
      horizontal
    ) &&
      length(
        horizontal
      ) ==
        1L &&
      nzchar(
        horizontal
      )
  ) {
    bp <- match_arg(
      horizontal,
      bs_breakpoints,
      allow_null = FALSE,
      arg_nm = "horizontal"
    )
    paste0(
      "list-group-horizontal-",
      bp
    )
  } else {
    NULL
  }

  classes <- bs_classes(
    "list-group",
    if (
      isTRUE(
        flush
      )
    )
      "list-group-flush",
    if (
      isTRUE(
        numbered
      )
    )
      "list-group-numbered",
    horizontal_class,
    class
  )

  # Flatten top-level bare lists of items so the container/element decisions
  # below see every item (htmltools would flatten them at render anyway).
  children <- flatten_bare_lists(
    children
  )

  # Choose the container element: groups containing actionable (<a>/<button>)
  # items or that are selectable must be a <div> (you cannot nest interactive
  # elements directly in <ul>/<ol>); numbered groups use an <ol> (numbering
  # still renders on a <div> via Bootstrap's CSS counters when the group is
  # also actionable/selectable); otherwise a plain <ul>.
  has_action_child <- any(vapply(
    children,
    function(
      ch
    )
      isTRUE(
        ch_tag_name(
          ch
        ) %in%
          c(
            "a",
            "button"
          )
      ),
    logical(
      1
    )
  ))
  tag_name <- if (
    has_action_child ||
      !is.null(
        id
      )
  ) {
    "div"
  } else if (
    isTRUE(
      numbered
    )
  ) {
    "ol"
  } else {
    "ul"
  }

  # A <div> container cannot hold <li> items: swap them to <div>s with the
  # same attributes/children (visually identical, valid HTML).
  if (
    identical(
      tag_name,
      "div"
    )
  ) {
    children <- lapply(
      children,
      function(
        ch
      ) {
        if (
          inherits(
            ch,
            "shiny.tag"
          ) &&
            identical(
              ch$name,
              "li"
            )
        ) {
          ch$name <- "div"
        }
        ch
      }
    )
  }

  group_attribs <- list(
    class = classes
  )
  if (
    !is.null(
      id
    )
  ) {
    group_attribs$id <- id
    group_attribs$`data-bootstrict` <- "list-group"
  }
  group_attribs <- c(
    group_attribs,
    attribs
  )

  attach_deps(htmltools::tag(
    tag_name,
    c(
      group_attribs,
      children
    )
  ))
}

#' @rdname bs_list_group
#' @param value Item value reported to the server when selected (its
#'   `data-value`). Only meaningful in a selectable group (when the parent
#'   [bs_list_group()] has an `id`).
#' @param active If `TRUE`, mark the item as the active/selected one.
#' @param disabled If `TRUE`, mark the item disabled.
#' @param color Contextual theme colour (`.list-group-item-*`).
#' @param action If `TRUE`, render an actionable `<button>` item
#'   (`.list-group-item-action`). Ignored when `href` is supplied (which always
#'   renders an actionable `<a>`).
#' @param href Link target; renders the item as an `<a>` (always actionable).
#' @export
#'
#' @examples
#' bs_list_group_item("A link item", href = "#", value = "a")
bs_list_group_item <- function(
  ...,
  value = NULL,
  active = FALSE,
  disabled = FALSE,
  color = NULL,
  action = FALSE,
  href = NULL,
  class = NULL
) {
  color <- check_color(
    color
  )

  actionable <- !is.null(
    href
  ) ||
    isTRUE(
      action
    )

  classes <- bs_classes(
    "list-group-item",
    if (
      actionable
    )
      "list-group-item-action",
    mod(
      "list-group-item",
      color
    ),
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
  )

  data_value <- if (
    !is.null(
      value
    )
  )
    as.character(
      value
    ) else
    NULL

  if (
    !is.null(
      href
    )
  ) {
    htmltools::tags$a(
      class = classes,
      href = href,
      `data-value` = data_value,
      `aria-current` = if (
        isTRUE(
          active
        )
      )
        "true",
      `aria-disabled` = if (
        isTRUE(
          disabled
        )
      )
        "true",
      # `.disabled` only removes pointer events; keyboard activation must be
      # blocked too.
      tabindex = if (
        isTRUE(
          disabled
        )
      )
        "-1",
      ...
    )
  } else if (
    isTRUE(
      action
    )
  ) {
    htmltools::tags$button(
      type = "button",
      class = classes,
      `data-value` = data_value,
      `aria-current` = if (
        isTRUE(
          active
        )
      )
        "true",
      disabled = if (
        isTRUE(
          disabled
        )
      )
        NA else
        NULL,
      ...
    )
  } else {
    htmltools::tags$li(
      class = classes,
      `data-value` = data_value,
      `aria-current` = if (
        isTRUE(
          active
        )
      )
        "true",
      ...
    )
  }
}

#' Control a list group selection from the server
#'
#' Activates the item whose `value` matches `selected` in a selectable
#' [bs_list_group()] (one created with an `id`).
#'
#' @param id List group id (namespaced automatically inside modules).
#' @param selected Item value to activate. `NULL` leaves the selection
#'   unchanged.
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' \dontrun{
#' update_bs_list_group("my_group", selected = "two")
#' }
update_bs_list_group <- function(
  id,
  selected = NULL,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "listgroup.update",
    id = bs_ns(
      id,
      session
    ),
    selected = if (
      !is.null(
        selected
      )
    )
      as.character(
        selected
      ) else
      NULL,
    session = session
  )
}

#' Flatten bare (unclassed) lists one level deep, recursively.
#' @noRd
flatten_bare_lists <- function(
  x
) {
  out <- list()
  for (ch in x) {
    if (
      is.list(
        ch
      ) &&
        !is.object(
          ch
        )
    ) {
      out <- c(
        out,
        flatten_bare_lists(
          ch
        )
      )
    } else {
      out <- c(
        out,
        list(
          ch
        )
      )
    }
  }
  out
}

#' Best-effort tag name of a list group child.
#' @noRd
ch_tag_name <- function(
  x
) {
  if (
    inherits(
      x,
      "shiny.tag"
    )
  ) {
    return(
      x$name
    )
  }
  NA_character_
}
