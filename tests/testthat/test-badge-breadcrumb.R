test_that("bs_badge renders a span with badge + text-bg classes", {
  html <- as.character(bs_badge(
    "New",
    color = "success"
  ))
  expect_match(
    html,
    "<span"
  )
  expect_match(
    html,
    "class=\"badge text-bg-success\""
  )
  expect_match(
    html,
    ">New</span>"
  )
})

test_that("bs_badge defaults to primary and supports pill + extra class", {
  expect_match(
    as.character(bs_badge(
      "9"
    )),
    "text-bg-primary"
  )
  html <- as.character(bs_badge(
    "9",
    pill = TRUE,
    class = "ms-1"
  ))
  expect_match(
    html,
    "rounded-pill"
  )
  expect_match(
    html,
    "ms-1"
  )
})

test_that("bs_badge rejects an unknown colour", {
  expect_error(bs_badge(
    "x",
    color = "purple"
  ))
})

test_that("bs_badge forwards named ... as attributes", {
  html <- as.character(bs_badge(
    "N",
    id = "b1",
    title = "tip"
  ))
  expect_match(
    html,
    "id=\"b1\""
  )
  expect_match(
    html,
    "title=\"tip\""
  )
})

test_that("bs_breadcrumb wraps an ol.breadcrumb in a labelled nav", {
  html <- as.character(
    bs_breadcrumb(
      bs_breadcrumb_item(
        "Home",
        href = "#"
      ),
      bs_breadcrumb_item(
        "Library",
        active = TRUE
      )
    )
  )
  expect_match(
    html,
    "<nav"
  )
  expect_match(
    html,
    "aria-label=\"breadcrumb\""
  )
  expect_match(
    html,
    "<ol class=\"breadcrumb\""
  )
})

test_that("bs_breadcrumb sets the divider CSS variable when a string", {
  html <- as.character(bs_breadcrumb(
    divider = ">"
  ))
  expect_match(
    html,
    "--bs-breadcrumb-divider",
    fixed = TRUE
  )
  expect_match(
    html,
    "&gt;",
    fixed = TRUE
  )
  # No style attribute when divider is NULL.
  expect_false(grepl(
    "breadcrumb-divider",
    as.character(bs_breadcrumb())
  ))
})

test_that("bs_breadcrumb forwards named ... and extra class to the nav", {
  html <- as.character(bs_breadcrumb(
    class = "my-2",
    id = "bc"
  ))
  expect_match(
    html,
    "class=\"my-2\""
  )
  expect_match(
    html,
    "id=\"bc\""
  )
})

test_that("bs_breadcrumb_item links non-active items with an href", {
  html <- as.character(bs_breadcrumb_item(
    "Home",
    href = "/home"
  ))
  expect_match(
    html,
    "class=\"breadcrumb-item\""
  )
  expect_match(
    html,
    "<a href=\"/home\">Home</a>"
  )
  expect_false(grepl(
    "aria-current",
    html
  ))
})

test_that("bs_breadcrumb_item marks active items and renders children inline", {
  html <- as.character(bs_breadcrumb_item(
    "Library",
    active = TRUE
  ))
  expect_match(
    html,
    "class=\"breadcrumb-item active\""
  )
  expect_match(
    html,
    "aria-current=\"page\""
  )
  expect_false(grepl(
    "<a ",
    html
  ))
})

test_that("bs_breadcrumb_item ignores href when active", {
  html <- as.character(
    bs_breadcrumb_item(
      "Library",
      href = "/lib",
      active = TRUE
    )
  )
  expect_false(grepl(
    "<a ",
    html
  ))
  expect_match(
    html,
    "aria-current=\"page\""
  )
})
