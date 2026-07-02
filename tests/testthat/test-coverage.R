# Targeted tests filling the remaining coverage gaps: server-side update_*()
# helpers (exercised through a mock Shiny session), the golem project hook,
# and the handful of constructors / internal helpers not otherwise reached.

render <- function(x) as.character(x)

# A minimal stand-in for a Shiny session: it captures the custom / input
# messages the update_*() helpers push, and namespaces ids like a module.
mock_session <- function(ns = TRUE) {
  store <- new.env(parent = emptyenv())
  store$custom <- list()
  store$input <- list()
  session <- list(
    sendCustomMessage = function(type, message) {
      store$custom[[length(store$custom) + 1L]] <- list(
        type = type,
        message = message
      )
      invisible()
    },
    sendInputMessage = function(id, message) {
      store$input[[length(store$input) + 1L]] <- list(
        id = id,
        message = message
      )
      invisible()
    },
    .store = store
  )
  if (isTRUE(ns)) {
    session$ns <- function(x) paste0("mod-", x)
  }
  session
}

last_custom <- function(session) {
  msgs <- session$.store$custom
  msgs[[length(msgs)]]
}

# --- messaging: bs_send / bs_ns -------------------------------------------

test_that("bs_send pushes a bootstrict-message and drops NULL fields", {
  s <- mock_session(ns = FALSE)
  bootstrict:::bs_send("demo.method", a = 1, b = NULL, session = s)
  msg <- last_custom(s)
  expect_equal(msg$type, "bootstrict-message")
  expect_equal(msg$message$method, "demo.method")
  expect_equal(msg$message$a, 1)
  expect_false("b" %in% names(msg$message))
})

test_that("bs_ns namespaces when the session is a module, passes through otherwise", {
  expect_equal(bootstrict:::bs_ns("x", mock_session(ns = TRUE)), "mod-x")
  expect_equal(bootstrict:::bs_ns("x", NULL), "x")
})

# --- accordion: open = TRUE opens every panel -----------------------------

test_that("bs_accordion open = TRUE shows all panels", {
  out <- render(bs_accordion(
    "acc",
    bs_accordion_panel("First", "one", value = "one"),
    bs_accordion_panel("Second", "two", value = "two"),
    open = TRUE,
    multiple = TRUE
  ))
  expect_equal(
    lengths(regmatches(out, gregexpr("collapse show", out))),
    2L
  )
})

# --- carousel: more than one active item is reduced to one ----------------

test_that("bs_carousel keeps only the first active item when several are set", {
  out <- render(bs_carousel(
    "c",
    bs_carousel_item("a", active = TRUE),
    bs_carousel_item("b", active = TRUE),
    bs_carousel_item("c", active = TRUE)
  ))
  # exactly one .carousel-item.active survives
  expect_equal(
    lengths(regmatches(out, gregexpr("carousel-item active", out))),
    1L
  )
})

# --- accordion ------------------------------------------------------------

test_that("update_bs_accordion sends namespaced open/close payloads", {
  s <- mock_session()
  update_bs_accordion("acc", open = "one", close = c("two", "three"), session = s)
  msg <- last_custom(s)
  expect_equal(msg$message$method, "accordion.update")
  expect_equal(msg$message$id, "mod-acc")
  expect_equal(msg$message$open, list("one"))
  expect_equal(msg$message$close, list("two", "three"))

  update_bs_accordion("acc", close = TRUE, session = s)
  expect_equal(last_custom(s)$message$close, "__all__")
})

test_that("as_msg_list keeps length-1 vectors as arrays", {
  expect_null(bootstrict:::as_msg_list(NULL))
  expect_equal(bootstrict:::as_msg_list("a"), list("a"))
})

# --- carousel -------------------------------------------------------------

test_that("update_bs_carousel forwards to/slide", {
  s <- mock_session()
  update_bs_carousel("demo", to = 2, session = s)
  msg <- last_custom(s)
  expect_equal(msg$message$method, "carousel.update")
  expect_equal(msg$message$id, "mod-demo")
  expect_equal(msg$message$to, 2L)

  update_bs_carousel("demo", slide = "next", session = s)
  expect_equal(last_custom(s)$message$slide, "next")
})

# --- collapse -------------------------------------------------------------

test_that("update_bs_collapse sends the action", {
  s <- mock_session()
  update_bs_collapse("more", "show", session = s)
  msg <- last_custom(s)
  expect_equal(msg$message$method, "collapse.update")
  expect_equal(msg$message$action, "show")
})

# --- modal ----------------------------------------------------------------

test_that("show/hide/toggle modal each dispatch their method", {
  s <- mock_session()
  show_bs_modal("info", session = s)
  expect_equal(last_custom(s)$message$method, "modal.show")
  hide_bs_modal("info", session = s)
  expect_equal(last_custom(s)$message$method, "modal.hide")
  toggle_bs_modal("info", session = s)
  expect_equal(last_custom(s)$message$method, "modal.toggle")
  expect_equal(last_custom(s)$message$id, "mod-info")
})

# --- offcanvas ------------------------------------------------------------

test_that("show/hide/toggle offcanvas each dispatch their method", {
  s <- mock_session()
  show_bs_offcanvas("menu", session = s)
  expect_equal(last_custom(s)$message$method, "offcanvas.show")
  hide_bs_offcanvas("menu", session = s)
  expect_equal(last_custom(s)$message$method, "offcanvas.hide")
  toggle_bs_offcanvas("menu", session = s)
  expect_equal(last_custom(s)$message$method, "offcanvas.toggle")
})

# --- toast ----------------------------------------------------------------

test_that("show/hide toast and bs_notify_toast dispatch their methods", {
  s <- mock_session()
  show_bs_toast("hello", session = s)
  expect_equal(last_custom(s)$message$method, "toast.show")
  hide_bs_toast("hello", session = s)
  expect_equal(last_custom(s)$message$method, "toast.hide")

  bs_notify_toast(
    "Saved!",
    title = "Status",
    color = "success",
    placement = "bottom-end",
    session = s
  )
  msg <- last_custom(s)
  expect_equal(msg$message$method, "toast.notify")
  expect_equal(msg$message$body, "Saved!")
  expect_equal(msg$message$color, "success")
  expect_equal(msg$message$placement, "bottom-end")
})

test_that("toast_placement_class maps every placement keyword", {
  expect_equal(
    bootstrict:::toast_placement_class("top-start"),
    "top-0 start-0"
  )
  expect_equal(
    bootstrict:::toast_placement_class("middle-center"),
    "top-50 start-50 translate-middle"
  )
  expect_equal(
    bootstrict:::toast_placement_class("middle-start"),
    "top-50 start-0 translate-middle-y"
  )
  expect_equal(
    bootstrict:::toast_placement_class("middle-end"),
    "top-50 end-0 translate-middle-y"
  )
  expect_match(
    render(bs_toast_container(placement = "bottom-center")),
    "translate-middle-x"
  )
})

# --- tabset ---------------------------------------------------------------

test_that("update_bs_tabset selects a panel and vertical tabset lays out flex", {
  s <- mock_session()
  update_bs_tabset("tabs", selected = "profile", session = s)
  msg <- last_custom(s)
  expect_equal(msg$message$method, "tabset.update")
  expect_equal(msg$message$selected, "profile")

  out <- render(bs_tabset(
    "v",
    bs_tab_panel("Home", "home", value = "home"),
    vertical = TRUE
  ))
  expect_match(out, "d-flex align-items-start")

  # an empty tabset with no panels and no explicit selection
  expect_match(render(bs_tabset("empty")), "bootstrict-tabset")
})

# --- list group -----------------------------------------------------------

test_that("update_bs_list_group sends the selected value", {
  s <- mock_session()
  update_bs_list_group("grp", selected = "two", session = s)
  msg <- last_custom(s)
  expect_equal(msg$message$method, "listgroup.update")
  expect_equal(msg$message$selected, "two")
})

# --- progress -------------------------------------------------------------

test_that("update_bs_progress dispatches and bs_progress_pct clamps a zero span", {
  s <- mock_session()
  update_bs_progress("load", value = 80, color = "info", session = s)
  msg <- last_custom(s)
  expect_equal(msg$message$method, "progress.update")
  expect_equal(msg$message$value, 80)
  expect_equal(msg$message$color, "info")

  expect_equal(bootstrict:::bs_progress_pct(5, min = 10, max = 10), 0)
  expect_equal(bootstrict:::bs_progress_pct(50, min = 0, max = 100), 50)
})

# --- range / colour inputs ------------------------------------------------

test_that("bs_color_input builds a colour control; update_* route through sendInputMessage", {
  out <- render(bs_color_input(
    "col",
    "Pick",
    value = "#0d6efd",
    help = "hex",
    width = "120px"
  ))
  expect_match(out, "form-control-color")
  expect_match(out, "width:120px")
  expect_match(out, "form-text")

  s <- mock_session()
  update_bs_range("vol", 75, session = s)
  expect_equal(s$.store$input[[1]]$message$value, 75)
  update_bs_color("col", "#198754", session = s)
  expect_equal(s$.store$input[[2]]$message$value, "#198754")

  expect_error(update_bs_range("vol", 1, session = NULL))
  expect_error(update_bs_color("col", "#fff", session = NULL))
})

# --- forms: textarea / password -------------------------------------------

test_that("textarea and password inputs gain Bootstrap classes", {
  ta <- render(bs_textarea_input(
    "bio",
    "Bio",
    rows = 3,
    size = "lg",
    help = "tell us"
  ))
  expect_match(ta, "form-control form-control-lg")
  expect_match(ta, "<textarea")
  expect_match(ta, "form-text")

  pw <- render(bs_password_input("pw", "Password", size = "sm"))
  expect_match(pw, "form-control form-control-sm")
  expect_match(pw, 'type="password"')
})

# --- forms layout: input group + floating label ---------------------------

test_that("input group unwraps controls to bare form-control children", {
  out <- render(bs_input_group(
    bs_input_group_text("@"),
    bs_text_input("user", placeholder = "Username"),
    size = "lg"
  ))
  expect_match(out, "input-group input-group-lg")
  expect_match(out, "input-group-text")
  # the text input's .shiny-input-container wrapper is unwrapped to the <input>
  expect_match(out, 'id="user"')
})

test_that("floating label reuses the control's own label text", {
  out <- render(bs_floating_label(bs_text_input("email", "Email address")))
  expect_match(out, "form-floating")
  expect_match(out, "Email address")
  expect_match(out, 'for="email"')
})

test_that("input group passes bare (non-tag) content through untouched", {
  out <- render(bs_input_group(
    "plain text",
    bs_input_group_text("@")
  ))
  expect_match(out, "plain text")
})

test_that("find_label_text returns NULL when no label exists in the tree", {
  expect_null(
    bootstrict:::find_label_text(htmltools::div(htmltools::span("hi")))
  )
})

# --- forms controls: form_check_enhance via radio/checkbox already covered;
#     ensure colour input default value path runs too.

# --- alert helpers --------------------------------------------------------

test_that("alert heading and link render their classes", {
  expect_match(
    render(bs_alert_heading("Title", level = 3)),
    "<h3[^>]*alert-heading"
  )
  out <- render(bs_alert_link("more", href = "/x"))
  expect_match(out, "alert-link")
  expect_match(out, 'href="/x"')
})

# --- buttons: group / toolbar ---------------------------------------------

test_that("button group and toolbar render their roles and classes", {
  g <- render(bs_button_group(
    bs_button(label = "L"),
    bs_button(label = "R"),
    size = "sm",
    label = "Actions"
  ))
  expect_match(g, "btn-group btn-group-sm")
  expect_match(g, 'role="group"')
  expect_match(g, 'aria-label="Actions"')

  gv <- render(bs_button_group(vertical = TRUE))
  expect_match(gv, "btn-group-vertical")

  tb <- render(bs_button_toolbar(label = "Toolbar"))
  expect_match(tb, "btn-toolbar")
  expect_match(tb, 'role="toolbar"')
})

# --- card extras ----------------------------------------------------------

test_that("card footer / subtitle / link / img / overlay / group render", {
  expect_match(render(bs_card_footer("f")), "card-footer")
  expect_match(render(bs_card_subtitle("s")), "card-subtitle")
  expect_match(render(bs_card_link("l", href = "/x")), "card-link")

  img <- render(bs_card_img("p.png", position = "bottom", alt = "pic"))
  expect_match(img, "card-img-bottom")
  expect_match(img, 'alt="pic"')
  expect_match(render(bs_card_img("p.png", position = "overlay")), "card-img")

  expect_match(render(bs_card_img_overlay("x")), "card-img-overlay")
  expect_match(render(bs_card_group(bs_card(bs_card_body("x")))), "card-group")
})

# --- content: table from data frame / matrix ------------------------------

test_that("bs_table builds head + body from a data frame, formatting NA cells", {
  df <- data.frame(
    a = c(1, NA),
    b = c("x", "y"),
    stringsAsFactors = FALSE
  )
  out <- render(bs_table(df, striped = TRUE, responsive = "md"))
  expect_match(out, "table-responsive-md")
  expect_match(out, "<thead")
  expect_match(out, "<tbody")
  expect_match(out, "<th scope=\"col\">a</th>")

  # matrix without column names -> V1/V2 headers
  m <- matrix(1:4, nrow = 2)
  out2 <- render(bs_table(m))
  expect_match(out2, ">V1<")

  expect_equal(bootstrict:::format_cell(NA), "")
  expect_equal(bootstrict:::format_cell(NULL), "")
  expect_equal(bootstrict:::format_cell(3), "3")

  # a data frame with no column names falls back to V1/V2 headers
  noname <- as.data.frame(matrix(1:4, nrow = 2))
  names(noname) <- NULL
  built <- bootstrict:::bs_table_from_data(noname)
  expect_match(render(built$head), ">V1<")
})

# --- layout: per-breakpoint responsive classes & column spans -------------

test_that("bs_col handles every breakpoint and responsive_classes a named list", {
  out <- render(bs_col(
    width = "auto",
    sm = 6,
    md = 4,
    lg = 3,
    xl = 2,
    xxl = TRUE
  ))
  expect_match(out, "col-auto")
  expect_match(out, "col-sm-6")
  expect_match(out, "col-md-4")
  expect_match(out, "col-lg-3")
  expect_match(out, "col-xl-2")
  expect_match(out, "col-xxl")

  # scalar (non-list) value -> a single un-prefixed class
  expect_equal(bootstrict:::responsive_classes("row-cols", 2), "row-cols-2")
  expect_match(render(bs_col(offset = 2)), "offset-2")
  expect_equal(
    bootstrict:::responsive_classes("offset", list(md = 2, lg = 3)),
    c("offset-md-2", "offset-lg-3")
  )
  # an unnamed / xs entry has no breakpoint segment
  expect_equal(
    bootstrict:::responsive_classes("row-cols", list(xs = 1)),
    "row-cols-1"
  )
  expect_match(
    render(bs_row(cols = list(sm = 1, md = 2))),
    "row-cols-sm-1 row-cols-md-2"
  )
})

# --- page constructors ----------------------------------------------------

test_that("page constructors attach the bootstrict dependency", {
  has_dep <- function(x) {
    any(vapply(
      htmltools::findDependencies(x),
      function(d) identical(d$name, "bootstrict"),
      logical(1)
    ))
  }
  expect_true(has_dep(bs_page(title = "t", bs_container("hi"))))
  expect_true(has_dep(bs_page_fluid(bs_container("hi"))))
  expect_true(has_dep(bs_page_fillable(bs_container("hi"))))
})

# --- theme ----------------------------------------------------------------

test_that("bootstrict_theme accepts a variable list, a bootswatch, and rejects junk", {
  th <- bootstrict_theme(variables = list(primary = "#fff"))
  expect_s3_class(th, "bs_theme")
  expect_s3_class(bootstrict_theme(bootswatch = "minty"), "bs_theme")
  expect_s3_class(bootstrict_theme(preset = "shiny"), "bs_theme")
  expect_error(bootstrict_theme(variables = 123), "named list")
})

test_that("parse_scss_variables errors on a missing file; use_bootstrict returns a dependency", {
  expect_error(
    parse_scss_variables(tempfile(fileext = ".scss")),
    "not found"
  )
  expect_s3_class(use_bootstrict(), "html_dependency")
})

# --- deps: stylesheet absent ----------------------------------------------

test_that("build_bootstrict_dep tolerates a missing stylesheet", {
  # Exercise the css-missing branch against a synthetic assets directory —
  # never by mutating the installed package (which breaks under parallel
  # testing / read-only libraries).
  assets <- tempfile("bootstrict-assets-")
  dir.create(file.path(assets, "js"), recursive = TRUE)
  on.exit(unlink(assets, recursive = TRUE), add = TRUE)
  writeLines("// core", file.path(assets, "js", "bootstrict-core.js"))
  writeLines("// one", file.path(assets, "js", "binding-one.js"))

  dep <- bootstrict:::build_bootstrict_dep(assets)
  expect_s3_class(dep, "html_dependency")
  expect_null(dep$stylesheet)
  # bootstrict-core.js must always load first.
  expect_identical(basename(dep$script[[1]]), "bootstrict-core.js")
})

test_that("bootstrict_dep is cached after the first call", {
  first <- bootstrict_dep()
  expect_s3_class(first, "html_dependency")
  expect_identical(bootstrict_dep(), first)
})

# --- internal utils -------------------------------------------------------

test_that("internal helpers cover their edge branches", {
  expect_true(bootstrict:::is_empty(NULL))
  expect_true(bootstrict:::is_empty(character(0)))
  expect_false(bootstrict:::is_empty("x"))

  expect_error(
    bootstrict:::match_arg(NULL, c("a", "b"), allow_null = FALSE),
    "must be one of"
  )

  expect_null(bootstrict:::bs_bool_attr(NULL))
  expect_equal(bootstrict:::bs_bool_attr(TRUE), "true")
  expect_equal(bootstrict:::bs_bool_attr(FALSE), "false")
  expect_equal(bootstrict:::bs_bool_attr("static"), "static")

  # has_class: a tag with no class attribute
  expect_false(bootstrict:::has_class(htmltools::div(), "x"))
  expect_false(bootstrict:::has_class("not a tag", "x"))

  # tag_modify_where descends into a tag list
  tl <- htmltools::tagList(
    htmltools::div(class = "hit"),
    htmltools::span(class = "hit")
  )
  marked <- bootstrict:::tag_modify_where(
    tl,
    function(t) bootstrict:::has_class(t, "hit"),
    function(t) htmltools::tagAppendAttributes(t, `data-x` = "1")
  )
  expect_match(render(marked), "data-x")

  # find_first_tag: match a nested child, and search through a bare list
  tree <- htmltools::div(htmltools::span(class = "needle", "x"))
  found <- bootstrict:::find_first_tag(
    tree,
    function(t) bootstrict:::has_class(t, "needle")
  )
  expect_equal(found$name, "span")
  found2 <- bootstrict:::find_first_tag(
    list(htmltools::div(), htmltools::span(class = "needle")),
    function(t) bootstrict:::has_class(t, "needle")
  )
  expect_equal(found2$name, "span")
  expect_null(
    bootstrict:::find_first_tag(
      htmltools::div(),
      function(t) bootstrict:::has_class(t, "nope")
    )
  )
})

# --- golem project hook ---------------------------------------------------

test_that("use_bootstrict_golem scaffolds a bootstrict app_ui and variables sheet", {
  old <- getwd()
  dir <- tempfile("golemproj")
  dir.create(dir)
  setwd(dir)
  on.exit(setwd(old), add = TRUE)
  # golem creates the package's R/ directory before invoking the hook.
  dir.create("R")

  use_bootstrict_golem(path = ".", package_name = "my.app")

  expect_true(file.exists(file.path("inst", "app", "www", "_variables.scss")))
  ui <- paste(readLines(file.path("R", "app_ui.R")), collapse = "\n")
  expect_match(ui, "bootstrict::bs_page")
  expect_match(ui, 'title = "my.app"')
  expect_match(ui, "golem_add_external_resources")

  # Second run: the variables sheet already exists, so creation is skipped.
  use_bootstrict_golem(path = ".", package_name = "my.app")
  expect_true(file.exists(file.path("inst", "app", "www", "_variables.scss")))
})
