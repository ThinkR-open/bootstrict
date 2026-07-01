# Component: buttons --------------------------------------------------------

#' Bootstrap button
#'
#' Renders a Bootstrap 5 button. When `id` is supplied the button is wired as a
#' Shiny action button: `input$id` holds the click count, exactly like
#' [shiny::actionButton()].
#'
#' @param id Optional input id. When set, the click count is reported as
#'   `input$id`.
#' @param label Button label (text or tags). Can also be passed via `...`.
#' @param ... Additional content and named HTML attributes.
#' @param color One of the eight Bootstrap theme colours, or `"link"`.
#' @param outline If `TRUE`, an outline button (`.btn-outline-*`).
#' @param size `"sm"` or `"lg"`.
#' @param disabled If `TRUE`, the button is disabled.
#' @param href Optional URL; renders an `<a>` styled as a button.
#' @param type Button `type` attribute (`"button"`, `"submit"`, `"reset"`).
#' @param class Extra classes.
#'
#' @return A button (or anchor) tag.
#' @export
#'
#' @examples
#' bs_button("go", "Go", color = "primary")
#' bs_button(label = "Cancel", color = "secondary", outline = TRUE)
bs_button <- function(
  id = NULL,
  label = NULL,
  ...,
  color = "primary",
  outline = FALSE,
  size = NULL,
  disabled = FALSE,
  href = NULL,
  type = "button",
  class = NULL
) {
  color <- match_arg(
    color,
    c(
      bs_theme_colors,
      "link"
    ),
    allow_null = FALSE
  )
  size <- match_arg(
    size,
    c(
      "sm",
      "lg"
    )
  )

  variant <- if (
    isTRUE(
      outline
    ) &&
      color !=
        "link"
  ) {
    paste0(
      "btn-outline-",
      color
    )
  } else {
    paste0(
      "btn-",
      color
    )
  }

  classes <- bs_classes(
    "btn",
    variant,
    mod(
      "btn",
      size
    ),
    if (
      !is.null(
        id
      )
    )
      "action-button",
    class
  )

  if (
    !is.null(
      href
    )
  ) {
    htmltools::tags$a(
      id = id,
      class = classes,
      href = href,
      role = "button",
      `aria-disabled` = if (
        isTRUE(
          disabled
        )
      )
        "true",
      label,
      ...
    ) |>
      attach_deps()
  } else {
    htmltools::tags$button(
      id = id,
      class = classes,
      type = type,
      disabled = if (
        isTRUE(
          disabled
        )
      )
        NA else
        NULL,
      label,
      ...
    ) |>
      attach_deps()
  }
}

#' Bootstrap button group / toolbar
#'
#' @param ... Buttons ([bs_button()]) and named HTML attributes.
#' @param size `"sm"` or `"lg"`.
#' @param vertical If `TRUE`, stack vertically (`.btn-group-vertical`).
#' @param label Accessible label (`aria-label`).
#' @param class Extra classes.
#'
#' @return A button group / toolbar tag.
#' @export
#'
#' @examples
#' bs_button_group(bs_button(label = "Left"), bs_button(label = "Right"))
bs_button_group <- function(
  ...,
  size = NULL,
  vertical = FALSE,
  label = NULL,
  class = NULL
) {
  size <- match_arg(
    size,
    c(
      "sm",
      "lg"
    )
  )
  base <- if (
    isTRUE(
      vertical
    )
  )
    "btn-group-vertical" else
    "btn-group"
  attach_deps(htmltools::div(
    class = bs_classes(
      base,
      mod(
        "btn-group",
        size
      ),
      class
    ),
    role = "group",
    `aria-label` = label,
    ...
  ))
}

#' @rdname bs_button_group
#' @export
bs_button_toolbar <- function(
  ...,
  label = NULL,
  class = NULL
) {
  attach_deps(htmltools::div(
    class = bs_classes(
      "btn-toolbar",
      class
    ),
    role = "toolbar",
    `aria-label` = label,
    ...
  ))
}
