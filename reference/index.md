# Package index

## Pages & theming

Wrap an app in a page, build a theme from a designer’s SASS sheet, and
switch Bootstrap 5.3 colour modes.

- [`bs_page()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
  [`bs_page_fluid()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
  [`bs_page_fillable()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
  : A Bootstrap 5.3 page
- [`bootstrict_theme()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_theme.md)
  : Create a Bootstrap 5.3 theme for a bootstrict UI
- [`parse_scss_variables()`](https://thinkr-open.github.io/bootstrict/reference/parse_scss_variables.md)
  : Parse a SASS/SCSS variable sheet into a named list
- [`set_bs_color_mode()`](https://thinkr-open.github.io/bootstrict/reference/set_bs_color_mode.md)
  : Switch the Bootstrap colour mode from the server
- [`use_bootstrict()`](https://thinkr-open.github.io/bootstrict/reference/use_bootstrict.md)
  : Activate bootstrict inside a UI
- [`use_bootstrict_golem()`](https://thinkr-open.github.io/bootstrict/reference/use_bootstrict_golem.md)
  : Scaffold a bootstrict app as a golem project hook
- [`bootstrict_dep()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_dep.md)
  : The bootstrict HTML dependency (Shiny input bindings + supporting
  CSS)
- [`bootstrap_dep()`](https://thinkr-open.github.io/bootstrict/reference/bootstrap_dep.md)
  : The Bootstrap HTML dependency for a theme
- [`bootstrap_version()`](https://thinkr-open.github.io/bootstrict/reference/bootstrap_version.md)
  : The Bootstrap version bootstrict ships

## Layout

Containers, the responsive 12-column grid, and flex stacks.

- [`bs_container()`](https://thinkr-open.github.io/bootstrict/reference/bs_container.md)
  : Bootstrap container
- [`bs_row()`](https://thinkr-open.github.io/bootstrict/reference/bs_row.md)
  : Bootstrap grid row
- [`bs_col()`](https://thinkr-open.github.io/bootstrict/reference/bs_col.md)
  : Bootstrap grid column
- [`bs_hstack()`](https://thinkr-open.github.io/bootstrict/reference/bs_hstack.md)
  [`bs_vstack()`](https://thinkr-open.github.io/bootstrict/reference/bs_hstack.md)
  : Bootstrap stacks (horizontal / vertical flex layouts)

## Content

Tables, media, typography, lists and small helpers.

- [`bs_table()`](https://thinkr-open.github.io/bootstrict/reference/bs_table.md)
  : Bootstrap table
- [`bs_img()`](https://thinkr-open.github.io/bootstrict/reference/bs_img.md)
  : Bootstrap image
- [`bs_figure()`](https://thinkr-open.github.io/bootstrict/reference/bs_figure.md)
  [`bs_figure_img()`](https://thinkr-open.github.io/bootstrict/reference/bs_figure.md)
  [`bs_figure_caption()`](https://thinkr-open.github.io/bootstrict/reference/bs_figure.md)
  : Bootstrap figure
- [`bs_blockquote()`](https://thinkr-open.github.io/bootstrict/reference/bs_blockquote.md)
  : Bootstrap blockquote
- [`bs_display_heading()`](https://thinkr-open.github.io/bootstrict/reference/bs_display_heading.md)
  : Bootstrap display heading
- [`bs_lead()`](https://thinkr-open.github.io/bootstrict/reference/bs_lead.md)
  : Bootstrap lead paragraph
- [`bs_list_unstyled()`](https://thinkr-open.github.io/bootstrict/reference/bs_list_unstyled.md)
  [`bs_list_inline()`](https://thinkr-open.github.io/bootstrict/reference/bs_list_unstyled.md)
  : Bootstrap unstyled / inline lists
- [`bs_icon_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_icon_link.md)
  : Bootstrap icon link
- [`bs_ratio()`](https://thinkr-open.github.io/bootstrict/reference/bs_ratio.md)
  : Fixed aspect-ratio container
- [`bs_vr()`](https://thinkr-open.github.io/bootstrict/reference/bs_vr.md)
  : Vertical rule
- [`bs_visually_hidden()`](https://thinkr-open.github.io/bootstrict/reference/bs_visually_hidden.md)
  : Visually hidden text

## Forms — inputs

Bootstrap 5 form controls. Most delegate to the matching
shiny::*Input(); bs_range_input() and bs_color_input() are native and
take update_bs\_*().

- [`bs_text_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_text_input.md)
  : Bootstrap text input
- [`bs_textarea_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_textarea_input.md)
  : Bootstrap textarea input
- [`bs_numeric_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_numeric_input.md)
  : Bootstrap numeric input
- [`bs_password_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_password_input.md)
  : Bootstrap password input
- [`bs_select_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_select_input.md)
  : Bootstrap select input
- [`bs_checkbox_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_input.md)
  [`bs_switch_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_input.md)
  : Bootstrap checkbox input
- [`bs_radio_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_input.md)
  : Bootstrap radio button group
- [`bs_checkbox_group_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_group_input.md)
  : Bootstrap checkbox group
- [`bs_radio_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md)
  [`bs_checkbox_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md)
  : Bootstrap toggle button groups
- [`update_bs_toggle_buttons()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_toggle_buttons.md)
  : Set the selection of a toggle button group from the server
- [`bs_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_range_input.md)
  : Bootstrap range (slider) input
- [`bs_color_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_color_input.md)
  : Bootstrap colour input
- [`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md)
  : Bootstrap date input
- [`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md)
  : Bootstrap date range input
- [`update_bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md)
  [`update_bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md)
  : Set a date input from the server
- [`bs_file_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_file_input.md)
  : Bootstrap file input
- [`update_bs_range()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_range.md)
  : Update a range input from the server
- [`update_bs_color()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_color.md)
  : Update a colour input from the server

## Forms — layout & validation

Group, float and validate controls.

- [`bs_input_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_input_group.md)
  [`bs_input_group_text()`](https://thinkr-open.github.io/bootstrict/reference/bs_input_group.md)
  : Bootstrap input group
- [`bs_floating_label()`](https://thinkr-open.github.io/bootstrict/reference/bs_floating_label.md)
  : Bootstrap floating label
- [`bs_form()`](https://thinkr-open.github.io/bootstrict/reference/bs_form.md)
  : Bootstrap form element
- [`bs_form_label()`](https://thinkr-open.github.io/bootstrict/reference/bs_form_label.md)
  : Bootstrap form label
- [`bs_form_text()`](https://thinkr-open.github.io/bootstrict/reference/bs_form_text.md)
  : Bootstrap form help text
- [`bs_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_feedback.md)
  : Attach validation feedback to a form control
- [`set_bs_validation()`](https://thinkr-open.github.io/bootstrict/reference/set_bs_validation.md)
  : Set a control's validation state from the server
- [`bs_valid_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_valid_feedback.md)
  [`bs_invalid_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_valid_feedback.md)
  : Bootstrap validation feedback

## Components — buttons

- [`bs_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_button.md)
  : Bootstrap button
- [`bs_button_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_button_group.md)
  [`bs_button_toolbar()`](https://thinkr-open.github.io/bootstrict/reference/bs_button_group.md)
  : Bootstrap button group / toolbar
- [`bs_close_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_close_button.md)
  : Bootstrap close button
- [`bs_download_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_download_button.md)
  : Bootstrap download button
- [`bs_download_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_download_link.md)
  : Bootstrap download link

## Components — cards

- [`bs_card()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  [`bs_card_body()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  [`bs_card_header()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  [`bs_card_footer()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  [`bs_card_title()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  [`bs_card_subtitle()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  [`bs_card_text()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  [`bs_card_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  [`bs_card_img()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  [`bs_card_img_overlay()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  [`bs_card_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  : Bootstrap card

## Components — feedback

Alerts, badges, progress, spinners and loading placeholders.

- [`bs_alert()`](https://thinkr-open.github.io/bootstrict/reference/bs_alert.md)
  [`bs_alert_heading()`](https://thinkr-open.github.io/bootstrict/reference/bs_alert.md)
  [`bs_alert_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_alert.md)
  : Bootstrap alert
- [`close_bs_alert()`](https://thinkr-open.github.io/bootstrict/reference/close_bs_alert.md)
  : Close an alert from the server
- [`bs_badge()`](https://thinkr-open.github.io/bootstrict/reference/bs_badge.md)
  : Bootstrap badge
- [`bs_progress()`](https://thinkr-open.github.io/bootstrict/reference/bs_progress.md)
  [`bs_progress_bar()`](https://thinkr-open.github.io/bootstrict/reference/bs_progress.md)
  : Bootstrap progress
- [`update_bs_progress()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_progress.md)
  : Update a progress bar from the server
- [`bs_spinner()`](https://thinkr-open.github.io/bootstrict/reference/bs_spinner.md)
  : Bootstrap spinner
- [`bs_placeholder()`](https://thinkr-open.github.io/bootstrict/reference/bs_placeholder.md)
  [`bs_placeholder_glow()`](https://thinkr-open.github.io/bootstrict/reference/bs_placeholder.md)
  [`bs_placeholder_wave()`](https://thinkr-open.github.io/bootstrict/reference/bs_placeholder.md)
  : Bootstrap placeholder

## Components — interactive

Accordion, carousel, collapse and list group report state as input\$id
and are driven from the server with update_bs\_\*().

- [`bs_accordion()`](https://thinkr-open.github.io/bootstrict/reference/bs_accordion.md)
  [`bs_accordion_panel()`](https://thinkr-open.github.io/bootstrict/reference/bs_accordion.md)
  : Bootstrap accordion
- [`update_bs_accordion()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_accordion.md)
  : Control an accordion from the server
- [`bs_carousel()`](https://thinkr-open.github.io/bootstrict/reference/bs_carousel.md)
  [`bs_carousel_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_carousel.md)
  : Bootstrap carousel
- [`update_bs_carousel()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_carousel.md)
  : Control a carousel from the server
- [`bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse.md)
  : Bootstrap collapse
- [`bs_collapse_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse_trigger.md)
  : Trigger a collapse from the UI
- [`update_bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_collapse.md)
  : Control a collapse from the server
- [`bs_list_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_list_group.md)
  [`bs_list_group_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_list_group.md)
  : Bootstrap list group
- [`update_bs_list_group()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_list_group.md)
  : Control a list group selection from the server

## Navigation

Navs & tabsets, the navbar, breadcrumbs, pagination and dropdowns.

- [`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)
  [`bs_nav_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)
  [`bs_nav_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)
  : Bootstrap navigation list
- [`update_bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_nav.md)
  : Set the active link of a nav from the server
- [`bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md)
  [`bs_tab_panel()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md)
  : Bootstrap tabset
- [`update_bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_tabset.md)
  : Control a tabset from the server
- [`bs_navbar()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md)
  [`bs_navbar_brand()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md)
  [`bs_navbar_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md)
  [`bs_navbar_text()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md)
  : Bootstrap navbar
- [`bs_breadcrumb()`](https://thinkr-open.github.io/bootstrict/reference/bs_breadcrumb.md)
  [`bs_breadcrumb_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_breadcrumb.md)
  : Bootstrap breadcrumb
- [`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md)
  : Bootstrap pagination
- [`bs_page_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_page_item.md)
  : Bootstrap pagination item
- [`bs_pagination_numbered()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination_numbered.md)
  : Build a numbered pager
- [`update_bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_pagination.md)
  : Set the active page of a pager from the server
- [`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)
  [`bs_dropdown_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)
  [`bs_dropdown_divider()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)
  [`bs_dropdown_header()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)
  [`bs_dropdown_text()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)
  : Bootstrap dropdown
- [`bs_nav_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav_dropdown.md)
  : Bootstrap dropdown inside a nav or a navbar
- [`show_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md)
  [`hide_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md)
  [`toggle_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md)
  : Open, close or toggle a dropdown from the server

## Overlays

Declared once in the UI, opened by id from the server. Modal, offcanvas
and toast, plus tooltips, popovers and scrollspy.

- [`bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
  [`bs_modal_header()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
  [`bs_modal_title()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
  [`bs_modal_body()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
  [`bs_modal_footer()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
  : Bootstrap modal
- [`show_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md)
  [`hide_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md)
  [`toggle_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md)
  : Control a modal from the server
- [`bs_modal_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal_trigger.md)
  : Trigger a modal from the UI
- [`bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas.md)
  : Bootstrap offcanvas
- [`show_bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_offcanvas.md)
  [`hide_bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_offcanvas.md)
  [`toggle_bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_offcanvas.md)
  : Control an offcanvas from the server
- [`bs_offcanvas_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas_trigger.md)
  : Trigger an offcanvas from the UI
- [`bs_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_toast.md)
  : Bootstrap toast
- [`bs_toast_container()`](https://thinkr-open.github.io/bootstrict/reference/bs_toast_container.md)
  : Position toasts on screen
- [`bs_notify_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_notify_toast.md)
  : Pop a transient toast notification from the server
- [`show_bs_toast()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_toast.md)
  [`hide_bs_toast()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_toast.md)
  : Control a toast from the server
- [`bs_tooltip()`](https://thinkr-open.github.io/bootstrict/reference/bs_tooltip.md)
  : Add a Bootstrap tooltip to a UI element
- [`bs_popover()`](https://thinkr-open.github.io/bootstrict/reference/bs_popover.md)
  : Add a Bootstrap popover to a UI element
- [`bs_scrollspy()`](https://thinkr-open.github.io/bootstrict/reference/bs_scrollspy.md)
  : Bootstrap scrollspy container
