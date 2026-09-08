# Markup snapshots: components, layout, content and helpers.
#
# These constructors build their HTML themselves, so the snapshots only move
# when bootstrict does. The shiny-delegated form controls live in
# test-snapshot-forms.R, where a shiny release can legitimately move them.

test_that("layout markup is stable", {
  expect_snapshot(snap(bs_container("x")))
  expect_snapshot(snap(bs_container("x", fluid = TRUE)))
  expect_snapshot(snap(bs_row(bs_col("a", width = 6), bs_col("b"), gutters = 3)))
  expect_snapshot(snap(bs_col("x", md = 6, lg = 4, offset = 2)))
  expect_snapshot(snap(bs_hstack("a", "b", gap = 3)))
  expect_snapshot(snap(bs_vstack("a", "b", gap = 2)))
})

test_that("content markup is stable", {
  expect_snapshot(snap(bs_table(
    head(mtcars, 2)[, 1:2],
    striped = TRUE,
    hover = TRUE,
    caption = "Cars"
  )))
  expect_snapshot(snap(bs_table(data.frame(a = 1:2, b = c("x", "y")))))
  expect_snapshot(snap(bs_img("a.png", alt = "A", fluid = TRUE)))
  expect_snapshot(snap(bs_figure(
    bs_figure_img("a.png", alt = "A"),
    bs_figure_caption("A caption")
  )))
  expect_snapshot(snap(bs_blockquote("Quote", footer = "Source")))
  expect_snapshot(snap(bs_display_heading("Display", level = 3)))
  expect_snapshot(snap(bs_lead("Lead paragraph.")))
  expect_snapshot(snap(bs_list_unstyled("One", "Two")))
  expect_snapshot(snap(bs_list_inline("One", "Two")))
  expect_snapshot(snap(bs_icon_link("Icon link", href = "#", hover = TRUE)))
  expect_snapshot(snap(bs_ratio("x", ratio = "16x9")))
  expect_snapshot(snap(bs_vr()))
  expect_snapshot(snap(bs_visually_hidden("Hidden")))
})

test_that("button markup is stable", {
  expect_snapshot(snap(bs_button("go", "Go", color = "primary")))
  expect_snapshot(snap(bs_button("go", "Go", outline = TRUE, size = "lg")))
  expect_snapshot(snap(bs_button("Link", href = "#", disabled = TRUE)))
  expect_snapshot(snap(bs_button_group(
    bs_button("a", "A"),
    bs_button("b", "B"),
    size = "sm"
  )))
  expect_snapshot(snap(bs_button_toolbar(bs_button_group(bs_button("a", "A")))))
  expect_snapshot(snap(bs_close_button()))
  expect_snapshot(snap(bs_download_button("dl", "Download", color = "success")))
  expect_snapshot(snap(bs_download_link("dl", "Download")))
})

test_that("card markup is stable", {
  expect_snapshot(snap(bs_card(
    bs_card_header("Header"),
    bs_card_img("a.png", alt = "A"),
    bs_card_body(
      bs_card_title("Title"),
      bs_card_subtitle("Subtitle"),
      bs_card_text("Body text."),
      bs_card_link("More", href = "#")
    ),
    bs_card_footer("Footer")
  )))
  expect_snapshot(snap(bs_card_group(bs_card(bs_card_body("a")))))
  expect_snapshot(snap(bs_card_img_overlay("over")))
})

test_that("feedback component markup is stable", {
  expect_snapshot(snap(bs_alert(
    bs_alert_heading("Heads up"),
    "Body",
    bs_alert_link("link", href = "#"),
    color = "warning",
    dismissible = TRUE
  )))
  expect_snapshot(snap(bs_badge("4", color = "danger", pill = TRUE)))
  expect_snapshot(snap(bs_progress(bs_progress_bar(40, color = "info"))))
  expect_snapshot(snap(bs_progress(
    bs_progress_bar(15),
    bs_progress_bar(30),
    height = "10px"
  )))
  expect_snapshot(snap(bs_spinner(color = "primary", size = "sm")))
  expect_snapshot(snap(bs_placeholder_glow(bs_placeholder(width = 6))))
  expect_snapshot(snap(bs_placeholder_wave(bs_placeholder(width = 4))))
})

test_that("interactive component markup is stable", {
  expect_snapshot(snap(bs_accordion(
    "acc",
    bs_accordion_panel("One", "first", value = "one"),
    bs_accordion_panel("Two", "second", value = "two"),
    flush = TRUE
  )))
  expect_snapshot(snap(bs_carousel(
    "car",
    bs_carousel_item(bs_img("a.png", alt = "A"), caption = "One", value = "s1"),
    bs_carousel_item(bs_img("b.png", alt = "B"), value = "s2"),
    indicators = TRUE
  )))
  expect_snapshot(snap(bs_collapse("coll", "Body")))
  expect_snapshot(snap(bs_collapse_trigger("coll", "Toggle")))
  expect_snapshot(snap(bs_list_group(
    "lg",
    bs_list_group_item("A", value = "a", action = TRUE),
    bs_list_group_item("B", value = "b", action = TRUE, active = TRUE),
    flush = TRUE
  )))
})

test_that("navigation markup is stable", {
  expect_snapshot(snap(bs_nav(
    bs_nav_item(bs_nav_link("Home", active = TRUE)),
    bs_nav_item(bs_nav_link("Away", disabled = TRUE)),
    type = "underline"
  )))
  expect_snapshot(snap(bs_tabset(
    "tabs",
    bs_tab_panel("One", "first", value = "one"),
    bs_tab_panel("Two", "second", value = "two")
  )))
  # An explicit id: the auto-generated fallback uses a session-wide counter,
  # so the markup would depend on how many navbars ran before.
  expect_snapshot(snap(bs_navbar(
    id = "nav",
    brand = bs_navbar_brand("Brand", href = "/"),
    bs_navbar_nav(
      bs_nav_item(bs_nav_link("Home", active = TRUE)),
      bs_nav_dropdown("More", bs_dropdown_item("Settings"))
    ),
    bs_navbar_text("Text"),
    bg = "primary",
    theme = "dark"
  )))
  expect_snapshot(snap(bs_breadcrumb(
    bs_breadcrumb_item("Home", href = "/"),
    bs_breadcrumb_item("Here", active = TRUE)
  )))
  expect_snapshot(snap(bs_pagination(
    bs_page_item("1", href = "#", active = TRUE),
    bs_page_item("2", href = "#")
  )))
  expect_snapshot(snap(bs_pagination_numbered(3, current = 2)))
  expect_snapshot(snap(bs_dropdown(
    "Menu",
    bs_dropdown_header("Actions"),
    bs_dropdown_item("Edit", id = "edit"),
    bs_dropdown_divider(),
    bs_dropdown_text("Signed in"),
    align = "end"
  )))
  expect_snapshot(snap(bs_nav_dropdown("More", bs_dropdown_item("Settings"))))
})

test_that("overlay markup is stable", {
  expect_snapshot(snap(bs_modal(
    "m",
    "Body",
    title = "Title",
    footer = bs_button("ok", "OK"),
    size = "lg",
    centered = TRUE
  )))
  expect_snapshot(snap(bs_modal(
    "m2",
    bs_modal_header(bs_modal_title("Title")),
    bs_modal_body("Body"),
    bs_modal_footer("Footer")
  )))
  expect_snapshot(snap(bs_modal_trigger("m", "Open")))
  expect_snapshot(snap(bs_offcanvas("oc", "Body", title = "Filters")))
  expect_snapshot(snap(bs_offcanvas(
    "ocr",
    "Body",
    title = "Filters",
    responsive = "lg",
    placement = "end"
  )))
  expect_snapshot(snap(bs_offcanvas_trigger("oc", "Open")))
  expect_snapshot(snap(bs_toast("t", "Body", title = "Toast")))
  expect_snapshot(snap(bs_toast_container(bs_toast("t", "Body"))))
  expect_snapshot(snap(bs_tooltip(bs_button("b", "B"), "Tip")))
  expect_snapshot(snap(bs_popover(
    bs_button("b", "B"),
    "Content",
    title = "Title"
  )))
  expect_snapshot(snap(bs_scrollspy("Body", target = "nav", id = "spy")))
})
