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
    help,
    id = id
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
    help,
    id = id
  )
  attach_deps(
    ctrl
  )
}

#' Validate a `#rrggbb` colour value.
#'
#' `<input type="color">` only accepts 6-digit hex; anything else is silently
#' coerced to `#000000` by the browser, making `input$id` disagree with the R
#' code. Fail loudly instead.
#' @noRd
check_hex_color <- function(
  value,
  arg_nm = rlang::caller_arg(
    value
  )
) {
  if (
    is.null(
      value
    )
  ) {
    return(
      invisible(
        NULL
      )
    )
  }
  ok <- is.character(
    value
  ) &&
    length(
      value
    ) ==
      1L &&
    grepl(
      "^#[0-9a-fA-F]{6}$",
      value
    )
  if (
    !ok
  ) {
    rlang::abort(sprintf(
      "`%s` must be a 6-digit hex colour string such as \"#0d6efd\" (got %s).",
      arg_nm,
      deparse1(
        value
      )
    ))
  }
  invisible(
    value
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
  # A choice group's options are regenerated server-side by shiny's own
  # updaters, in Bootstrap 3 markup. Mark the container so the client can put
  # the Bootstrap 5 classes back, and record the two variants that are not
  # recoverable from the replaced HTML.
  if (
    has_class(
      tag,
      "shiny-input-radiogroup"
    ) ||
      has_class(
        tag,
        "shiny-input-checkboxgroup"
      )
  ) {
    tag <- htmltools::tagAppendAttributes(
      tag,
      `data-bootstrict` = "form-check",
      `data-bootstrict-inline` = if (
        isTRUE(
          inline
        )
      )
        "",
      `data-bootstrict-reverse` = if (
        isTRUE(
          reverse
        )
      )
        ""
    )
  }
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
  # Group label: promote shiny's `.control-label` to also be a Bootstrap
  # `.form-label`, as every other delegated input does.
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
#' @param value Initial value. If `NULL`, the browser initializes the control
#'   at its midpoint (`(min + max) / 2`), which is what `input$id` reports.
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
  value <- shiny::restoreInput(
    id = id,
    default = value
  )
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
    help,
    id = id
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
  value <- shiny::restoreInput(
    id = id,
    default = value
  )
  check_hex_color(
    value
  )
  input <- htmltools::tags$input(
    id = id,
    type = "color",
    class = "form-control form-control-color",
    value = value,
    `data-bootstrict` = "color",
    ...
  )
  ctrl <- htmltools::div(
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
    help,
    id = id
  )
  attach_deps(
    ctrl
  )
}

#' Bootstrap file input
#'
#' Delegates to [shiny::fileInput()] for the upload plumbing, then emits the
#' Bootstrap 5.3 markup: a plain `<input class="form-control" type="file">`.
#'
#' shiny builds the Bootstrap 3 compound widget instead -- a "Browse" button
#' next to a readonly text box showing the file name, with the real input
#' hidden off-screen -- which is not in the Bootstrap 5.3 docs at all. Only
#' shiny's own element is kept, so uploads, the progress bar and
#' `input$id` are unchanged; the browser draws the button and the file name
#' itself, which is what the 5.3 reference relies on.
#'
#' @inheritParams bs_radio_input
#' @param ... Extra attributes applied to the `<input type="file">` element
#'   (e.g. `capture`, `webkitdirectory`).
#' @param multiple Allow selecting more than one file.
#' @param accept Character vector of accepted MIME types / extensions.
#' @param size Control size: `"sm"` or `"lg"`.
#' @param help Help text rendered below the control (`.form-text`).
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
  size = NULL,
  help = NULL,
  width = NULL
) {
  size <- match_arg(
    size,
    c(
      "sm",
      "lg"
    )
  )
  built <- shiny::fileInput(
    id,
    label,
    multiple = multiple,
    accept = accept,
    width = width
  )

  # Keep shiny's own <input type="file"> -- it carries the id, name and the
  # .shiny-input-file class the binding finds -- and its progress bar, which
  # the binding locates by walking up to .form-group. Everything else is the
  # Bootstrap 3 compound widget and goes.
  control <- find_first_tag(
    built,
    function(
      t
    ) {
      identical(
        t$name,
        "input"
      ) &&
        identical(
          htmltools::tagGetAttribute(
            t,
            "type"
          ),
          "file"
        )
    }
  )
  progress <- find_first_tag(
    built,
    function(
      t
    )
      has_class(
        t,
        "shiny-file-input-progress"
      )
  )

  # shiny positions the input off-screen so its Bootstrap 3 button can stand
  # in for it; here the input is the control.
  control$attribs$style <- NULL
  control <- htmltools::tagAppendAttributes(
    control,
    class = bs_classes(
      "form-control",
      mod(
        "form-control",
        size
      )
    )
  )
  control <- add_control_attribs(
    control,
    ...
  )

  # shiny's upload progress bar uses the BS3 animation classes; Bootstrap 5
  # puts stripes and animation on the bar itself (invisible while idle, so
  # they can be set unconditionally).
  progress <- tag_modify_where(
    progress,
    function(
      t
    )
      has_class(
        t,
        "progress-bar"
      ),
    function(
      t
    ) {
      htmltools::tagAppendAttributes(
        t,
        class = "progress-bar-striped progress-bar-animated"
      )
    }
  )

  ctrl <- htmltools::div(
    # `.form-group` is load-bearing: shiny's binding finds the progress bar
    # with closest("div.form-group"). `.shiny-input-container` is not -- its
    # JS never looks for it, and its CSS would cap the control at 300px.
    class = "form-group",
    style = if (
      !is.null(
        width
      )
    ) {
      paste0(
        "width: ",
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
    control,
    progress
  )
  attach_deps(add_form_help(
    ctrl,
    help,
    id = id
  ))
}

#' Bootstrap date input
#'
#' A native `<input type="date">` with the Bootstrap `.form-control` class, as
#' the Bootstrap 5.3 forms reference has it: the browser supplies the calendar.
#'
#' This does **not** delegate to [shiny::dateInput()], which loads
#' `bootstrap-datepicker` -- a third-party stylesheet whose calendar markup
#' (`.datepicker`, `.datepicker-days`, ...) appears nowhere in the Bootstrap
#' documentation and which a designer's SASS sheet cannot reach. The
#' consequence is that `format`, `language`, `weekstart` and `datesdisabled`
#' are gone: the browser owns the presentation, and there is no Bootstrap way
#' to ask it for another. Use [update_bs_date_input()] rather than
#' `shiny::updateDateInput()`.
#'
#' @inheritParams bs_radio_input
#' @param value Initial date (a `Date` or `"yyyy-mm-dd"` string), or `NULL`
#'   for an empty field.
#' @param min,max Earliest / latest selectable date.
#' @param size Control size: `"sm"` or `"lg"`.
#'
#' @return A form control tag.
#' @seealso [update_bs_date_input()], [bs_date_range_input()]
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
  size = NULL,
  help = NULL,
  width = NULL
) {
  check_widget_id(
    id
  )
  # The container carries `id` (the binding reads it there, as it must for a
  # range's two fields), so the field itself gets a derived one for the label.
  ctrl <- date_field(
    id = paste0(
      id,
      "-field"
    ),
    value = value,
    min = min,
    max = max,
    size = size,
    ...
  )
  attach_deps(add_form_help(
    date_container(
      id = id,
      label = label,
      width = width,
      marker = "date",
      ctrl
    ),
    help,
    id = id
  ))
}

#' Bootstrap date range input
#'
#' Two native date fields joined in an `.input-group`, with a separator
#' between them. Bootstrap has no date-range component, so this is the
#' assembly its docs prescribe; see [bs_date_input()] for why neither field
#' delegates to shiny.
#'
#' @inheritParams bs_date_input
#' @param start,end Initial start / end dates.
#' @param separator Text shown between the two fields, in an
#'   `.input-group-text`.
#'
#' @return A form control tag. `input$id` is a length-2 `Date`.
#' @seealso [update_bs_date_range_input()], [bs_date_input()]
#' @export
#'
#' @examples
#' bs_date_range_input("range", "Period", start = "2026-01-01")
bs_date_range_input <- function(
  id,
  label = NULL,
  start = NULL,
  end = NULL,
  ...,
  min = NULL,
  max = NULL,
  separator = "to",
  size = NULL,
  help = NULL,
  width = NULL
) {
  check_widget_id(
    id
  )
  group <- htmltools::div(
    class = bs_classes(
      "input-group",
      mod(
        "input-group",
        size
      )
    ),
    date_field(
      id = paste0(
        id,
        "-start"
      ),
      value = start,
      min = min,
      max = max,
      size = size,
      `aria-label` = "Start date",
      ...
    ),
    htmltools::tags$span(
      class = "input-group-text",
      separator
    ),
    date_field(
      id = paste0(
        id,
        "-end"
      ),
      value = end,
      min = min,
      max = max,
      size = size,
      `aria-label` = "End date",
      ...
    )
  )
  attach_deps(add_form_help(
    date_container(
      id = id,
      label = label,
      width = width,
      marker = "date-range",
      group
    ),
    help,
    id = id
  ))
}

#' One `<input type="date">`.
#' @noRd
date_field <- function(
  id,
  value,
  min,
  max,
  size,
  ...
) {
  htmltools::tags$input(
    id = id,
    type = "date",
    class = bs_classes(
      "form-control",
      mod(
        "form-control",
        size
      )
    ),
    value = date_attr(
      value,
      "value"
    ),
    min = date_attr(
      min,
      "min"
    ),
    max = date_attr(
      max,
      "max"
    ),
    ...
  )
}

#' The wrapper carrying the id the binding reports under.
#'
#' The `<input>` of a range cannot carry it (there are two), so the marker and
#' the id live on the container for both, which keeps one binding.
#' @noRd
date_container <- function(
  id,
  label,
  width,
  marker,
  ...
) {
  htmltools::div(
    id = id,
    `data-bootstrict` = marker,
    style = if (
      !is.null(
        width
      )
    ) {
      paste0(
        "width: ",
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
        `for` = if (
          identical(
            marker,
            "date"
          )
        )
          paste0(
            id,
            "-field"
          ),
        id = paste0(
          id,
          "-label"
        ),
        label
      )
    },
    ...
  )
}

#' Coerce a date argument to the `yyyy-mm-dd` an `<input type="date">` takes.
#' @noRd
date_attr <- function(
  x,
  arg_nm
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
  parsed <- tryCatch(
    as.Date(
      x
    ),
    error = function(
      e
    )
      NA
  )
  if (
    length(
      parsed
    ) !=
      1L ||
      is.na(
        parsed
      )
  ) {
    rlang::abort(sprintf(
      "`%s` must be a single date, as a `Date` or a \"yyyy-mm-dd\" string.",
      arg_nm
    ))
  }
  format(
    parsed,
    "%Y-%m-%d"
  )
}

#' Set a date input from the server
#'
#' The native counterpart of `shiny::updateDateInput()`, which cannot reach
#' these controls.
#'
#' @param id Input id.
#' @param value New date, or `NA` to clear the field.
#' @param min,max New bounds.
#' @param session The Shiny session.
#'
#' @return Nothing, called for its side effect.
#' @seealso [bs_date_input()]
#' @export
#'
#' @examples
#' if (interactive()) update_bs_date_input("day", value = Sys.Date())
update_bs_date_input <- function(
  id,
  value = NULL,
  min = NULL,
  max = NULL,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "date.update",
    id = bs_ns(
      id,
      session
    ),
    value = date_message(
      value
    ),
    min = date_attr(
      min,
      "min"
    ),
    max = date_attr(
      max,
      "max"
    ),
    session = session
  )
}

#' @rdname update_bs_date_input
#' @param start,end New start / end dates, or `NA` to clear either field.
#' @export
update_bs_date_range_input <- function(
  id,
  start = NULL,
  end = NULL,
  min = NULL,
  max = NULL,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "daterange.update",
    id = bs_ns(
      id,
      session
    ),
    start = date_message(
      start
    ),
    end = date_message(
      end
    ),
    min = date_attr(
      min,
      "min"
    ),
    max = date_attr(
      max,
      "max"
    ),
    session = session
  )
}

#' A date for a server message: `NA` clears the field, `NULL` leaves it alone.
#' @noRd
date_message <- function(
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
    length(
      x
    ) ==
      1L &&
      is.na(
        x
      )
  ) {
    return(
      ""
    )
  }
  date_attr(
    x,
    "value"
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
  check_hex_color(
    value
  )
  session$sendInputMessage(
    id,
    list(
      value = value
    )
  )
  invisible()
}

# Toggle buttons (.btn-check) -----------------------------------------------
#
# Bootstrap's segmented controls are not the `.form-check` markup with a
# different skin: the `<input class="btn-check">` is a *sibling* of its
# `<label class="btn">` (the CSS is `.btn-check:checked + .btn`), there is no
# wrapper around the pair, and `autocomplete="off"` is required. That cannot
# come out of shiny's generateOptions(), so these are native controls with
# their own binding, like bs_range_input() and bs_color_input().

#' Bootstrap toggle button groups
#'
#' The segmented control from the Bootstrap "Button group" page: a row of
#' buttons backed by hidden radio or checkbox inputs (`.btn-check`).
#' `bs_radio_button_input()` picks one value, `bs_checkbox_button_input()` picks
#' any number.
#'
#' These are native controls, not restyled shiny inputs, so drive them with
#' [update_bs_toggle_buttons()] rather than `shiny::updateRadioButtons()`.
#'
#' @param id Input id; the selection is available as `input$id` (a single
#'   string for radio buttons, a character vector — possibly empty — for
#'   checkboxes).
#' @param label Label shown above the group, or `NULL` for none.
#' @param choices Character vector of values. Names, when present, are used as
#'   the button labels.
#' @param selected Initially selected value(s). Defaults to the first choice
#'   for radio buttons and to none for checkboxes.
#' @param ... Named HTML attributes applied to the `.btn-group`.
#' @param color Button theme colour.
#' @param outline If `TRUE` (the default, as in the Bootstrap examples),
#'   outline buttons (`.btn-outline-*`).
#' @param size Button size: `"sm"` or `"lg"`.
#' @param vertical If `TRUE`, stack the buttons (`.btn-group-vertical`).
#' @param class Extra classes for the `.btn-group`.
#'
#' @return A form control tag.
#' @seealso [update_bs_toggle_buttons()], [bs_button_group()]
#' @export
#'
#' @examples
#' bs_radio_button_input("size", "Size", c(Small = "s", Large = "l"))
#' bs_checkbox_button_input("opts", "Options", c("a", "b"))
bs_radio_button_input <- function(
  id,
  label = NULL,
  choices,
  selected = NULL,
  ...,
  color = "primary",
  outline = TRUE,
  size = NULL,
  vertical = FALSE,
  class = NULL
) {
  toggle_buttons(
    id = id,
    label = label,
    choices = choices,
    selected = selected %||%
      choices[[
        1
      ]],
    type = "radio",
    color = color,
    outline = outline,
    size = size,
    vertical = vertical,
    class = class,
    ...
  )
}

#' @rdname bs_radio_button_input
#' @export
bs_checkbox_button_input <- function(
  id,
  label = NULL,
  choices,
  selected = NULL,
  ...,
  color = "primary",
  outline = TRUE,
  size = NULL,
  vertical = FALSE,
  class = NULL
) {
  toggle_buttons(
    id = id,
    label = label,
    choices = choices,
    selected = selected,
    type = "checkbox",
    color = color,
    outline = outline,
    size = size,
    vertical = vertical,
    class = class,
    ...
  )
}

#' Build the shared `.btn-check` markup.
#' @noRd
toggle_buttons <- function(
  id,
  label,
  choices,
  selected,
  type,
  color,
  outline,
  size,
  vertical,
  class,
  ...
) {
  if (
    !is.character(
      id
    ) ||
      length(
        id
      ) !=
        1L ||
      !nzchar(
        id
      )
  ) {
    rlang::abort(
      "`id` must be a single non-empty string."
    )
  }
  color <- check_color(
    color,
    arg_nm = "color"
  )
  size <- match_arg(
    size,
    c(
      "sm",
      "lg"
    )
  )
  values <- as.character(
    choices
  )
  labels <- names(
    choices
  ) %||%
    values
  labels[
    !nzchar(
      labels
    )
  ] <- values[
    !nzchar(
      labels
    )
  ]
  if (
    !length(
      values
    )
  ) {
    rlang::abort(
      "`choices` must contain at least one value."
    )
  }
  selected <- as.character(
    selected %||%
      character()
  )
  unknown <- setdiff(
    selected,
    values
  )
  if (
    length(
      unknown
    )
  ) {
    rlang::abort(sprintf(
      "`selected` must be one of the `choices`; %s is not.",
      paste0(
        "\"",
        unknown[[
          1
        ]],
        "\""
      )
    ))
  }
  if (
    identical(
      type,
      "radio"
    )
  ) {
    selected <- selected[seq_len(min(
      1L,
      length(
        selected
      )
    ))]
  }

  variant <- if (
    isTRUE(
      outline
    )
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
  label_id <- if (
    !is.null(
      label
    )
  )
    paste0(
      id,
      "-label"
    )

  buttons <- lapply(
    seq_along(
      values
    ),
    function(
      i
    ) {
      button_id <- paste0(
        id,
        "-",
        i
      )
      list(
        htmltools::tags$input(
          type = type,
          class = "btn-check",
          name = id,
          id = button_id,
          value = values[[
            i
          ]],
          # Required by Bootstrap: without it a browser can restore a stale
          # checked state on reload and desynchronise the buttons.
          autocomplete = "off",
          checked = if (
            values[[
              i
            ]] %in%
              selected
          )
            NA
        ),
        htmltools::tags$label(
          class = bs_classes(
            "btn",
            variant,
            mod(
              "btn",
              size
            )
          ),
          `for` = button_id,
          labels[[
            i
          ]]
        )
      )
    }
  )

  group <- htmltools::div(
    class = bs_classes(
      if (
        isTRUE(
          vertical
        )
      )
        "btn-group-vertical" else
        "btn-group",
      class
    ),
    role = "group",
    `aria-labelledby` = label_id,
    `aria-label` = if (
      is.null(
        label_id
      )
    )
      "Toggle buttons",
    ...,
    buttons
  )

  attach_deps(htmltools::div(
    id = id,
    `data-bootstrict` = "toggle-buttons",
    `data-bootstrict-type` = type,
    if (
      !is.null(
        label
      )
    ) {
      htmltools::tags$label(
        class = "form-label",
        id = label_id,
        label
      )
    },
    group
  ))
}

#' Set the selection of a toggle button group from the server
#'
#' Drives a [bs_radio_button_input()] or [bs_checkbox_button_input()]. Pass
#' `character(0)` to clear a checkbox group.
#'
#' @param id Input id.
#' @param selected Value(s) to select. A radio group keeps only the first.
#' @param session The Shiny session.
#'
#' @return Nothing, called for its side effect.
#' @seealso [bs_radio_button_input()]
#' @export
#'
#' @examples
#' if (interactive()) update_bs_toggle_buttons("size", selected = "l")
update_bs_toggle_buttons <- function(
  id,
  selected = NULL,
  session = shiny::getDefaultReactiveDomain()
) {
  bs_send(
    "togglebuttons.update",
    id = bs_ns(
      id,
      session
    ),
    # An empty selection has to survive as [] rather than vanish from the
    # payload, so it is sent as an explicit flag.
    selected = if (
      length(
        selected
      )
    )
      as.character(
        selected
      ),
    clear = if (
      !is.null(
        selected
      ) &&
        !length(
          selected
        )
    )
      TRUE,
    session = session
  )
}
