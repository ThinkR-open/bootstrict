# Component: nav, tabs & pills ----------------------------------------------

#' Bootstrap navigation list
#'
#' A static navigation container rendered as a Bootstrap `<ul class="nav">`.
#' Compose it with [bs_nav_item()] and [bs_nav_link()]. For an interactive,
#' server-reporting tabset use [bs_tabset()] instead.
#'
#' @param ... Navigation items ([bs_nav_item()] / [bs_nav_link()]) and named
#'   HTML attributes.
#' @param type Visual style: `"tabs"` or `"pills"` (default `NULL` for a plain
#'   nav).
#' @param fill If `TRUE`, items expand to fill available width (`.nav-fill`).
#' @param justified If `TRUE`, items get equal width (`.nav-justified`).
#' @param vertical If `TRUE`, stack items vertically (`.flex-column`).
#' @param class Extra classes.
#'
#' @return A nav tag.
#' @export
#'
#' @examples
#' bs_nav(
#'   bs_nav_item(bs_nav_link("Active", active = TRUE)),
#'   bs_nav_item(bs_nav_link("Link")),
#'   type = "tabs"
#' )
bs_nav <- function(
  ...,
  type = NULL,
  fill = FALSE,
  justified = FALSE,
  vertical = FALSE,
  class = NULL
) {
  type <- match_arg(
    type,
    c(
      "tabs",
      "pills"
    )
  )
  attach_deps(htmltools::tags$ul(
    class = bs_classes(
      "nav",
      mod(
        "nav",
        type
      ),
      if (
        isTRUE(
          fill
        )
      )
        "nav-fill",
      if (
        isTRUE(
          justified
        )
      )
        "nav-justified",
      if (
        isTRUE(
          vertical
        )
      )
        "flex-column",
      class
    ),
    ...
  ))
}

#' @rdname bs_nav
#' @export
bs_nav_item <- function(
  ...,
  class = NULL
) {
  htmltools::tags$li(
    class = bs_classes(
      "nav-item",
      class
    ),
    ...
  )
}

#' @rdname bs_nav
#' @param href Link target.
#' @param active If `TRUE`, mark the link as the active page
#'   (adds `.active` and `aria-current="page"`).
#' @param disabled If `TRUE`, mark the link disabled (`.disabled`).
#' @param id Optional element id.
#' @export
bs_nav_link <- function(
  ...,
  href = "#",
  active = FALSE,
  disabled = FALSE,
  id = NULL,
  class = NULL
) {
  htmltools::tags$a(
    class = bs_classes(
      "nav-link",
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
    href = href,
    id = id,
    `aria-current` = if (
      isTRUE(
        active
      )
    )
      "page",
    `aria-disabled` = if (
      isTRUE(
        disabled
      )
    )
      "true",
    ...
  )
}

# Component: tabset (interactive) -------------------------------------------

#' Bootstrap tabset
#'
#' An interactive set of tabbed panels. The `data-value` of the currently
#' shown panel is reported to the server as `input$id`, and the active tab can
#' be driven server-side with [update_bs_tabset()].
#'
#' @param id Tabset id; the active panel value is available as `input$id`.
#' @param ... Panels built with [bs_tab_panel()].
#' @param type Visual style: `"tabs"` (default) or `"pills"`.
#' @param selected Value of the panel shown initially (defaults to the first).
#' @param fill If `TRUE`, tabs expand to fill available width (`.nav-fill`).
#' @param justified If `TRUE`, tabs get equal width (`.nav-justified`).
#' @param vertical If `TRUE`, lay tabs out vertically beside the content.
#' @param class Extra classes for the wrapper.
#'
#' @return A tabset tag.
#' @export
#'
#' @examples
#' bs_tabset(
#'   "tabs",
#'   bs_tab_panel("Home", "Home content", value = "home"),
#'   bs_tab_panel("Profile", "Profile content", value = "profile"),
#'   selected = "profile"
#' )
bs_tabset <- function(
  id,
  ...,
  type = "tabs",
  selected = NULL,
  fill = FALSE,
  justified = FALSE,
  vertical = FALSE,
  class = NULL
) {
  type <- match_arg(
    type,
    c(
      "tabs",
      "pills"
    ),
    allow_null = FALSE
  )

  panels <- Filter(
    Negate(
      is.null
    ),
    rlang::list2(
      ...
    )
  )
  ok <- vapply(
    panels,
    inherits,
    logical(
      1
    ),
    what = "bs_tab_panel"
  )
  if (
    !all(
      ok
    )
  ) {
    rlang::abort(
      "All `...` arguments to `bs_tabset()` must be `bs_tab_panel()`s."
    )
  }

  values <- vapply(
    panels,
    function(
      p
    )
      p$value,
    character(
      1
    )
  )
  if (
    anyDuplicated(
      values
    )
  ) {
    rlang::abort(
      "`bs_tab_panel()` values must be unique within a tabset."
    )
  }

  selected <- if (
    is.null(
      selected
    )
  ) {
    if (
      length(
        values
      )
    )
      values[[
        1
      ]] else
      NULL
  } else {
    as.character(
      selected
    )
  }

  tab_id <- function(
    i
  )
    paste0(
      id,
      "-tab-",
      i
    )
  pane_id <- function(
    i
  )
    paste0(
      id,
      "-pane-",
      i
    )

  nav_items <- lapply(
    seq_along(
      panels
    ),
    function(
      i
    ) {
      p <- panels[[
        i
      ]]
      is_active <- identical(
        p$value,
        selected
      )
      htmltools::tags$li(
        class = "nav-item",
        role = "presentation",
        htmltools::tags$button(
          class = bs_classes(
            "nav-link",
            if (
              is_active
            )
              "active"
          ),
          id = tab_id(
            i
          ),
          `data-bs-toggle` = "tab",
          `data-bs-target` = paste0(
            "#",
            pane_id(
              i
            )
          ),
          type = "button",
          role = "tab",
          `aria-controls` = pane_id(
            i
          ),
          `aria-selected` = if (
            is_active
          )
            "true" else
            "false",
          `data-value` = p$value,
          p$icon,
          p$title
        )
      )
    }
  )

  nav <- htmltools::tags$ul(
    class = bs_classes(
      "nav",
      mod(
        "nav",
        type
      ),
      if (
        isTRUE(
          fill
        )
      )
        "nav-fill",
      if (
        isTRUE(
          justified
        )
      )
        "nav-justified",
      if (
        isTRUE(
          vertical
        )
      )
        "flex-column"
    ),
    role = "tablist",
    id = id,
    `data-bootstrict` = "tabset",
    nav_items
  )

  panes <- lapply(
    seq_along(
      panels
    ),
    function(
      i
    ) {
      p <- panels[[
        i
      ]]
      is_active <- identical(
        p$value,
        selected
      )
      htmltools::div(
        class = bs_classes(
          "tab-pane",
          "fade",
          if (
            is_active
          )
            c(
              "show",
              "active"
            ),
          p$class
        ),
        id = pane_id(
          i
        ),
        role = "tabpanel",
        `aria-labelledby` = tab_id(
          i
        ),
        `data-value` = p$value,
        p$body
      )
    }
  )

  content <- htmltools::div(
    class = "tab-content",
    panes
  )

  body <- if (
    isTRUE(
      vertical
    )
  ) {
    htmltools::div(
      class = "d-flex align-items-start",
      nav,
      content
    )
  } else {
    list(
      nav,
      content
    )
  }

  attach_deps(htmltools::div(
    class = bs_classes(
      "bootstrict-tabset",
      class
    ),
    body
  ))
}

#' @rdname bs_tabset
#' @param title Tab label content.
#' @param value Panel identifier reported to the server (defaults to `title`).
#' @param icon Optional icon placed before the title.
#' @export
bs_tab_panel <- function(
  title,
  ...,
  value = NULL,
  icon = NULL,
  class = NULL
) {
  structure(
    list(
      title = title,
      value = as.character(
        value %||%
          title
      ),
      icon = icon,
      body = rlang::list2(
        ...
      ),
      class = class
    ),
    class = "bs_tab_panel"
  )
}

#' Control a tabset from the server
#'
#' @param id Tabset id (namespaced automatically inside modules).
#' @param selected Value of the panel to show.
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' \dontrun{
#' update_bs_tabset("tabs", selected = "profile")
#' }
update_bs_tabset <- function(
  id,
  selected,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "tabset.update",
    id = bs_ns(
      id,
      session
    ),
    selected = as.character(
      selected
    ),
    session = session
  )
}
