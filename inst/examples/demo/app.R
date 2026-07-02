# bootstrict — exhaustive demo. Every exported widget is shown, each titled with
# the function that produces it.
# Run: shiny::runApp(system.file("examples/demo", package = "bootstrict"))
library(
  shiny
)
library(
  bootstrict
)

`%||%` <- function(
  a,
  b
)
  if (
    is.null(
      a
    )
  )
    b else
    a

# Inline SVG placeholder so the demo needs no network.
ph <- function(
  w = 400,
  h = 160,
  c = "0d6efd"
) {
  sprintf(
    paste0(
      "data:image/svg+xml,%%3Csvg xmlns='http://www.w3.org/2000/svg' ",
      "width='%d' height='%d'%%3E%%3Crect width='100%%25' height='100%%25' ",
      "fill='%%23%s'/%%3E%%3C/svg%%3E"
    ),
    w,
    h,
    c
  )
}

# A titled demo block: header = the function name as <code>.
demo <- function(
  fn,
  ...,
  note = NULL
) {
  bs_card(
    class = "mb-3 h-100",
    bs_card_header(tags$code(
      fn
    )),
    bs_card_body(
      if (
        !is.null(
          note
        )
      ) {
        tags$p(
          class = "text-body-secondary small mb-2",
          note
        )
      },
      ...
    )
  )
}
gridrow <- function(
  ...
)
  bs_row(
    class = "g-3 mb-2",
    ...
  )

# ---------------------------------------------------------------------------
ui <- bs_page(
  title = "bootstrict — full demo",
  theme = bootstrict_theme(
    primary = "#0d6efd",
    "border-radius" = "0.5rem"
  ),

  ## bs_navbar() / bs_navbar_brand() / bs_navbar_nav() / bs_navbar_text()
  bs_navbar(
    id = "main_navbar",
    brand = bs_navbar_brand(
      "bootstrict"
    ),
    bs_navbar_nav(
      bs_nav_item(bs_nav_link(
        "Home",
        active = TRUE
      )),
      bs_nav_item(bs_nav_link(
        "Docs",
        href = "#"
      ))
    ),
    bs_navbar_text(
      "Bootstrap 5.3 widgets for Shiny"
    ),
    bg = "dark",
    theme = "dark",
    placement = NULL
  ),

  bs_container(
    class = "py-4",
    tags$h2(
      "bootstrict — every widget"
    ),
    tags$p(
      class = "lead",
      "Each card header shows the function that builds it."
    ),

    bs_tabset(
      "nav",
      type = "pills",

      ## ===================== LAYOUT =====================
      bs_tab_panel(
        "Layout",
        value = "layout",
        gridrow(
          bs_col(
            md = 12,
            demo(
              "bs_container() / bs_row() / bs_col()",
              note = "Responsive 12-column grid with offsets, order and alignment.",
              bs_row(
                class = "g-2",
                bs_col(
                  width = 6,
                  md = 4,
                  tags$div(
                    class = "border p-2",
                    "6 / md-4"
                  )
                ),
                bs_col(
                  md = 4,
                  tags$div(
                    class = "border p-2",
                    "md-4"
                  )
                ),
                bs_col(
                  md = 4,
                  offset = list(
                    md = 0
                  ),
                  tags$div(
                    class = "border p-2",
                    "md-4"
                  )
                ),
                bs_col(
                  width = "auto",
                  order = "first",
                  tags$div(
                    class = "border p-2",
                    "auto / order-first"
                  )
                )
              )
            )
          )
        ),
        gridrow(
          bs_col(
            md = 4,
            demo(
              "bs_hstack()",
              bs_hstack(
                gap = 2,
                bs_badge(
                  "A"
                ),
                bs_badge(
                  "B"
                ),
                bs_badge(
                  "C"
                )
              )
            )
          ),
          bs_col(
            md = 4,
            demo(
              "bs_vstack()",
              bs_vstack(
                gap = 1,
                bs_badge(
                  "one"
                ),
                bs_badge(
                  "two"
                )
              )
            )
          ),
          bs_col(
            md = 4,
            demo(
              "bs_vr() / bs_visually_hidden()",
              bs_hstack(
                gap = 2,
                "left",
                bs_vr(),
                "right",
                bs_visually_hidden(
                  "(screen-reader only)"
                )
              )
            )
          )
        ),
        gridrow(
          bs_col(
            md = 6,
            demo(
              "bs_ratio()",
              bs_ratio(
                tags$div(
                  class = "bg-primary-subtle d-flex align-items-center justify-content-center",
                  "16x9"
                ),
                ratio = "16x9"
              )
            )
          ),
          bs_col(
            md = 6,
            demo(
              "bs_container(fluid=) / bs_page_fluid() / bs_page_fillable()",
              note = "Alternative page/container widths.",
              tags$ul(
                tags$li(tags$code(
                  "bs_page_fluid()"
                )),
                tags$li(tags$code(
                  "bs_page_fillable()"
                )),
                tags$li(tags$code(
                  'bs_container(fluid = TRUE)'
                ))
              )
            )
          )
        )
      ),

      ## ===================== CONTENT =====================
      bs_tab_panel(
        "Content",
        value = "content",
        gridrow(
          bs_col(
            md = 7,
            demo(
              "bs_table()",
              bs_table(
                head(
                  mtcars[,
                    1:5
                  ],
                  4
                ),
                striped = TRUE,
                hover = TRUE,
                small = TRUE,
                responsive = TRUE,
                caption = "mtcars"
              )
            )
          ),
          bs_col(
            md = 5,
            demo(
              "bs_img() / bs_figure() / bs_figure_img() / bs_figure_caption()",
              bs_img(
                ph(
                  360,
                  120
                ),
                fluid = TRUE,
                rounded = TRUE,
                alt = "demo"
              ),
              bs_figure(
                bs_figure_img(
                  ph(
                    360,
                    90,
                    "6c757d"
                  ),
                  alt = "fig"
                ),
                bs_figure_caption(
                  "A figure caption."
                )
              )
            )
          )
        ),
        gridrow(
          bs_col(
            md = 6,
            demo(
              "bs_blockquote()",
              bs_blockquote(
                "A well-known quote.",
                footer = "Someone Famous"
              )
            )
          ),
          bs_col(
            md = 6,
            demo(
              "bs_display_heading() / bs_lead()",
              bs_display_heading(
                "Display 4",
                level = 4
              ),
              bs_lead(
                "Lead paragraph stands out."
              )
            )
          )
        ),
        gridrow(
          bs_col(
            md = 6,
            demo(
              "bs_list_unstyled()",
              bs_list_unstyled(
                "First",
                "Second",
                "Third"
              )
            )
          ),
          bs_col(
            md = 6,
            demo(
              "bs_list_inline()",
              bs_list_inline(
                "Alpha",
                "Beta",
                "Gamma"
              )
            )
          )
        )
      ),

      ## ===================== FORMS =====================
      bs_tab_panel(
        "Forms",
        value = "forms",
        bs_row(
          class = "g-3",
          bs_col(
            lg = 8,
            gridrow(
              bs_col(
                md = 6,
                demo(
                  "bs_text_input()",
                  bs_text_input(
                    "f_text",
                    "Text",
                    placeholder = "type…"
                  )
                )
              ),
              bs_col(
                md = 6,
                demo(
                  "bs_password_input()",
                  bs_password_input(
                    "f_pw",
                    "Password"
                  )
                )
              )
            ),
            gridrow(
              bs_col(
                md = 6,
                demo(
                  "bs_textarea_input()",
                  bs_textarea_input(
                    "f_area",
                    "Textarea",
                    rows = 2
                  )
                )
              ),
              bs_col(
                md = 6,
                demo(
                  "bs_numeric_input()",
                  bs_numeric_input(
                    "f_num",
                    "Numeric",
                    5,
                    min = 0,
                    max = 10
                  )
                )
              )
            ),
            gridrow(
              bs_col(
                md = 6,
                demo(
                  "bs_select_input()",
                  bs_select_input(
                    "f_sel",
                    "Select",
                    c(
                      "Apple",
                      "Pear",
                      "Plum"
                    )
                  )
                )
              ),
              bs_col(
                md = 6,
                demo(
                  "bs_select_input(multiple=)",
                  bs_select_input(
                    "f_selm",
                    "Multi",
                    c(
                      "A",
                      "B",
                      "C"
                    ),
                    multiple = TRUE
                  )
                )
              )
            ),
            gridrow(
              bs_col(
                md = 6,
                demo(
                  "bs_checkbox_input() / bs_switch_input()",
                  bs_checkbox_input(
                    "f_chk",
                    "Checkbox",
                    TRUE
                  ),
                  bs_switch_input(
                    "f_sw",
                    "Switch"
                  ),
                  bs_switch_input(
                    "f_swr",
                    "Switch (reverse)",
                    reverse = TRUE
                  )
                )
              ),
              bs_col(
                md = 6,
                demo(
                  "bs_radio_input() / bs_checkbox_group_input()",
                  bs_radio_input(
                    "f_rad",
                    "Radio",
                    c(
                      "x",
                      "y"
                    ),
                    inline = TRUE
                  ),
                  bs_checkbox_group_input(
                    "f_cbg",
                    "Checkbox group",
                    c(
                      "p",
                      "q",
                      "r"
                    )
                  )
                )
              )
            ),
            gridrow(
              bs_col(
                md = 4,
                demo(
                  "bs_range_input() + update_bs_range()",
                  bs_range_input(
                    "f_rng",
                    "Range",
                    value = 40
                  ),
                  bs_button(
                    "f_rng_btn",
                    "set 75",
                    size = "sm"
                  )
                )
              ),
              bs_col(
                md = 4,
                demo(
                  "bs_color_input() + update_bs_color()",
                  bs_color_input(
                    "f_col",
                    "Colour",
                    "#0d6efd"
                  ),
                  bs_button(
                    "f_col_btn",
                    "set red",
                    size = "sm"
                  )
                )
              ),
              bs_col(
                md = 4,
                demo(
                  "bs_date_input()",
                  bs_date_input(
                    "f_date",
                    "Date"
                  )
                )
              )
            ),
            gridrow(
              bs_col(
                md = 6,
                demo(
                  "bs_date_range_input()",
                  bs_date_range_input(
                    "f_dr",
                    "Date range"
                  )
                )
              ),
              bs_col(
                md = 6,
                demo(
                  "bs_file_input()",
                  note = "Upload a file — its details appear below, proving input$f_file is wired.",
                  bs_file_input(
                    "f_file",
                    "File",
                    multiple = TRUE
                  ),
                  uiOutput(
                    "file_info"
                  )
                )
              )
            ),
            gridrow(
              bs_col(
                md = 6,
                demo(
                  "bs_input_group() / bs_input_group_text()",
                  bs_input_group(
                    bs_input_group_text(
                      "@"
                    ),
                    bs_text_input(
                      "f_ig",
                      NULL,
                      placeholder = "username"
                    )
                  )
                )
              ),
              bs_col(
                md = 6,
                demo(
                  "bs_floating_label()",
                  bs_floating_label(
                    bs_text_input(
                      "f_fl",
                      "Email"
                    ),
                    "Email address"
                  )
                )
              )
            ),
            gridrow(
              bs_col(
                md = 12,
                demo(
                  "bs_form() / bs_form_label() / bs_form_text() / bs_valid_feedback() / bs_invalid_feedback()",
                  note = "Plain <form> with explicit label, help text and validation feedback.",
                  bs_form(
                    bs_form_label(
                      "f_email2",
                      "Email"
                    ),
                    bs_text_input(
                      "f_email2",
                      NULL,
                      class = "is-valid"
                    ),
                    bs_valid_feedback(
                      "Looks good."
                    ),
                    bs_form_text(
                      "We'll never share it."
                    ),
                    bs_text_input(
                      "f_email3",
                      NULL,
                      class = "is-invalid"
                    ),
                    bs_invalid_feedback(
                      "Please provide a value."
                    )
                  )
                )
              )
            )
          ),
          bs_col(
            lg = 4,
            bs_card(
              class = "position-sticky",
              style = "top:1rem",
              bs_card_header(
                "Live input$ values"
              ),
              bs_card_body(verbatimTextOutput(
                "vals"
              ))
            )
          )
        )
      ),

      ## ===================== COMPONENTS =====================
      bs_tab_panel(
        "Components",
        value = "components",
        gridrow(
          bs_col(
            md = 6,
            demo(
              "bs_button() / bs_button_group() / bs_button_toolbar() / bs_close_button()",
              bs_hstack(
                gap = 1,
                class = "flex-wrap mb-2",
                bs_button(
                  "c_btn",
                  "Action",
                  color = "primary"
                ),
                bs_button(
                  label = "Outline",
                  color = "secondary",
                  outline = TRUE
                ),
                bs_button(
                  label = "Small",
                  color = "success",
                  size = "sm"
                ),
                bs_button(
                  label = "Link",
                  color = "link"
                ),
                bs_button(
                  label = "Disabled",
                  disabled = TRUE
                )
              ),
              bs_button_toolbar(
                bs_button_group(
                  bs_button(
                    label = "L"
                  ),
                  bs_button(
                    label = "M"
                  ),
                  bs_button(
                    label = "R"
                  )
                )
              ),
              tags$span(
                class = "ms-2",
                bs_close_button()
              )
            )
          ),
          bs_col(
            md = 6,
            demo(
              "bs_badge()",
              bs_hstack(
                gap = 1,
                class = "flex-wrap",
                bs_badge(
                  "primary"
                ),
                bs_badge(
                  "success",
                  color = "success"
                ),
                bs_badge(
                  "danger",
                  color = "danger"
                ),
                bs_badge(
                  "pill",
                  color = "info",
                  pill = TRUE
                )
              )
            )
          )
        ),
        gridrow(
          bs_col(
            md = 6,
            demo(
              "bs_breadcrumb() / bs_breadcrumb_item()",
              bs_breadcrumb(
                bs_breadcrumb_item(
                  "Home",
                  href = "#"
                ),
                bs_breadcrumb_item(
                  "Library",
                  href = "#"
                ),
                bs_breadcrumb_item(
                  "Data",
                  active = TRUE
                )
              )
            )
          ),
          bs_col(
            md = 6,
            demo(
              "bs_pagination() / bs_page_item() / bs_pagination_numbered()",
              bs_pagination(
                bs_page_item(
                  "«"
                ),
                bs_page_item(
                  "1",
                  active = TRUE
                ),
                bs_page_item(
                  "2"
                ),
                bs_page_item(
                  "»"
                )
              ),
              bs_pagination_numbered(
                5,
                current = 2,
                size = "sm"
              )
            )
          )
        ),
        gridrow(
          bs_col(
            md = 6,
            demo(
              "bs_spinner()",
              bs_hstack(
                gap = 2,
                bs_spinner(
                  type = "border",
                  color = "primary"
                ),
                bs_spinner(
                  type = "grow",
                  color = "success"
                ),
                bs_spinner(
                  type = "border",
                  size = "sm"
                )
              )
            )
          ),
          bs_col(
            md = 6,
            demo(
              "bs_placeholder() / bs_placeholder_glow() / bs_placeholder_wave()",
              bs_placeholder_glow(
                bs_placeholder(
                  width = 7
                ),
                bs_placeholder(
                  width = 4
                )
              ),
              bs_placeholder_wave(bs_placeholder(
                width = 6,
                color = "secondary"
              ))
            )
          )
        ),
        gridrow(
          bs_col(
            md = 8,
            demo(
              "bs_card() + bs_card_header/body/title/subtitle/text/link/footer/img/img_overlay/group",
              bs_card_group(
                bs_card(
                  bs_card_img(
                    ph(
                      300,
                      80
                    ),
                    position = "top",
                    alt = "top"
                  ),
                  bs_card_body(
                    bs_card_title(
                      "Card title"
                    ),
                    bs_card_subtitle(
                      "Subtitle"
                    ),
                    bs_card_text(
                      "Body text."
                    ),
                    bs_card_link(
                      "More",
                      href = "#"
                    )
                  ),
                  bs_card_footer(
                    "Footer"
                  )
                ),
                bs_card(
                  bs_card_img(
                    ph(
                      300,
                      120,
                      "6c757d"
                    ),
                    position = "overlay",
                    alt = "ov"
                  ),
                  bs_card_img_overlay(bs_card_title(
                    "Overlay"
                  ))
                )
              )
            )
          ),
          bs_col(
            md = 4,
            demo(
              "bs_alert() / bs_alert_heading() / bs_alert_link()",
              bs_alert(
                bs_alert_heading(
                  "Heads up"
                ),
                "With an ",
                bs_alert_link(
                  "alert link",
                  href = "#"
                ),
                ".",
                color = "warning",
                dismissible = TRUE
              )
            )
          )
        ),
        gridrow(
          bs_col(
            md = 6,
            demo(
              "bs_progress() / bs_progress_bar() + update_bs_progress()",
              bs_progress(bs_progress_bar(
                20,
                id = "c_bar",
                color = "info",
                striped = TRUE,
                animated = TRUE,
                label = "20%"
              )),
              bs_button(
                "c_bump",
                "update_bs_progress()",
                color = "primary",
                size = "sm",
                class = "mt-2"
              )
            )
          ),
          bs_col(
            md = 6,
            demo(
              "bs_list_group() / bs_list_group_item() + update_bs_list_group()",
              bs_list_group(
                "c_lg",
                bs_list_group_item(
                  "Inbox",
                  value = "inbox",
                  action = TRUE,
                  active = TRUE
                ),
                bs_list_group_item(
                  "Sent",
                  value = "sent",
                  action = TRUE
                ),
                bs_list_group_item(
                  "Trash",
                  value = "trash",
                  action = TRUE,
                  color = "danger"
                )
              ),
              bs_button(
                "c_lg_btn",
                "select 'sent'",
                size = "sm",
                class = "mt-2"
              )
            )
          )
        ),
        gridrow(
          bs_col(
            md = 6,
            demo(
              "bs_nav() / bs_nav_item() / bs_nav_link()",
              bs_nav(
                type = "tabs",
                bs_nav_item(bs_nav_link(
                  "Active",
                  active = TRUE
                )),
                bs_nav_item(bs_nav_link(
                  "Link",
                  href = "#"
                )),
                bs_nav_item(bs_nav_link(
                  "Disabled",
                  disabled = TRUE
                ))
              )
            )
          ),
          bs_col(
            md = 6,
            demo(
              "bs_dropdown() + items/divider/header/text",
              bs_dropdown(
                "Menu",
                color = "primary",
                bs_dropdown_header(
                  "Actions"
                ),
                bs_dropdown_item(
                  "Fires input$c_dd",
                  id = "c_dd"
                ),
                bs_dropdown_item(
                  "Link",
                  href = "#"
                ),
                bs_dropdown_divider(),
                bs_dropdown_text(
                  "plain text"
                ),
                bs_dropdown_item(
                  "Disabled",
                  disabled = TRUE
                ),
                split = TRUE
              )
            )
          )
        ),
        gridrow(
          bs_col(
            md = 12,
            demo(
              "bs_navbar() (standalone example)",
              bs_navbar(
                id = "demo_navbar",
                brand = bs_navbar_brand(
                  "Brand"
                ),
                bs_navbar_nav(
                  scroll = FALSE,
                  bs_nav_item(bs_nav_link(
                    "Home",
                    active = TRUE
                  )),
                  bs_nav_item(bs_nav_link(
                    "Features",
                    href = "#"
                  ))
                ),
                bg = "primary",
                theme = "dark"
              )
            )
          )
        )
      ),

      ## ===================== INTERACTIVE =====================
      bs_tab_panel(
        "Interactive",
        value = "interactive",
        gridrow(
          bs_col(
            md = 6,
            demo(
              "bs_accordion() / bs_accordion_panel() + update_bs_accordion()",
              bs_accordion(
                "i_acc",
                bs_accordion_panel(
                  "Panel one",
                  "First body",
                  value = "one"
                ),
                bs_accordion_panel(
                  "Panel two",
                  "Second body",
                  value = "two"
                ),
                open = "one"
              ),
              bs_button(
                "i_acc_btn",
                "open 'two'",
                size = "sm",
                class = "mt-2"
              )
            )
          ),
          bs_col(
            md = 6,
            demo(
              "bs_tabset() / bs_tab_panel() + update_bs_tabset()",
              bs_tabset(
                "i_tabs",
                type = "tabs",
                bs_tab_panel(
                  "Tab A",
                  "Content A",
                  value = "a"
                ),
                bs_tab_panel(
                  "Tab B",
                  "Content B",
                  value = "b"
                )
              ),
              bs_button(
                "i_tabs_btn",
                "select 'b'",
                size = "sm",
                class = "mt-2"
              )
            )
          )
        ),
        gridrow(
          bs_col(
            md = 6,
            demo(
              "bs_carousel() / bs_carousel_item() + update_bs_carousel()",
              bs_carousel(
                "i_car",
                bs_carousel_item(
                  bs_img(
                    ph(
                      600,
                      160
                    ),
                    fluid = TRUE
                  ),
                  active = TRUE,
                  caption = "Slide 1"
                ),
                bs_carousel_item(
                  bs_img(
                    ph(
                      600,
                      160,
                      "198754"
                    ),
                    fluid = TRUE
                  ),
                  caption = "Slide 2"
                ),
                bs_carousel_item(
                  bs_img(
                    ph(
                      600,
                      160,
                      "dc3545"
                    ),
                    fluid = TRUE
                  ),
                  caption = "Slide 3"
                )
              ),
              bs_button(
                "i_car_btn",
                "go to slide 3",
                size = "sm",
                class = "mt-2"
              )
            )
          ),
          bs_col(
            md = 6,
            demo(
              "bs_collapse() / bs_collapse_trigger() + update_bs_collapse()",
              bs_collapse_trigger(
                "i_coll",
                "Toggle (data API)",
                class = "btn-outline-primary btn-sm"
              ),
              bs_button(
                "i_coll_btn",
                "update_bs_collapse()",
                size = "sm",
                class = "ms-1"
              ),
              bs_collapse(
                "i_coll",
                class = "mt-2",
                bs_card(bs_card_body(
                  "Hidden collapsible content."
                ))
              )
            )
          )
        ),
        bs_card(
          class = "mt-2",
          bs_card_header(
            "Interactive input$ values"
          ),
          bs_card_body(verbatimTextOutput(
            "ivals"
          ))
        )
      ),

      ## ===================== OVERLAYS =====================
      bs_tab_panel(
        "Overlays",
        value = "overlays",
        gridrow(
          bs_col(
            md = 4,
            demo(
              "bs_modal() + bs_modal_trigger() / show_/hide_/toggle_bs_modal()",
              bs_modal_trigger(
                "o_modal",
                "Open (data API)",
                class = "btn-primary btn-sm"
              ),
              bs_button(
                "o_modal_show",
                "show_bs_modal()",
                size = "sm",
                class = "ms-1"
              )
            )
          ),
          bs_col(
            md = 4,
            demo(
              "bs_offcanvas() + bs_offcanvas_trigger() / show_/hide_/toggle_bs_offcanvas()",
              bs_offcanvas_trigger(
                "o_oc",
                "Open offcanvas",
                class = "btn-primary btn-sm"
              ),
              bs_button(
                "o_oc_show",
                "show_bs_offcanvas()",
                size = "sm",
                class = "ms-1"
              )
            )
          ),
          bs_col(
            md = 4,
            demo(
              "bs_toast() / bs_toast_container() + show_bs_toast() / hide_bs_toast() / bs_notify_toast()",
              bs_button(
                "o_toast",
                "show_bs_toast()",
                color = "success",
                size = "sm"
              ),
              bs_button(
                "o_toast_hide",
                "hide_bs_toast()",
                size = "sm",
                class = "ms-1"
              ),
              bs_button(
                "o_notify",
                "bs_notify_toast()",
                color = "info",
                size = "sm",
                class = "ms-1"
              )
            )
          )
        ),
        gridrow(
          bs_col(
            md = 12,
            demo(
              "bs_modal_header() / bs_modal_title() / bs_modal_body() / bs_modal_footer()",
              note = "The building blocks bs_modal() assembles internally (shown inline here).",
              tags$div(
                class = "modal-content border",
                bs_modal_header(bs_modal_title(
                  "Title"
                )),
                bs_modal_body(
                  "Body content."
                ),
                bs_modal_footer(bs_button(
                  label = "OK",
                  color = "primary"
                ))
              )
            )
          )
        )
      ),

      ## ===================== BEHAVIORS =====================
      bs_tab_panel(
        "Behaviors",
        value = "behaviors",
        gridrow(
          bs_col(
            md = 4,
            demo(
              "bs_tooltip()",
              bs_tooltip(
                bs_button(
                  label = "Hover me",
                  color = "secondary"
                ),
                title = "A tooltip"
              )
            )
          ),
          bs_col(
            md = 4,
            demo(
              "bs_popover()",
              bs_popover(
                bs_button(
                  label = "Click me",
                  color = "secondary"
                ),
                content = "Popover body",
                title = "Popover"
              )
            )
          ),
          bs_col(
            md = 4,
            demo(
              "bs_scrollspy()",
              bs_row(
                bs_col(
                  width = 4,
                  bs_nav(
                    id = "ss-nav",
                    class = "nav-pills flex-column",
                    bs_nav_item(bs_nav_link(
                      "One",
                      href = "#ss1"
                    )),
                    bs_nav_item(bs_nav_link(
                      "Two",
                      href = "#ss2"
                    )),
                    bs_nav_item(bs_nav_link(
                      "Three",
                      href = "#ss3"
                    ))
                  )
                ),
                bs_col(
                  width = 8,
                  bs_scrollspy(
                    "ss-nav",
                    smooth = TRUE,
                    style = "max-height:140px;overflow:auto;",
                    tabindex = "0",
                    tags$h6(
                      id = "ss1",
                      "One"
                    ),
                    tags$p(
                      "Lorem ipsum dolor sit amet."
                    ),
                    tags$h6(
                      id = "ss2",
                      "Two"
                    ),
                    tags$p(
                      "Consectetur adipiscing elit."
                    ),
                    tags$h6(
                      id = "ss3",
                      "Three"
                    ),
                    tags$p(
                      "Sed do eiusmod tempor."
                    )
                  )
                )
              )
            )
          )
        ),
        demo(
          "Theming — bootstrict_theme() / parse_scss_variables() / use_bootstrict() / bootstrict_dep()",
          note = "The page theme is built from bootstrict_theme(); a designer's _variables.scss feeds parse_scss_variables().",
          verbatimTextOutput(
            "theme_vars"
          )
        )
      )
    )
  ),

  ## Top-level overlays (must live outside tab panes to display correctly).
  bs_modal(
    "o_modal",
    "Hello from a bootstrict modal.",
    title = "bs_modal()",
    footer = bs_button(
      "o_modal_close",
      "Close",
      color = "secondary"
    )
  ),
  bs_offcanvas(
    "o_oc",
    "Offcanvas body content.",
    bs_button(
      "o_oc_hide",
      "hide_bs_offcanvas()",
      size = "sm",
      class = "mt-2"
    ),
    title = "bs_offcanvas()",
    placement = "end"
  ),
  bs_toast_container(
    bs_toast(
      "o_toast_el",
      "A toast message.",
      title = "bs_toast()"
    ),
    placement = "bottom-end"
  )
)

# ---------------------------------------------------------------------------
server <- function(
  input,
  output,
  session
) {
  output$vals <- renderText(
    {
      paste(
        paste(
          "nav tab :",
          input$nav %||%
            ""
        ),
        paste(
          "text    :",
          input$f_text %||%
            ""
        ),
        paste(
          "password:",
          input$f_pw %||%
            ""
        ),
        paste(
          "textarea:",
          input$f_area %||%
            ""
        ),
        paste(
          "numeric :",
          input$f_num %||%
            ""
        ),
        paste(
          "select  :",
          input$f_sel %||%
            ""
        ),
        paste(
          "multi   :",
          paste(
            input$f_selm,
            collapse = ", "
          )
        ),
        paste(
          "checkbox:",
          isTRUE(
            input$f_chk
          )
        ),
        paste(
          "switch  :",
          isTRUE(
            input$f_sw
          )
        ),
        paste(
          "radio   :",
          input$f_rad %||%
            ""
        ),
        paste(
          "cbgroup :",
          paste(
            input$f_cbg,
            collapse = ", "
          )
        ),
        paste(
          "range   :",
          input$f_rng %||%
            ""
        ),
        paste(
          "colour  :",
          input$f_col %||%
            ""
        ),
        paste(
          "date    :",
          as.character(
            input$f_date %||%
              ""
          )
        ),
        sep = "\n"
      )
    }
  )

  # Proof that bs_file_input() delivers a value to the server.
  output$file_info <- renderUI(
    {
      f <- input$f_file
      if (
        is.null(
          f
        )
      ) {
        return(tags$p(
          class = "text-body-secondary small mb-0",
          "No file uploaded yet."
        ))
      }
      tagList(
        bs_alert(
          sprintf(
            "✓ %d file(s) received — input$f_file is populated.",
            nrow(
              f
            )
          ),
          color = "success",
          class = "py-2"
        ),
        bs_table(
          data.frame(
            name = f$name,
            type = f$type,
            `size (bytes)` = f$size,
            check.names = FALSE
          ),
          striped = TRUE,
          small = TRUE,
          responsive = TRUE
        )
      )
    }
  )

  output$ivals <- renderText(
    {
      paste(
        paste(
          "accordion :",
          paste(
            input$i_acc,
            collapse = ", "
          )
        ),
        paste(
          "tabset    :",
          input$i_tabs %||%
            ""
        ),
        paste(
          "carousel  :",
          input$i_car %||%
            ""
        ),
        paste(
          "collapse  :",
          isTRUE(
            input$i_coll
          )
        ),
        paste(
          "list-group:",
          input$c_lg %||%
            ""
        ),
        paste(
          "dropdown clicks:",
          input$c_dd %||%
            0
        ),
        sep = "\n"
      )
    }
  )

  output$theme_vars <- renderText(
    {
      tmp <- tempfile(
        fileext = ".scss"
      )
      writeLines(
        c(
          "$primary: #0d6efd;",
          "$border-radius: 0.5rem !default;"
        ),
        tmp
      )
      vars <- parse_scss_variables(
        tmp
      )
      paste(
        names(
          vars
        ),
        unlist(
          vars
        ),
        sep = ": ",
        collapse = "\n"
      )
    }
  )

  # Components tab
  observeEvent(
    input$c_bump,
    {
      v <- min(
        100,
        20 +
          20 *
            input$c_bump
      )
      update_bs_progress(
        "c_bar",
        value = v,
        label = paste0(
          v,
          "%"
        )
      )
    }
  )
  observeEvent(
    input$c_lg_btn,
    update_bs_list_group(
      "c_lg",
      selected = "sent"
    )
  )
  observeEvent(
    input$f_rng_btn,
    update_bs_range(
      "f_rng",
      75
    )
  )
  observeEvent(
    input$f_col_btn,
    update_bs_color(
      "f_col",
      "#dc3545"
    )
  )

  # Interactive tab
  observeEvent(
    input$i_acc_btn,
    update_bs_accordion(
      "i_acc",
      open = "two"
    )
  )
  observeEvent(
    input$i_tabs_btn,
    update_bs_tabset(
      "i_tabs",
      selected = "b"
    )
  )
  observeEvent(
    input$i_car_btn,
    update_bs_carousel(
      "i_car",
      to = 2
    )
  )
  observeEvent(
    input$i_coll_btn,
    update_bs_collapse(
      "i_coll",
      action = "toggle"
    )
  )

  # Overlays tab
  observeEvent(
    input$o_modal_show,
    show_bs_modal(
      "o_modal"
    )
  )
  observeEvent(
    input$o_modal_close,
    hide_bs_modal(
      "o_modal"
    )
  )
  observeEvent(
    input$o_oc_show,
    show_bs_offcanvas(
      "o_oc"
    )
  )
  observeEvent(
    input$o_oc_hide,
    hide_bs_offcanvas(
      "o_oc"
    )
  )
  observeEvent(
    input$o_toast,
    show_bs_toast(
      "o_toast_el"
    )
  )
  observeEvent(
    input$o_toast_hide,
    hide_bs_toast(
      "o_toast_el"
    )
  )
  observeEvent(
    input$o_notify,
    bs_notify_toast(
      "Created on the fly.",
      title = "bs_notify_toast()",
      color = "primary"
    )
  )
}

shinyApp(
  ui,
  server
)
