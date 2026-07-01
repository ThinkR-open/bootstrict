test_that("bs_spinner renders a border spinner with role and label", {
  html <- as.character(bs_spinner())
  expect_match(
    html,
    "spinner-border"
  )
  expect_match(
    html,
    'role="status"'
  )
  expect_match(
    html,
    '<span class="visually-hidden">Loading\\.\\.\\.</span>'
  )
})

test_that("bs_spinner supports the grow type", {
  html <- as.character(bs_spinner(
    type = "grow"
  ))
  expect_match(
    html,
    "spinner-grow"
  )
  expect_false(grepl(
    "spinner-border",
    html
  ))
})

test_that("bs_spinner applies colour, size and a custom label", {
  html <- as.character(
    bs_spinner(
      type = "border",
      color = "primary",
      size = "sm",
      label = "Please wait"
    )
  )
  expect_match(
    html,
    "text-primary"
  )
  expect_match(
    html,
    "spinner-border-sm"
  )
  expect_match(
    html,
    "Please wait"
  )
})

test_that("bs_spinner grow size uses the grow modifier", {
  html <- as.character(bs_spinner(
    type = "grow",
    size = "sm"
  ))
  expect_match(
    html,
    "spinner-grow-sm"
  )
  expect_false(grepl(
    "spinner-border-sm",
    html
  ))
})

test_that("bs_spinner validates colour and size", {
  expect_error(bs_spinner(
    color = "nope"
  ))
  expect_error(bs_spinner(
    size = "lg"
  ))
})

test_that("bs_placeholder renders a span with width, colour and size", {
  html <- as.character(
    bs_placeholder(
      width = 6,
      color = "danger",
      size = "lg"
    )
  )
  expect_match(
    html,
    "^<span"
  )
  expect_match(
    html,
    "placeholder"
  )
  expect_match(
    html,
    "col-6"
  )
  expect_match(
    html,
    "bg-danger"
  )
  expect_match(
    html,
    "placeholder-lg"
  )
})

test_that("bs_placeholder validates the width range", {
  expect_error(bs_placeholder(
    width = 0
  ))
  expect_error(bs_placeholder(
    width = 13
  ))
  expect_error(bs_placeholder(
    size = "xl"
  ))
})

test_that("bs_placeholder forwards extra attributes and classes", {
  html <- as.character(
    bs_placeholder(
      class = "my-extra",
      `aria-hidden` = "true"
    )
  )
  expect_match(
    html,
    "my-extra"
  )
  expect_match(
    html,
    'aria-hidden="true"'
  )
})

test_that("placeholder glow and wave wrappers carry their classes and children", {
  glow <- as.character(bs_placeholder_glow(bs_placeholder(
    width = 6
  )))
  expect_match(
    glow,
    "<p"
  )
  expect_match(
    glow,
    "placeholder-glow"
  )
  expect_match(
    glow,
    "col-6"
  )

  wave <- as.character(bs_placeholder_wave(bs_placeholder(
    width = 4
  )))
  expect_match(
    wave,
    "placeholder-wave"
  )
  expect_match(
    wave,
    "col-4"
  )
})

test_that("constructors attach the bootstrict dependency", {
  for (tag in list(
    bs_spinner(),
    bs_placeholder(),
    bs_placeholder_glow(),
    bs_placeholder_wave()
  )) {
    deps <- htmltools::findDependencies(
      tag
    )
    expect_true(any(vapply(
      deps,
      function(
        d
      )
        d$name ==
          "bootstrict",
      logical(
        1
      )
    )))
  }
})
