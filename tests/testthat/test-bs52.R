# Bootstrap 5.1 / 5.2 additions: stacks, responsive offcanvas,
# .form-check-reverse, .navbar-nav-scroll.

render <- function(
  x
)
  as.character(
    x
  )

test_that("stacks render hstack / vstack with gap", {
  expect_match(
    render(bs_hstack(
      gap = 2
    )),
    "hstack gap-2"
  )
  expect_match(
    render(bs_vstack(
      gap = 3
    )),
    "vstack gap-3"
  )
  expect_match(
    render(bs_hstack()),
    "hstack"
  )
  expect_true(any(vapply(
    htmltools::findDependencies(bs_hstack()),
    function(
      d
    )
      identical(
        d$name,
        "bootstrict"
      ),
    logical(
      1
    )
  )))
})

test_that("responsive offcanvas uses offcanvas-{bp} instead of plain .offcanvas", {
  out <- render(bs_offcanvas(
    "nav",
    "x",
    responsive = "lg",
    placement = "end"
  ))
  expect_match(
    out,
    "offcanvas-lg"
  )
  expect_match(
    out,
    "offcanvas-end"
  )
  # plain `.offcanvas` (followed by space/quote) must be absent
  expect_false(grepl(
    'class="offcanvas ',
    out
  ))
  # a non-responsive offcanvas keeps the plain base class
  expect_match(
    render(bs_offcanvas(
      "n2",
      "x"
    )),
    "offcanvas offcanvas-start"
  )
})

test_that("form-check-reverse flows through checkbox / switch / radio / group", {
  expect_match(
    render(bs_checkbox_input(
      "c",
      "x",
      reverse = TRUE
    )),
    "form-check form-check-reverse"
  )
  expect_match(
    render(bs_switch_input(
      "s",
      "x",
      reverse = TRUE
    )),
    "form-check form-switch form-check-reverse"
  )
  expect_match(
    render(bs_radio_input(
      "r",
      "x",
      c(
        "a",
        "b"
      ),
      reverse = TRUE
    )),
    "form-check-reverse"
  )
  expect_match(
    render(bs_checkbox_group_input(
      "g",
      "x",
      c(
        "a",
        "b"
      ),
      reverse = TRUE
    )),
    "form-check-reverse"
  )
})

test_that("navbar-nav-scroll adds class and scroll-height var", {
  out <- render(bs_navbar_nav(
    scroll = TRUE,
    scroll_height = "75vh"
  ))
  expect_match(
    out,
    "navbar-nav-scroll"
  )
  expect_match(
    out,
    "--bs-scroll-height: 75vh"
  )
  # off by default
  expect_false(grepl(
    "navbar-nav-scroll",
    render(bs_navbar_nav())
  ))
})
