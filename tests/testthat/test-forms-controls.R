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
  expect_true(grepl(
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
  expect_match(
    html,
    "input-daterange|shiny-date-input|datepicker"
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
  expect_match(
    html,
    "shiny-date-range-input"
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
