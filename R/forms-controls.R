# Forms: choice, range, colour, file & date controls -----------------------
#
# As with `R/forms.R`, the standard controls delegate to shiny's own input
# functions (keeping the value binding and every `update*()` intact) and then
# enhance the markup to Bootstrap 5 `.form-check` / `.form-control` shape.
# `bs_range_input()` and `bs_color_input()` have no shiny equivalent and are
# built natively with their own bindings (see `inst/assets/js/binding-range.js`
# and `binding-color.js`); their server-side `update_*()` helpers go through
# `session$sendInputMessage()` so the binding's `receiveMessage` handles them.

#' Bootstrap radio button group
#'
#' Delegates to [shiny::radioButtons()] and rewrites the markup to Bootstrap 5
#' `.form-check` shape so the value stays available as `input$id`.
#'
#' @param id Input id; selected value available as `input$id`.
#' @param label Input label.
#' @param choices Named or unnamed vector / list of choices.
#' @param selected Initially selected value.
#' @param ... Extra attributes applied to each radio `<input>`.
#' @param inline If `TRUE`, lay the choices out horizontally.
#' @param reverse If `TRUE`, put the label before the control
#'   (`.form-check-reverse`, Bootstrap 5.2).
#' @param help Help text rendered below the control (`.form-text`).
#' @param width CSS width (e.g. `"100%"`, `"200px"`).
#'
#' @return A form control tag.
#' @seealso [shiny::radioButtons()]
#' @export
#'
#' @examples
#' bs_radio_input("size", "Size", c("S", "M", "L"), selected = "M")
bs_radio_input <- function(
  id,
  label = NULL,
  choices,
  selected = NULL,
  ...,
  inline = FALSE,
  reverse = FALSE,
  help = NULL,
  width = NULL
) {
  ctrl <- shiny::radioButtons(
    id,
    label,
    choices = choices,
    selected = selected,
    inline = inline,
    width = width
  )
  ctrl <- form_check_enhance(
    ctrl,
    inline = inline,
    reverse = reverse
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

#' Bootstrap checkbox group
#'
#' Delegates to [shiny::checkboxGroupInput()] and rewrites the markup to
#' Bootstrap 5 `.form-check` shape so the value stays available as `input$id`.
#'
#' @inheritParams bs_radio_input
#' @param selected Initially selected value(s).
#'
#' @return A form control tag.
#' @seealso [shiny::checkboxGroupInput()]
#' @export
#'
#' @examples
#' bs_checkbox_group_input("opts", "Options", c("A", "B", "C"), selected = "A")
bs_checkbox_group_input <- function(
  id,
  label = NULL,
  choices,
  selected = NULL,
  ...,
  inline = FALSE,
  reverse = FALSE,
  help = NULL,
  width = NULL
) {
  ctrl <- shiny::checkboxGroupInput(
    id,
    label,
    choices = choices,
    selected = selected,
    inline = inline,
    width = width
  )
  ctrl <- form_check_enhance(
    ctrl,
    inline = inline,
    reverse = reverse
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

#' Rewrite a shiny choice group to Bootstrap 5 `.form-check` markup.
#'
#' shiny renders each option as a `<div class="radio">`/`<div class="checkbox">`
#' (or the `*-inline` variant) wrapping a `<label>` that itself contains the
#' `<input>`. We promote those wrappers/inputs/labels to the Bootstrap 5 class
#' names while leaving shiny's `radiogroup`/`checkboxgroup` binding untouched.
#' @noRd
form_check_enhance <- function(
  tag,
  inline = FALSE,
  reverse = FALSE
) {
  # Wrappers: .radio / .checkbox (and their -inline variants) -> .form-check.
  tag <- tag_modify_where(
    tag,
    function(
      t
    ) {
      has_class(
        t,
        "radio"
      ) ||
        has_class(
          t,
          "radio-inline"
        ) ||
        has_class(
          t,
          "checkbox"
        ) ||
        has_class(
          t,
          "checkbox-inline"
        )
    },
    function(
      t
    ) {
      is_inline <- isTRUE(
        inline
      ) ||
        has_class(
          t,
          "radio-inline"
        ) ||
        has_class(
          t,
          "checkbox-inline"
        )
      keep <- setdiff(
        unlist(strsplit(
          paste(
            unlist(
              t$attribs$class
            ),
            collapse = " "
          ),
          "\\s+"
        )),
        c(
          "radio",
          "radio-inline",
          "checkbox",
          "checkbox-inline"
        )
      )
      t$attribs$class <- bs_classes(
        "form-check",
        if (
          is_inline
        )
          "form-check-inline",
        if (
          isTRUE(
            reverse
          )
        )
          "form-check-reverse",
        keep
      )
      t
    }
  )
  # Radio / checkbox inputs -> .form-check-input.
  tag <- tag_modify_where(
    tag,
    function(
      t
    ) {
      identical(
        t$name,
        "input"
      ) &&
        (identical(
          unname(
            t$attribs$type
          ),
          "radio"
        ) ||
          identical(
            unname(
              t$attribs$type
            ),
            "checkbox"
          ))
    },
    function(
      t
    )
      htmltools::tagAppendAttributes(
        t,
        class = "form-check-input"
      )
  )
  # Per-option labels -> .form-check-label. Skip the group's .control-label and
  # any `<label>` that has already become an inline `.form-check` wrapper (shiny
  # renders inline options as a bare `<label class="*-inline">` with no inner
  # label, so the wrapper and the check-label are the same element there).
  tag <- tag_modify_where(
    tag,
    function(
      t
    ) {
      identical(
        t$name,
        "label"
      ) &&
        !has_class(
          t,
          "control-label"
        ) &&
        !has_class(
          t,
          "form-label"
        ) &&
        !has_class(
          t,
          "form-check"
        )
    },
    function(
      t
    )
      htmltools::tagAppendAttributes(
        t,
        class = "form-check-label"
      )
  )
  tag
}

#' Bootstrap range (slider) input
#'
#' A native `<input type="range" class="form-range">` whose value is reported to
#' the server as `input$id`. Drive it server-side with [update_bs_range()].
#'
#' @param id Input id; value available as `input$id`.
#' @param label Input label.
#' @param value Initial value.
#' @param min,max,step Numeric bounds and step.
#' @param ... Extra attributes applied to the `<input>` element.
#' @param help Help text rendered below the control (`.form-text`).
#' @param width CSS width (e.g. `"100%"`, `"200px"`).
#'
#' @return A form control tag.
#' @export
#'
#' @examples
#' bs_range_input("vol", "Volume", value = 50, min = 0, max = 100)
bs_range_input <- function(
  id,
  label = NULL,
  value = NULL,
  min = 0,
  max = 100,
  step = NULL,
  ...,
  help = NULL,
  width = NULL
) {
  input <- htmltools::tags$input(
    id = id,
    type = "range",
    class = "form-range",
    min = min,
    max = max,
    step = step,
    value = value,
    `data-bootstrict` = "range",
    ...
  )
  ctrl <- htmltools::div(
    class = "shiny-input-container form-group",
    style = if (
      !is.null(
        width
      )
    ) {
      paste0(
        "width:",
        htmltools::validateCssUnit(
          width
        ),
        ";"
      )
    },
    if (
      !is.null(
        label
      )
    ) {
      htmltools::tags$label(
        class = "form-label",
        `for` = id,
        id = paste0(
          id,
          "-label"
        ),
        label
      )
    },
    input
  )
  ctrl <- add_form_help(
    ctrl,
    help
  )
  attach_deps(
    ctrl
  )
}

#' Bootstrap colour input
#'
#' A native `<input type="color" class="form-control form-control-color">` whose
#' value (a `"#rrggbb"` string) is reported as `input$id`. Drive it server-side
#' with [update_bs_color()].
#'
#' @inheritParams bs_range_input
#' @param value Initial colour as a hex string (e.g. `"#0d6efd"`).
#'
#' @return A form control tag.
#' @export
#'
#' @examples
#' bs_color_input("col", "Pick a colour", value = "#0d6efd")
bs_color_input <- function(
  id,
  label = NULL,
  value = "#000000",
  ...,
  help = NULL,
  width = NULL
) {
  input <- htmltools::tags$input(
    id = id,
    type = "color",
    class = "form-control form-control-color",
    value = value,
    `data-bootstrict` = "color",
    ...
  )
  ctrl <- htmltools::div(
    class = "shiny-input-container form-group",
    style = if (
      !is.null(
        width
      )
    ) {
      paste0(
        "width:",
        htmltools::validateCssUnit(
          width
        ),
        ";"
      )
    },
    if (
      !is.null(
        label
      )
    ) {
      htmltools::tags$label(
        class = "form-label",
        `for` = id,
        id = paste0(
          id,
          "-label"
        ),
        label
      )
    },
    input
  )
  ctrl <- add_form_help(
    ctrl,
    help
  )
  attach_deps(
    ctrl
  )
}

#' Bootstrap file input
#'
#' Delegates to [shiny::fileInput()] and adapts its markup to Bootstrap 5.
#'
#' shiny hides the real `<input type="file">` off-screen (`top: -99999px`) and
#' relies on Bootstrap 3 `.btn-file` CSS to bring it back over the browse
#' button. That CSS is absent under Bootstrap 5, so clicking the button focuses
#' the off-screen input and the browser scrolls the page to the top. We fix this
#' by overlaying the input on the button (invisible, `opacity: 0`) so a click
#' lands on it directly, and restyle the browse button as a real Bootstrap 5
#' button.
#'
#' @inheritParams bs_radio_input
#' @param multiple Allow selecting more than one file.
#' @param accept Character vector of accepted MIME types / extensions.
#' @param button_label Label shown on the browse button.
#' @param placeholder Placeholder text shown before a file is chosen.
#'
#' @return A form control tag.
#' @seealso [shiny::fileInput()]
#' @export
#'
#' @examples
#' bs_file_input("upload", "Upload a file", accept = ".csv")
bs_file_input <- function(
  id,
  label = NULL,
  ...,
  multiple = FALSE,
  accept = NULL,
  button_label = "Browse...",
  placeholder = "No file selected",
  width = NULL
) {
  ctrl <- shiny::fileInput(
    id,
    label,
    multiple = multiple,
    accept = accept,
    width = width,
    buttonLabel = button_label,
    placeholder = placeholder
  )

  # Overlay the file <input> on its button instead of shiny's off-screen
  # position (the cause of the scroll-to-top). Replacing the inline style is the
  # only way to win against shiny's inline `!important`.
  ctrl <- tag_modify_where(
    ctrl,
    function(
      t
    ) {
      identical(
        t$name,
        "input"
      ) &&
        identical(
          unname(
            t$attribs$type
          ),
          "file"
        )
    },
    function(
      t
    ) {
      t$attribs[
        names(
          t$attribs
        ) ==
          "style"
      ] <- NULL
      htmltools::tagAppendAttributes(
        t,
        style = paste(
          "position:absolute;top:0;left:0;width:100%;height:100%;",
          "margin:0;padding:0;opacity:0;cursor:pointer;"
        )
      )
    }
  )

  # Browse button: BS3 `.btn-default` has no styling under BS5 -> use a real one.
  ctrl <- tag_modify_where(
    ctrl,
    function(
      t
    )
      has_class(
        t,
        "btn-default"
      ),
    function(
      t
    ) {
      keep <- setdiff(
        unlist(strsplit(
          paste(
            unlist(
              t$attribs$class
            ),
            collapse = " "
          ),
          "\\s+"
        )),
        "btn-default"
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
          keep,
          "btn-secondary"
        )
      )
    }
  )

  ctrl <- tag_modify_where(
    ctrl,
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
  ctrl <- add_control_attribs(
    ctrl,
    ...
  )
  attach_deps(
    ctrl
  )
}

#' Bootstrap date input
#'
#' Delegates to [shiny::dateInput()] and adds the Bootstrap `.form-label` /
#' `.form-control` affordances.
#'
#' @inheritParams bs_radio_input
#' @param value Initial date (a `Date` or `"yyyy-mm-dd"` string).
#' @param min,max Minimum / maximum selectable date.
#'
#' @return A form control tag.
#' @seealso [shiny::dateInput()]
#' @export
#'
#' @examples
#' bs_date_input("day", "Pick a day", value = "2026-06-26")
bs_date_input <- function(
  id,
  label = NULL,
  value = NULL,
  ...,
  min = NULL,
  max = NULL,
  width = NULL
) {
  ctrl <- shiny::dateInput(
    id,
    label,
    value = value,
    min = min,
    max = max,
    width = width
  )
  ctrl <- enhance_form_control(
    ctrl
  )
  ctrl <- add_control_attribs(
    ctrl,
    ...
  )
  attach_deps(
    ctrl
  )
}

#' Bootstrap date range input
#'
#' Delegates to [shiny::dateRangeInput()] and adds the Bootstrap `.form-label` /
#' `.form-control` affordances.
#'
#' @inheritParams bs_date_input
#' @param start,end Initial start / end dates.
#'
#' @return A form control tag.
#' @seealso [shiny::dateRangeInput()]
#' @export
#'
#' @examples
#' bs_date_range_input("range", "Period", start = "2026-01-01", end = "2026-12-31")
bs_date_range_input <- function(
  id,
  label = NULL,
  start = NULL,
  end = NULL,
  ...,
  min = NULL,
  max = NULL,
  width = NULL
) {
  ctrl <- shiny::dateRangeInput(
    id,
    label,
    start = start,
    end = end,
    min = min,
    max = max,
    width = width
  )
  ctrl <- enhance_form_control(
    ctrl
  )
  ctrl <- add_control_attribs(
    ctrl,
    ...
  )
  attach_deps(
    ctrl
  )
}

#' Update a range input from the server
#'
#' Routes through [shiny::session]'s `sendInputMessage()` so the range binding's
#' `receiveMessage` updates the slider (the "shiny-like" update path).
#'
#' @param id Range input id (namespaced automatically inside modules).
#' @param value New value.
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' if (interactive()) update_bs_range("vol", 75)
update_bs_range <- function(
  id,
  value,
  session = shiny::getDefaultReactiveDomain()
) {
  if (
    is.null(
      session
    )
  ) {
    rlang::abort(
      "This function must be called from within a Shiny session."
    )
  }
  session$sendInputMessage(
    id,
    list(
      value = value
    )
  )
  invisible()
}

#' Update a colour input from the server
#'
#' Routes through [shiny::session]'s `sendInputMessage()` so the colour binding's
#' `receiveMessage` updates the swatch.
#'
#' @param id Colour input id (namespaced automatically inside modules).
#' @param value New colour as a hex string (e.g. `"#0d6efd"`).
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' if (interactive()) update_bs_color("col", "#198754")
update_bs_color <- function(
  id,
  value,
  session = shiny::getDefaultReactiveDomain()
) {
  if (
    is.null(
      session
    )
  ) {
    rlang::abort(
      "This function must be called from within a Shiny session."
    )
  }
  session$sendInputMessage(
    id,
    list(
      value = value
    )
  )
  invisible()
}
