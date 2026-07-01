test_that("bs_offcanvas renders faithful Bootstrap 5 markup", {
  html <- as.character(bs_offcanvas(
    "menu",
    "Body text.",
    title = "Menu"
  ))
  expect_match(
    html,
    "^<div"
  )
  expect_match(
    html,
    "class=\"offcanvas offcanvas-start\""
  )
  expect_match(
    html,
    "id=\"menu\""
  )
  expect_match(
    html,
    "tabindex=\"-1\""
  )
  expect_match(
    html,
    "data-bootstrict=\"offcanvas\""
  )
  expect_match(
    html,
    "class=\"offcanvas-body\""
  )
  expect_match(
    html,
    "Body text."
  )
})

test_that("title produces a header with title and close button", {
  html <- as.character(bs_offcanvas(
    "o",
    title = "Title here"
  ))
  expect_match(
    html,
    "class=\"offcanvas-header\""
  )
  expect_match(
    html,
    "class=\"offcanvas-title\""
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
    "data-bs-dismiss=\"offcanvas\""
  )
})

test_that("no header is rendered when title is NULL", {
  html <- as.character(bs_offcanvas(
    "o",
    "Just a body"
  ))
  expect_false(grepl(
    "offcanvas-header",
    html
  ))
})

test_that("placement modifier picks the right edge class", {
  expect_match(
    as.character(bs_offcanvas(
      "o",
      placement = "end"
    )),
    "offcanvas-end"
  )
  expect_match(
    as.character(bs_offcanvas(
      "o",
      placement = "top"
    )),
    "offcanvas-top"
  )
  expect_match(
    as.character(bs_offcanvas(
      "o",
      placement = "bottom"
    )),
    "offcanvas-bottom"
  )
})

test_that("placement is validated", {
  expect_error(bs_offcanvas(
    "o",
    placement = "left"
  ))
})

test_that("backdrop and scroll set data attributes", {
  no_bd <- as.character(bs_offcanvas(
    "o",
    backdrop = FALSE
  ))
  expect_match(
    no_bd,
    "data-bs-backdrop=\"false\""
  )

  static <- as.character(bs_offcanvas(
    "o",
    backdrop = "static"
  ))
  expect_match(
    static,
    "data-bs-backdrop=\"static\""
  )

  scroll <- as.character(bs_offcanvas(
    "o",
    scroll = TRUE
  ))
  expect_match(
    scroll,
    "data-bs-scroll=\"true\""
  )
})

test_that("default backdrop and scroll emit no data attributes", {
  html <- as.character(bs_offcanvas(
    "o",
    "x"
  ))
  expect_false(grepl(
    "data-bs-backdrop",
    html
  ))
  expect_false(grepl(
    "data-bs-scroll",
    html
  ))
})

test_that("unnamed content lands in the body and named dots decorate the root", {
  html <- as.character(
    bs_offcanvas(
      "o",
      "Inner content",
      `data-foo` = "bar"
    )
  )
  expect_match(
    html,
    "<div class=\"offcanvas-body\">Inner content</div>"
  )
  expect_match(
    html,
    "data-foo=\"bar\""
  )
})

test_that("bs_offcanvas_trigger renders a toggle button targeting the offcanvas", {
  html <- as.character(bs_offcanvas_trigger(
    "menu",
    "Open"
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
    "data-bs-toggle=\"offcanvas\""
  )
  expect_match(
    html,
    "data-bs-target=\"#menu\""
  )
  expect_match(
    html,
    "aria-controls=\"menu\""
  )
  expect_match(
    html,
    "Open"
  )
})

test_that("extra classes are merged on root and trigger", {
  expect_match(
    as.character(bs_offcanvas(
      "o",
      class = "shadow"
    )),
    "offcanvas offcanvas-start shadow"
  )
  expect_match(
    as.character(bs_offcanvas_trigger(
      "o",
      "x",
      class = "btn-primary"
    )),
    "btn btn-primary"
  )
})

test_that("the bootstrict dependency travels with the offcanvas", {
  deps <- htmltools::findDependencies(bs_offcanvas(
    "o",
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
