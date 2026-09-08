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

test_that("lists pass explicit <li> children through instead of nesting them", {
  # The content vignette documents passing tags$li() for richer items. Wrapping
  # them produced <li><li>...</li></li>; the HTML parser closes the outer item
  # at the inner start tag, so the item that survives carries none of the
  # list's classes and .list-inline breaks.
  expect_equal(
    as.character(bs_list_unstyled(
      htmltools::tags$li(
        "x"
      ),
      htmltools::tags$li(
        "y"
      )
    )),
    "<ul class=\"list-unstyled\">\n  <li>x</li>\n  <li>y</li>\n</ul>"
  )

  # bs_list_inline() still adds its class, merged with the item's own.
  expect_match(
    as.character(bs_list_inline(
      htmltools::tags$li(
        class = "extra",
        "x"
      )
    )),
    "<li class=\"extra list-inline-item\">x</li>",
    fixed = TRUE
  )

  # Bare children are still wrapped.
  expect_match(
    as.character(bs_list_inline(
      "One",
      "Two"
    )),
    "<li class=\"list-inline-item\">One</li>",
    fixed = TRUE
  )
})

test_that("lists expand lapply()-built children", {
  # A list child used to be wrapped whole in a single <li>.
  expect_equal(
    length(gregexpr(
      "<li>",
      as.character(bs_list_unstyled(lapply(
        1:3,
        function(
          i
        )
          htmltools::tags$li(
            i
          )
      )))
    )[[
      1
    ]]),
    3L
  )
  expect_match(
    as.character(bs_list_unstyled(htmltools::tagList(htmltools::tags$li(
      "x"
    )))),
    "<li>x</li>",
    fixed = TRUE
  )
})

test_that("bs_table reads the column, not a 1x1 frame", {
  skip_if_not_installed(
    "tibble"
  )
  # `data[i, j]` keeps a 1x1 tibble, so as.character() rendered the underlying
  # storage: a factor as its integer code, a Date as its day number.
  out <- as.character(bs_table(tibble::tibble(
    f = factor(c(
      "a",
      "b"
    )),
    d = as.Date(c(
      "2020-01-01",
      "2020-02-01"
    ))
  )))
  expect_match(
    out,
    "<td>a</td>",
    fixed = TRUE
  )
  expect_match(
    out,
    "<td>2020-01-01</td>",
    fixed = TRUE
  )
  expect_no_match(
    out,
    "<td>18262</td>",
    fixed = TRUE
  )
})

test_that("bs_table formats numbers the way a reader expects", {
  out <- as.character(bs_table(data.frame(
    x = c(
      100000,
      1e6,
      1 /
        3
    )
  )))
  expect_match(
    out,
    "<td>100000</td>",
    fixed = TRUE
  )
  expect_no_match(
    out,
    "1e+05",
    fixed = TRUE
  )
  expect_no_match(
    out,
    "0.333333333333333",
    fixed = TRUE
  )
  # NA still renders as an empty cell.
  expect_match(
    as.character(bs_table(data.frame(
      x = c(
        NA,
        1
      )
    ))),
    "<td></td>",
    fixed = TRUE
  )
})

test_that("bs_table keeps real row names as the reference row header", {
  skip_if_not_installed(
    "tibble"
  )
  out <- as.character(bs_table(head(
    mtcars,
    2
  )[,
    1,
    drop = FALSE
  ]))
  expect_match(
    out,
    "<th scope=\"row\">Mazda RX4</th>",
    fixed = TRUE
  )

  # Automatic row names (a tibble, a fresh data.frame) are not row headers...
  expect_no_match(
    as.character(bs_table(tibble::tibble(
      a = 1:2
    ))),
    "scope=\"row\"",
    fixed = TRUE
  )
  # ...unless asked for, and then the rows are numbered as in the docs.
  expect_match(
    as.character(bs_table(
      tibble::tibble(
        a = 1:2
      ),
      rownames = TRUE
    )),
    "<th scope=\"row\">1</th>",
    fixed = TRUE
  )
  expect_no_match(
    as.character(bs_table(
      head(
        mtcars,
        1
      )[,
        1,
        drop = FALSE
      ],
      rownames = FALSE
    )),
    "scope=\"row\"",
    fixed = TRUE
  )
})

test_that("bs_table covers the accented-table surface", {
  d <- data.frame(
    a = 1:3,
    b = c(
      "x",
      "y",
      "z"
    )
  )
  out <- as.character(bs_table(
    d,
    rownames = FALSE,
    striped = "columns",
    head_variant = "dark",
    group_divider = TRUE,
    row_variant = c(
      NA,
      "success",
      "active"
    ),
    caption = "Cap",
    caption_top = TRUE
  ))
  expect_match(
    out,
    "class=\"table table-striped-columns caption-top\""
  )
  expect_match(
    out,
    "<thead class=\"table-dark\">"
  )
  expect_match(
    out,
    "<tbody class=\"table-group-divider\">"
  )
  expect_match(
    out,
    "<tr class=\"table-success\">"
  )
  expect_match(
    out,
    "<tr class=\"table-active\">"
  )
  # An NA row is left unstyled, not given a class that does not exist.
  expect_no_match(
    out,
    "table-NA",
    fixed = TRUE
  )

  # striped stays a switch as well as a choice.
  expect_match(
    as.character(bs_table(
      d,
      striped = TRUE
    )),
    "class=\"table table-striped\""
  )
  expect_no_match(
    as.character(bs_table(
      d
    )),
    "table-striped",
    fixed = TRUE
  )
})

test_that("bs_table validates its new arguments", {
  d <- data.frame(
    a = 1
  )
  expect_error(
    bs_table(
      d,
      striped = "bogus"
    ),
    "`striped` must be one of"
  )
  expect_error(
    bs_table(
      d,
      head_variant = "bogus"
    ),
    "`head_variant` must be"
  )
  expect_error(
    bs_table(
      d,
      row_variant = "bogus"
    ),
    "theme colour"
  )
  # A single variant is recycled across the rows.
  expect_equal(
    length(gregexpr(
      "table-info",
      as.character(bs_table(
        data.frame(
          a = 1:2
        ),
        row_variant = "info"
      ))
    )[[
      1
    ]]),
    2L
  )
})
