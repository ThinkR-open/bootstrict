# Forms: input controls -----------------------------------------------------
#
# Standard controls delegate to shiny's own input functions so that the value
# binding and every `update*()` keep working identically (this is the
# "minimum deviation from Shiny" promise), then layer Bootstrap 5 affordances
# (sizing, help text, switches, ...) on top.

#' Bootstrap text input
#'
#' @param id Input id; value available as `input$id`.
#' @param label Input label.
#' @param value Initial value.
#' @param ... Extra attributes applied to the `<input>` element.
#' @param placeholder Placeholder text.
#' @param size Control size: `"sm"` or `"lg"`.
#' @param help Help text rendered below the control (`.form-text`).
#' @param width CSS width (e.g. `"100%"`, `"200px"`).
#'
#' @return A form control tag.
#' @seealso [shiny::textInput()]
#' @export
#'
#' @examples
#' bs_text_input("name", "Your name", placeholder = "Jane Doe")
bs_text_input <- function(
  id,
  label = NULL,
  value = "",
  ...,
  placeholder = NULL,
  size = NULL,
  help = NULL,
  width = NULL
) {
  ctrl <- shiny::textInput(
    id,
    label,
    value,
    width = width,
    placeholder = placeholder
  )
  ctrl <- enhance_form_control(
    ctrl,
    size = size
  )
  ctrl <- add_control_attribs(
    ctrl,
    ...
  )
  ctrl <- add_form_help(
    ctrl,
    help
  )
  attach_deps(
    ctrl
  )
}

#' Bootstrap textarea input
#'
#' @inheritParams bs_text_input
#' @param rows,cols Visible rows / columns.
#'
#' @return A form control tag.
#' @seealso [shiny::textAreaInput()]
#' @export
bs_textarea_input <- function(
  id,
  label = NULL,
  value = "",
  ...,
  placeholder = NULL,
  rows = NULL,
  cols = NULL,
  size = NULL,
  help = NULL,
  width = NULL
) {
  ctrl <- shiny::textAreaInput(
    id,
    label,
    value,
    width = width,
    placeholder = placeholder,
    rows = rows,
    cols = cols
  )
  ctrl <- enhance_form_control(
    ctrl,
    size = size
  )
  ctrl <- add_control_attribs(
    ctrl,
    ...
  )
  ctrl <- add_form_help(
    ctrl,
    help
  )
  attach_deps(
    ctrl
  )
}

#' Bootstrap numeric input
#'
#' @inheritParams bs_text_input
#' @param min,max,step Numeric bounds and step.
#'
#' @return A form control tag.
#' @seealso [shiny::numericInput()]
#' @export
bs_numeric_input <- function(
  id,
  label = NULL,
  value = NULL,
  ...,
  min = NULL,
  max = NULL,
  step = NULL,
  size = NULL,
  help = NULL,
  width = NULL
) {
  # shiny::numericInput() tests `!is.na(min/max/step)`, which errors on NULL;
  # its own default is NA, so coerce.
  ctrl <- shiny::numericInput(
    id,
    label,
    value,
    min = min %||%
      NA,
    max = max %||%
      NA,
    step = step %||%
      NA,
    width = width
  )
  ctrl <- enhance_form_control(
    ctrl,
    size = size
  )
  ctrl <- add_control_attribs(
    ctrl,
    ...
  )
  ctrl <- add_form_help(
    ctrl,
    help
  )
  attach_deps(
    ctrl
  )
}

#' Bootstrap password input
#'
#' @inheritParams bs_text_input
#'
#' @return A form control tag.
#' @seealso [shiny::passwordInput()]
#' @export
bs_password_input <- function(
  id,
  label = NULL,
  value = "",
  ...,
  size = NULL,
  help = NULL,
  width = NULL
) {
  ctrl <- shiny::passwordInput(
    id,
    label,
    value,
    width = width
  )
  ctrl <- enhance_form_control(
    ctrl,
    size = size
  )
  ctrl <- add_control_attribs(
    ctrl,
    ...
  )
  ctrl <- add_form_help(
    ctrl,
    help
  )
  attach_deps(
    ctrl
  )
}

#' Bootstrap select input
#'
#' Renders a native Bootstrap 5 `<select class="form-select">` (selectize is
#' disabled to stay faithful to the Bootstrap markup).
#'
#' @inheritParams bs_text_input
#' @param choices Named or unnamed vector / list of choices.
#' @param selected Initially selected value(s).
#' @param multiple Allow multiple selection.
#'
#' @return A form control tag.
#' @seealso [shiny::selectInput()]
#' @export
#'
#' @examples
#' bs_select_input("fruit", "Fruit", c("Apple", "Pear"))
bs_select_input <- function(
  id,
  label = NULL,
  choices = NULL,
  selected = NULL,
  ...,
  multiple = FALSE,
  size = NULL,
  help = NULL,
  width = NULL
) {
  ctrl <- shiny::selectInput(
    id,
    label,
    choices = choices,
    selected = selected,
    multiple = multiple,
    selectize = FALSE,
    width = width
  )
  ctrl <- enhance_form_control(
    ctrl,
    size = size,
    select = TRUE
  )
  ctrl <- add_control_attribs(
    ctrl,
    ...
  )
  ctrl <- add_form_help(
    ctrl,
    help
  )
  attach_deps(
    ctrl
  )
}

#' Bootstrap checkbox input
#'
#' @inheritParams bs_text_input
#' @param value Initial checked state.
#' @param switch If `TRUE`, render as a toggle switch (`.form-switch`).
#' @param reverse If `TRUE`, put the label before the control
#'   (`.form-check-reverse`, Bootstrap 5.2).
#'
#' @return A form control tag.
#' @seealso [shiny::checkboxInput()]
#' @export
#'
#' @examples
#' bs_checkbox_input("agree", "I agree", TRUE)
#' bs_checkbox_input("dark", "Dark mode", switch = TRUE)
bs_checkbox_input <- function(
  id,
  label = NULL,
  value = FALSE,
  ...,
  switch = FALSE,
  reverse = FALSE,
  width = NULL
) {
  ctrl <- shiny::checkboxInput(
    id,
    label,
    value,
    width = width
  )

  # Promote shiny's BS3-style checkbox to Bootstrap 5 `.form-check` markup.
  ctrl <- tag_modify_where(
    ctrl,
    function(
      t
    )
      has_class(
        t,
        "checkbox"
      ),
    function(
      t
    ) {
      t$attribs$class <- bs_classes(
        "form-check",
        if (
          isTRUE(
            switch
          )
        )
          "form-switch",
        if (
          isTRUE(
            reverse
          )
        )
          "form-check-reverse"
      )
      t
    }
  )
  ctrl <- tag_modify_where(
    ctrl,
    function(
      t
    )
      has_class(
        t,
        "shiny-input-checkbox"
      ),
    function(
      t
    ) {
      t <- htmltools::tagAppendAttributes(
        t,
        class = "form-check-input"
      )
      if (
        isTRUE(
          switch
        )
      ) {
        t <- htmltools::tagAppendAttributes(
          t,
          role = "switch"
        )
      }
      t
    }
  )
  ctrl <- add_control_attribs(
    ctrl,
    ...
  )
  attach_deps(
    ctrl
  )
}

#' @rdname bs_checkbox_input
#' @export
bs_switch_input <- function(
  id,
  label = NULL,
  value = FALSE,
  ...,
  reverse = FALSE,
  width = NULL
) {
  bs_checkbox_input(
    id,
    label,
    value,
    ...,
    switch = TRUE,
    reverse = reverse,
    width = width
  )
}
