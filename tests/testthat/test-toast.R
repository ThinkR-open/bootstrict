test_that("bs_toast renders faithful Bootstrap 5 markup", {
  html <- as.character(bs_toast(
    "hello",
    "Hello, world!"
  ))
  expect_match(
    html,
    "^<div"
  )
  expect_match(
    html,
    "id=\"hello\""
  )
  expect_match(
    html,
    "class=\"toast\""
  )
  expect_match(
    html,
    "role=\"alert\""
  )
  expect_match(
    html,
    "aria-live=\"assertive\""
  )
  expect_match(
    html,
    "aria-atomic=\"true\""
  )
  expect_match(
    html,
    "data-bootstrict=\"toast\""
  )
  expect_match(
    html,
    "class=\"toast-body\""
  )
  expect_match(
    html,
    "Hello, world!"
  )
})

test_that("title produces a header with the title, strong + close button", {
  html <- as.character(bs_toast(
    "t",
    "Body",
    title = "Heads up"
  ))
  expect_match(
    html,
    "class=\"toast-header\""
  )
  expect_match(
    html,
    "<strong class=\"me-auto\">Heads up</strong>"
  )
  expect_match(
    html,
    "btn-close"
  )
  expect_match(
    html,
    "data-bs-dismiss=\"toast\""
  )
})

test_that("no header is rendered when title is NULL", {
  html <- as.character(bs_toast(
    "t",
    "Just a body"
  ))
  expect_false(grepl(
    "toast-header",
    html
  ))
})

test_that("icon is placed in the header before the title", {
  html <- as.character(
    bs_toast(
      "t",
      "Body",
      title = "Hi",
      icon = htmltools::tags$i(
        class = "bi"
      )
    )
  )
  expect_match(
    html,
    "<i class=\"bi\"></i>"
  )
  # icon comes before the strong title
  expect_lt(
    regexpr(
      "class=\"bi\"",
      html
    ),
    regexpr(
      "me-auto",
      html
    )
  )
})

test_that("autohide, delay and animation drive data attributes", {
  # defaults: autohide TRUE -> no flag, animation TRUE -> no flag, delay present
  default <- as.character(bs_toast(
    "t",
    "x"
  ))
  expect_match(
    default,
    "data-bs-delay=\"5000\""
  )
  expect_false(grepl(
    "data-bs-autohide",
    default
  ))
  expect_false(grepl(
    "data-bs-animation",
    default
  ))

  off <- as.character(
    bs_toast(
      "t",
      "x",
      autohide = FALSE,
      animation = FALSE,
      delay = 2000
    )
  )
  expect_match(
    off,
    "data-bs-autohide=\"false\""
  )
  expect_match(
    off,
    "data-bs-animation=\"false\""
  )
  expect_match(
    off,
    "data-bs-delay=\"2000\""
  )
})

test_that("named ... become attributes and unnamed ... become body content", {
  html <- as.character(bs_toast(
    "t",
    "Body bit",
    `data-x` = "y"
  ))
  expect_match(
    html,
    "data-x=\"y\""
  )
  expect_match(
    html,
    "Body bit"
  )
})

test_that("bs_toast_container renders a fixed-position container", {
  html <- as.character(bs_toast_container(
    placement = "top-end"
  ))
  expect_match(
    html,
    "class=\"toast-container position-fixed p-3 top-0 end-0\""
  )
})

test_that("toast container placement keywords map to position utilities", {
  expect_match(
    as.character(bs_toast_container(
      placement = "top-start"
    )),
    "top-0 start-0"
  )
  expect_match(
    as.character(bs_toast_container(
      placement = "top-center"
    )),
    "top-0 start-50 translate-middle-x"
  )
  expect_match(
    as.character(bs_toast_container(
      placement = "middle-center"
    )),
    "top-50 start-50 translate-middle"
  )
  expect_match(
    as.character(bs_toast_container(
      placement = "bottom-start"
    )),
    "bottom-0 start-0"
  )
  expect_match(
    as.character(bs_toast_container(
      placement = "bottom-end"
    )),
    "bottom-0 end-0"
  )
})

test_that("invalid placement is rejected", {
  expect_error(bs_toast_container(
    placement = "nowhere"
  ))
})

test_that("a container nests its toasts", {
  html <- as.character(
    bs_toast_container(
      bs_toast(
        "a",
        "First",
        title = "One"
      ),
      placement = "bottom-end"
    )
  )
  expect_match(
    html,
    "toast-container"
  )
  expect_match(
    html,
    "id=\"a\""
  )
  expect_match(
    html,
    "First"
  )
})

test_that("the bootstrict dependency travels with the toast and container", {
  for (tag in list(
    bs_toast(
      "t",
      "x"
    ),
    bs_toast_container()
  )) {
    deps <- htmltools::findDependencies(
      tag
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
  }
})
