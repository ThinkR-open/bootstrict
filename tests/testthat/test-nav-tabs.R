# Tests for the `nav-tabs` component group -----------------------------------

test_that("bs_nav renders a nav <ul> with type and layout modifiers", {
  html <- as.character(bs_nav(
    bs_nav_item(bs_nav_link(
      "One"
    )),
    type = "tabs",
    fill = TRUE,
    justified = TRUE,
    vertical = TRUE
  ))
  expect_match(
    html,
    "<ul class=\"nav nav-tabs nav-fill nav-justified flex-column\">"
  )
  expect_match(
    html,
    "<li class=\"nav-item\">"
  )
})

test_that("bs_nav pills variant and plain nav", {
  pills <- as.character(bs_nav(
    bs_nav_item(
      "x"
    ),
    type = "pills"
  ))
  expect_match(
    pills,
    "nav-pills"
  )

  plain <- as.character(bs_nav(bs_nav_item(
    "x"
  )))
  expect_match(
    plain,
    "<ul class=\"nav\">"
  )
  expect_false(grepl(
    "nav-tabs",
    plain
  ))
})

test_that("bs_nav rejects an invalid type", {
  expect_error(bs_nav(
    type = "nope"
  ))
})

test_that("bs_nav_link sets active and disabled markup", {
  active <- as.character(bs_nav_link(
    "Home",
    active = TRUE
  ))
  expect_match(
    active,
    "class=\"nav-link active\""
  )
  expect_match(
    active,
    "aria-current=\"page\""
  )

  disabled <- as.character(bs_nav_link(
    "Dead",
    disabled = TRUE,
    href = "/x"
  ))
  expect_match(
    disabled,
    "class=\"nav-link disabled\""
  )
  expect_match(
    disabled,
    "aria-disabled=\"true\""
  )
  expect_match(
    disabled,
    "href=\"/x\""
  )
})

test_that("bs_nav_link forwards id and named attributes", {
  html <- as.character(bs_nav_link(
    "L",
    id = "mylink",
    `data-foo` = "bar"
  ))
  expect_match(
    html,
    "id=\"mylink\""
  )
  expect_match(
    html,
    "data-foo=\"bar\""
  )
})

test_that("bs_tab_panel is a tagged list with a value default", {
  p <- bs_tab_panel(
    "Title",
    "body content"
  )
  expect_true(inherits(
    p,
    "bs_tab_panel"
  ))
  expect_identical(
    p$value,
    "Title"
  )
  expect_identical(
    p$title,
    "Title"
  )

  p2 <- bs_tab_panel(
    "Title",
    value = "custom"
  )
  expect_identical(
    p2$value,
    "custom"
  )
})

test_that("bs_tabset builds tablist nav and tab-content panes", {
  html <- as.character(bs_tabset(
    "tabs",
    bs_tab_panel(
      "Home",
      "Home body",
      value = "home"
    ),
    bs_tab_panel(
      "Profile",
      "Profile body",
      value = "profile"
    )
  ))

  # Root wrapper + binding marker on the nav.
  expect_match(
    html,
    "class=\"bootstrict-tabset\""
  )
  expect_match(
    html,
    "data-bootstrict=\"tabset\""
  )
  expect_match(
    html,
    "role=\"tablist\""
  )
  expect_match(
    html,
    "id=\"tabs\""
  )

  # Tab buttons.
  expect_match(
    html,
    "<button class=\"nav-link active\" id=\"tabs-tab-1\""
  )
  expect_match(
    html,
    "data-bs-toggle=\"tab\""
  )
  expect_match(
    html,
    "data-bs-target=\"#tabs-pane-1\""
  )
  expect_match(
    html,
    "aria-controls=\"tabs-pane-1\""
  )
  expect_match(
    html,
    "data-value=\"home\""
  )
  expect_match(
    html,
    "data-value=\"profile\""
  )

  # Panes.
  expect_match(
    html,
    "<div class=\"tab-content\">"
  )
  expect_match(
    html,
    "class=\"tab-pane fade show active\" id=\"tabs-pane-1\""
  )
  expect_match(
    html,
    "class=\"tab-pane fade\" id=\"tabs-pane-2\""
  )
  expect_match(
    html,
    "aria-labelledby=\"tabs-tab-1\""
  )
})

test_that("bs_tabset selected= activates the matching panel", {
  html <- as.character(bs_tabset(
    "tabs",
    bs_tab_panel(
      "Home",
      "h",
      value = "home"
    ),
    bs_tab_panel(
      "Profile",
      "p",
      value = "profile"
    ),
    selected = "profile"
  ))
  # First tab/pane should NOT be active.
  expect_match(
    html,
    "<button class=\"nav-link\" id=\"tabs-tab-1\""
  )
  expect_match(
    html,
    "class=\"tab-pane fade\" id=\"tabs-pane-1\""
  )
  # Second tab/pane should be active.
  expect_match(
    html,
    "<button class=\"nav-link active\" id=\"tabs-tab-2\""
  )
  expect_match(
    html,
    "aria-selected=\"true\" data-value=\"profile\""
  )
  expect_match(
    html,
    "class=\"tab-pane fade show active\" id=\"tabs-pane-2\""
  )
})

test_that("bs_tabset pills and vertical layout", {
  pills <- as.character(bs_tabset(
    "t",
    bs_tab_panel(
      "A",
      "a"
    ),
    type = "pills"
  ))
  expect_match(
    pills,
    "nav-pills"
  )

  vert <- as.character(bs_tabset(
    "t",
    bs_tab_panel(
      "A",
      "a"
    ),
    vertical = TRUE
  ))
  expect_match(
    vert,
    "<div class=\"d-flex align-items-start\">"
  )
  expect_match(
    vert,
    "flex-column"
  )
})

test_that("bs_tabset validates panel type and unique values", {
  expect_error(
    bs_tabset(
      "t",
      "not a panel"
    ),
    "bs_tab_panel"
  )
  expect_error(
    bs_tabset(
      "t",
      bs_tab_panel(
        "A",
        value = "dup"
      ),
      bs_tab_panel(
        "B",
        value = "dup"
      )
    ),
    "unique"
  )
})
