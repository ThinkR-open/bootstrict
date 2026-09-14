# Regression tests for the 2026-07 audit fixes. Each block pins the corrected
# behaviour of one confirmed bug; see NEWS.md for the full list.

render <- function(
  x
)
  as.character(
    x
  )

audit_mock_session <- function() {
  store <- new.env(
    parent = emptyenv()
  )
  store$custom <- list()
  session <- list(
    sendCustomMessage = function(
      type,
      message
    ) {
      store$custom[[
        length(
          store$custom
        ) +
          1L
      ]] <- list(
        type = type,
        message = message
      )
      invisible()
    },
    ns = function(
      x
    )
      paste0(
        "mod-",
        x
      ),
    .store = store
  )
  session
}

audit_last_msg <- function(
  session
) {
  msgs <- session$.store$custom
  msgs[[length(
    msgs
  )]]$message
}

# --- `...` contract: named args decorate the documented element ------------

test_that("bs_dropdown named ... become wrapper attributes, not children", {
  html <- render(
    bs_dropdown(
      "Menu",
      `data-foo` = "bar",
      bs_dropdown_item(
        "A"
      )
    )
  )
  wrapper <- regmatches(
    html,
    regexpr(
      "<div[^>]*class=\"dropdown\"[^>]*>",
      html
    )
  )
  expect_match(
    wrapper,
    "data-foo=\"bar\""
  )
  # the value must not leak into the page as text
  expect_no_match(
    html,
    ">bar<"
  )
})

test_that("bs_dropdown responsive align sets data-bs-display on the toggle", {
  html <- render(
    bs_dropdown(
      "M",
      align = list(
        lg = "end"
      ),
      bs_dropdown_item(
        "A"
      )
    )
  )
  expect_match(
    html,
    "dropdown-menu-lg-end"
  )
  toggle <- regmatches(
    html,
    regexpr(
      "<button[^>]*dropdown-toggle[^>]*>",
      html
    )
  )
  expect_match(
    toggle,
    "data-bs-display=\"static\""
  )
  # plain alignment does not need it
  expect_no_match(
    render(bs_dropdown(
      "M",
      align = "end",
      bs_dropdown_item(
        "A"
      )
    )),
    "data-bs-display"
  )
})

test_that("bs_modal named ... land on the modal root, not .modal-body", {
  html <- render(bs_modal(
    "m",
    "Body",
    `data-bs-focus` = "false"
  ))
  root <- regmatches(
    html,
    regexpr(
      "<div[^>]*class=\"modal fade\"[^>]*>",
      html
    )
  )
  expect_match(
    root,
    "data-bs-focus=\"false\""
  )
  body <- regmatches(
    html,
    regexpr(
      "<div class=\"modal-body\"[^>]*>",
      html
    )
  )
  expect_no_match(
    body,
    "data-bs-focus"
  )
})

# --- forms: has_class fix and attribute routing ----------------------------

test_that("extra attributes on bs_checkbox_input reach the <input>", {
  html <- render(bs_checkbox_input(
    "c",
    "L",
    `data-foo` = "bar"
  ))
  input <- regmatches(
    html,
    regexpr(
      "<input[^>]*type=\"checkbox\"[^>]*>",
      html
    )
  )
  expect_match(
    input,
    "data-foo=\"bar\""
  )
  expect_match(
    input,
    "form-check-input"
  )
})

test_that("checkbox labels carry .form-check-label and help renders", {
  html <- render(bs_checkbox_input(
    "c",
    "L",
    help = "hint"
  ))
  expect_match(
    html,
    "form-check-label"
  )
  # help text is id-ed and wired to the control (Bootstrap 5.3 forms markup)
  expect_match(
    html,
    "<div id=\"c-help\" class=\"form-text\">hint</div>"
  )
  expect_match(
    html,
    "aria-describedby=\"c-help\""
  )
  expect_match(
    render(bs_switch_input(
      "s",
      "L",
      help = "h2"
    )),
    "form-text"
  )
})

test_that("attributes in ... replace shiny's, instead of merging", {
  html <- render(bs_text_input(
    "t",
    "T",
    type = "email"
  ))
  expect_match(
    html,
    "type=\"email\""
  )
  expect_no_match(
    html,
    "text email"
  )
})

test_that("bs_file_input ... reaches the file input; BS3/BS4 markup is gone", {
  html <- render(bs_file_input(
    "f",
    "F",
    capture = "camera"
  ))
  file_input <- regmatches(
    html,
    regexpr(
      "<input[^>]*type=\"file\"[^>]*>",
      html
    )
  )
  expect_match(
    file_input,
    "capture=\"camera\""
  )
  expect_no_match(
    html,
    "input-group-btn"
  )
  expect_no_match(
    html,
    "input-group-prepend"
  )
  expect_match(
    html,
    "progress-bar-striped progress-bar-animated"
  )
})

test_that("group labels are promoted to .form-label", {
  expect_match(
    render(bs_radio_input(
      "r",
      "Group",
      c(
        "A",
        "B"
      )
    )),
    "control-label form-label"
  )
})

# --- input groups / floating labels refuse container-bound inputs ----------

test_that("bs_input_group errors on container-bound inputs", {
  expect_error(
    bs_input_group(bs_date_input(
      "d",
      "Date"
    )),
    "binding lives on"
  )
  expect_error(
    bs_input_group(bs_file_input(
      "f",
      "File"
    )),
    "binding lives on"
  )
  expect_error(
    bs_input_group(bs_radio_input(
      "r",
      "G",
      c(
        "A",
        "B"
      )
    )),
    "binding lives on"
  )
})

test_that("bs_floating_label errors on container-bound inputs", {
  expect_error(
    bs_floating_label(bs_date_input(
      "d",
      "When"
    )),
    "binding lives on"
  )
})

test_that("bs_input_group unwraps a checkbox to its bare control", {
  html <- render(bs_input_group(bs_checkbox_input(
    "ck",
    NULL
  )))
  expect_match(
    html,
    "form-check-input"
  )
  expect_no_match(
    html,
    "shiny-input-container"
  )
})

# --- native inputs ----------------------------------------------------------

test_that("bs_color_input validates its value", {
  expect_error(
    bs_color_input(
      "c",
      value = "red"
    ),
    "hex colour"
  )
  expect_silent(bs_color_input(
    "c2",
    value = "#0d6efd"
  ))
})

# --- carousel / accordion / collapse ---------------------------------------

test_that("update_bs_accordion open/close TRUE map to the __all__ sentinel", {
  s <- audit_mock_session()
  update_bs_accordion(
    "acc",
    open = TRUE,
    session = s
  )
  expect_identical(
    audit_last_msg(
      s
    )$open,
    "__all__"
  )

  update_bs_accordion(
    "acc",
    close = TRUE,
    session = s
  )
  expect_identical(
    audit_last_msg(
      s
    )$close,
    "__all__"
  )

  # FALSE is a no-op, not a panel value of "FALSE"
  update_bs_accordion(
    "acc",
    open = FALSE,
    close = "x",
    session = s
  )
  msg <- audit_last_msg(
    s
  )
  expect_false(
    "open" %in%
      names(
        msg
      )
  )
  expect_identical(
    msg$close,
    list(
      "x"
    )
  )
})

test_that("bs_collapse_trigger reflects the initial expanded state", {
  collapsed <- render(bs_collapse_trigger(
    "more",
    "Toggle"
  ))
  expect_match(
    collapsed,
    "class=\"btn collapsed\""
  )
  expect_match(
    collapsed,
    "aria-expanded=\"false\""
  )

  open <- render(bs_collapse_trigger(
    "more",
    "Toggle",
    expanded = TRUE
  ))
  expect_no_match(
    open,
    "collapsed"
  )
  expect_match(
    open,
    "aria-expanded=\"true\""
  )
})

# --- ids with CSS-special characters are escaped in selectors --------------

test_that("generated selectors escape CSS-special id characters", {
  acc <- render(bs_accordion(
    "a.b",
    bs_accordion_panel(
      "T",
      "body",
      value = "v"
    )
  ))
  expect_match(
    acc,
    "data-bs-target=\"#a\\\\.b-panel-1\"",
    fixed = FALSE
  )
  expect_match(
    acc,
    "data-bs-parent=\"#a\\\\.b\"",
    fixed = FALSE
  )
  expect_match(
    render(bs_modal_trigger(
      "x.y",
      "Open"
    )),
    "data-bs-target=\"#x\\\\.y\""
  )
  expect_match(
    render(bs_collapse_trigger(
      "x.y",
      "T",
      button = FALSE
    )),
    "href=\"#x\\\\.y\""
  )

  expect_identical(
    bootstrict:::css_id_selector(
      "plain-id"
    ),
    "#plain-id"
  )
  expect_identical(
    bootstrict:::css_id_selector(
      "a.b:c"
    ),
    "#a\\.b\\:c"
  )
  expect_identical(
    bootstrict:::css_id_selector(
      "1abc"
    ),
    "#\\31 abc"
  )
})

# --- buttons / pagination / layout validation ------------------------------

test_that("disabled anchor buttons carry .disabled and tabindex", {
  html <- render(bs_button(
    label = "L",
    href = "/x",
    disabled = TRUE
  ))
  expect_match(
    html,
    "class=\"btn btn-primary disabled\""
  )
  expect_match(
    html,
    "tabindex=\"-1\""
  )
  expect_match(
    html,
    "aria-disabled=\"true\""
  )
})

test_that("bs_pagination_numbered validates current", {
  expect_error(
    bs_pagination_numbered(
      3,
      current = 10
    ),
    "between 1 and"
  )
  expect_error(
    bs_pagination_numbered(
      3,
      current = 0
    ),
    "between 1 and"
  )
})

test_that("layout scales are validated", {
  expect_error(
    bs_col(
      width = 15
    ),
    "between 1 and 12"
  )
  expect_error(
    bs_col(
      md = FALSE
    ),
    "between 1 and 12"
  )
  expect_error(
    bs_row(
      gutters = 9
    ),
    "between 0 and 5"
  )
  expect_error(
    bs_hstack(
      gap = 9
    ),
    "between 0 and 5"
  )
  expect_error(
    bs_vstack(
      gap = -1
    ),
    "between 0 and 5"
  )
  expect_error(
    bs_display_heading(
      "X",
      level = 7
    ),
    "between 1 and 6"
  )
  expect_error(
    bs_card_title(
      "X",
      level = 0
    ),
    "between 1 and 6"
  )
  expect_error(
    bs_dropdown_header(
      "X",
      level = 9
    ),
    "between 1 and 6"
  )
  # valid values still work
  expect_match(
    render(bs_col(
      width = 6,
      md = "auto"
    )),
    "col-6 col-md-auto"
  )
  expect_match(
    render(bs_row(
      gutters = 3
    )),
    "gx-3 gy-3"
  )
})

# --- progress ---------------------------------------------------------------

test_that("progress uses the 5.3 track markup and clamps percentages", {
  html <- render(bs_progress(bs_progress_bar(
    value = 150,
    id = "p"
  )))
  # Bootstrap 5.3: role + aria on the .progress track, bar purely visual.
  track <- regmatches(
    html,
    regexpr(
      "<div[^>]*class=\"progress\"[^>]*>",
      html
    )
  )
  expect_match(
    track,
    "role=\"progressbar\""
  )
  expect_match(
    track,
    "aria-valuenow=\"150\""
  )
  expect_match(
    track,
    "id=\"p\""
  )
  bar <- regmatches(
    html,
    regexpr(
      "<div class=\"progress-bar\"[^>]*>",
      html
    )
  )
  expect_no_match(
    bar,
    "role="
  )
  expect_match(
    html,
    "width: 100%"
  )
  expect_match(
    render(bs_progress_bar(
      value = -10
    )),
    "width: 0%"
  )
})

# --- list group --------------------------------------------------------------

test_that("selectable list groups emit valid HTML (no <li> in <div>)", {
  html <- render(bs_list_group(
    "sel",
    bs_list_group_item(
      "A",
      value = "a"
    )
  ))
  expect_match(
    html,
    "^<div"
  )
  expect_no_match(
    html,
    "<li"
  )
  expect_match(
    html,
    "<div class=\"list-group-item\""
  )
})

test_that("disabled anchor list items are keyboard-unreachable", {
  html <- render(bs_list_group_item(
    "X",
    href = "#",
    disabled = TRUE
  ))
  expect_match(
    html,
    "tabindex=\"-1\""
  )
})

# --- nav-tabs -----------------------------------------------------------------

test_that("bs_tabset validates selected and marks vertical orientation", {
  expect_error(
    bs_tabset(
      "t",
      bs_tab_panel(
        "A",
        "a"
      ),
      selected = "nope"
    ),
    "does not match any"
  )
  html <- render(bs_tabset(
    "t",
    bs_tab_panel(
      "A",
      "a"
    ),
    vertical = TRUE
  ))
  expect_match(
    html,
    "aria-orientation=\"vertical\""
  )
})

# --- 5.2 fidelity -------------------------------------------------------------

test_that("bs_card_subtitle uses the 5.3 body-secondary class", {
  html <- render(bs_card_subtitle(
    "S"
  ))
  expect_match(
    html,
    "text-body-secondary"
  )
  expect_no_match(
    html,
    "text-muted"
  )
})

test_that("offcanvas titles are wired via aria-labelledby", {
  html <- render(bs_offcanvas(
    "menu",
    "Body",
    title = "Menu"
  ))
  expect_match(
    html,
    "aria-labelledby=\"menu-title\""
  )
  expect_match(
    html,
    "<h5 class=\"offcanvas-title\" id=\"menu-title\""
  )
})

test_that("bs_page_fillable does not leak a fillable attribute", {
  html <- render(bs_page_fillable(
    "x"
  ))
  expect_no_match(
    html,
    "fillable=\""
  )
})

# --- content -----------------------------------------------------------------

test_that("bs_table keeps unnamed children (e.g. a tfoot) alongside data", {
  html <- render(bs_table(
    data.frame(
      x = 1
    ),
    htmltools::tags$tfoot(htmltools::tags$tr(htmltools::tags$td(
      "total"
    )))
  ))
  expect_match(
    html,
    "<tfoot>"
  )
})

test_that("bs_breadcrumb escapes quotes in the divider", {
  html <- render(bs_breadcrumb(
    bs_breadcrumb_item(
      "Home"
    ),
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
    bs_notify_toast(
      htmltools::tags$b(
        "hi"
      ),
      session = s
    ),
    "plain-text"
  )
  expect_error(
    bs_notify_toast(
      "ok",
      title = htmltools::tags$b(
        "t"
      ),
      session = s
    ),
    "plain-text"
  )
  expect_error(
    bs_notify_toast(
      "ok",
      dely = 100,
      session = s
    ),
    class = "rlib_error_dots_nonempty"
  )

  bs_notify_toast(
    "ok",
    title = "T",
    autohide = FALSE,
    session = s
  )
  msg <- audit_last_msg(
    s
  )
  expect_false(
    msg$autohide
  )
  expect_identical(
    msg$body,
    "ok"
  )
  expect_identical(
    msg$title,
    "T"
  )
})

# --- theme parser ---------------------------------------------------------------

test_that("parse_scss_variables strips multi-line block comments", {
  tmp <- tempfile(
    fileext = ".scss"
  )
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
  on.exit(
    unlink(
      tmp
    ),
    add = TRUE
  )
  vars <- parse_scss_variables(
    tmp
  )
  expect_false(
    "commented" %in%
      names(
        vars
      )
  )
  expect_identical(
    vars$primary,
    "#ff6600"
  )
  # every declaration on a line is read, not just the first
  expect_identical(
    vars$a,
    "1"
  )
  expect_identical(
    vars$b,
    "2"
  )
})

# --- scrollspy ---------------------------------------------------------------

test_that("bs_scrollspy gets an id and the bootstrict marker", {
  html <- render(bs_scrollspy(
    "nav-menu",
    "content"
  ))
  expect_match(
    html,
    "data-bootstrict=\"scrollspy\""
  )
  expect_match(
    html,
    "id=\"bs-scrollspy-"
  )
  expect_match(
    html,
    "data-bs-target=\"#nav-menu\""
  )
  # explicit ids are kept
  expect_match(
    render(bs_scrollspy(
      "nav-menu",
      "content",
      id = "spy"
    )),
    "id=\"spy\""
  )
})

test_that("parse_scss_variables reads multi-line declarations (every Bootstrap map)", {
  # The parser used to match `$name: ...;` line by line, so a declaration
  # spanning several lines matched nothing and was dropped without a word --
  # that is the shape of $theme-colors, $grid-breakpoints, $spacers, and of
  # most of what a designer actually overrides.
  tmp <- tempfile(
    fileext = ".scss"
  )
  writeLines(
    c(
      "$theme-colors: (",
      '  "primary": #ff6600,   // brand',
      '  "secondary": #6c757d',
      ");",
      "$spacers: map-merge($spacers, (6: 4rem));"
    ),
    tmp
  )
  vars <- parse_scss_variables(
    tmp
  )
  expect_named(
    vars,
    c(
      "theme-colors",
      "spacers"
    )
  )
  expect_match(
    vars[[
      "theme-colors"
    ]],
    "\"secondary\": #6c757d"
  )
  # The comment inside the map is stripped, not carried into the value.
  expect_no_match(
    vars[[
      "theme-colors"
    ]],
    "brand",
    fixed = TRUE
  )
  expect_equal(
    vars[[
      "spacers"
    ]],
    "map-merge($spacers, (6: 4rem))"
  )
})

test_that("parse_scss_variables treats delimiters inside strings and url() as data", {
  # `//` used to be stripped as a comment wherever it appeared, which killed
  # $web-font-path -- the most common non-colour variable a designer sets --
  # along with the rest of its declaration.
  tmp <- tempfile(
    fileext = ".scss"
  )
  writeLines(
    c(
      '$web-font-path: "https://fonts.googleapis.com/css2?family=Inter";',
      "$logo: url(https://cdn.example.com/logo.svg);",
      '$content: "a; b";'
    ),
    tmp
  )
  vars <- parse_scss_variables(
    tmp
  )
  expect_equal(
    vars[[
      "web-font-path"
    ]],
    "\"https://fonts.googleapis.com/css2?family=Inter\""
  )
  expect_equal(
    vars[[
      "logo"
    ]],
    "url(https://cdn.example.com/logo.svg)"
  )
  expect_equal(
    vars[[
      "content"
    ]],
    "\"a; b\""
  )
})

test_that("parse_scss_variables handles interpolation, rule blocks and a missing final semicolon", {
  tmp <- tempfile(
    fileext = ".scss"
  )
  writeLines(
    c(
      "$interp: #{$primary};",
      ".une-regle { color: red; }",
      "$after-block: #123456;",
      "@use \"sass:map\";",
      "$last: #000"
    ),
    tmp
  )
  vars <- parse_scss_variables(
    tmp
  )
  # `#{}` must not read as a rule block, a rule block must not bleed into the
  # declaration that follows it, and the last line has no `;`.
  expect_equal(
    vars[[
      "interp"
    ]],
    "#{$primary}"
  )
  expect_equal(
    vars[[
      "after-block"
    ]],
    "#123456"
  )
  expect_equal(
    vars[[
      "last"
    ]],
    "#000"
  )
  expect_false(
    "color" %in%
      names(
        vars
      )
  )
})

test_that("parse_scss_variables reads Bootstrap's own variable sheet", {
  vars <- parse_scss_variables(file.path(
    bootstrict:::bootstrap_lib(),
    "scss",
    "_variables.scss"
  ))
  expect_true(all(
    c(
      "theme-colors",
      "grid-breakpoints",
      "spacers",
      "font-sizes"
    ) %in%
      names(
        vars
      )
  ))
})

test_that("bootstrict_theme routes a value built from another Sass variable", {
  # A colour given as a reference -- the form Bootstrap ships its own defaults
  # in -- has to reach the layer where that reference resolves.
  expect_named(
    bootstrict_theme(
      secondary = "$gray-600"
    )$declarations,
    "secondary"
  )
  expect_named(
    bootstrict_theme(
      "link-hover-color" = "shade-color($primary, 20%)"
    )$declarations,
    "link-hover-color"
  )
})

test_that("bootstrict_theme routes each value to a layer that compiles", {
  skip_on_cran()
  compiled <- function(
    theme
  ) {
    dep <- bootstrap_dep(
      theme
    )
    paste(
      readLines(
        file.path(
          dep$src$file,
          dep$stylesheet
        ),
        warn = FALSE
      ),
      collapse = "\n"
    )
  }
  var_of <- function(
    css,
    name
  ) {
    m <- regmatches(
      css,
      regexpr(
        paste0(
          "--bs-",
          name,
          ":[^;]+"
        ),
        css
      )
    )
    if (
      length(
        m
      )
    )
      trimws(sub(
        ".*:",
        "",
        m
      )) else
      NA_character_
  }

  # A sheet that refers to its own variables must keep working end to end: the
  # values land in the defaults layer, in sheet order, so Bootstrap still
  # derives everything from them.
  tmp <- tempfile(
    fileext = ".scss"
  )
  writeLines(
    c(
      "$brand-orange: #ff6600;",
      "$primary: $brand-orange;",
      "$gray-700: #aa0000;",
      "$secondary: $gray-700;"
    ),
    tmp
  )
  css <- compiled(bootstrict_theme(
    variables = tmp
  ))
  expect_equal(
    var_of(
      css,
      "primary"
    ),
    "#f60"
  )
  expect_equal(
    var_of(
      css,
      "secondary"
    ),
    "#a00"
  )

  # A multi-line map naming one of the sheet's own colours: the designer's
  # entry generates its own theme colour.
  map_sheet <- tempfile(
    fileext = ".scss"
  )
  writeLines(
    c(
      "$primary: #ff6600;",
      "$theme-colors: (",
      '  "primary": $primary,',
      '  "brand": #00aa88',
      ");"
    ),
    map_sheet
  )
  mapped <- compiled(bootstrict_theme(
    variables = map_sheet
  ))
  expect_equal(
    var_of(
      mapped,
      "primary"
    ),
    "#f60"
  )
  expect_equal(
    var_of(
      mapped,
      "brand"
    ),
    "#0a8"
  )

  # A value derived from one of Bootstrap's variables goes to the declarations
  # layer, where that variable exists, and takes effect.
  derived <- compiled(bootstrict_theme(
    primary = "#ff6600",
    "link-hover-color" = "shade-color($primary, 40%)"
  ))
  expect_equal(
    var_of(
      derived,
      "link-hover-color"
    ),
    "#993d00"
  )
})

test_that("scss_variable_refs lists the variables a value refers to", {
  expect_equal(
    bootstrict:::scss_variable_refs(
      "#ff6600"
    ),
    character()
  )
  expect_equal(
    bootstrict:::scss_variable_refs(
      "map-merge($spacers, (6: $gap))"
    ),
    c(
      "spacers",
      "gap"
    )
  )
  expect_equal(
    bootstrict:::scss_variable_refs(
      TRUE
    ),
    character()
  )
})

test_that("panel constructors accept lapply()-built children", {
  # Generating panels in a loop is the usual thing to do in a data-driven app,
  # and dev/CONVENTIONS.md says to let htmltools flatten lists. The type
  # validation ran before any flattening, so it saw the list itself.
  panels <- lapply(
    1:3,
    function(
      i
    )
      bs_tab_panel(
        paste(
          "T",
          i
        ),
        "body",
        value = as.character(
          i
        )
      )
  )
  expect_equal(
    length(gregexpr(
      "nav-link",
      as.character(bs_tabset(
        "t",
        panels
      ))
    )[[
      1
    ]]),
    3L
  )

  expect_match(
    as.character(bs_accordion(
      "a",
      lapply(
        1:2,
        function(
          i
        )
          bs_accordion_panel(
            paste(
              "P",
              i
            ),
            "b",
            value = as.character(
              i
            )
          )
      )
    )),
    "data-value=\"2\""
  )
  expect_match(
    as.character(bs_carousel(
      "c",
      lapply(
        1:2,
        function(
          i
        )
          bs_carousel_item(paste(
            "S",
            i
          ))
      )
    )),
    "carousel-item"
  )
  expect_match(
    as.character(bs_progress(lapply(
      c(
        20,
        30
      ),
      bs_progress_bar
    ))),
    "progress-stacked"
  )

  # Mixing a direct child with a list keeps document order, and a tagList is a
  # container to open like any other.
  expect_match(
    as.character(bs_tabset(
      "t",
      bs_tab_panel(
        "A",
        "a",
        value = "a"
      ),
      lapply(
        2:3,
        function(
          i
        )
          bs_tab_panel(
            paste(
              "T",
              i
            ),
            "b",
            value = as.character(
              i
            )
          )
      )
    )),
    "data-value=\"a\".*data-value=\"2\".*data-value=\"3\""
  )
  expect_no_error(
    bs_tabset(
      "t",
      htmltools::tagList(bs_tab_panel(
        "A",
        "a",
        value = "a"
      ))
    )
  )
})

test_that("flattening children does not take a panel object apart", {
  # A bs_tab_panel is a classed list: descending into it would dismantle it,
  # and the type check would then reject its pieces.
  expect_true(bootstrict:::is_bare_list(list(
    1,
    2
  )))
  expect_true(bootstrict:::is_bare_list(htmltools::tagList()))
  expect_false(bootstrict:::is_bare_list(bs_tab_panel(
    "A",
    "a",
    value = "a"
  )))
  expect_false(bootstrict:::is_bare_list(htmltools::div()))
  expect_false(bootstrict:::is_bare_list(
    "text"
  ))

  # The type error is still raised for a genuinely wrong child.
  expect_error(
    bs_tabset(
      "t",
      "not a panel"
    ),
    "must be `bs_tab_panel"
  )
})

test_that("a forgotten leading id is reported instead of silently rendered", {
  # These constructors take their id first, so the first child landed on `id`:
  # bs_tabset(bs_tab_panel("A", "a")) rendered an empty <ul> whose id was the
  # deparsed panel object.
  for (fn in c(
    "bs_tabset",
    "bs_accordion",
    "bs_carousel",
    "bs_collapse",
    "bs_modal",
    "bs_offcanvas",
    "bs_toast"
  )) {
    expect_error(
      do.call(
        fn,
        list(htmltools::div(
          "x"
        ))
      ),
      "single non-empty string",
      info = fn
    )
  }
  expect_error(
    bs_tabset(
      NULL
    ),
    "single non-empty string"
  )
  expect_error(
    bs_modal(c(
      "a",
      "b"
    )),
    "single non-empty string"
  )
  expect_error(
    bs_modal(
      NA_character_
    ),
    "single non-empty string"
  )
  expect_error(
    bs_modal(
      ""
    ),
    "single non-empty string"
  )
})

test_that("bs_list_group keeps taking a leading item instead of an id", {
  # Its id is optional and leading, so an items-only call passes the first item
  # positionally; the constructor already treats a non-string `id` as a child,
  # which is better than an error and is what the documented example does.
  out <- as.character(bs_list_group(
    bs_list_group_item(
      "An item"
    ),
    bs_list_group_item(
      "A second",
      active = TRUE
    ),
    flush = TRUE
  ))
  expect_match(
    out,
    "list-group-flush"
  )
  expect_equal(
    length(gregexpr(
      "list-group-item",
      out
    )[[
      1
    ]]),
    2L
  )
  expect_no_match(
    out,
    "id=",
    fixed = TRUE
  )
})

test_that("panel constructors apply named ... as attributes, not body text", {
  expect_match(
    as.character(bs_tabset(
      "t",
      bs_tab_panel(
        "T",
        "body",
        value = "v",
        `data-x` = "1"
      )
    )),
    "data-value=\"v\" data-x=\"1\">body</div>"
  )
  expect_match(
    as.character(bs_accordion(
      "a",
      bs_accordion_panel(
        "T",
        "body",
        value = "v",
        `data-x` = "1"
      )
    )),
    "data-x=\"1\""
  )
})

test_that("a tag title yields readable text as its value, not escaped markup", {
  # as.character() on a tag gives its markup, so the value used to be
  # data-value="&lt;span&gt;Home&lt;/span&gt;".
  expect_match(
    as.character(bs_tabset(
      "t",
      bs_tab_panel(
        htmltools::span(
          "Home"
        ),
        "c"
      )
    )),
    "data-value=\"Home\""
  )
  expect_match(
    as.character(bs_accordion(
      "a",
      bs_accordion_panel(
        htmltools::span(
          "Home"
        ),
        "c"
      )
    )),
    "data-value=\"Home\""
  )
  # A title with no text at all cannot yield one: say so instead of guessing.
  expect_error(
    bs_tab_panel(
      htmltools::tags$i(
        class = "icon"
      ),
      "c"
    ),
    "needs a `value`"
  )
})

test_that("small markup defects are fixed", {
  # The .form-text node stays with the container the input group discards.
  expect_no_match(
    as.character(bs_input_group(
      bs_input_group_text(
        "@"
      ),
      bs_text_input(
        "u",
        NULL,
        help = "hint"
      )
    )),
    "aria-describedby",
    fixed = TRUE
  )
  # A <select> has no placeholder attribute.
  expect_no_match(
    as.character(bs_floating_label(bs_select_input(
      "s",
      "Sel",
      c(
        "a",
        "b"
      )
    ))),
    "placeholder",
    fixed = TRUE
  )
  expect_match(
    as.character(bs_floating_label(bs_text_input(
      "e",
      "Email"
    ))),
    "placeholder"
  )
  # Bootstrap resolves a collapse target with querySelectorAll: several
  # targets are a comma-separated selector, not just the first one.
  expect_match(
    as.character(bs_collapse_trigger(
      c(
        "a",
        "b"
      ),
      "Toggle"
    )),
    "data-bs-target=\"#a, #b\""
  )
  # A disabled nav link must leave the keyboard tab order.
  expect_match(
    as.character(bs_nav_link(
      "B",
      disabled = TRUE
    )),
    "tabindex=\"-1\""
  )
  expect_no_match(
    as.character(bs_nav_link(
      "B"
    )),
    "tabindex",
    fixed = TRUE
  )
  # An unvalidated align became a class that does not exist.
  expect_error(
    bs_table(
      data.frame(
        a = 1
      ),
      align = "bogus"
    ),
    "`align` must be"
  )
  # An <img> with no alt at all is announced by its file name.
  expect_match(
    as.character(bs_img(
      "a.png"
    )),
    "alt=\"\""
  )
  expect_match(
    as.character(bs_card_img(
      "a.png"
    )),
    "alt=\"\""
  )
})

test_that("a hand-composed modal gets an accessible name", {
  # aria-labelledby was only ever set by the `title` shortcut.
  expect_match(
    as.character(bs_modal(
      "m",
      bs_modal_header(bs_modal_title(
        "Titre"
      )),
      bs_modal_body(
        "b"
      )
    )),
    "aria-labelledby=\"m-title\".*id=\"m-title\""
  )
  # An id the caller set wins.
  expect_match(
    as.character(bs_modal(
      "m",
      bs_modal_header(bs_modal_title(
        "Titre",
        id = "mine"
      ))
    )),
    "aria-labelledby=\"mine\""
  )
  # No title, no claim.
  expect_no_match(
    as.character(bs_modal(
      "m",
      "body"
    )),
    "aria-labelledby",
    fixed = TRUE
  )
})
