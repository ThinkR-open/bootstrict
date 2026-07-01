# Tests for the `forms-layout` component group ------------------------------

test_that("bs_input_group builds the group and supports sizing", {
  html <- as.character(bs_input_group(
    bs_input_group_text(
      "@"
    ),
    htmltools::tags$input(
      class = "form-control"
    ),
    size = "lg"
  ))
  expect_match(
    html,
    "<div class=\"input-group input-group-lg\""
  )
  expect_match(
    html,
    "<span class=\"input-group-text\">@</span>"
  )
  expect_match(
    html,
    "<input class=\"form-control\""
  )
})

test_that("bs_input_group without a size omits the modifier", {
  html <- as.character(bs_input_group(bs_input_group_text(
    "kg"
  )))
  expect_match(
    html,
    "class=\"input-group\""
  )
  expect_false(grepl(
    "input-group-sm|input-group-lg",
    html
  ))
})

test_that("bs_input_group rejects an invalid size", {
  expect_error(bs_input_group(
    size = "huge"
  ))
})

test_that("bs_input_group_text takes extra classes and attributes", {
  html <- as.character(bs_input_group_text(
    "$",
    id = "addon",
    class = "fw-bold"
  ))
  expect_match(
    html,
    "<span class=\"input-group-text fw-bold\""
  )
  expect_match(
    html,
    "id=\"addon\""
  )
})

test_that("bs_form renders a form and adds novalidate when asked", {
  plain <- as.character(bs_form(htmltools::div(
    "body"
  )))
  expect_match(
    plain,
    "<form"
  )
  expect_match(
    plain,
    "<div>body</div>"
  )
  expect_false(grepl(
    "novalidate",
    plain
  ))

  nv <- as.character(bs_form(
    htmltools::div(
      "body"
    ),
    novalidate = TRUE,
    class = "needs-validation"
  ))
  expect_match(
    nv,
    "<form class=\"needs-validation\" novalidate"
  )
})

test_that("bs_form_label sets the form-label class and for attribute", {
  html <- as.character(bs_form_label(
    "email",
    "Email address"
  ))
  expect_match(
    html,
    "<label class=\"form-label\""
  )
  expect_match(
    html,
    "for=\"email\""
  )
  expect_match(
    html,
    ">Email address</label>"
  )
})

test_that("bs_form_text renders muted helper text", {
  html <- as.character(bs_form_text(
    "Must be 8-20 characters."
  ))
  expect_match(
    html,
    "<div class=\"form-text\">Must be 8-20 characters.</div>"
  )
})

test_that("validation feedback helpers use the right classes", {
  ok <- as.character(bs_valid_feedback(
    "Looks good!"
  ))
  expect_match(
    ok,
    "<div class=\"valid-feedback\">Looks good!</div>"
  )

  bad <- as.character(bs_invalid_feedback(
    "Please choose a username."
  ))
  expect_match(
    bad,
    "<div class=\"invalid-feedback\">Please choose a username.</div>"
  )
})

test_that("bs_floating_label wraps a text control and reuses its label", {
  html <- as.character(bs_floating_label(bs_text_input(
    "email",
    "Email address"
  )))
  expect_match(
    html,
    "<div class=\"form-floating\""
  )
  # the existing control is moved, not rebuilt (id and shiny wiring preserved)
  expect_match(
    html,
    "id=\"email\""
  )
  expect_match(
    html,
    "shiny-input-text"
  )
  expect_match(
    html,
    "form-control"
  )
  # required placeholder is injected for the floating animation
  expect_match(
    html,
    "placeholder=\" \""
  )
  # label kept, reusing existing text, placed after the control with a `for`
  expect_match(
    html,
    "<label for=\"email\">Email address</label>"
  )
  expect_true(
    regexpr(
      "id=\"email\"",
      html
    ) <
      regexpr(
        "<label",
        html
      )
  )
})

test_that("bs_floating_label accepts an explicit label and handles selects", {
  html <- as.character(
    bs_floating_label(
      bs_select_input(
        "fruit",
        "Fruit",
        c(
          "Apple",
          "Pear"
        )
      ),
      label = "Pick fruit"
    )
  )
  expect_match(
    html,
    "<div class=\"form-floating\""
  )
  # the select control becomes a direct child of the wrapper
  expect_match(
    html,
    "<select"
  )
  expect_match(
    html,
    "form-select"
  )
  expect_match(
    html,
    "id=\"fruit\""
  )
  expect_match(
    html,
    "<label for=\"fruit\">Pick fruit</label>"
  )
})

test_that("bs_floating_label preserves an existing placeholder", {
  html <- as.character(
    bs_floating_label(bs_text_input(
      "e2",
      "L",
      placeholder = "you@x.com"
    ))
  )
  expect_match(
    html,
    "placeholder=\"you@x.com\""
  )
  expect_false(grepl(
    "placeholder=\" \"",
    html
  ))
})

test_that("bs_floating_label errors without a form control", {
  expect_error(
    bs_floating_label(htmltools::div(
      "not a control"
    )),
    "form-control"
  )
})
