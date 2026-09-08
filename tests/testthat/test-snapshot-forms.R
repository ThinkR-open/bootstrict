# Markup snapshots: form controls.
#
# These are kept apart from the component snapshots because they delegate to
# shiny::*Input() and then restyle the result, so a shiny release can move them
# for reasons that have nothing to do with bootstrict. When one of these
# changes, read the diff before accepting it: the point of the package is that
# what comes out is Bootstrap 5.3 markup, whatever shiny emitted.

test_that("text-like control markup is stable", {
  expect_snapshot(snap(bs_text_input(
    "name",
    "Name",
    placeholder = "Jane",
    help = "Your full name."
  )))
  expect_snapshot(snap(bs_textarea_input(
    "bio",
    "Bio",
    rows = 3
  )))
  expect_snapshot(snap(bs_numeric_input(
    "n",
    "N",
    value = 1,
    min = 0,
    max = 10
  )))
  expect_snapshot(snap(bs_password_input(
    "pw",
    "Password",
    size = "lg"
  )))
  expect_snapshot(snap(bs_select_input(
    "s",
    "Select",
    c(
      "a",
      "b"
    )
  )))
})

test_that("check-like control markup is stable", {
  expect_snapshot(snap(bs_checkbox_input(
    "cb",
    "Agree"
  )))
  expect_snapshot(snap(bs_switch_input(
    "sw",
    "Enable"
  )))
  expect_snapshot(snap(bs_radio_input(
    "r",
    "Size",
    c(
      "S",
      "M"
    ),
    inline = TRUE
  )))
  expect_snapshot(snap(bs_checkbox_group_input(
    "cg",
    "Pick",
    c(
      "a",
      "b"
    )
  )))
  expect_snapshot(snap(bs_checkbox_input(
    "cbr",
    "Reverse",
    reverse = TRUE
  )))
})

test_that("toggle button markup is stable", {
  expect_snapshot(snap(bs_radio_button_input(
    "size",
    "Size",
    c(
      Small = "s",
      Large = "l"
    )
  )))
  expect_snapshot(snap(bs_checkbox_button_input(
    "opts",
    NULL,
    c(
      "a",
      "b"
    )
  )))
})

test_that("native control markup is stable", {
  expect_snapshot(snap(bs_range_input(
    "rng",
    "Range",
    value = 5,
    min = 0,
    max = 10
  )))
  expect_snapshot(snap(bs_color_input(
    "col",
    "Colour",
    value = "#ff6600"
  )))
})

test_that("form layout markup is stable", {
  expect_snapshot(snap(bs_input_group(
    bs_input_group_text(
      "@"
    ),
    bs_text_input(
      "u",
      NULL
    )
  )))
  expect_snapshot(snap(bs_input_group(
    bs_input_group_text(bs_checkbox_input(
      "cb",
      NULL
    )),
    bs_text_input(
      "u",
      NULL
    )
  )))
  expect_snapshot(snap(bs_floating_label(bs_text_input(
    "e",
    "Email"
  ))))
  expect_snapshot(snap(bs_form(
    bs_form_label(
      "e",
      "Email"
    ),
    bs_text_input(
      "e",
      NULL
    ),
    bs_form_text(
      "We never share it."
    )
  )))
  expect_snapshot(snap(bs_feedback(
    bs_text_input(
      "user",
      "User"
    ),
    invalid = "Taken.",
    state = "invalid"
  )))
  expect_snapshot(snap(bs_valid_feedback(
    "Looks good."
  )))
  expect_snapshot(snap(bs_invalid_feedback(
    "Please provide a value."
  )))
})

test_that("the shiny-inherited controls are recorded as they stand", {
  # These three still emit Bootstrap 3 structures, which is a known deviation:
  # the file input renders the "Browse" compound widget instead of
  # <input class="form-control" type="file">, and the date inputs ship
  # bootstrap-datepicker, whose popup is not 5.3 markup. Snapshotting them
  # records the deviation, so fixing it shows up as a diff.
  expect_snapshot(snap(bs_file_input(
    "f",
    "Upload"
  )))
  expect_snapshot(snap(bs_date_input(
    "d",
    "Date"
  )))
  expect_snapshot(snap(bs_date_range_input(
    "dr",
    "Range"
  )))
})
