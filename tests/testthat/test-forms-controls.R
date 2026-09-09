test_that("bs_radio_input renders Bootstrap form-check markup", {
  html <- as.character(
    bs_radio_input(
      "size",
      "Size",
      c(
        "S",
        "M",
        "L"
      ),
      selected = "M"
    )
  )
  expect_match(
    html,
    "form-check"
  )
  expect_match(
    html,
    "form-check-input"
  )
  expect_match(
    html,
    "form-check-label"
  )
  expect_match(
    html,
    "type=\"radio\""
  )
  # shiny's radiogroup binding must survive the enhancement.
  expect_match(
    html,
    "shiny-options-group"
  )
})

test_that("bs_radio_input inline adds form-check-inline and help", {
  html <- as.character(
    bs_radio_input(
      "size",
      "Size",
      c(
        "S",
        "M"
      ),
      inline = TRUE,
      help = "Pick one"
    )
  )
  expect_match(
    html,
    "form-check-inline"
  )
  expect_match(
    html,
    "form-text"
  )
  expect_match(
    html,
    "Pick one"
  )
})

test_that("bs_checkbox_group_input renders form-check markup", {
  html <- as.character(
    bs_checkbox_group_input(
      "opts",
      "Options",
      c(
        "A",
        "B",
        "C"
      ),
      selected = "A"
    )
  )
  expect_match(
    html,
    "form-check"
  )
  expect_match(
    html,
    "form-check-input"
  )
  expect_match(
    html,
    "form-check-label"
  )
  expect_match(
    html,
    "type=\"checkbox\""
  )
})

test_that("bs_range_input renders a native form-range input", {
  html <- as.character(
    bs_range_input(
      "vol",
      "Volume",
      value = 50,
      min = 0,
      max = 100,
      step = 5
    )
  )
  expect_match(
    html,
    "type=\"range\""
  )
  expect_match(
    html,
    "class=\"form-range\""
  )
  expect_match(
    html,
    "data-bootstrict=\"range\""
  )
  expect_match(
    html,
    "id=\"vol\""
  )
  expect_match(
    html,
    "min=\"0\""
  )
  expect_match(
    html,
    "max=\"100\""
  )
  expect_match(
    html,
    "step=\"5\""
  )
  expect_match(
    html,
    "value=\"50\""
  )
  expect_match(
    html,
    "class=\"form-label\""
  )
  expect_match(
    html,
    "shiny-input-container"
  )
})

test_that("bs_range_input honours width and help", {
  html <- as.character(
    bs_range_input(
      "vol",
      value = 1,
      width = "200px",
      help = "Slide me"
    )
  )
  expect_match(
    html,
    "width:200px"
  )
  expect_match(
    html,
    "form-text"
  )
  expect_match(
    html,
    "Slide me"
  )
})

test_that("bs_color_input renders a native colour control", {
  html <- as.character(
    bs_color_input(
      "col",
      "Colour",
      value = "#0d6efd"
    )
  )
  expect_match(
    html,
    "type=\"color\""
  )
  expect_match(
    html,
    "form-control form-control-color"
  )
  expect_match(
    html,
    "data-bootstrict=\"color\""
  )
  expect_match(
    html,
    "value=\"#0d6efd\""
  )
  expect_match(
    html,
    "id=\"col\""
  )
})

test_that("bs_file_input adds form-control to the file input", {
  html <- as.character(
    bs_file_input(
      "upload",
      "Upload",
      accept = ".csv"
    )
  )
  expect_match(
    html,
    "type=\"file\""
  )
  expect_match(
    html,
    "form-control"
  )
  expect_match(
    html,
    "form-label"
  )
  # No "Browse" button: Bootstrap 5.3's file input is the control itself, and
  # the browser draws the button.
  expect_false(grepl(
    "Browse",
    html
  ))
})

test_that("bs_date_input enhances the date control to Bootstrap", {
  html <- as.character(
    bs_date_input(
      "day",
      "Day",
      value = "2026-06-26"
    )
  )
  expect_match(
    html,
    "form-label"
  )
  expect_match(
    html,
    "form-control"
  )
  # Native <input type="date">: no shiny wrapper, no datepicker.
  expect_match(
    html,
    "type=\"date\""
  )
  expect_no_match(
    html,
    "shiny-date-input",
    fixed = TRUE
  )
  expect_no_match(
    html,
    "datepicker",
    fixed = TRUE
  )
})

test_that("bs_date_range_input enhances the range control", {
  html <- as.character(
    bs_date_range_input(
      "range",
      "Period",
      start = "2026-01-01",
      end = "2026-12-31"
    )
  )
  expect_match(
    html,
    "form-label"
  )
  expect_match(
    html,
    "form-control"
  )
  # Two native fields joined in an input group.
  expect_equal(
    length(gregexpr(
      "type=\"date\"",
      html
    )[[
      1
    ]]),
    2L
  )
  expect_match(
    html,
    "data-bootstrict=\"date-range\""
  )
  expect_no_match(
    html,
    "shiny-date-range-input",
    fixed = TRUE
  )
})

test_that("extra named ... become attributes on the control", {
  html <- as.character(
    bs_radio_input(
      "size",
      "Size",
      c(
        "S",
        "M"
      ),
      `data-test` = "x"
    )
  )
  expect_match(
    html,
    "data-test=\"x\""
  )

  rng <- as.character(bs_range_input(
    "vol",
    value = 1,
    `data-test` = "y"
  ))
  expect_match(
    rng,
    "data-test=\"y\""
  )
})

test_that("choice groups are marked so the client can repair shiny's updates", {
  # shiny:::generateOptions() regenerates the options in Bootstrap 3 markup on
  # every updateRadioButtons()/updateCheckboxGroupInput() with `choices`, and
  # `inline` / `reverse` cannot be recovered from the replaced HTML.
  inline <- as.character(bs_radio_input(
    "r",
    "Size",
    c(
      "S",
      "M"
    ),
    inline = TRUE
  ))
  expect_match(
    inline,
    "data-bootstrict=\"form-check\""
  )
  expect_match(
    inline,
    "data-bootstrict-inline"
  )

  stacked <- as.character(bs_checkbox_group_input(
    "cg",
    "Pick",
    c(
      "a",
      "b"
    )
  ))
  expect_match(
    stacked,
    "data-bootstrict=\"form-check\""
  )
  expect_no_match(
    stacked,
    "data-bootstrict-inline",
    fixed = TRUE
  )

  # A single checkbox is not a group: nothing regenerates it, so it is not
  # marked.
  expect_no_match(
    as.character(bs_checkbox_input(
      "cb",
      "Agree"
    )),
    "data-bootstrict=",
    fixed = TRUE
  )
})

test_that("toggle buttons emit the reference .btn-check markup", {
  out <- as.character(bs_radio_button_input(
    "size",
    "Size",
    c(
      Small = "s",
      Large = "l"
    )
  ))
  # The input is a *sibling* of its label -- the CSS is `.btn-check:checked +
  # .btn` -- with no wrapper between them, and autocomplete="off" is required.
  expect_match(
    out,
    paste0(
      "<input type=\"radio\" class=\"btn-check\" name=\"size\" id=\"size-1\" ",
      "value=\"s\" autocomplete=\"off\" checked/>",
      "\\s*<label class=\"btn btn-outline-primary\" for=\"size-1\">Small</label>"
    )
  )
  expect_match(
    out,
    "<div class=\"btn-group\" role=\"group\""
  )
  expect_no_match(
    out,
    "form-check",
    fixed = TRUE
  )
  # Names label the buttons, values are what gets reported.
  expect_match(
    out,
    ">Large</label>"
  )
  expect_match(
    out,
    "value=\"l\""
  )
})

test_that("toggle button options and defaults behave", {
  # A radio group selects its first choice by default; a checkbox group none.
  expect_match(
    as.character(bs_radio_button_input(
      "r",
      NULL,
      c(
        "a",
        "b"
      )
    )),
    "value=\"a\" autocomplete=\"off\" checked"
  )
  expect_no_match(
    as.character(bs_checkbox_button_input(
      "c",
      NULL,
      c(
        "a",
        "b"
      )
    )),
    "checked",
    fixed = TRUE
  )
  expect_match(
    as.character(bs_radio_button_input(
      "r",
      NULL,
      c(
        "a",
        "b"
      ),
      outline = FALSE,
      size = "sm",
      vertical = TRUE
    )),
    "btn-group-vertical"
  )
  expect_match(
    as.character(bs_radio_button_input(
      "r",
      NULL,
      c(
        "a",
        "b"
      ),
      outline = FALSE,
      color = "danger"
    )),
    "class=\"btn btn-danger\""
  )
  # Unlabelled groups still get an accessible name.
  expect_match(
    as.character(bs_radio_button_input(
      "r",
      NULL,
      c(
        "a"
      )
    )),
    "aria-label=\"Toggle buttons\""
  )
  expect_match(
    as.character(bs_radio_button_input(
      "r",
      "Pick",
      c(
        "a"
      )
    )),
    "aria-labelledby=\"r-label\""
  )
})

test_that("toggle buttons validate their arguments", {
  expect_error(
    bs_radio_button_input(
      "r",
      NULL,
      c(
        "a"
      ),
      selected = "z"
    ),
    "must be one of the `choices`"
  )
  expect_error(
    bs_radio_button_input(
      "r",
      NULL,
      character()
    ),
    "at least one"
  )
  expect_error(
    bs_radio_button_input(
      NULL,
      NULL,
      c(
        "a"
      )
    ),
    "non-empty string"
  )
  expect_error(
    bs_radio_button_input(
      "r",
      NULL,
      c(
        "a"
      ),
      color = "bogus"
    ),
    "color"
  )
})

test_that("update_bs_toggle_buttons distinguishes absent from empty", {
  store <- NULL
  session <- list(
    sendCustomMessage = function(
      type,
      message
    ) {
      store <<- message
      invisible()
    },
    ns = function(
      x
    )
      paste0(
        "mod-",
        x
      )
  )
  update_bs_toggle_buttons(
    "tb",
    selected = c(
      "a",
      "b"
    ),
    session = session
  )
  expect_equal(
    store$method,
    "togglebuttons.update"
  )
  expect_equal(
    store$id,
    "mod-tb"
  )
  expect_equal(
    store$selected,
    c(
      "a",
      "b"
    )
  )
  expect_false(
    "clear" %in%
      names(
        store
      )
  )

  # character(0) must survive as an explicit clear rather than being dropped.
  update_bs_toggle_buttons(
    "tb",
    selected = character(
      0
    ),
    session = session
  )
  expect_true(
    store$clear
  )
  expect_false(
    "selected" %in%
      names(
        store
      )
  )
})

test_that("bs_file_input emits the reference 5.3 markup", {
  out <- as.character(bs_file_input(
    "f",
    "Upload",
    accept = ".csv"
  ))
  # Bootstrap 5.3 is a plain .form-control, not shiny's Bootstrap 3 compound
  # widget (a Browse button plus a readonly text box showing the file name).
  expect_match(
    out,
    "<input[^>]*class=\"shiny-input-file form-control\"[^>]*type=\"file\"/>"
  )
  expect_no_match(
    out,
    "btn-file",
    fixed = TRUE
  )
  expect_no_match(
    out,
    "input-group",
    fixed = TRUE
  )
  expect_no_match(
    out,
    "readonly",
    fixed = TRUE
  )
  expect_no_match(
    out,
    "No file selected",
    fixed = TRUE
  )
  # shiny's upload plumbing is untouched.
  expect_match(
    out,
    "id=\"f\""
  )
  expect_match(
    out,
    "name=\"f\""
  )
  expect_match(
    out,
    "accept=\".csv\""
  )
  expect_match(
    out,
    "id=\"f_progress\""
  )
})

test_that("bs_date_range_input no longer forces a small group or a BS3 addon", {
  out <- as.character(bs_date_range_input(
    "dr",
    "Range"
  ))
  # shiny hardcodes .input-group-sm, so the control was always small.
  expect_no_match(
    out,
    "input-group-sm",
    fixed = TRUE
  )
  # Add-ons must be direct children of .input-group under Bootstrap 5, or the
  # corner rounding between the two fields breaks.
  expect_no_match(
    out,
    "input-group-addon",
    fixed = TRUE
  )
  expect_no_match(
    out,
    "input-group-prepend",
    fixed = TRUE
  )
  expect_match(
    out,
    "<span class=\"input-group-text\">to</span>"
  )

  sized <- as.character(bs_date_range_input(
    "dr",
    "Range",
    size = "sm"
  ))
  expect_match(
    sized,
    "input-group input-group-sm"
  )
  expect_match(
    sized,
    "form-control form-control-sm"
  )
})

test_that("date inputs are native and ship no third-party library", {
  out <- as.character(bs_date_input(
    "d",
    "Date",
    value = as.Date(
      "2026-06-26"
    ),
    min = "2026-01-01",
    max = "2026-12-31",
    size = "sm"
  ))
  expect_match(
    out,
    "<input id=\"d-field\" type=\"date\""
  )
  expect_match(
    out,
    "class=\"form-control form-control-sm\""
  )
  expect_match(
    out,
    "value=\"2026-06-26\""
  )
  expect_match(
    out,
    "min=\"2026-01-01\""
  )
  expect_match(
    out,
    "max=\"2026-12-31\""
  )
  # The container carries the id the binding reports under; the field gets a
  # derived one so the label can point at it without duplicating an id.
  expect_match(
    out,
    "id=\"d\" class=\"form-group\" data-bootstrict=\"date\""
  )
  expect_match(
    out,
    "for=\"d-field\""
  )
  ids <- regmatches(
    out,
    gregexpr(
      "id=\"[^\"]+\"",
      out
    )
  )[[
    1
  ]]
  expect_equal(
    length(
      ids
    ),
    length(unique(
      ids
    ))
  )
})

test_that("a date range is two native fields in an input group", {
  out <- as.character(bs_date_range_input(
    "r",
    "Period",
    start = "2026-01-01",
    end = "2026-03-01",
    separator = "-"
  ))
  expect_equal(
    length(gregexpr(
      "type=\"date\"",
      out
    )[[
      1
    ]]),
    2L
  )
  expect_match(
    out,
    "id=\"r-start\""
  )
  expect_match(
    out,
    "id=\"r-end\""
  )
  expect_match(
    out,
    "<span class=\"input-group-text\">-</span>"
  )
  # Each field needs its own accessible name: one label cannot serve both.
  expect_match(
    out,
    "aria-label=\"Start date\""
  )
  expect_match(
    out,
    "aria-label=\"End date\""
  )
})

test_that("date arguments are validated and formatted", {
  expect_error(
    bs_date_input(
      "d",
      value = "not a date"
    ),
    "single date"
  )
  expect_error(
    bs_date_input(
      "d",
      min = c(
        "2026-01-01",
        "2026-02-01"
      )
    ),
    "single date"
  )
  # A Date and a string give the same attribute.
  expect_equal(
    as.character(bs_date_input(
      "d",
      value = as.Date(
        "2026-06-26"
      )
    )),
    as.character(bs_date_input(
      "d",
      value = "2026-06-26"
    ))
  )
})

test_that("the date server helpers distinguish clearing from leaving alone", {
  store <- NULL
  session <- list(
    sendCustomMessage = function(
      type,
      message
    ) {
      store <<- message
      invisible()
    },
    ns = function(
      x
    )
      paste0(
        "mod-",
        x
      )
  )
  update_bs_date_input(
    "d",
    value = as.Date(
      "2027-01-15"
    ),
    session = session
  )
  expect_equal(
    store$method,
    "date.update"
  )
  expect_equal(
    store$id,
    "mod-d"
  )
  expect_equal(
    store$value,
    "2027-01-15"
  )

  # NA clears the field; NULL is absent from the payload and leaves it alone.
  update_bs_date_input(
    "d",
    value = NA,
    session = session
  )
  expect_equal(
    store$value,
    ""
  )
  update_bs_date_input(
    "d",
    min = "2026-01-01",
    session = session
  )
  expect_false(
    "value" %in%
      names(
        store
      )
  )
  expect_equal(
    store$min,
    "2026-01-01"
  )

  update_bs_date_range_input(
    "r",
    start = "2026-01-01",
    end = NA,
    session = session
  )
  expect_equal(
    store$method,
    "daterange.update"
  )
  expect_equal(
    store$start,
    "2026-01-01"
  )
  expect_equal(
    store$end,
    ""
  )
})

test_that("browser date strings become Dates, empty ones NA", {
  expect_equal(
    bootstrict:::parse_date_value(
      "2026-06-26"
    ),
    as.Date(
      "2026-06-26"
    )
  )
  # A range keeps both positions when only one end is set.
  expect_equal(
    bootstrict:::parse_date_value(c(
      "2026-01-01",
      ""
    )),
    as.Date(c(
      "2026-01-01",
      NA
    ))
  )
  expect_null(bootstrict:::parse_date_value(
    NULL
  ))
})
