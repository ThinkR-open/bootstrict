test_that("bs_dropdown renders a .dropdown wrapper with a toggle button and menu", {
  html <- as.character(bs_dropdown(
    "Menu",
    bs_dropdown_item(
      "Action",
      id = "act"
    )
  ))
  expect_match(
    html,
    "^<div class=\"dropdown\""
  )
  expect_match(
    html,
    "<button[^>]*class=\"btn btn-secondary dropdown-toggle\""
  )
  expect_match(
    html,
    "data-bs-toggle=\"dropdown\""
  )
  expect_match(
    html,
    "aria-expanded=\"false\""
  )
  expect_match(
    html,
    "<ul class=\"dropdown-menu\""
  )
  expect_match(
    html,
    "Menu"
  )
})

test_that("colour, outline and size modifiers are applied to the toggle", {
  outline <- as.character(bs_dropdown(
    "M",
    color = "primary",
    outline = TRUE
  ))
  expect_match(
    outline,
    "btn-outline-primary"
  )

  sized <- as.character(bs_dropdown(
    "M",
    color = "success",
    size = "lg"
  ))
  expect_match(
    sized,
    "btn btn-success btn-lg dropdown-toggle"
  )

  link <- as.character(bs_dropdown(
    "M",
    color = "link",
    outline = TRUE
  ))
  expect_match(
    link,
    "btn-link"
  )
  expect_false(grepl(
    "btn-outline-link",
    link
  ))
})

test_that("colour, size and direction are validated", {
  expect_error(bs_dropdown(
    "M",
    color = "rainbow"
  ))
  expect_error(bs_dropdown(
    "M",
    size = "xl"
  ))
  expect_error(bs_dropdown(
    "M",
    direction = "sideways"
  ))
})

test_that("direction maps to the correct wrapper class", {
  expect_match(
    as.character(bs_dropdown(
      "M",
      direction = "up"
    )),
    "class=\"dropup\""
  )
  expect_match(
    as.character(bs_dropdown(
      "M",
      direction = "end"
    )),
    "class=\"dropend\""
  )
  expect_match(
    as.character(bs_dropdown(
      "M",
      direction = "start"
    )),
    "class=\"dropstart\""
  )
})

test_that("split renders a label button plus a split toggle and btn-group wrapper", {
  html <- as.character(bs_dropdown(
    "Save",
    split = TRUE,
    color = "primary"
  ))
  expect_match(
    html,
    "class=\"dropdown btn-group\""
  )
  expect_match(
    html,
    "dropdown-toggle dropdown-toggle-split"
  )
  expect_match(
    html,
    "<span class=\"visually-hidden\">Toggle Dropdown</span>"
  )
  # The plain label button is present alongside the split toggle.
  expect_match(
    html,
    "<button type=\"button\" class=\"btn btn-primary\">Save</button>"
  )
})

test_that("dark and align modifiers reach the menu", {
  dark <- as.character(bs_dropdown(
    "M",
    dark = TRUE
  ))
  # Bootstrap 5.3 colour modes (.dropdown-menu-dark is deprecated).
  expect_match(
    dark,
    "data-bs-theme=\"dark\""
  )
  expect_no_match(
    dark,
    "dropdown-menu-dark"
  )

  end <- as.character(bs_dropdown(
    "M",
    align = "end"
  ))
  expect_match(
    end,
    "dropdown-menu dropdown-menu-end"
  )

  responsive <- as.character(bs_dropdown(
    "M",
    align = list(
      lg = "end"
    )
  ))
  expect_match(
    responsive,
    "dropdown-menu-lg-end"
  )
})

test_that("bs_dropdown_item renders an <li><a class='dropdown-item'>", {
  html <- as.character(bs_dropdown_item(
    "Action"
  ))
  expect_match(
    html,
    "^<li>"
  )
  expect_match(
    html,
    "<a class=\"dropdown-item\""
  )
  expect_match(
    html,
    "href=\"#\""
  )
})

test_that("dropdown item id makes it an action button with that id", {
  html <- as.character(bs_dropdown_item(
    "Action",
    id = "go"
  ))
  expect_match(
    html,
    "id=\"go\""
  )
  expect_match(
    html,
    "action-button"
  )
})

test_that("active and disabled items carry the right classes and aria attrs", {
  html <- as.character(bs_dropdown_item(
    "X",
    active = TRUE,
    disabled = TRUE
  ))
  expect_match(
    html,
    "dropdown-item active disabled"
  )
  expect_match(
    html,
    "aria-current=\"true\""
  )
  expect_match(
    html,
    "aria-disabled=\"true\""
  )
})

test_that("dropdown helpers render the expected sub-elements", {
  divider <- as.character(bs_dropdown_divider())
  expect_match(
    divider,
    "^<li>"
  )
  expect_match(
    divider,
    "<hr class=\"dropdown-divider\"/>"
  )

  header <- as.character(bs_dropdown_header(
    "Section",
    level = 5
  ))
  expect_match(
    header,
    "^<li>"
  )
  expect_match(
    header,
    "<h5 class=\"dropdown-header\">Section</h5>"
  )

  text <- as.character(bs_dropdown_text(
    "Some text"
  ))
  expect_match(
    text,
    "^<li>"
  )
  expect_match(
    text,
    "<span class=\"dropdown-item-text\">Some text</span>"
  )
})

test_that("the bootstrict dependency travels with the top-level dropdown", {
  deps <- htmltools::findDependencies(
    bs_dropdown(
      "M",
      bs_dropdown_item(
        "A"
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

test_that("bs_nav_dropdown renders the reference nav markup", {
  # bs_dropdown() emits a <div class="dropdown"> with a <button class="btn">,
  # which is invalid as a direct child of <ul class="navbar-nav"> and renders
  # as a grey button instead of a nav link.
  out <- as.character(bs_nav_dropdown(
    "More",
    bs_dropdown_item(
      "Settings"
    )
  ))
  expect_match(
    out,
    "^<li class=\"nav-item dropdown\">"
  )
  expect_match(
    out,
    paste0(
      "<a class=\"nav-link dropdown-toggle\" href=\"#\" role=\"button\" ",
      "data-bs-toggle=\"dropdown\" aria-expanded=\"false\">More</a>"
    )
  )
  expect_match(
    out,
    "<ul class=\"dropdown-menu\">"
  )
  expect_no_match(
    out,
    "btn",
    fixed = TRUE
  )
})

test_that("bs_nav_dropdown carries the nav-link states and menu options", {
  active <- as.character(bs_nav_dropdown(
    "More",
    active = TRUE
  ))
  expect_match(
    active,
    "nav-link dropdown-toggle active"
  )
  expect_match(
    active,
    "aria-current=\"page\""
  )

  disabled <- as.character(bs_nav_dropdown(
    "More",
    disabled = TRUE
  ))
  expect_match(
    disabled,
    "aria-disabled=\"true\""
  )

  expect_match(
    as.character(bs_nav_dropdown(
      "More",
      align = "end"
    )),
    "dropdown-menu dropdown-menu-end"
  )
  # Responsive alignment needs Popper's dynamic positioning turned off.
  responsive <- as.character(bs_nav_dropdown(
    "More",
    align = list(
      lg = "end"
    )
  ))
  expect_match(
    responsive,
    "dropdown-menu-lg-end"
  )
  expect_match(
    responsive,
    "data-bs-display=\"static\""
  )

  expect_match(
    as.character(bs_nav_dropdown(
      "More",
      dark = TRUE
    )),
    "data-bs-theme=\"dark\""
  )
  # Named `...` decorate the <li>.
  expect_match(
    as.character(bs_nav_dropdown(
      "More",
      `data-x` = "1"
    )),
    "data-x=\"1\""
  )
})
