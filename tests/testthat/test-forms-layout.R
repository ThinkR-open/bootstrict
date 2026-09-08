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

test_that("bs_feedback puts the message where Bootstrap can display it", {
  # Bootstrap only shows feedback via `.is-invalid ~ .invalid-feedback`, so the
  # message must be a *following sibling* of the control, not of shiny's
  # input container.
  out <- as.character(bs_feedback(
    bs_text_input(
      "email",
      "Email"
    ),
    invalid = "Adresse invalide."
  ))
  expect_match(
    out,
    "id=\"email\".*<div class=\"invalid-feedback\">Adresse invalide.</div>\\s*</div>"
  )

  # A <select> is wrapped by shiny in a bare div: the feedback goes in there,
  # next to the control, not after the wrapper.
  sel <- as.character(bs_feedback(
    bs_select_input(
      "s",
      "S",
      c(
        "a",
        "b"
      )
    ),
    valid = "OK"
  ))
  expect_match(
    sel,
    "</select>\\s*<div class=\"valid-feedback\">OK</div>"
  )
})

test_that("bs_feedback marks the control and carries one message per group", {
  out <- as.character(bs_feedback(
    bs_checkbox_input(
      "cb",
      "Agree"
    ),
    invalid = "Obligatoire.",
    state = "invalid"
  ))
  expect_match(
    out,
    "form-check-input is-invalid"
  )

  # A radio group holds one control per option; the reference markup carries
  # the feedback once, after the last one.
  radio <- as.character(bs_feedback(
    bs_radio_input(
      "r",
      "Size",
      c(
        "S",
        "M"
      )
    ),
    invalid = "Choisis."
  ))
  expect_equal(
    length(gregexpr(
      "invalid-feedback",
      radio
    )[[
      1
    ]]),
    1L
  )
  expect_match(
    radio,
    "value=\"M\".*invalid-feedback"
  )
})

test_that("bs_feedback validates its arguments", {
  expect_error(
    bs_feedback(
      "not a tag",
      invalid = "x"
    ),
    "bs_\\*_input"
  )
  expect_error(
    bs_feedback(
      bs_text_input(
        "a",
        "A"
      ),
      state = "bogus"
    ),
    "valid"
  )
  expect_error(
    bs_feedback(
      htmltools::div(
        "no control here"
      ),
      invalid = "x"
    ),
    "no Bootstrap form control"
  )
})

test_that("set_bs_validation sends a namespaced message", {
  store <- list()
  session <- list(
    sendCustomMessage = function(
      type,
      message
    ) {
      store <<- list(
        type = type,
        message = message
      )
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

  set_bs_validation(
    "user",
    "invalid",
    "Ce nom est deja pris.",
    session = session
  )
  expect_equal(
    store$type,
    "bootstrict-message"
  )
  expect_equal(
    store$message$method,
    "validation.set"
  )
  expect_equal(
    store$message$id,
    "mod-user"
  )
  expect_equal(
    store$message$state,
    "invalid"
  )
  expect_equal(
    store$message$message,
    "Ce nom est deja pris."
  )

  # "none" clears the state; a NULL message is dropped from the payload.
  set_bs_validation(
    "user",
    "none",
    session = session
  )
  expect_equal(
    store$message$state,
    "none"
  )
  expect_false(
    "message" %in%
      names(
        store$message
      )
  )
})

test_that("set_bs_validation rejects a non-text message and a bad state", {
  expect_error(
    set_bs_validation(
      "a",
      "invalid",
      message = htmltools::span(
        "x"
      ),
      session = list(
        sendCustomMessage = function(
          ...
        )
          NULL
      )
    ),
    "plain text"
  )
  expect_error(
    set_bs_validation(
      "a",
      "bogus"
    ),
    "one of"
  )
})
