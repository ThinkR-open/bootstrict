# Component: alert ----------------------------------------------------------

#' Bootstrap alert
#'
#' @param ... Alert content and named HTML attributes.
#' @param color Theme colour (`.alert-*`). Defaults to `"primary"`.
#' @param dismissible If `TRUE`, add a close button and fade-out behaviour.
#' @param class Extra classes.
#'
#' @return An alert tag.
#' @export
#'
#' @examples
#' bs_alert("Well done!", color = "success")
#' bs_alert("Heads up.", color = "warning", dismissible = TRUE)
bs_alert <- function(
  ...,
  color = "primary",
  dismissible = FALSE,
  class = NULL
) {
  color <- match_arg(
    color,
    bs_theme_colors,
    allow_null = FALSE
  )
  close_btn <- if (
    isTRUE(
      dismissible
    )
  ) {
    bs_close_button(
      `data-bs-dismiss` = "alert"
    )
  }
  attach_deps(
    htmltools::div(
      class = bs_classes(
        "alert",
        paste0(
          "alert-",
          color
        ),
        if (
          isTRUE(
            dismissible
          )
        )
          c(
            "alert-dismissible",
            "fade",
            "show"
          ),
        class
      ),
      role = "alert",
      ...,
      close_btn
    )
  )
}

#' @rdname bs_alert
#' @param level Heading level (1-6).
#' @export
bs_alert_heading <- function(
  ...,
  level = 4,
  class = NULL
) {
  htmltools::tag(
    paste0(
      "h",
      level
    ),
    list(
      class = bs_classes(
        "alert-heading",
        class
      ),
      ...
    )
  )
}

#' @rdname bs_alert
#' @param href Link target.
#' @export
bs_alert_link <- function(
  ...,
  href = "#",
  class = NULL
) {
  htmltools::tags$a(
    href = href,
    class = bs_classes(
      "alert-link",
      class
    ),
    ...
  )
}

#' Bootstrap close button
#'
#' @param ... Named HTML attributes (e.g. `data-bs-dismiss`).
#' @param label Accessible label.
#' @param white If `TRUE`, the variant for dark backgrounds
#'   (`data-bs-theme="dark"` on the button — the Bootstrap 5.3 idiom;
#'   `.btn-close-white` is deprecated).
#' @param class Extra classes.
#'
#' @return A button tag.
#' @export
bs_close_button <- function(
  ...,
  label = "Close",
  white = FALSE,
  class = NULL
) {
  htmltools::tags$button(
    type = "button",
    class = bs_classes(
      "btn-close",
      class
    ),
    `data-bs-theme` = if (
      isTRUE(
        white
      )
    )
      "dark",
    `aria-label` = label,
    ...
  )
}
