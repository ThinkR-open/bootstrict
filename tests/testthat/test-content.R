# Tests for the `content` component group -----------------------------------

test_that("bs_table builds thead/tbody from a data frame", {
  df <- data.frame(
    a = c(
      1L,
      2L
    ),
    b = c(
      "x",
      "y"
    ),
    stringsAsFactors = FALSE
  )
  html <- as.character(bs_table(
    df
  ))
  expect_match(
    html,
    "<table class=\"table\""
  )
  expect_match(
    html,
    "<thead>"
  )
  expect_match(
    html,
    "<tbody>"
  )
  expect_match(
    html,
    "<th scope=\"col\">a</th>"
  )
  expect_match(
    html,
    "<th scope=\"col\">b</th>"
  )
  expect_match(
    html,
    "<td>1</td>"
  )
  expect_match(
    html,
    "<td>x</td>"
  )
})

test_that("bs_table applies all modifier classes", {
  html <- as.character(bs_table(
    data.frame(
      a = 1
    ),
    striped = TRUE,
    bordered = TRUE,
    borderless = TRUE,
    hover = TRUE,
    small = TRUE,
    variant = "dark",
    align = "middle"
  ))
  expect_match(
    html,
    "table-striped"
  )
  expect_match(
    html,
    "table-bordered"
  )
  expect_match(
    html,
    "table-borderless"
  )
  expect_match(
    html,
    "table-hover"
  )
  expect_match(
    html,
    "table-sm"
  )
  expect_match(
    html,
    "table-dark"
  )
  expect_match(
    html,
    "align-middle"
  )
})

test_that("bs_table responsive wraps and supports breakpoints", {
  resp <- as.character(bs_table(
    data.frame(
      a = 1
    ),
    responsive = TRUE
  ))
  expect_match(
    resp,
    "<div class=\"table-responsive\">"
  )

  bp <- as.character(bs_table(
    data.frame(
      a = 1
    ),
    responsive = "lg"
  ))
  expect_match(
    bp,
    "<div class=\"table-responsive-lg\">"
  )
})

test_that("bs_table renders caption and accepts manual children", {
  cap <- as.character(bs_table(
    data.frame(
      a = 1
    ),
    caption = "My caption"
  ))
  expect_match(
    cap,
    "<caption>My caption</caption>"
  )

  manual <- as.character(bs_table(
    data = NULL,
    htmltools::tags$tbody(htmltools::tags$tr(htmltools::tags$td(
      "z"
    )))
  ))
  expect_match(
    manual,
    "<td>z</td>"
  )
  expect_false(grepl(
    "<thead>",
    manual
  ))
})

test_that("bs_table rejects an invalid variant", {
  expect_error(bs_table(
    data.frame(
      a = 1
    ),
    variant = "nope"
  ))
})

test_that("bs_img sets image classes", {
  html <- as.character(bs_img(
    "logo.png",
    alt = "Logo",
    fluid = TRUE,
    thumbnail = TRUE,
    rounded = TRUE
  ))
  expect_match(
    html,
    "<img"
  )
  expect_match(
    html,
    "src=\"logo.png\""
  )
  expect_match(
    html,
    "alt=\"Logo\""
  )
  expect_match(
    html,
    "img-fluid"
  )
  expect_match(
    html,
    "img-thumbnail"
  )
  expect_match(
    html,
    "rounded"
  )
})

test_that("bs_figure and helpers build figure markup", {
  html <- as.character(bs_figure(
    bs_figure_img(
      "p.jpg",
      alt = "A photo"
    ),
    bs_figure_caption(
      "Caption text"
    )
  ))
  expect_match(
    html,
    "<figure class=\"figure\">"
  )
  expect_match(
    html,
    "class=\"figure-img img-fluid rounded\""
  )
  expect_match(
    html,
    "<figcaption class=\"figure-caption\">Caption text</figcaption>"
  )
})

test_that("bs_blockquote wraps in figure and adds footer when given", {
  with_footer <- as.character(bs_blockquote(
    "A quote.",
    footer = "Author"
  ))
  expect_match(
    with_footer,
    "<figure>"
  )
  expect_match(
    with_footer,
    "<blockquote class=\"blockquote\">"
  )
  expect_match(
    with_footer,
    "<figcaption class=\"blockquote-footer\">Author</figcaption>"
  )

  no_footer <- as.character(bs_blockquote(
    "A quote."
  ))
  expect_false(grepl(
    "blockquote-footer",
    no_footer
  ))
})

test_that("bs_display_heading uses the requested level", {
  html <- as.character(bs_display_heading(
    "Big",
    level = 2
  ))
  expect_match(
    html,
    "<h2 class=\"display-2\">Big</h2>"
  )
})

test_that("bs_lead adds the lead class", {
  html <- as.character(bs_lead(
    "Intro paragraph"
  ))
  expect_match(
    html,
    "<p class=\"lead\">Intro paragraph</p>"
  )
})

test_that("bs_list_unstyled wraps each child in an <li>", {
  html <- as.character(bs_list_unstyled(
    "First",
    "Second"
  ))
  expect_match(
    html,
    "<ul class=\"list-unstyled\">"
  )
  expect_match(
    html,
    "<li>First</li>"
  )
  expect_match(
    html,
    "<li>Second</li>"
  )
})

test_that("bs_list_inline wraps each child in an inline-item <li>", {
  html <- as.character(bs_list_inline(
    "One",
    "Two"
  ))
  expect_match(
    html,
    "<ul class=\"list-inline\">"
  )
  expect_match(
    html,
    "<li class=\"list-inline-item\">One</li>"
  )
  expect_match(
    html,
    "<li class=\"list-inline-item\">Two</li>"
  )
})

test_that("named ... become attributes on list containers", {
  html <- as.character(bs_list_unstyled(
    "X",
    id = "mylist"
  ))
  expect_match(
    html,
    "id=\"mylist\""
  )
  expect_match(
    html,
    "<li>X</li>"
  )
})
