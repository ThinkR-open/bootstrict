# Browser tests -------------------------------------------------------------
#
# The markup tests render tags with as.character(); they never run a line of
# the ~940 lines of binding JS, and never start a Shiny session. Every blocker
# the audit found lived exactly there. These tests boot a fixture app in a real
# browser and check the behaviour those bugs broke.

skip_if_no_browser()

app <- start_fixture_app()
withr::defer(
  stop_fixture_app(
    app
  ),
  teardown_env()
)

test_that("the fixture app loads without a JS exception", {
  expect_equal(
    js_errors(
      app
    ),
    character()
  )
  expect_true(js(
    app,
    'document.querySelectorAll("[data-bootstrict]").length > 0'
  ))
})

test_that("every state-reporting widget has an initial value", {
  for (id in c(
    "tabs",
    "acc",
    "coll",
    "car",
    "lg",
    "rng",
    "col",
    "m",
    "oc",
    "tst"
  )) {
    expect_false(
      identical(
        input_value(
          app,
          id
        ),
        "undefined"
      ),
      info = paste(
        "input$",
        id,
        " was never registered",
        sep = ""
      )
    )
  }
  expect_equal(
    input_value(
      app,
      "tabs"
    ),
    "\"one\""
  )
  expect_equal(
    input_value(
      app,
      "rng"
    ),
    "5"
  )
  expect_equal(
    input_value(
      app,
      "m"
    ),
    "false"
  )
})

test_that("a tooltip leaves the element's own Shiny binding alone", {
  # The tooltip used to be a Shiny InputBinding whose getId() returned el.id,
  # so it claimed the element and the real binding never bound.
  expect_equal(
    binding_of(
      app,
      "tipped"
    ),
    "shiny.actionButtonInput"
  )
  expect_equal(
    binding_of(
      app,
      "plain"
    ),
    "shiny.actionButtonInput"
  )
  expect_true(js(
    app,
    'bootstrap.Tooltip.getInstance(document.getElementById("tipped")) !== null'
  ))

  click(
    app,
    "tipped"
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "tipped"
      ),
      "> 0"
    )
  ))
  # The plain button is the control: both must count.
  click(
    app,
    "plain"
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "plain"
      ),
      "> 0"
    )
  ))
})

test_that("interactive widgets report their state back", {
  js(
    app,
    'document.querySelector("#tabs [data-value=\'two\']").click()'
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "tabs"
      ),
      '=== "two"'
    )
  ))

  # data-value sits on the .accordion-collapse; its button is in a sibling h2.
  js(
    app,
    paste0(
      'document.querySelector("#acc [data-value=\'b\']")',
      '.closest(".accordion-item").querySelector(".accordion-button").click()'
    )
  )
  expect_true(wait_until(
    app,
    paste0(
      'JSON.stringify(',
      shiny_value(
        "acc"
      ),
      ').indexOf("b") >= 0'
    )
  ))

  js(
    app,
    'document.querySelector("#lg [data-value=\'s\']").click()'
  )
  expect_true(wait_until(
    app,
    paste0(
      'JSON.stringify(',
      shiny_value(
        "lg"
      ),
      ').indexOf("s") >= 0'
    )
  ))
})

test_that("overlays open and close from the server contract", {
  js(
    app,
    'bootstrict.bs("Modal", document.getElementById("m")).show()'
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "m"
      ),
      "=== true"
    )
  ))
  js(
    app,
    'bootstrict.bs("Modal", document.getElementById("m")).hide()'
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "m"
      ),
      "=== false"
    )
  ))
})

test_that("the close button of a responsive offcanvas closes it", {
  # .offcanvas-{bp} replaces .offcanvas, so Bootstrap's dismiss handler needs
  # an explicit data-bs-target to find anything to close.
  js(
    app,
    'bootstrict.bs("Offcanvas", document.getElementById("ocr")).show()'
  )
  expect_true(wait_until(
    app,
    'document.getElementById("ocr").classList.contains("show")'
  ))
  js(
    app,
    'document.querySelector("#ocr .btn-close").click()'
  )
  expect_true(wait_until(
    app,
    '!document.getElementById("ocr").classList.contains("show")'
  ))
})

test_that("re-rendering an open modal does not leave the page scroll-locked", {
  # hide() is transition based: disposing in the same tick used to abort the
  # teardown, leaving body.modal-open and the inline scroll lock behind.
  js(
    app,
    'bootstrict.bs("Modal", document.getElementById("dynm")).show()'
  )
  # Wait for shown.bs.modal, which is what the binding reports. Removing the
  # element while show() is still mid-transition makes Bootstrap itself throw,
  # which would be a flaky test rather than a finding.
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "dynm"
      ),
      "=== true"
    )
  ))
  expect_true(js(
    app,
    'document.body.classList.contains("modal-open")'
  ))
  click(
    app,
    "swap"
  )
  expect_true(wait_until(
    app,
    paste0(
      '!document.body.classList.contains("modal-open") && ',
      'getComputedStyle(document.body).overflow !== "hidden" && ',
      'document.querySelectorAll(".modal-backdrop").length === 0'
    ),
    timeout = 15
  ))
})

test_that("validation feedback is displayed, and the server can switch it", {
  # Bootstrap only shows feedback through `.is-invalid ~ .invalid-feedback`,
  # so it has to be a sibling of the control, not of shiny's container.
  expect_equal(
    js(
      app,
      'getComputedStyle(document.querySelector("#email ~ .invalid-feedback")).display'
    ),
    "block"
  )
  expect_equal(
    js(
      app,
      'getComputedStyle(document.querySelector("#user ~ .invalid-feedback")).display'
    ),
    "none"
  )

  click(
    app,
    "validate"
  )
  expect_true(wait_until(
    app,
    'document.getElementById("user").classList.contains("is-invalid")'
  ))
  expect_equal(
    js(
      app,
      'document.querySelector("#user ~ .invalid-feedback").textContent'
    ),
    "Deja pris."
  )
})

test_that("a stacked progress with a height keeps its widths", {
  # Two separate style attributes rendered as one malformed declaration, which
  # the browser dropped whole, leaving zero-width segments.
  widths <- js(
    app,
    paste0(
      '(function(){return Array.prototype.map.call(',
      'document.querySelectorAll(".progress-stacked > .progress"),',
      'function(el){return parseFloat(getComputedStyle(el).width);}).join(",");})()'
    )
  )
  expect_match(
    widths,
    "^[0-9.]+,[0-9.]+$"
  )
  expect_true(all(
    as.numeric(strsplit(
      widths,
      ","
    )[[
      1
    ]]) >
      0
  ))
  expect_equal(
    js(
      app,
      'getComputedStyle(document.querySelector(".progress-stacked > .progress")).height'
    ),
    "10px"
  )
})

test_that("a navbar dropdown is valid markup and opens", {
  expect_true(js(
    app,
    paste0(
      '(function(){return Array.prototype.every.call(',
      'document.querySelector(".navbar-nav").children,',
      'function(c){return c.tagName === "LI";});})()'
    )
  ))
  js(
    app,
    'document.querySelector(".navbar-nav .dropdown-toggle").click()'
  )
  expect_true(wait_until(
    app,
    'document.querySelector(".navbar-nav .dropdown-menu").classList.contains("show")'
  ))
  click(
    app,
    "menu_item"
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "menu_item"
      ),
      "> 0"
    )
  ))
})

test_that("toggle button groups report their selection", {
  # .btn-check markup: the input is a sibling of its label, so clicking the
  # label is what a user actually does.
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "tbr"
      ),
      '=== "s"'
    )
  ))
  expect_true(wait_until(
    app,
    paste0(
      "JSON.stringify(",
      shiny_value(
        "tbc"
      ),
      ") === '[]'"
    )
  ))

  js(
    app,
    'document.querySelector("label[for=\'tbr-2\']").click()'
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "tbr"
      ),
      '=== "l"'
    )
  ))
  # A radio group keeps exactly one checked input.
  expect_equal(
    js(
      app,
      'document.querySelectorAll("#tbr .btn-check:checked").length'
    ),
    1
  )

  js(
    app,
    'document.querySelector("label[for=\'tbc-1\']").click()'
  )
  js(
    app,
    'document.querySelector("label[for=\'tbc-2\']").click()'
  )
  expect_true(wait_until(
    app,
    paste0(
      "JSON.stringify(",
      shiny_value(
        "tbc"
      ),
      ") === '[\"a\",\"b\"]'"
    )
  ))
})

test_that("toggle button groups take a selection from the server", {
  js(
    app,
    'document.querySelector("label[for=\'tbr-1\']").click()'
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "tbr"
      ),
      '=== "s"'
    )
  ))
  click(
    app,
    "pick_l"
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "tbr"
      ),
      '=== "l"'
    )
  ))
  expect_true(js(
    app,
    'document.getElementById("tbr-2").checked'
  ))

  # character(0) clears a checkbox group rather than being dropped from the
  # payload as an absent argument.
  click(
    app,
    "clear_tbc"
  )
  expect_true(wait_until(
    app,
    paste0(
      "JSON.stringify(",
      shiny_value(
        "tbc"
      ),
      ") === '[]'"
    )
  ))
  expect_equal(
    js(
      app,
      'document.querySelectorAll("#tbc .btn-check:checked").length'
    ),
    0
  )
  expect_true(wait_until(
    app,
    'document.getElementById("tbc_type").innerText.trim() === "character/0"'
  ))
})

test_that("shiny's own choice-group updaters keep the Bootstrap 5 markup", {
  # shiny:::generateOptions() has no theme branch: it always regenerates the
  # options as <div class="radio"><label><input>, so without a repair the
  # control loses .form-check on the first update.
  classes <- function(
    selector
  ) {
    js(
      app,
      sprintf(
        paste0(
          '(function(){return Array.prototype.map.call(',
          'document.querySelectorAll("%s"),',
          'function(el){return el.className;}).join("|");})()'
        ),
        selector
      )
    )
  }
  expect_match(
    classes(
      "#rad .shiny-options-group > *"
    ),
    "form-check"
  )

  click(
    app,
    "regen"
  )
  expect_true(wait_until(
    app,
    'document.querySelectorAll("#rad input").length === 2 && ' %+%
      'document.querySelector("#rad input").value === "L"'
  ))

  for (group in c(
    "#rad",
    "#cgrp"
  )) {
    wrappers <- classes(paste(
      group,
      ".shiny-options-group > *"
    ))
    expect_match(
      wrappers,
      "form-check",
      info = group
    )
    expect_no_match(
      wrappers,
      "\\bradio\\b",
      info = group
    )
    expect_no_match(
      wrappers,
      "\\bcheckbox\\b",
      info = group
    )
    expect_match(
      classes(paste(
        group,
        "input"
      )),
      "form-check-input",
      info = group
    )
  }
  # Inline is not recoverable from the replaced HTML, so it is remembered on
  # the container. There the <label> *is* the .form-check, exactly as
  # bootstrict renders it, so there is no inner .form-check-label -- unlike
  # the stacked group next to it.
  expect_match(
    classes(
      "#rad .shiny-options-group > *"
    ),
    "form-check-inline"
  )
  expect_match(
    classes(
      "#cgrp label"
    ),
    "form-check-label"
  )
})

test_that("a nav reports its active link and takes one from the server", {
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "nv"
      ),
      '=== "home"'
    )
  ))
  js(
    app,
    'document.querySelector("#nv [data-value=\'prof\']").click()'
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "nv"
      ),
      '=== "prof"'
    )
  ))
  # href="#" must not jump to the top of the page.
  expect_equal(
    js(
      app,
      "window.location.hash"
    ),
    ""
  )
})

test_that("a pager reports its page, steps with the arrows, and takes one from the server", {
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "pg"
      ),
      '=== "1"'
    )
  ))
  # Prev is disabled on the first page.
  expect_true(js(
    app,
    'document.querySelector("#pg [data-bootstrict-step=\'prev\']").closest(".page-item").classList.contains("disabled")'
  ))
  js(
    app,
    'document.querySelector("#pg [data-bootstrict-step=\'next\']").click()'
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "pg"
      ),
      '=== "2"'
    )
  ))
  js(
    app,
    'document.querySelector("#pg [data-value=\'3\'] .page-link").click()'
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "pg"
      ),
      '=== "3"'
    )
  ))
  # Next is disabled on the last page.
  expect_true(js(
    app,
    'document.querySelector("#pg [data-bootstrict-step=\'next\']").closest(".page-item").classList.contains("disabled")'
  ))

  js(
    app,
    'document.querySelector("#pg [data-bootstrict-step=\'prev\']").click()'
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "pg"
      ),
      '=== "2"'
    )
  ))
  click(
    app,
    "goto3"
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "pg"
      ),
      '=== "3"'
    )
  ))
})

test_that("a dropdown reports its open state and is driven from the server", {
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "dd"
      ),
      "=== false"
    )
  ))
  click(
    app,
    "open_dd"
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "dd"
      ),
      "=== true"
    )
  ))
  expect_true(js(
    app,
    'document.querySelector("#dd .dropdown-menu").classList.contains("show")'
  ))
  # Clicking away closes it, and that is reported too.
  js(
    app,
    "document.body.click()"
  )
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "dd"
      ),
      "=== false"
    )
  ))
})

test_that("a dismissible alert reports its state and closes from the server", {
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "al"
      ),
      "=== true"
    )
  ))
  click(
    app,
    "close_alert"
  )
  # close.bs.alert fires while the element is still bound; closed.bs.alert
  # fires after Bootstrap has removed it, too late to report anything.
  expect_true(wait_until(
    app,
    paste(
      shiny_value(
        "al"
      ),
      "=== false"
    )
  ))
  expect_true(wait_until(
    app,
    'document.getElementById("al") === null'
  ))
})

test_that("nothing threw during the whole session", {
  expect_equal(
    js_errors(
      app
    ),
    character()
  )
})
