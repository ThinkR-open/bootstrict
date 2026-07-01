test_that("bs_progress renders a progress container", {
  html <- as.character(bs_progress(bs_progress_bar(
    value = 25
  )))
  expect_match(
    html,
    "class=\"progress\""
  )
  expect_match(
    html,
    "role=\"progressbar\""
  )
})

test_that("bs_progress applies a height style", {
  html <- as.character(bs_progress(
    bs_progress_bar(
      value = 0
    ),
    height = "20px"
  ))
  expect_match(
    html,
    "height: 20px"
  )
})

test_that("bs_progress forwards named attrs and unnamed children", {
  html <- as.character(
    bs_progress(
      bs_progress_bar(
        value = 10
      ),
      id = "track",
      class = "mb-3"
    )
  )
  expect_match(
    html,
    "id=\"track\""
  )
  expect_match(
    html,
    "class=\"progress mb-3\""
  )
  expect_match(
    html,
    "progress-bar"
  )
})

test_that("bs_progress_bar computes width percentage from value/min/max", {
  html <- as.character(bs_progress_bar(
    value = 25
  ))
  expect_match(
    html,
    "width: 25%"
  )
  expect_match(
    html,
    "aria-valuenow=\"25\""
  )
  expect_match(
    html,
    "aria-valuemin=\"0\""
  )
  expect_match(
    html,
    "aria-valuemax=\"100\""
  )

  scaled <- as.character(bs_progress_bar(
    value = 30,
    min = 10,
    max = 50
  ))
  # (30 - 10) / (50 - 10) = 50%
  expect_match(
    scaled,
    "width: 50%"
  )
  expect_match(
    scaled,
    "aria-valuemin=\"10\""
  )
  expect_match(
    scaled,
    "aria-valuemax=\"50\""
  )
})

test_that("bs_progress_bar carries faithful BS5 markup", {
  html <- as.character(bs_progress_bar(
    value = 40,
    id = "b1",
    label = "40%"
  ))
  expect_match(
    html,
    "class=\"progress-bar\""
  )
  expect_match(
    html,
    "id=\"b1\""
  )
  expect_match(
    html,
    "role=\"progressbar\""
  )
  expect_match(
    html,
    ">40%<"
  )
})

test_that("bs_progress_bar applies colour, striped and animated modifiers", {
  html <- as.character(
    bs_progress_bar(
      value = 60,
      color = "success",
      striped = TRUE,
      animated = TRUE
    )
  )
  expect_match(
    html,
    "bg-success"
  )
  expect_match(
    html,
    "progress-bar-striped"
  )
  expect_match(
    html,
    "progress-bar-animated"
  )
})

test_that("bs_progress_bar animated implies striped", {
  html <- as.character(bs_progress_bar(
    value = 10,
    animated = TRUE,
    striped = FALSE
  ))
  expect_match(
    html,
    "progress-bar-striped"
  )
  expect_match(
    html,
    "progress-bar-animated"
  )
})

test_that("bs_progress_bar validates the colour", {
  expect_error(bs_progress_bar(
    value = 10,
    color = "not-a-color"
  ))
})

test_that("bs_progress_bar forwards extra named attributes", {
  html <- as.character(bs_progress_bar(
    value = 10,
    `data-foo` = "bar"
  ))
  expect_match(
    html,
    "data-foo=\"bar\""
  )
})

test_that("bs_progress attaches the bootstrict dependency", {
  tag <- bs_progress(bs_progress_bar(
    value = 0
  ))
  deps <- htmltools::findDependencies(
    tag
  )
  expect_true(
    length(
      deps
    ) >
      0
  )
  expect_true(any(vapply(
    deps,
    function(
      d
    )
      d$name ==
        "bootstrict",
    logical(
      1
    )
  )))
})

test_that("update_bs_progress requires a session", {
  expect_error(update_bs_progress(
    "b1",
    value = 50,
    session = NULL
  ))
})
