test_that("bs_tooltip decorates a tag with the right data attributes", {
  out <- as.character(bs_tooltip(
    shiny::tags$button(
      "Hover me"
    ),
    "Tooltip text",
    placement = "bottom"
  ))
  expect_match(
    out,
    "data-bs-toggle=\"tooltip\""
  )
  # Bootstrap 5.3 idiom: data-bs-title, and no bare `title` attribute (which
  # would flash the native browser tooltip).
  expect_match(
    out,
    "data-bs-title=\"Tooltip text\""
  )
  expect_no_match(
    out,
    " title=\"Tooltip text\""
  )
  expect_match(
    out,
    "data-bs-placement=\"bottom\""
  )
  expect_match(
    out,
    "data-bootstrict-tip=\"tooltip\""
  )
})

test_that("bs_tooltip honours html and trigger options", {
  out <- as.character(bs_tooltip(
    shiny::tags$span(
      "x"
    ),
    "<b>hi</b>",
    html = TRUE,
    trigger = "click"
  ))
  expect_match(
    out,
    "data-bs-html=\"true\""
  )
  expect_match(
    out,
    "data-bs-trigger=\"click\""
  )

  plain <- as.character(bs_tooltip(
    shiny::tags$span(
      "x"
    ),
    "hi"
  ))
  expect_false(grepl(
    "data-bs-html",
    plain
  ))
  expect_false(grepl(
    "data-bs-trigger",
    plain
  ))
})

test_that("bs_tooltip rejects an invalid placement", {
  expect_error(bs_tooltip(
    shiny::tags$span(
      "x"
    ),
    "hi",
    placement = "diagonal"
  ))
})

test_that("bs_popover decorates a tag with the right data attributes", {
  out <- as.character(bs_popover(
    shiny::tags$button(
      "Click me"
    ),
    "Popover body",
    title = "Heads up"
  ))
  expect_match(
    out,
    "data-bs-toggle=\"popover\""
  )
  expect_match(
    out,
    "data-bs-content=\"Popover body\""
  )
  expect_match(
    out,
    "data-bs-title=\"Heads up\""
  )
  expect_match(
    out,
    "data-bs-placement=\"right\""
  )
  expect_match(
    out,
    "data-bs-trigger=\"click\""
  )
  expect_match(
    out,
    "data-bootstrict-tip=\"popover\""
  )
})

test_that("bs_popover html flag is opt-in", {
  with_html <- as.character(
    bs_popover(
      shiny::tags$span(
        "x"
      ),
      "body",
      html = TRUE
    )
  )
  expect_match(
    with_html,
    "data-bs-html=\"true\""
  )

  without_html <- as.character(bs_popover(
    shiny::tags$span(
      "x"
    ),
    "body"
  ))
  expect_false(grepl(
    "data-bs-html",
    without_html
  ))
})

test_that("bs_scrollspy builds the expected container", {
  out <- as.character(bs_scrollspy(
    "nav-menu",
    shiny::tags$h4(
      "Section"
    ),
    offset = 100
  ))
  expect_match(
    out,
    "data-bs-spy=\"scroll\""
  )
  expect_match(
    out,
    "data-bs-target=\"#nav-menu\""
  )
  expect_match(
    out,
    "data-bs-offset=\"100\""
  )
  expect_match(
    out,
    "data-bs-smooth-scroll=\"true\""
  )
  expect_match(
    out,
    "tabindex=\"0\""
  )
  expect_match(
    out,
    "<h4>Section</h4>"
  )
})

test_that("bs_scrollspy can disable smooth scrolling", {
  out <- as.character(bs_scrollspy(
    "nav",
    "content",
    smooth = FALSE
  ))
  expect_false(grepl(
    "data-bs-smooth-scroll",
    out
  ))
})

test_that("bs_visually_hidden renders a visually-hidden span", {
  out <- as.character(bs_visually_hidden(
    "Loading"
  ))
  expect_match(
    out,
    "<span class=\"visually-hidden\""
  )
  expect_match(
    out,
    "Loading"
  )
})

test_that("bs_ratio renders a fixed aspect-ratio wrapper", {
  out <- as.character(bs_ratio(
    shiny::tags$iframe(
      src = "x"
    ),
    ratio = "4x3"
  ))
  expect_match(
    out,
    "class=\"ratio ratio-4x3\""
  )
  expect_true(grepl(
    "<iframe",
    out
  ))
})

test_that("bs_ratio rejects an unknown ratio", {
  expect_error(bs_ratio(
    ratio = "3x2"
  ))
})

test_that("bs_vr renders a vertical rule", {
  out <- as.character(bs_vr())
  expect_match(
    out,
    "class=\"vr\""
  )

  out2 <- as.character(bs_vr(
    class = "mx-2"
  ))
  expect_match(
    out2,
    "vr"
  )
  expect_match(
    out2,
    "mx-2"
  )
})

test_that("bs_tooltip leaves an existing data-API trigger untouched", {
  # Decorating an offcanvas/modal/collapse trigger must not append a second
  # data-bs-toggle value ("offcanvas tooltip"), which Bootstrap's exact
  # [data-bs-toggle="offcanvas"] selector would no longer match.
  out <- as.character(bs_tooltip(
    bs_offcanvas_trigger(
      "filters",
      "Filters"
    ),
    "Open the filter drawer"
  ))
  expect_match(
    out,
    "data-bs-toggle=\"offcanvas\""
  )
  expect_no_match(
    out,
    "offcanvas tooltip"
  )
  # The tooltip still initialises (marker + title present).
  expect_match(
    out,
    "data-bootstrict-tip=\"tooltip\""
  )
  expect_match(
    out,
    "data-bs-title=\"Open the filter drawer\""
  )
})

test_that("bs_popover leaves an existing data-API trigger untouched", {
  out <- as.character(bs_popover(
    bs_modal_trigger(
      "info",
      "Details"
    ),
    "Popover body"
  ))
  expect_match(
    out,
    "data-bs-toggle=\"modal\""
  )
  expect_no_match(
    out,
    "modal popover"
  )
  expect_match(
    out,
    "data-bootstrict-tip=\"popover\""
  )
})
