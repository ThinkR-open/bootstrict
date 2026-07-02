# Regression tests for the 2026-07 audit fixes. Each block pins the corrected
# behaviour of one confirmed bug; see NEWS.md for the full list.

render <- function(x) as.character(x)

audit_mock_session <- function() {
  store <- new.env(parent = emptyenv())
  store$custom <- list()
  session <- list(
    sendCustomMessage = function(type, message) {
      store$custom[[length(store$custom) + 1L]] <- list(
        type = type,
        message = message
      )
      invisible()
    },
    ns = function(x) paste0("mod-", x),
    .store = store
  )
  session
}

audit_last_msg <- function(session) {
  msgs <- session$.store$custom
  msgs[[length(msgs)]]$message
}

# --- `...` contract: named args decorate the documented element ------------

test_that("bs_dropdown named ... become wrapper attributes, not children", {
  html <- render(
    bs_dropdown("Menu", `data-foo` = "bar", bs_dropdown_item("A"))
  )
  wrapper <- regmatches(
    html,
    regexpr("<div[^>]*class=\"dropdown\"[^>]*>", html)
  )
  expect_match(wrapper, "data-foo=\"bar\"")
  # the value must not leak into the page as text
  expect_no_match(html, ">bar<")
})

test_that("bs_dropdown responsive align sets data-bs-display on the toggle", {
  html <- render(
    bs_dropdown("M", align = list(lg = "end"), bs_dropdown_item("A"))
  )
  expect_match(html, "dropdown-menu-lg-end")
  toggle <- regmatches(html, regexpr("<button[^>]*dropdown-toggle[^>]*>", html))
  expect_match(toggle, "data-bs-display=\"static\"")
  # plain alignment does not need it
  expect_no_match(
    render(bs_dropdown("M", align = "end", bs_dropdown_item("A"))),
    "data-bs-display"
  )
})

test_that("bs_modal named ... land on the modal root, not .modal-body", {
  html <- render(bs_modal("m", "Body", `data-bs-focus` = "false"))
  root <- regmatches(html, regexpr("<div[^>]*class=\"modal fade\"[^>]*>", html))
  expect_match(root, "data-bs-focus=\"false\"")
  body <- regmatches(html, regexpr("<div class=\"modal-body\"[^>]*>", html))
  expect_no_match(body, "data-bs-focus")
})

# --- forms: has_class fix and attribute routing ----------------------------

test_that("extra attributes on bs_checkbox_input reach the <input>", {
  html <- render(bs_checkbox_input("c", "L", `data-foo` = "bar"))
  input <- regmatches(html, regexpr("<input[^>]*type=\"checkbox\"[^>]*>", html))
  expect_match(input, "data-foo=\"bar\"")
  expect_match(input, "form-check-input")
})

test_that("checkbox labels carry .form-check-label and help renders", {
  html <- render(bs_checkbox_input("c", "L", help = "hint"))
  expect_match(html, "form-check-label")
  # help text is id-ed and wired to the control (Bootstrap 5.3 forms markup)
  expect_match(html, "<div id=\"c-help\" class=\"form-text\">hint</div>")
  expect_match(html, "aria-describedby=\"c-help\"")
  expect_match(render(bs_switch_input("s", "L", help = "h2")), "form-text")
})

test_that("attributes in ... replace shiny's, instead of merging", {
  html <- render(bs_text_input("t", "T", type = "email"))
  expect_match(html, "type=\"email\"")
  expect_no_match(html, "text email")
})

test_that("bs_file_input ... reaches the file input; BS3/BS4 markup is gone", {
  html <- render(bs_file_input("f", "F", capture = "camera"))
  file_input <- regmatches(
    html,
    regexpr("<input[^>]*type=\"file\"[^>]*>", html)
  )
  expect_match(file_input, "capture=\"camera\"")
  expect_no_match(html, "input-group-btn")
  expect_no_match(html, "input-group-prepend")
  expect_match(html, "progress-bar-striped progress-bar-animated")
})

test_that("group labels are promoted to .form-label", {
  expect_match(
    render(bs_radio_input("r", "Group", c("A", "B"))),
    "control-label form-label"
  )
})

# --- input groups / floating labels refuse container-bound inputs ----------

test_that("bs_input_group errors on container-bound inputs", {
  expect_error(
    bs_input_group(bs_date_input("d", "Date")),
    "binding lives on"
  )
  expect_error(
    bs_input_group(bs_file_input("f", "File")),
    "binding lives on"
  )
  expect_error(
    bs_input_group(bs_radio_input("r", "G", c("A", "B"))),
    "binding lives on"
  )
})

test_that("bs_floating_label errors on container-bound inputs", {
  expect_error(
    bs_floating_label(bs_date_input("d", "When")),
    "binding lives on"
  )
})

test_that("bs_input_group unwraps a checkbox to its bare control", {
  html <- render(bs_input_group(bs_checkbox_input("ck", NULL)))
  expect_match(html, "form-check-input")
  expect_no_match(html, "shiny-input-container")
})

# --- native inputs ----------------------------------------------------------

test_that("bs_color_input validates its value", {
  expect_error(bs_color_input("c", value = "red"), "hex colour")
  expect_silent(bs_color_input("c2", value = "#0d6efd"))
})

# --- carousel / accordion / collapse ---------------------------------------

test_that("update_bs_accordion open/close TRUE map to the __all__ sentinel", {
  s <- audit_mock_session()
  update_bs_accordion("acc", open = TRUE, session = s)
  expect_identical(audit_last_msg(s)$open, "__all__")

  update_bs_accordion("acc", close = TRUE, session = s)
  expect_identical(audit_last_msg(s)$close, "__all__")

  # FALSE is a no-op, not a panel value of "FALSE"
  update_bs_accordion("acc", open = FALSE, close = "x", session = s)
  msg <- audit_last_msg(s)
  expect_false("open" %in% names(msg))
  expect_identical(msg$close, list("x"))
})

test_that("bs_collapse_trigger reflects the initial expanded state", {
  collapsed <- render(bs_collapse_trigger("more", "Toggle"))
  expect_match(collapsed, "class=\"btn collapsed\"")
  expect_match(collapsed, "aria-expanded=\"false\"")

  open <- render(bs_collapse_trigger("more", "Toggle", expanded = TRUE))
  expect_no_match(open, "collapsed")
  expect_match(open, "aria-expanded=\"true\"")
})

# --- ids with CSS-special characters are escaped in selectors --------------

test_that("generated selectors escape CSS-special id characters", {
  acc <- render(bs_accordion(
    "a.b",
    bs_accordion_panel("T", "body", value = "v")
  ))
  expect_match(acc, "data-bs-target=\"#a\\\\.b-panel-1\"", fixed = FALSE)
  expect_match(acc, "data-bs-parent=\"#a\\\\.b\"", fixed = FALSE)
  expect_match(
    render(bs_modal_trigger("x.y", "Open")),
    "data-bs-target=\"#x\\\\.y\""
  )
  expect_match(
    render(bs_collapse_trigger("x.y", "T", button = FALSE)),
    "href=\"#x\\\\.y\""
  )

  expect_identical(bootstrict:::css_id_selector("plain-id"), "#plain-id")
  expect_identical(bootstrict:::css_id_selector("a.b:c"), "#a\\.b\\:c")
  expect_identical(bootstrict:::css_id_selector("1abc"), "#\\31 abc")
})

# --- buttons / pagination / layout validation ------------------------------

test_that("disabled anchor buttons carry .disabled and tabindex", {
  html <- render(bs_button(label = "L", href = "/x", disabled = TRUE))
  expect_match(html, "class=\"btn btn-primary disabled\"")
  expect_match(html, "tabindex=\"-1\"")
  expect_match(html, "aria-disabled=\"true\"")
})

test_that("bs_pagination_numbered validates current", {
  expect_error(bs_pagination_numbered(3, current = 10), "between 1 and")
  expect_error(bs_pagination_numbered(3, current = 0), "between 1 and")
})

test_that("layout scales are validated", {
  expect_error(bs_col(width = 15), "between 1 and 12")
  expect_error(bs_col(md = FALSE), "between 1 and 12")
  expect_error(bs_row(gutters = 9), "between 0 and 5")
  expect_error(bs_hstack(gap = 9), "between 0 and 5")
  expect_error(bs_vstack(gap = -1), "between 0 and 5")
  expect_error(bs_display_heading("X", level = 7), "between 1 and 6")
  expect_error(bs_card_title("X", level = 0), "between 1 and 6")
  expect_error(bs_dropdown_header("X", level = 9), "between 1 and 6")
  # valid values still work
  expect_match(render(bs_col(width = 6, md = "auto")), "col-6 col-md-auto")
  expect_match(render(bs_row(gutters = 3)), "gx-3 gy-3")
})

# --- progress ---------------------------------------------------------------

test_that("progress uses the 5.3 track markup and clamps percentages", {
  html <- render(bs_progress(bs_progress_bar(value = 150, id = "p")))
  # Bootstrap 5.3: role + aria on the .progress track, bar purely visual.
  track <- regmatches(html, regexpr("<div[^>]*class=\"progress\"[^>]*>", html))
  expect_match(track, "role=\"progressbar\"")
  expect_match(track, "aria-valuenow=\"150\"")
  expect_match(track, "id=\"p\"")
  bar <- regmatches(html, regexpr("<div class=\"progress-bar\"[^>]*>", html))
  expect_no_match(bar, "role=")
  expect_match(html, "width: 100%")
  expect_match(
    render(bs_progress_bar(value = -10)),
    "width: 0%"
  )
})

# --- list group --------------------------------------------------------------

test_that("selectable list groups emit valid HTML (no <li> in <div>)", {
  html <- render(bs_list_group(
    "sel",
    bs_list_group_item("A", value = "a")
  ))
  expect_match(html, "^<div")
  expect_no_match(html, "<li")
  expect_match(html, "<div class=\"list-group-item\"")
})

test_that("disabled anchor list items are keyboard-unreachable", {
  html <- render(bs_list_group_item("X", href = "#", disabled = TRUE))
  expect_match(html, "tabindex=\"-1\"")
})

# --- nav-tabs -----------------------------------------------------------------

test_that("bs_tabset validates selected and marks vertical orientation", {
  expect_error(
    bs_tabset("t", bs_tab_panel("A", "a"), selected = "nope"),
    "does not match any"
  )
  html <- render(bs_tabset(
    "t",
    bs_tab_panel("A", "a"),
    vertical = TRUE
  ))
  expect_match(html, "aria-orientation=\"vertical\"")
})

# --- 5.2 fidelity -------------------------------------------------------------

test_that("bs_card_subtitle uses the 5.3 body-secondary class", {
  html <- render(bs_card_subtitle("S"))
  expect_match(html, "text-body-secondary")
  expect_no_match(html, "text-muted")
})

test_that("offcanvas titles are wired via aria-labelledby", {
  html <- render(bs_offcanvas("menu", "Body", title = "Menu"))
  expect_match(html, "aria-labelledby=\"menu-title\"")
  expect_match(html, "<h5 class=\"offcanvas-title\" id=\"menu-title\"")
})

test_that("bs_page_fillable does not leak a fillable attribute", {
  html <- render(bs_page_fillable("x"))
  expect_no_match(html, "fillable=\"")
})

# --- content -----------------------------------------------------------------

test_that("bs_table keeps unnamed children (e.g. a tfoot) alongside data", {
  html <- render(bs_table(
    data.frame(x = 1),
    htmltools::tags$tfoot(htmltools::tags$tr(htmltools::tags$td("total")))
  ))
  expect_match(html, "<tfoot>")
})

test_that("bs_breadcrumb escapes quotes in the divider", {
  html <- render(bs_breadcrumb(
    bs_breadcrumb_item("Home"),
    divider = "'"
  ))
  # htmltools entity-encodes the quotes (&#39;); the CSS escape is the
  # backslash in front of the inner one: '\'' once the browser decodes it.
  expect_match(
    html,
    "--bs-breadcrumb-divider: &#39;\\\\&#39;&#39;;",
    fixed = FALSE
  )
})

# --- notify toast -------------------------------------------------------------

test_that("bs_notify_toast validates its text fields and forwards autohide", {
  s <- audit_mock_session()
  expect_error(
    bs_notify_toast(htmltools::tags$b("hi"), session = s),
    "plain-text"
  )
  expect_error(
    bs_notify_toast("ok", title = htmltools::tags$b("t"), session = s),
    "plain-text"
  )
  expect_error(
    bs_notify_toast("ok", dely = 100, session = s),
    class = "rlib_error_dots_nonempty"
  )

  bs_notify_toast("ok", title = "T", autohide = FALSE, session = s)
  msg <- audit_last_msg(s)
  expect_false(msg$autohide)
  expect_identical(msg$body, "ok")
  expect_identical(msg$title, "T")
})

# --- theme parser ---------------------------------------------------------------

test_that("parse_scss_variables strips multi-line block comments", {
  tmp <- tempfile(fileext = ".scss")
  writeLines(
    c(
      "/*!",
      " * Exported header",
      " * $commented: out;",
      " */",
      "$primary: #ff6600;",
      "$a: 1; $b: 2;"
    ),
    tmp
  )
  on.exit(unlink(tmp), add = TRUE)
  vars <- parse_scss_variables(tmp)
  expect_false("commented" %in% names(vars))
  expect_identical(vars$primary, "#ff6600")
  # every declaration on a line is read, not just the first
  expect_identical(vars$a, "1")
  expect_identical(vars$b, "2")
})

# --- scrollspy ---------------------------------------------------------------

test_that("bs_scrollspy gets an id and the bootstrict marker", {
  html <- render(bs_scrollspy("nav-menu", "content"))
  expect_match(html, "data-bootstrict=\"scrollspy\"")
  expect_match(html, "id=\"bs-scrollspy-")
  expect_match(html, "data-bs-target=\"#nav-menu\"")
  # explicit ids are kept
  expect_match(
    render(bs_scrollspy("nav-menu", "content", id = "spy")),
    "id=\"spy\""
  )
})
