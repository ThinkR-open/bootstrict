# Fixture app for the browser tests. One instance of every widget whose
# behaviour lives in JS, with stable ids. Loaded by test-browser.R.
# bootstrict is attached by the caller (helper-browser.R), which picks the
# development version under devtools::test() and the installed one under
# R CMD check.
library(shiny)

ui <- bs_page(
  theme = bootstrict_theme(),
  title = "bindings",
  bs_navbar(
    brand = bs_navbar_brand("Fixture"),
    bs_navbar_nav(
      bs_nav_item(bs_nav_link("Home", active = TRUE)),
      bs_nav_dropdown("menu", bs_dropdown_item("Settings", id = "menu_item"), id = "navdd")
    )
  ),
  bs_container(
    # A tooltip must not steal the button's Shiny binding.
    bs_tooltip(bs_button("tipped", "Tipped"), "tip"),
    bs_button("plain", "Plain"),

    bs_tabset(
      "tabs",
      bs_tab_panel("One", "first", value = "one"),
      bs_tab_panel("Two", "second", value = "two")
    ),
    bs_accordion(
      "acc",
      bs_accordion_panel("A", "body a", value = "a"),
      bs_accordion_panel("B", "body b", value = "b")
    ),
    bs_collapse("coll", "collapsible body"),
    bs_collapse_trigger("coll", "Toggle"),
    bs_carousel(
      "car",
      bs_carousel_item(bs_img("a.png", alt = "a"), value = "s1"),
      bs_carousel_item(bs_img("b.png", alt = "b"), value = "s2")
    ),
    bs_list_group(
      "lg",
      bs_list_group_item("First", value = "f", action = TRUE),
      bs_list_group_item("Second", value = "s", action = TRUE)
    ),
    bs_range_input("rng", "Range", value = 5, min = 0, max = 10),
    bs_color_input("col", "Colour", value = "#ff6600"),

    # Stacked progress with a height: the two declarations must merge.
    bs_progress(
      bs_progress_bar(15, color = "success"),
      bs_progress_bar(30, color = "info"),
      height = "10px"
    ),

    # Validation feedback must be a sibling of the control to display.
    bs_feedback(
      bs_text_input("email", "Email"),
      invalid = "Adresse invalide.",
      state = "invalid"
    ),
    bs_feedback(bs_text_input("user", "User"), invalid = "placeholder"),

    bs_button("validate", "Validate"),
    bs_button("swap", "Re-render"),
    verbatimTextOutput("tbc_type"),
    uiOutput("dyn"),

    bs_radio_button_input("tbr", "Size", c(Small = "s", Large = "l")),
    bs_checkbox_button_input("tbc", "Options", c("a", "b")),
    bs_button("pick_l", "Pick large"),
    bs_button("clear_tbc", "Clear options"),

    bs_radio_input("rad", "Size", c("S", "M"), inline = TRUE),
    bs_checkbox_group_input("cgrp", "Pick", c("a", "b")),
    bs_button("regen", "Regenerate choices"),

    bs_nav(
      bs_nav_item(bs_nav_link("Home", active = TRUE, value = "home")),
      bs_nav_item(bs_nav_link("Profile", value = "prof")),
      id = "nv",
      type = "pills"
    ),
    bs_pagination_numbered(3, current = 1, id = "pg"),
    bs_button("goto3", "Go to page 3"),

    bs_dropdown("Menu", bs_dropdown_item("Edit", id = "dd_item"), id = "dd"),
    bs_button("open_dd", "Open dropdown"),

    bs_alert("Saved", id = "al", color = "success", dismissible = TRUE),
    bs_button("close_alert", "Close alert"),

    bs_modal("m", "Modal body", title = "Title"),
    bs_offcanvas("oc", "Panel", title = "Filters"),
    bs_offcanvas("ocr", "Responsive panel", title = "Resp", responsive = "lg"),
    bs_toast("tst", "Toast body", title = "Toast")
  )
)

server <- function(input, output, session) {
  # What the checkbox toggle group actually looks like on the R side.
  output$tbc_type <- renderText({
    paste0(class(input$tbc), "/", length(input$tbc))
  })
  # Overlays inside dynamic UI: re-rendering one while open must not leave the
  # page scroll-locked.
  output$dyn <- renderUI({
    input$swap
    bs_modal("dynm", "Dynamic modal", title = "Dyn")
  })
  observeEvent(input$validate, {
    set_bs_validation("user", "invalid", "Deja pris.")
  })
  observeEvent(input$close_alert, close_bs_alert("al"))
  observeEvent(input$open_dd, show_bs_dropdown("dd"))
  observeEvent(input$goto3, update_bs_pagination("pg", selected = "3"))
  observeEvent(input$pick_l, update_bs_toggle_buttons("tbr", selected = "l"))
  observeEvent(input$clear_tbc, update_bs_toggle_buttons("tbc", selected = character(0)))
  observeEvent(input$regen, {
    # shiny's own updaters, exactly as the vignette promises they can be used.
    updateRadioButtons(session, "rad", choices = c("L", "XL"), inline = TRUE)
    updateCheckboxGroupInput(session, "cgrp", choices = c("c", "d"))
  })
}

shinyApp(ui, server)
