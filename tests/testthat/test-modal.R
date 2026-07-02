test_that("bs_modal renders faithful Bootstrap 5 markup", {
  html <- as.character(bs_modal(
    "info",
    "Body text.",
    title = "Heads up"
  ))
  expect_match(
    html,
    "^<div"
  )
  expect_match(
    html,
    "class=\"modal fade\""
  )
  expect_match(
    html,
    "id=\"info\""
  )
  expect_match(
    html,
    "tabindex=\"-1\""
  )
  expect_match(
    html,
    "aria-hidden=\"true\""
  )
  expect_match(
    html,
    "data-bootstrict=\"modal\""
  )
  expect_match(
    html,
    "class=\"modal-dialog\""
  )
  expect_match(
    html,
    "class=\"modal-content\""
  )
  expect_match(
    html,
    "class=\"modal-body\""
  )
  expect_match(
    html,
    "Body text."
  )
})

test_that("title produces a header with title and close button", {
  html <- as.character(bs_modal(
    "m",
    title = "Title here"
  ))
  expect_match(
    html,
    "class=\"modal-header\""
  )
  # Bootstrap 5.3 pattern: <h1 class="modal-title fs-5">, wired to the root
  # via aria-labelledby.
  expect_match(
    html,
    "<h1 class=\"modal-title fs-5\" id=\"m-title\""
  )
  expect_match(
    html,
    "aria-labelledby=\"m-title\""
  )
  expect_match(
    html,
    "Title here"
  )
  expect_match(
    html,
    "btn-close"
  )
  expect_match(
    html,
    "data-bs-dismiss=\"modal\""
  )
})

test_that("no header is rendered when title is NULL", {
  html <- as.character(bs_modal(
    "m",
    "Just a body"
  ))
  expect_false(grepl(
    "modal-header",
    html
  ))
})

test_that("footer is rendered only when supplied", {
  with_footer <- as.character(bs_modal(
    "m",
    "x",
    footer = "Footer bits"
  ))
  expect_match(
    with_footer,
    "class=\"modal-footer\""
  )
  expect_match(
    with_footer,
    "Footer bits"
  )

  without <- as.character(bs_modal(
    "m",
    "x"
  ))
  expect_false(grepl(
    "modal-footer",
    without
  ))
})

test_that("size, centered, scrollable modifiers apply to the dialog", {
  html <- as.character(
    bs_modal(
      "m",
      "x",
      size = "lg",
      centered = TRUE,
      scrollable = TRUE
    )
  )
  expect_match(
    html,
    "modal-lg"
  )
  expect_match(
    html,
    "modal-dialog-centered"
  )
  expect_match(
    html,
    "modal-dialog-scrollable"
  )
})

test_that("size is validated", {
  expect_error(bs_modal(
    "m",
    size = "huge"
  ))
})

test_that("fullscreen TRUE and breakpoint variants are applied", {
  full <- as.character(bs_modal(
    "m",
    "x",
    fullscreen = TRUE
  ))
  expect_match(
    full,
    "modal-fullscreen\\b"
  )

  bp <- as.character(bs_modal(
    "m",
    "x",
    fullscreen = "lg"
  ))
  expect_match(
    bp,
    "modal-fullscreen-lg-down"
  )
})

test_that("fullscreen breakpoint is validated", {
  expect_error(bs_modal(
    "m",
    fullscreen = "nope"
  ))
})

test_that("static backdrop and disabled keyboard set data attributes", {
  static <- as.character(bs_modal(
    "m",
    "x",
    backdrop = "static"
  ))
  expect_match(
    static,
    "data-bs-backdrop=\"static\""
  )

  # FALSE means *no backdrop at all* — distinct from "static" (a backdrop
  # that does not dismiss), matching Bootstrap and bs_offcanvas().
  false_bd <- as.character(bs_modal(
    "m",
    "x",
    backdrop = FALSE
  ))
  expect_match(
    false_bd,
    "data-bs-backdrop=\"false\""
  )

  no_kbd <- as.character(bs_modal(
    "m",
    "x",
    keyboard = FALSE
  ))
  expect_match(
    no_kbd,
    "data-bs-keyboard=\"false\""
  )
})

test_that("default backdrop and keyboard emit no data attributes", {
  html <- as.character(bs_modal(
    "m",
    "x"
  ))
  expect_false(grepl(
    "data-bs-backdrop",
    html
  ))
  expect_false(grepl(
    "data-bs-keyboard",
    html
  ))
})

test_that("modal sub-piece helpers render their containers", {
  expect_match(
    as.character(bs_modal_header(
      "h"
    )),
    "class=\"modal-header\""
  )
  expect_match(
    as.character(bs_modal_header(
      "h"
    )),
    "btn-close"
  )
  expect_match(
    as.character(bs_modal_body(
      "b"
    )),
    "class=\"modal-body\""
  )
  expect_match(
    as.character(bs_modal_footer(
      "f"
    )),
    "class=\"modal-footer\""
  )

  title <- as.character(bs_modal_title(
    "T"
  ))
  expect_match(
    title,
    "^<h1"
  )
  expect_match(
    title,
    "class=\"modal-title fs-5\""
  )
})

test_that("bs_modal_trigger renders a toggle button targeting the modal", {
  html <- as.character(bs_modal_trigger(
    "info",
    "Open"
  ))
  expect_match(
    html,
    "^<button"
  )
  expect_match(
    html,
    "class=\"btn"
  )
  expect_match(
    html,
    "data-bs-toggle=\"modal\""
  )
  expect_match(
    html,
    "data-bs-target=\"#info\""
  )
  expect_match(
    html,
    "Open"
  )
})

test_that("the bootstrict dependency travels with the modal", {
  deps <- htmltools::findDependencies(bs_modal(
    "m",
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
