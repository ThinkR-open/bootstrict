test_that("bs_list_group renders a plain <ul> by default", {
  html <- as.character(bs_list_group(
    bs_list_group_item(
      "An item"
    ),
    bs_list_group_item(
      "Another item"
    )
  ))
  expect_match(
    html,
    "^<ul"
  )
  expect_match(
    html,
    "class=\"list-group\""
  )
  expect_match(
    html,
    "list-group-item"
  )
})

test_that("flush, numbered and horizontal modifiers are applied", {
  flush <- as.character(bs_list_group(
    bs_list_group_item(
      "x"
    ),
    flush = TRUE
  ))
  expect_match(
    flush,
    "list-group-flush"
  )

  numbered <- as.character(bs_list_group(
    bs_list_group_item(
      "x"
    ),
    numbered = TRUE
  ))
  expect_match(
    numbered,
    "^<ol"
  )
  expect_match(
    numbered,
    "list-group-numbered"
  )

  horiz <- as.character(bs_list_group(
    bs_list_group_item(
      "x"
    ),
    horizontal = TRUE
  ))
  expect_match(
    horiz,
    "list-group-horizontal\\b"
  )

  horiz_bp <- as.character(bs_list_group(
    bs_list_group_item(
      "x"
    ),
    horizontal = "md"
  ))
  expect_match(
    horiz_bp,
    "list-group-horizontal-md"
  )
})

test_that("horizontal rejects an invalid breakpoint", {
  expect_error(bs_list_group(
    horizontal = "nope"
  ))
})

test_that("a group with an id is selectable and uses a <div>", {
  html <- as.character(bs_list_group(
    "picker",
    bs_list_group_item(
      "One",
      value = "one",
      action = TRUE
    ),
    bs_list_group_item(
      "Two",
      value = "two",
      action = TRUE
    )
  ))
  expect_match(
    html,
    "^<div"
  )
  expect_match(
    html,
    "id=\"picker\""
  )
  expect_match(
    html,
    "data-bootstrict=\"list-group\""
  )
})

test_that("a group containing action items uses a <div> even without an id", {
  html <- as.character(bs_list_group(
    bs_list_group_item(
      "A button item",
      action = TRUE
    )
  ))
  expect_match(
    html,
    "^<div"
  )
})

test_that("a group containing href items uses a <div>", {
  html <- as.character(bs_list_group(
    bs_list_group_item(
      "A link",
      href = "#"
    )
  ))
  expect_match(
    html,
    "^<div"
  )
})

test_that("bs_list_group_item renders a plain <li> by default", {
  html <- as.character(bs_list_group_item(
    "Hello"
  ))
  expect_match(
    html,
    "^<li"
  )
  expect_match(
    html,
    "class=\"list-group-item\""
  )
})

test_that("active, disabled and color modifiers are applied", {
  html <- as.character(bs_list_group_item(
    "Item",
    active = TRUE,
    disabled = TRUE,
    color = "success"
  ))
  expect_match(
    html,
    "active"
  )
  expect_match(
    html,
    "disabled"
  )
  expect_match(
    html,
    "list-group-item-success"
  )
  expect_match(
    html,
    "aria-current=\"true\""
  )
})

test_that("color is validated against the theme colours", {
  expect_error(bs_list_group_item(
    "Item",
    color = "rainbow"
  ))
})

test_that("action items render an actionable <button> with data-value", {
  html <- as.character(bs_list_group_item(
    "Click",
    value = "v1",
    action = TRUE
  ))
  expect_match(
    html,
    "^<button"
  )
  expect_match(
    html,
    "type=\"button\""
  )
  expect_match(
    html,
    "list-group-item-action"
  )
  expect_match(
    html,
    "data-value=\"v1\""
  )
})

test_that("href items render an actionable <a> with data-value", {
  html <- as.character(bs_list_group_item(
    "Go",
    value = "v2",
    href = "/path"
  ))
  expect_match(
    html,
    "^<a"
  )
  expect_match(
    html,
    "href=\"/path\""
  )
  expect_match(
    html,
    "list-group-item-action"
  )
  expect_match(
    html,
    "data-value=\"v2\""
  )
})

test_that("no data-value attribute is emitted when value is NULL", {
  html <- as.character(bs_list_group_item(
    "Plain"
  ))
  expect_false(grepl(
    "data-value",
    html
  ))
})

test_that("the bootstrict dependency travels with the top-level group", {
  deps <- htmltools::findDependencies(bs_list_group(bs_list_group_item(
    "x"
  )))
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
