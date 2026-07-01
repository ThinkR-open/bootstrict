# Forms: layout helpers -----------------------------------------------------
#
# Structural pieces that arrange and decorate form controls: input groups,
# the <form> element itself, labels, help/validation text, and Bootstrap 5
# floating labels. These compose with the controls in R/forms.R.

#' Bootstrap input group
#'
#' Groups one or more form controls together with add-ons (text, buttons,
#' dropdowns) on a single line.
#'
#' @param ... Controls and add-ons (e.g. [bs_input_group_text()],
#'   [bs_text_input()], [bs_button()]) and named HTML attributes.
#' @param size Control size: `"sm"` or `"lg"`.
#' @param class Extra classes.
#'
#' @return An input-group tag.
#' @export
#'
#' @examples
#' bs_input_group(
#'   bs_input_group_text("@"),
#'   bs_text_input("user", placeholder = "Username")
#' )
bs_input_group <- function(
  ...,
  size = NULL,
  class = NULL
) {
  size <- match_arg(
    size,
    c(
      "sm",
      "lg"
    )
  )
  # Bootstrap needs the bare control (.form-control/.form-select) as a direct
  # child of .input-group so it sits flush with the add-ons. bootstrict inputs
  # return a `.shiny-input-container` wrapper, so unwrap those to the inner
  # control (its id keeps the Shiny binding + value updates working).
  parts <- lapply(
    rlang::list2(
      ...
    ),
    ig_unwrap_control
  )
  group <- do.call(
    htmltools::div,
    c(
      list(
        class = bs_classes(
          "input-group",
          mod(
            "input-group",
            size
          ),
          class
        )
      ),
      parts
    )
  )
  attach_deps(
    group
  )
}

#' Unwrap a shiny-input-container to its bare Bootstrap control for input groups.
#' @noRd
ig_unwrap_control <- function(
  x
) {
  if (
    !inherits(
      x,
      "shiny.tag"
    )
  ) {
    return(
      x
    )
  }
  if (
    !tag_contains(
      x,
      function(
        t
      )
        has_class(
          t,
          "shiny-input-container"
        )
    )
  ) {
    return(
      x
    )
  }
  ctrl <- find_first_tag(
    x,
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
        identical(
          t$name,
          "textarea"
        ) ||
        has_class(
          t,
          "form-check-input"
        )
    }
  )
  ctrl %||%
    x
}

#' @rdname bs_input_group
#' @export
bs_input_group_text <- function(
  ...,
  class = NULL
) {
  htmltools::tags$span(
    class = bs_classes(
      "input-group-text",
      class
    ),
    ...
  )
}

#' Bootstrap form element
#'
#' A plain `<form>` container for grouping form controls.
#'
#' @param ... Form content (controls, layout, buttons) and named HTML
#'   attributes.
#' @param novalidate If `TRUE`, add the `novalidate` attribute to disable the
#'   browser's native validation UI (useful with custom validation feedback).
#' @param class Extra classes.
#'
#' @return A form tag.
#' @export
#'
#' @examples
#' bs_form(
#'   bs_text_input("email", "Email"),
#'   bs_button("Submit", color = "primary")
#' )
bs_form <- function(
  ...,
  novalidate = FALSE,
  class = NULL
) {
  attach_deps(htmltools::tags$form(
    class = bs_classes(
      class
    ),
    novalidate = if (
      isTRUE(
        novalidate
      )
    )
      NA else
      NULL,
    ...
  ))
}

#' Bootstrap form label
#'
#' A `<label class="form-label">` tied to a control via its `for` attribute.
#'
#' @param for_id The id of the control this label describes (rendered as the
#'   `for` attribute).
#' @param ... Label content and named HTML attributes.
#' @param class Extra classes.
#'
#' @return A label tag.
#' @export
#'
#' @examples
#' bs_form_label("email", "Email address")
bs_form_label <- function(
  for_id,
  ...,
  class = NULL
) {
  htmltools::tags$label(
    class = bs_classes(
      "form-label",
      class
    ),
    `for` = for_id,
    ...
  )
}

#' Bootstrap form help text
#'
#' Muted helper text rendered below a control (`.form-text`).
#'
#' @param ... Help content and named HTML attributes.
#' @param class Extra classes.
#'
#' @return A div tag.
#' @export
#'
#' @examples
#' bs_form_text("Must be 8-20 characters long.")
bs_form_text <- function(
  ...,
  class = NULL
) {
  htmltools::div(
    class = bs_classes(
      "form-text",
      class
    ),
    ...
  )
}

#' Bootstrap validation feedback
#'
#' Inline messages shown next to a control to convey its validation state.
#' `bs_valid_feedback()` renders `.valid-feedback`; `bs_invalid_feedback()`
#' renders `.invalid-feedback`.
#'
#' @param ... Feedback content and named HTML attributes.
#' @param class Extra classes.
#'
#' @return A div tag.
#' @export
#'
#' @examples
#' bs_valid_feedback("Looks good!")
#' bs_invalid_feedback("Please choose a username.")
bs_valid_feedback <- function(
  ...,
  class = NULL
) {
  htmltools::div(
    class = bs_classes(
      "valid-feedback",
      class
    ),
    ...
  )
}

#' @rdname bs_valid_feedback
#' @export
bs_invalid_feedback <- function(
  ...,
  class = NULL
) {
  htmltools::div(
    class = bs_classes(
      "invalid-feedback",
      class
    ),
    ...
  )
}

#' Bootstrap floating label
#'
#' Reshape a control built by one of the `bs_*_input()` constructors (e.g.
#' [bs_text_input()], [bs_select_input()]) into a Bootstrap 5 floating-label
#' group, where the label animates into the control's border. The existing
#' control and its Shiny input wiring are preserved (the element is moved, not
#' rebuilt), so the value still reports as `input$id`.
#'
#' @param input A control tag tree produced by a `bs_*_input()` constructor.
#' @param label Floating label text. If `NULL`, the control's existing label
#'   text is reused.
#' @param class Extra classes.
#'
#' @return A `.form-floating` wrapper tag.
#' @export
#'
#' @examples
#' bs_floating_label(bs_text_input("email", "Email address"))
bs_floating_label <- function(
  input,
  label = NULL,
  class = NULL
) {
  # Locate the inner control (.form-control or .form-select) and pull it out so
  # it can become a *direct* child of the floating wrapper (a requirement of
  # Bootstrap floating labels).
  ctrl <- find_form_control(
    input
  )
  if (
    is.null(
      ctrl
    )
  ) {
    rlang::abort(
      "`input` must contain a `.form-control` or `.form-select` element."
    )
  }

  # Floating labels need a placeholder on the control for the CSS to animate.
  if (
    is.null(
      ctrl$attribs$placeholder
    )
  ) {
    ctrl <- htmltools::tagAppendAttributes(
      ctrl,
      placeholder = " "
    )
  }

  ctrl_id <- ctrl$attribs$id

  # Reuse the control's existing label text when none is supplied.
  if (
    is.null(
      label
    )
  ) {
    label <- find_label_text(
      input
    )
  }

  label_tag <- htmltools::tags$label(
    `for` = ctrl_id,
    label
  )

  attach_deps(htmltools::div(
    class = bs_classes(
      "form-floating",
      class
    ),
    ctrl,
    label_tag
  ))
}

# --- private helpers (unique to this file) ---------------------------------

#' Find the first `.form-control`/`.form-select` element in a tag tree.
#' @noRd
find_form_control <- function(
  x
) {
  if (
    inherits(
      x,
      "shiny.tag"
    )
  ) {
    if (
      has_class(
        x,
        "form-control"
      ) ||
        has_class(
          x,
          "form-select"
        )
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
      hit <- find_form_control(
        x$children
      )
      if (
        !is.null(
          hit
        )
      )
        return(
          hit
        )
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
      is.list(
        x
      )
  ) {
    for (child in x) {
      hit <- find_form_control(
        child
      )
      if (
        !is.null(
          hit
        )
      )
        return(
          hit
        )
    }
  }
  NULL
}

#' Extract the text content of the first `.control-label`/`.form-label`.
#' @noRd
find_label_text <- function(
  x
) {
  if (
    inherits(
      x,
      "shiny.tag"
    )
  ) {
    if (
      has_class(
        x,
        "control-label"
      ) ||
        has_class(
          x,
          "form-label"
        )
    ) {
      return(
        x$children
      )
    }
    if (
      !is.null(
        x$children
      )
    ) {
      hit <- find_label_text(
        x$children
      )
      if (
        !is.null(
          hit
        )
      )
        return(
          hit
        )
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
      is.list(
        x
      )
  ) {
    for (child in x) {
      hit <- find_label_text(
        child
      )
      if (
        !is.null(
          hit
        )
      )
        return(
          hit
        )
    }
  }
  NULL
}
