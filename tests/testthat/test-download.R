render <- function(
  x
)
  as.character(
    x
  )

# --- bs_download_button ------------------------------------------------------

test_that("bs_download_button drops shiny's Bootstrap 3 .btn-default", {
  html <- render(
    bs_download_button(
      "report"
    )
  )
  expect_false(grepl(
    "btn-default",
    html,
    fixed = TRUE
  ))
  expect_match(
    html,
    "btn-primary"
  )
})

test_that("bs_download_button keeps shiny's download plumbing intact", {
  tag <- bs_download_button(
    "report",
    "Download CSV"
  )
  html <- render(
    tag
  )
  expect_match(
    html,
    'id="report"'
  )
  expect_match(
    html,
    "shiny-download-link"
  )
  expect_match(
    html,
    'target="_blank"'
  )
  expect_match(
    html,
    "Download CSV"
  )
  expect_false(is.null(htmltools::tagGetAttribute(
    tag,
    "download"
  )))
  expect_equal(
    htmltools::tagGetAttribute(
      tag,
      "href"
    ),
    ""
  )
})

test_that("bs_download_button keeps shiny's auto-enable dance", {
  # shiny renders the anchor disabled and its client enables it once the
  # matching downloadHandler() is registered -- we must not undo that. The
  # mechanism only exists in shiny versions exposing `enabled`.
  skip_if_not(
    "enabled" %in%
      names(formals(
        shiny::downloadButton
      ))
  )
  tag <- bs_download_button(
    "report"
  )
  expect_match(
    htmltools::tagGetAttribute(
      tag,
      "class"
    ),
    "disabled"
  )
  expect_equal(
    htmltools::tagGetAttribute(
      tag,
      "aria-disabled"
    ),
    "true"
  )
})

test_that("bs_download_button honours color, outline, size and class", {
  html <- render(
    bs_download_button(
      "report",
      color = "secondary",
      outline = TRUE,
      size = "lg",
      class = "w-100"
    )
  )
  expect_match(
    html,
    "btn-outline-secondary"
  )
  expect_match(
    html,
    "btn-lg"
  )
  expect_match(
    html,
    "w-100"
  )
  expect_false(grepl(
    "btn-secondary\\b",
    html
  ))
})

test_that("bs_download_button color = 'link' never becomes an outline", {
  html <- render(
    bs_download_button(
      "report",
      color = "link",
      outline = TRUE
    )
  )
  expect_match(
    html,
    "btn-link"
  )
  expect_false(grepl(
    "btn-outline",
    html,
    fixed = TRUE
  ))
})

test_that("bs_download_button renders no icon by default and forwards ...", {
  plain <- render(
    bs_download_button(
      "report"
    )
  )
  expect_false(grepl(
    "<i ",
    plain,
    fixed = TRUE
  ))

  html <- render(
    bs_download_button(
      "report",
      icon = htmltools::tags$span(
        class = "me-1",
        "*"
      ),
      `data-testid` = "dl"
    )
  )
  expect_match(
    html,
    'data-testid="dl"'
  )
  expect_match(
    html,
    "me-1"
  )
})

test_that("bs_download_button rejects an unknown colour", {
  expect_error(
    bs_download_button(
      "report",
      color = "nope"
    )
  )
  expect_error(
    bs_download_button(
      "report",
      color = NULL
    )
  )
})

# --- bs_download_link --------------------------------------------------------

test_that("bs_download_link renders shiny's link markup with .link-* colour", {
  html <- render(
    bs_download_link(
      "report",
      "Raw data",
      color = "danger"
    )
  )
  expect_match(
    html,
    'id="report"'
  )
  expect_match(
    html,
    "shiny-download-link"
  )
  expect_match(
    html,
    "link-danger"
  )
  expect_match(
    html,
    "Raw data"
  )
  expect_false(grepl(
    "btn",
    html,
    fixed = TRUE
  ))
})

test_that("bs_download_link colour is optional and class is forwarded", {
  html <- render(
    bs_download_link(
      "report",
      class = "fw-bold"
    )
  )
  expect_false(grepl(
    "link-",
    html,
    fixed = TRUE
  ))
  expect_match(
    html,
    "fw-bold"
  )
  expect_error(
    bs_download_link(
      "report",
      color = "nope"
    )
  )
})

# --- dependency --------------------------------------------------------------

test_that("download constructors carry the bootstrict dependency", {
  expect_true(
    length(htmltools::findDependencies(
      bs_download_button(
        "report"
      )
    )) >
      0L
  )
  expect_true(
    length(htmltools::findDependencies(
      bs_download_link(
        "report"
      )
    )) >
      0L
  )
})
