test_that("bs_carousel renders faithful Bootstrap 5 markup", {
  html <- as.character(
    bs_carousel(
      "demo",
      bs_carousel_item(
        "Slide one"
      ),
      bs_carousel_item(
        "Slide two"
      )
    )
  )
  expect_match(
    html,
    "^<div"
  )
  expect_match(
    html,
    "id=\"demo\""
  )
  expect_match(
    html,
    "class=\"carousel slide\""
  )
  expect_match(
    html,
    "data-bootstrict=\"carousel\""
  )
  expect_match(
    html,
    "data-bs-ride=\"carousel\""
  )
  expect_match(
    html,
    "class=\"carousel-inner\""
  )
  expect_match(
    html,
    "Slide one"
  )
  expect_match(
    html,
    "Slide two"
  )
})

test_that("indicators render one button per item with correct targets", {
  html <- as.character(
    bs_carousel(
      "c",
      bs_carousel_item(
        "a"
      ),
      bs_carousel_item(
        "b"
      ),
      bs_carousel_item(
        "c"
      )
    )
  )
  expect_match(
    html,
    "class=\"carousel-indicators\""
  )
  expect_match(
    html,
    "data-bs-target=\"#c\""
  )
  expect_match(
    html,
    "data-bs-slide-to=\"0\""
  )
  expect_match(
    html,
    "data-bs-slide-to=\"1\""
  )
  expect_match(
    html,
    "data-bs-slide-to=\"2\""
  )
  expect_match(
    html,
    "aria-label=\"Slide 1\""
  )
  expect_match(
    html,
    "aria-label=\"Slide 3\""
  )
  # First indicator is active + aria-current.
  expect_match(
    html,
    "aria-current=\"true\""
  )
})

test_that("indicators can be disabled", {
  html <- as.character(
    bs_carousel(
      "c",
      bs_carousel_item(
        "a"
      ),
      indicators = FALSE
    )
  )
  expect_false(grepl(
    "carousel-indicators",
    html
  ))
})

test_that("controls render prev and next buttons", {
  html <- as.character(
    bs_carousel(
      "c",
      bs_carousel_item(
        "a"
      ),
      bs_carousel_item(
        "b"
      )
    )
  )
  expect_match(
    html,
    "carousel-control-prev"
  )
  expect_match(
    html,
    "carousel-control-prev-icon"
  )
  expect_match(
    html,
    "carousel-control-next"
  )
  expect_match(
    html,
    "carousel-control-next-icon"
  )
  expect_match(
    html,
    "data-bs-slide=\"prev\""
  )
  expect_match(
    html,
    "data-bs-slide=\"next\""
  )
  expect_match(
    html,
    "Previous"
  )
  expect_match(
    html,
    ">Next<"
  )
})

test_that("controls can be disabled", {
  html <- as.character(
    bs_carousel(
      "c",
      bs_carousel_item(
        "a"
      ),
      controls = FALSE
    )
  )
  expect_false(grepl(
    "carousel-control-prev",
    html
  ))
  expect_false(grepl(
    "carousel-control-next",
    html
  ))
})

test_that("fade and dark add their modifier classes", {
  html <- as.character(
    bs_carousel(
      "c",
      bs_carousel_item(
        "a"
      ),
      fade = TRUE,
      dark = TRUE
    )
  )
  expect_match(
    html,
    "carousel-fade"
  )
  expect_match(
    html,
    "carousel-dark"
  )
})

test_that("autoplay FALSE sets data-bs-ride to true", {
  html <- as.character(
    bs_carousel(
      "c",
      bs_carousel_item(
        "a"
      ),
      autoplay = FALSE
    )
  )
  expect_match(
    html,
    "data-bs-ride=\"true\""
  )
})

test_that("interval sets the data-bs-interval attribute", {
  html <- as.character(
    bs_carousel(
      "c",
      bs_carousel_item(
        "a"
      ),
      interval = 5000
    )
  )
  expect_match(
    html,
    "data-bs-interval=\"5000\""
  )
})

test_that("exactly one item is active, defaulting to the first", {
  html <- as.character(
    bs_carousel(
      "c",
      bs_carousel_item(
        "a"
      ),
      bs_carousel_item(
        "b"
      )
    )
  )
  expect_match(
    html,
    "carousel-item active"
  )
  # Only one active item.
  n_active <- length(gregexpr(
    "carousel-item active",
    html
  )[[
    1
  ]])
  expect_true(
    n_active ==
      1L
  )
})

test_that("an explicitly active item is honoured", {
  html <- as.character(
    bs_carousel(
      "c",
      bs_carousel_item(
        "a"
      ),
      bs_carousel_item(
        "b",
        active = TRUE
      )
    )
  )
  # The second item carries the active class; only one active total.
  expect_match(
    html,
    "carousel-item active"
  )
  n_active <- length(gregexpr(
    "carousel-item active",
    html
  )[[
    1
  ]])
  expect_true(
    n_active ==
      1L
  )
})

test_that("bs_carousel_item renders an item with optional caption and interval", {
  plain <- as.character(bs_carousel_item(
    "body"
  ))
  expect_match(
    plain,
    "class=\"carousel-item\""
  )
  expect_match(
    plain,
    "body"
  )
  expect_false(grepl(
    "carousel-caption",
    plain
  ))

  rich <- as.character(
    bs_carousel_item(
      "body",
      caption = "Hello",
      interval = 2000
    )
  )
  expect_match(
    rich,
    "carousel-caption d-none d-md-block"
  )
  expect_match(
    rich,
    "Hello"
  )
  expect_match(
    rich,
    "data-bs-interval=\"2000\""
  )
})

test_that("non-item children are rejected", {
  expect_error(bs_carousel(
    "c",
    htmltools::div(
      "nope"
    )
  ))
})

test_that("named ... become attributes on the root", {
  html <- as.character(
    bs_carousel(
      "c",
      bs_carousel_item(
        "a"
      ),
      `data-test` = "x"
    )
  )
  expect_match(
    html,
    "data-test=\"x\""
  )
})

test_that("the bootstrict dependency travels with the carousel", {
  deps <- htmltools::findDependencies(
    bs_carousel(
      "c",
      bs_carousel_item(
        "a"
      )
    )
  )
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
