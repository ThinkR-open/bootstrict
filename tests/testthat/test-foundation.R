# Tests for the hand-written foundation: layout, card, buttons, forms,
# accordion, alert, theme + dependency plumbing.

render <- function(
  x
)
  as.character(
    x
  )
has_dep <- function(
  x
) {
  any(vapply(
    htmltools::findDependencies(
      x
    ),
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
  ))
}

test_that("layout: container / row / col build faithful grid classes", {
  expect_match(
    render(bs_container(
      fluid = TRUE
    )),
    "container-fluid"
  )
  expect_match(
    render(bs_container(
      breakpoint = "md"
    )),
    "container-md"
  )
  r <- render(bs_row(
    bs_col(
      width = 6,
      md = 4,
      offset = list(
        md = 2
      )
    ),
    gutters = 3,
    justify = "between"
  ))
  expect_match(
    r,
    "row"
  )
  expect_match(
    r,
    "gx-3"
  )
  expect_match(
    r,
    "gy-3"
  )
  expect_match(
    r,
    "justify-content-between"
  )
  expect_match(
    r,
    "col-6"
  )
  expect_match(
    r,
    "col-md-4"
  )
  expect_match(
    r,
    "offset-md-2"
  )
  expect_match(
    render(bs_col()),
    'class="col"'
  )
})

test_that("card composes header / body / title / text", {
  out <- render(bs_card(
    bs_card_header(
      "H"
    ),
    bs_card_body(
      bs_card_title(
        "T"
      ),
      bs_card_text(
        "body"
      )
    ),
    color = "primary"
  ))
  expect_match(
    out,
    "card text-bg-primary"
  )
  expect_match(
    out,
    "card-header"
  )
  expect_match(
    out,
    "card-body"
  )
  expect_match(
    out,
    "card-title"
  )
  expect_match(
    out,
    "card-text"
  )
})

test_that("button is a Shiny action button when given an id", {
  expect_match(
    render(bs_button(
      "go",
      "Go",
      color = "success"
    )),
    'class="btn btn-success action-button"'
  )
  expect_match(
    render(bs_button(
      label = "x",
      color = "secondary",
      outline = TRUE
    )),
    "btn-outline-secondary"
  )
  # no id -> not an action button
  expect_false(grepl(
    "action-button",
    render(bs_button(
      label = "x"
    ))
  ))
  expect_match(
    render(bs_button(
      label = "L",
      href = "/x"
    )),
    "<a"
  )
})

test_that("text input delegates to shiny and gains Bootstrap classes", {
  out <- render(bs_text_input(
    "nm",
    "Name",
    size = "lg",
    help = "hint"
  ))
  expect_match(
    out,
    "form-control form-control-lg"
  )
  expect_match(
    out,
    "form-label"
  )
  expect_match(
    out,
    "form-text"
  )
  expect_match(
    out,
    'id="nm"'
  )
})

test_that("numeric input tolerates NULL min/max/step (regression)", {
  # shiny::numericInput() errors on NULL bounds; bs_numeric_input must coerce.
  expect_match(
    render(bs_numeric_input(
      "n",
      "N",
      5
    )),
    'type="number"'
  )
  expect_match(
    render(bs_numeric_input(
      "n",
      "N",
      5,
      min = 0,
      max = 10
    )),
    'max="10"'
  )
  expect_match(
    render(bs_numeric_input(
      "n",
      "N",
      5,
      step = 0.5
    )),
    'step="0.5"'
  )
})

test_that("file input is overlaid (no off-screen scroll) and keeps its binding", {
  out <- render(bs_file_input(
    "up",
    "File"
  ))
  # the cause of the scroll-to-top: shiny's off-screen positioning, removed.
  expect_false(grepl(
    "99999",
    out
  ))
  expect_match(
    out,
    "opacity:0"
  )
  # real BS5 button, not the unstyled BS3 .btn-default
  expect_match(
    out,
    "btn-secondary"
  )
  expect_false(grepl(
    "btn-default",
    out
  ))
  # shiny's file binding (so input$id still works) is preserved
  expect_match(
    out,
    "shiny-input-file"
  )
  expect_match(
    out,
    'id="up_progress"'
  )
})

test_that("delegated inputs keep their html dependency (not rendered as text)", {
  # Regression: tag_modify_where() used to recurse into html_dependency objects
  # (which are lists), strip their class and render them as garbage text.
  di <- bs_date_input(
    "d",
    "Date"
  )
  html <- render(
    di
  )
  expect_false(grepl(
    "datepicker|html_dependency",
    html
  ))
  expect_match(
    html,
    "form-control"
  )
  deps <- vapply(
    htmltools::findDependencies(
      di
    ),
    function(
      d
    )
      d$name,
    character(
      1
    )
  )
  expect_true(
    "bootstrap-datepicker-js" %in%
      deps
  )
})

test_that("select renders a native form-select without form-control", {
  out <- render(bs_select_input(
    "s",
    "Pick",
    c(
      "a",
      "b"
    )
  ))
  expect_match(
    out,
    "form-select"
  )
  expect_false(grepl(
    "form-control",
    out
  ))
})

test_that("switch is a form-check form-switch", {
  out <- render(bs_switch_input(
    "sw",
    "Dark"
  ))
  expect_match(
    out,
    "form-check form-switch"
  )
  expect_match(
    out,
    "form-check-input"
  )
  expect_match(
    out,
    'role="switch"'
  )
})

test_that("accordion: faithful markup, state attrs, open panel", {
  out <- render(bs_accordion(
    "acc",
    bs_accordion_panel(
      "First",
      "one",
      value = "one"
    ),
    bs_accordion_panel(
      "Second",
      "two",
      value = "two"
    ),
    open = "one"
  ))
  expect_match(
    out,
    'data-bootstrict="accordion"'
  )
  expect_match(
    out,
    "accordion-collapse collapse show"
  )
  expect_match(
    out,
    'data-value="one"'
  )
  expect_match(
    out,
    'data-bs-toggle="collapse"'
  )
  expect_match(
    out,
    'data-bs-parent="#acc"'
  )
})

test_that("accordion rejects non-panel children and duplicate values", {
  expect_error(
    bs_accordion(
      "a",
      "not a panel"
    ),
    "bs_accordion_panel"
  )
  expect_error(
    bs_accordion(
      "a",
      bs_accordion_panel(
        "x",
        value = "v"
      ),
      bs_accordion_panel(
        "y",
        value = "v"
      )
    ),
    "unique"
  )
})

test_that("alert: colour, dismissible close button, single aria-label", {
  out <- render(bs_alert(
    "hi",
    color = "warning",
    dismissible = TRUE
  ))
  expect_match(
    out,
    "alert alert-warning alert-dismissible"
  )
  expect_match(
    out,
    "btn-close"
  )
  # exactly one aria-label on the close button (regression: was duplicated)
  expect_equal(
    lengths(regmatches(
      out,
      gregexpr(
        "aria-label",
        out
      )
    )),
    1L
  )
})

test_that("every top-level widget carries the bootstrict dependency", {
  expect_true(has_dep(bs_card(bs_card_body(
    "x"
  ))))
  expect_true(has_dep(bs_container()))
  expect_true(has_dep(bs_button(
    "b",
    "x"
  )))
  expect_true(has_dep(bs_text_input(
    "t",
    "x"
  )))
  expect_true(has_dep(bs_accordion(
    "a",
    bs_accordion_panel(
      "p"
    )
  )))
  expect_true(has_dep(bs_alert(
    "x"
  )))
})

test_that("theme helpers parse SASS variables and build a bs5 theme", {
  tmp <- tempfile(
    fileext = ".scss"
  )
  writeLines(
    c(
      "// a comment",
      "$primary: #ff6600;",
      "$border-radius: 0.5rem !default;",
      "$font-family-base: 'Inter', sans-serif;"
    ),
    tmp
  )
  vars <- parse_scss_variables(
    tmp
  )
  expect_equal(
    vars$primary,
    "#ff6600"
  )
  expect_equal(
    vars$`border-radius`,
    "0.5rem"
  )
  expect_false(grepl(
    "!default",
    vars$`border-radius`
  ))
  th <- bootstrict_theme(
    variables = tmp,
    secondary = "#000"
  )
  expect_s3_class(
    th,
    "bs_theme"
  )
})
