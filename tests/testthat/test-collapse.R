test_that("bs_collapse renders faithful Bootstrap 5 markup", {
  html <- as.character(bs_collapse(
    "more",
    "Hidden content."
  ))
  expect_match(
    html,
    "^<div"
  )
  expect_match(
    html,
    "id=\"more\""
  )
  expect_match(
    html,
    "class=\"collapse\""
  )
  expect_match(
    html,
    "data-bootstrict=\"collapse\""
  )
  expect_match(
    html,
    "Hidden content."
  )
})

test_that("open adds .show and horizontal adds .collapse-horizontal", {
  open <- as.character(bs_collapse(
    "more",
    "x",
    open = TRUE
  ))
  expect_match(
    open,
    "collapse show"
  )

  horiz <- as.character(bs_collapse(
    "more",
    "x",
    horizontal = TRUE
  ))
  expect_match(
    horiz,
    "collapse-horizontal"
  )

  closed <- as.character(bs_collapse(
    "more",
    "x"
  ))
  expect_false(grepl(
    "\\bshow\\b",
    closed
  ))
  expect_false(grepl(
    "collapse-horizontal",
    closed
  ))
})

test_that("extra class and named attributes are forwarded", {
  html <- as.character(
    bs_collapse(
      "more",
      "x",
      class = "extra",
      `data-foo` = "bar"
    )
  )
  expect_match(
    html,
    "extra"
  )
  expect_match(
    html,
    "data-foo=\"bar\""
  )
})

test_that("bs_collapse_trigger renders a toggle button by default", {
  html <- as.character(bs_collapse_trigger(
    "more",
    "Toggle"
  ))
  expect_match(
    html,
    "^<button"
  )
  expect_match(
    html,
    "class=\"btn\""
  )
  expect_match(
    html,
    "type=\"button\""
  )
  expect_match(
    html,
    "data-bs-toggle=\"collapse\""
  )
  expect_match(
    html,
    "data-bs-target=\"#more\""
  )
  expect_match(
    html,
    "aria-expanded=\"false\""
  )
  expect_match(
    html,
    "aria-controls=\"more\""
  )
  expect_match(
    html,
    "Toggle"
  )
})

test_that("bs_collapse_trigger with button = FALSE renders an anchor", {
  html <- as.character(bs_collapse_trigger(
    "more",
    "Toggle",
    button = FALSE
  ))
  expect_match(
    html,
    "^<a"
  )
  expect_match(
    html,
    "data-bs-toggle=\"collapse\""
  )
  expect_match(
    html,
    "href=\"#more\""
  )
  expect_match(
    html,
    "role=\"button\""
  )
  expect_match(
    html,
    "aria-expanded=\"false\""
  )
  expect_match(
    html,
    "aria-controls=\"more\""
  )
})

test_that("update_bs_collapse validates the action argument", {
  expect_error(
    update_bs_collapse(
      "more",
      "explode",
      session = NULL
    )
  )
})

test_that("the bootstrict dependency travels with the collapse", {
  deps <- htmltools::findDependencies(bs_collapse(
    "more",
    "x"
  ))
  names <- vapply(
    deps,
    function(
      d
    )
      d$name,
    character(
      1
    )
  )
  expect_true(
    "bootstrict" %in%
      names
  )
})
