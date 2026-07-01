test_that("bs_navbar renders nav.navbar with default expand-lg and container-fluid", {
  html <- as.character(bs_navbar())
  expect_match(
    html,
    "<nav"
  )
  expect_match(
    html,
    "class=\"navbar navbar-expand-lg\""
  )
  # default id is auto-generated and unique (navbar-<n>)
  expect_match(
    html,
    "id=\"navbar-[0-9]+\""
  )
  expect_match(
    html,
    "class=\"container-fluid\"",
    fixed = TRUE
  )
})

test_that("two default navbars get distinct collapse ids (no collision)", {
  a <- as.character(bs_navbar())
  b <- as.character(bs_navbar())
  id_a <- regmatches(
    a,
    regexpr(
      "navbar-collapse\" id=\"[^\"]+\"",
      a
    )
  )
  id_b <- regmatches(
    b,
    regexpr(
      "navbar-collapse\" id=\"[^\"]+\"",
      b
    )
  )
  expect_false(identical(
    id_a,
    id_b
  ))
})

test_that("bs_navbar wires the toggler to the collapse region by id", {
  html <- as.character(bs_navbar(
    id = "main"
  ))
  expect_match(
    html,
    "class=\"navbar-toggler\""
  )
  expect_match(
    html,
    "data-bs-toggle=\"collapse\""
  )
  expect_match(
    html,
    "data-bs-target=\"#main-collapse\""
  )
  expect_match(
    html,
    "aria-controls=\"main-collapse\""
  )
  expect_match(
    html,
    "aria-expanded=\"false\""
  )
  expect_match(
    html,
    "aria-label=\"Toggle navigation\""
  )
  expect_match(
    html,
    "<span class=\"navbar-toggler-icon\"></span>"
  )
})

test_that("bs_navbar builds the collapsible region with id <id>-collapse", {
  html <- as.character(bs_navbar(
    id = "main"
  ))
  expect_match(
    html,
    "class=\"collapse navbar-collapse\" id=\"main-collapse\""
  )
})

test_that("bs_navbar places children inside the collapse region", {
  html <- as.character(bs_navbar(htmltools::span(
    "inner",
    class = "marker"
  )))
  expect_match(
    html,
    "navbar-collapse"
  )
  expect_match(
    html,
    "<span class=\"marker\">inner</span>"
  )
})

test_that("bs_navbar renders the brand before the toggler", {
  html <- as.character(bs_navbar(
    brand = bs_navbar_brand(
      "Acme"
    )
  ))
  expect_match(
    html,
    "navbar-brand"
  )
  expect_lt(
    regexpr(
      "navbar-brand",
      html
    ),
    regexpr(
      "navbar-toggler",
      html
    )
  )
})

test_that("bs_navbar applies bg, theme and placement", {
  html <- as.character(
    bs_navbar(
      bg = "dark",
      theme = "dark",
      placement = "fixed-top"
    )
  )
  expect_match(
    html,
    "bg-dark"
  )
  expect_match(
    html,
    "fixed-top"
  )
  expect_match(
    html,
    "data-bs-theme=\"dark\""
  )
})

test_that("bs_navbar expand = TRUE yields navbar-expand and FALSE yields none", {
  expect_match(
    as.character(bs_navbar(
      expand = TRUE
    )),
    "navbar navbar-expand\""
  )
  html <- as.character(bs_navbar(
    expand = FALSE
  ))
  expect_false(grepl(
    "navbar-expand",
    html
  ))
})

test_that("bs_navbar fluid = FALSE uses .container", {
  html <- as.character(bs_navbar(
    fluid = FALSE
  ))
  expect_match(
    html,
    "class=\"container\"",
    fixed = TRUE
  )
  expect_false(grepl(
    "container-fluid",
    html
  ))
})

test_that("bs_navbar forwards named ... as attributes and extra class to nav", {
  html <- as.character(bs_navbar(
    class = "shadow",
    `aria-label` = "Main"
  ))
  expect_match(
    html,
    "shadow"
  )
  expect_match(
    html,
    "aria-label=\"Main\""
  )
})

test_that("bs_navbar rejects invalid bg, theme, placement and expand", {
  expect_error(bs_navbar(
    bg = "purple"
  ))
  expect_error(bs_navbar(
    theme = "blue"
  ))
  expect_error(bs_navbar(
    placement = "middle"
  ))
  expect_error(bs_navbar(
    expand = "huge"
  ))
})

test_that("bs_navbar_brand renders an anchor with href", {
  html <- as.character(bs_navbar_brand(
    "Acme",
    href = "/home"
  ))
  expect_match(
    html,
    "<a class=\"navbar-brand\" href=\"/home\">Acme</a>"
  )
})

test_that("bs_navbar_brand defaults href to # and accepts extra class", {
  html <- as.character(bs_navbar_brand(
    "X",
    class = "fw-bold"
  ))
  expect_match(
    html,
    "href=\"#\""
  )
  expect_match(
    html,
    "fw-bold"
  )
})

test_that("bs_navbar_nav renders ul.navbar-nav and keeps children", {
  html <- as.character(
    bs_navbar_nav(htmltools::tags$li(
      "item",
      class = "nav-item"
    ))
  )
  expect_match(
    html,
    "<ul class=\"navbar-nav\""
  )
  expect_match(
    html,
    "<li class=\"nav-item\">item</li>"
  )
})

test_that("bs_navbar_nav forwards named ... and extra class", {
  html <- as.character(bs_navbar_nav(
    class = "me-auto",
    id = "menu"
  ))
  expect_match(
    html,
    "navbar-nav me-auto"
  )
  expect_match(
    html,
    "id=\"menu\""
  )
})

test_that("bs_navbar_text renders span.navbar-text", {
  html <- as.character(bs_navbar_text(
    "Signed in"
  ))
  expect_match(
    html,
    "<span class=\"navbar-text\">Signed in</span>"
  )
})

test_that("bs_navbar_text accepts extra class and named ...", {
  html <- as.character(bs_navbar_text(
    "hi",
    class = "muted",
    id = "t1"
  ))
  expect_match(
    html,
    "navbar-text muted"
  )
  expect_match(
    html,
    "id=\"t1\""
  )
})
