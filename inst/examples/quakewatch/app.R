# Quake Watch — a seismic monitor for the Fiji region, built with bootstrict.
#
# A realistic showcase (not a widget catalogue — see examples/demo for that)
# built on datasets::quakes: 1,000 real seismic events of magnitude 4.0+
# recorded near Fiji. It walks through the package's core story:
#
#   * the designer hand-off — the whole visual identity comes from the
#     _variables.scss sheet next to this file, loaded by bootstrict_theme();
#   * overlays declared once in the UI and driven by id from the server:
#     the filter drawer (bs_offcanvas), the event modal (bs_modal) and
#     transient toasts (bs_notify_toast);
#   * components that report state — the list group of strongest events and
#     the tabset are plain Bootstrap markup, yet input$id just works — and
#     are driven back with update_bs_*() helpers;
#   * Bootstrap 5.3 features: colour modes (set_bs_color_mode), .nav-underline
#     tabs and a .progress-stacked severity gauge.
#
# Run: shiny::runApp(system.file("examples/quakewatch", package = "bootstrict"))

library(
  shiny
)
library(
  bootstrict
)

`%||%` <- function(
  a,
  b
) {
  if (
    is.null(
      a
    )
  ) {
    b
  } else {
    a
  }
}

# --- data --------------------------------------------------------------------
# quakes: 1,000 seismic events (magnitude > 4.0) near Fiji, recorded since 1964.
events <- datasets::quakes
events$id <- seq_len(nrow(
  events
))
events$severity <- cut(
  events$mag,
  breaks = c(
    -Inf,
    4.5,
    5.5,
    Inf
  ),
  labels = c(
    "Light",
    "Moderate",
    "Strong"
  ),
  right = FALSE
)
# Two planes of activity are visible in the data: the Tonga trench to the
# east, the Vanuatu / New Hebrides trench to the west.
events$zone <- ifelse(
  events$long >=
    175,
  "Tonga Trench",
  "New Hebrides Trench"
)
events$layer <- cut(
  events$depth,
  breaks = c(
    -Inf,
    70,
    300,
    Inf
  ),
  labels = c(
    "Shallow",
    "Intermediate",
    "Deep"
  ),
  right = FALSE
)

severity_levels <- levels(
  events$severity
)
severity_color <- c(
  Light = "success",
  Moderate = "warning",
  Strong = "danger"
)
# Epicentre map palette, by depth layer — mirrors the designer's tokens.
layer_color <- c(
  Shallow = "#0ea5e9",
  Intermediate = "#0f766e",
  Deep = "#e11d48"
)

mag_floor <- 4
mag_ceiling <- max(
  events$mag
)
depth_ceiling <- max(
  events$depth
)

severity_share <- function(
  d
) {
  if (
    !nrow(
      d
    )
  ) {
    return(stats::setNames(
      numeric(length(
        severity_levels
      )),
      severity_levels
    ))
  }
  100 *
    table(
      d$severity
    )[
      severity_levels
    ] /
    nrow(
      d
    )
}

# --- small UI helpers ----------------------------------------------------------
kpi_card <- function(
  label,
  value_id,
  note_id
) {
  bs_card(
    class = "h-100",
    bs_card_body(
      bs_card_subtitle(
        label,
        class = "text-body-secondary text-uppercase small"
      ),
      bs_card_title(
        textOutput(
          value_id,
          inline = TRUE
        ),
        level = 3,
        class = "mb-1"
      ),
      bs_card_text(
        class = "small text-body-secondary mb-0",
        uiOutput(
          note_id,
          inline = TRUE
        )
      )
    )
  )
}

severity_legend <- do.call(
  bs_hstack,
  c(
    list(
      gap = 2,
      class = "flex-wrap mt-2"
    ),
    lapply(
      severity_levels,
      function(
        s
      ) {
        bs_badge(
          s,
          color = severity_color[[
            s
          ]],
          pill = TRUE
        )
      }
    )
  )
)

# --- UI ------------------------------------------------------------------------
ui <- bs_page(
  title = "Quake Watch — Fiji seismic monitor",
  # The designer's sheet is the theme. Nothing else to wire up.
  theme = bootstrict_theme(
    variables = "_variables.scss"
  ),
  color_mode = "light",

  bs_navbar(
    brand = bs_navbar_brand(
      "Quake Watch"
    ),
    bs_navbar_nav(
      bs_nav_item(
        bs_nav_link(
          "Monitor",
          active = TRUE
        )
      ),
      bs_nav_item(
        bs_nav_link(
          "datasets::quakes",
          href = "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/quakes.html",
          target = "_blank"
        )
      )
    ),
    bs_navbar_text(
      "Fiji region · 1964 →"
    ),
    bg = "primary",
    theme = "dark"
  ),

  bs_container(
    class = "py-4",

    # Header: title, dark-mode switch, filter drawer trigger.
    bs_row(
      class = "g-3 align-items-end mb-3",
      bs_col(
        md = 7,
        bs_display_heading(
          "Seismic activity, Fiji region",
          level = 6,
          class = "mb-1"
        ),
        bs_lead(
          class = "mb-0",
          "1,000 events of magnitude 4.0 and above, recorded since 1964."
        )
      ),
      bs_col(
        md = 5,
        bs_hstack(
          gap = 3,
          class = "justify-content-md-end align-items-center",
          bs_switch_input(
            "dark",
            "Dark mode",
            width = "auto"
          ),
          bs_tooltip(
            bs_offcanvas_trigger(
              "filters",
              "Filters",
              class = "btn-primary"
            ),
            title = "Magnitude, depth, severity and zone filters"
          )
        )
      )
    ),

    # Active-filter badges — regenerated server-side as filters move.
    tags$div(
      class = "mb-4",
      uiOutput(
        "active_filters"
      )
    ),

    # KPI row.
    bs_row(
      class = "g-3 mb-4",
      bs_col(
        md = 3,
        sm = 6,
        kpi_card(
          "Events shown",
          "k_events",
          "k_events_note"
        )
      ),
      bs_col(
        md = 3,
        sm = 6,
        kpi_card(
          "Strongest event",
          "k_mag",
          "k_mag_note"
        )
      ),
      bs_col(
        md = 3,
        sm = 6,
        kpi_card(
          "Median depth",
          "k_depth",
          "k_depth_note"
        )
      ),
      bs_col(
        md = 3,
        sm = 6,
        kpi_card(
          "Stations reporting",
          "k_stations",
          "k_stations_note"
        )
      )
    ),

    bs_tabset(
      "tabs",
      type = "underline",

      bs_tab_panel(
        "Overview",
        value = "overview",
        bs_row(
          class = "g-3 mt-0",
          bs_col(
            lg = 8,
            bs_card(
              class = "h-100",
              bs_card_header(
                "Epicentre map"
              ),
              bs_card_body(
                plotOutput(
                  "map",
                  height = "420px"
                ),
                bs_card_text(
                  class = "small text-body-secondary mb-0",
                  "Point size follows magnitude; colour follows focal depth. ",
                  "The triangle marks Suva, Fiji."
                )
              )
            )
          ),
          bs_col(
            lg = 4,
            bs_vstack(
              gap = 3,
              bs_card(
                bs_card_header(
                  "Severity mix"
                ),
                bs_card_body(
                  # Bootstrap 5.3 stacked progress, driven by
                  # update_bs_progress() as the filters move.
                  do.call(
                    bs_progress,
                    c(
                      list(
                        height = "1.5rem"
                      ),
                      lapply(
                        severity_levels,
                        function(
                          s
                        ) {
                          share <- severity_share(
                            events
                          )[[
                            s
                          ]]
                          bs_progress_bar(
                            value = share,
                            id = paste0(
                              "sev_",
                              tolower(
                                s
                              )
                            ),
                            color = severity_color[[
                              s
                            ]],
                            label = sprintf(
                              "%.0f%%",
                              share
                            ),
                            aria_label = s
                          )
                        }
                      )
                    )
                  ),
                  severity_legend
                )
              ),
              bs_card(
                bs_card_header(
                  "Strongest events"
                ),
                # Flush list group straight in the card; each item reports
                # its data-value as input$strongest_list when clicked.
                uiOutput(
                  "strongest"
                ),
                bs_card_footer(
                  class = "small text-body-secondary",
                  "Click an event for its full record."
                )
              )
            )
          )
        )
      ),

      bs_tab_panel(
        "Events",
        value = "events",
        bs_row(
          class = "g-3 mt-0 mb-1",
          bs_col(
            md = 4,
            bs_select_input(
              "sort_by",
              "Sort by",
              c(
                "Magnitude" = "mag",
                "Depth" = "depth",
                "Stations reporting" = "stations"
              )
            )
          ),
          bs_col(
            md = 4,
            bs_select_input(
              "n_rows",
              "Rows",
              c(
                10,
                25,
                50
              ),
              selected = 10
            )
          ),
          bs_col(
            md = 4,
            class = "d-flex align-items-end",
            bs_switch_input(
              "sort_desc",
              "Largest first",
              value = TRUE
            )
          )
        ),
        uiOutput(
          "events_table"
        )
      ),

      bs_tab_panel(
        "About",
        value = "about",
        bs_row(
          class = "g-3 mt-0",
          bs_col(
            lg = 7,
            bs_accordion(
              "about_acc",
              open = "data",
              bs_accordion_panel(
                "The data",
                value = "data",
                tags$p(
                  "The ",
                  tags$code(
                    "quakes"
                  ),
                  " data set ships with every R ",
                  "installation. It records the location, focal depth, ",
                  "magnitude and number of reporting stations for 1,000 ",
                  "seismic events near Fiji — one of the most seismically ",
                  "active regions on Earth, where the Pacific plate dives ",
                  "under the Australian plate along the Tonga and New ",
                  "Hebrides trenches."
                ),
                bs_blockquote(
                  "The data set give the locations of 1000 seismic events of ",
                  "MB > 4.0. The events occurred in a cube near Fiji since 1964.",
                  footer = "R datasets documentation"
                )
              ),
              bs_accordion_panel(
                "What this app demonstrates",
                value = "features",
                bs_list_unstyled(
                  tags$li(
                    tags$code(
                      "bootstrict_theme(variables=)"
                    ),
                    " — the whole theme is the designer's SCSS sheet"
                  ),
                  tags$li(
                    tags$code(
                      "bs_offcanvas()"
                    ),
                    " — the filter drawer, declared in the UI, opened by id"
                  ),
                  tags$li(
                    tags$code(
                      "bs_modal()"
                    ),
                    " + ",
                    tags$code(
                      "show_bs_modal()"
                    ),
                    " — the event record"
                  ),
                  tags$li(
                    tags$code(
                      "bs_list_group()"
                    ),
                    " — strongest events report clicks as ",
                    tags$code(
                      "input$strongest_list"
                    )
                  ),
                  tags$li(
                    tags$code(
                      "update_bs_progress()"
                    ),
                    " — the 5.3 stacked severity gauge follows the filters"
                  ),
                  tags$li(
                    tags$code(
                      "update_bs_range()"
                    ),
                    " & friends — the Reset button rewinds the drawer"
                  ),
                  tags$li(
                    tags$code(
                      "set_bs_color_mode()"
                    ),
                    " — 5.3 colour modes, plots included"
                  ),
                  tags$li(
                    tags$code(
                      "bs_notify_toast()"
                    ),
                    " — transient feedback"
                  )
                )
              ),
              bs_accordion_panel(
                "The designer hand-off",
                value = "handoff",
                tags$p(
                  "Every colour, radius and font in this app comes from ",
                  tags$code(
                    "_variables.scss"
                  ),
                  ", the sheet a designer would ",
                  "export — it sits next to ",
                  tags$code(
                    "app.R"
                  ),
                  ". ",
                  tags$code(
                    "parse_scss_variables()"
                  ),
                  " reads it as:"
                ),
                verbatimTextOutput(
                  "theme_vars"
                )
              )
            )
          ),
          bs_col(
            lg = 5,
            bs_card(
              bs_card_body(
                bs_card_title(
                  "Two planes of activity"
                ),
                bs_card_text(
                  "Filter by seismic zone in the drawer and watch the map ",
                  "split: shallow events cluster along the New Hebrides ",
                  "trench, while the Tonga trench dives deep — events down ",
                  "to 680 km."
                ),
                bs_button(
                  "goto_overview",
                  "Back to the overview",
                  color = "primary",
                  outline = TRUE
                )
              )
            )
          )
        )
      )
    )
  ),

  # -- overlays: declared once, at the top level of the page, driven by id. ----
  bs_offcanvas(
    "filters",
    title = "Filter events",
    placement = "end",
    bs_range_input(
      "f_mag",
      "Minimum magnitude",
      value = mag_floor,
      min = mag_floor,
      max = mag_ceiling,
      step = 0.1,
      help = "Richter magnitude; the data starts at 4.0."
    ),
    bs_range_input(
      "f_depth",
      "Maximum depth (km)",
      value = depth_ceiling,
      min = 40,
      max = depth_ceiling,
      step = 10
    ),
    bs_checkbox_group_input(
      "f_sev",
      "Severity",
      choices = severity_levels,
      selected = severity_levels
    ),
    bs_radio_input(
      "f_zone",
      "Seismic zone",
      choices = c(
        "All zones",
        "Tonga Trench",
        "New Hebrides Trench"
      )
    ),
    tags$hr(),
    bs_button(
      "reset",
      "Reset filters",
      color = "secondary",
      outline = TRUE
    )
  ),
  bs_modal(
    "event_modal",
    uiOutput(
      "event_detail"
    ),
    title = "Event record",
    centered = TRUE
  )
)

# --- server --------------------------------------------------------------------
server <- function(
  input,
  output,
  session
) {
  # Bootstrap 5.3 colour mode, flipped from the server.
  observeEvent(
    input$dark,
    {
      set_bs_color_mode(
        if (
          isTRUE(
            input$dark
          )
        ) {
          "dark"
        } else {
          "light"
        }
      )
    }
  )

  filtered <- reactive(
    {
      d <- events
      d <- d[
        d$mag >=
          (input$f_mag %||%
            mag_floor),
      ]
      d <- d[
        d$depth <=
          (input$f_depth %||%
            depth_ceiling),
      ]
      d <- d[
        d$severity %in%
          input$f_sev,
      ]
      if (
        !identical(
          input$f_zone,
          "All zones"
        )
      ) {
        d <- d[
          d$zone ==
            input$f_zone,
        ]
      }
      d
    }
  )

  # -- header: active-filter badges -------------------------------------------
  output$active_filters <- renderUI(
    {
      chips <- list()
      if (
        (input$f_mag %||%
          mag_floor) >
          mag_floor
      ) {
        chips <- c(
          chips,
          list(bs_badge(sprintf(
            "magnitude ≥ %.1f",
            input$f_mag
          )))
        )
      }
      if (
        (input$f_depth %||%
          depth_ceiling) <
          depth_ceiling
      ) {
        chips <- c(
          chips,
          list(bs_badge(sprintf(
            "depth ≤ %d km",
            input$f_depth
          )))
        )
      }
      if (
        length(
          input$f_sev
        ) <
          length(
            severity_levels
          )
      ) {
        chips <- c(
          chips,
          list(bs_badge(
            paste(
              input$f_sev,
              collapse = " + "
            ),
            color = "warning"
          ))
        )
      }
      if (
        !identical(
          input$f_zone,
          "All zones"
        )
      ) {
        chips <- c(
          chips,
          list(bs_badge(
            input$f_zone,
            color = "info"
          ))
        )
      }
      if (
        !length(
          chips
        )
      ) {
        chips <- list(bs_badge(
          "no filters — full catalogue",
          color = "secondary"
        ))
      }
      do.call(
        bs_hstack,
        c(
          list(
            gap = 2,
            class = "flex-wrap"
          ),
          chips
        )
      )
    }
  )

  # -- KPI row ------------------------------------------------------------------
  output$k_events <- renderText(format(
    nrow(filtered()),
    big.mark = ","
  ))
  output$k_events_note <- renderUI(
    {
      sprintf(
        "of %s recorded (%.0f%%)",
        format(
          nrow(
            events
          ),
          big.mark = ","
        ),
        100 *
          nrow(filtered()) /
          nrow(
            events
          )
      )
    }
  )

  output$k_mag <- renderText(
    {
      d <- filtered()
      if (
        !nrow(
          d
        )
      ) {
        "—"
      } else {
        sprintf(
          "%.1f",
          max(
            d$mag
          )
        )
      }
    }
  )
  output$k_mag_note <- renderUI(
    {
      d <- filtered()
      if (
        !nrow(
          d
        )
      ) {
        return(
          "no matching event"
        )
      }
      top <- d[
        which.max(
          d$mag
        ),
      ]
      tagList(
        bs_badge(
          top$severity,
          color = severity_color[[as.character(
            top$severity
          )]],
          pill = TRUE
        ),
        paste0(
          " ",
          top$zone
        )
      )
    }
  )

  output$k_depth <- renderText(
    {
      d <- filtered()
      if (
        !nrow(
          d
        )
      ) {
        "—"
      } else {
        sprintf(
          "%d km",
          round(stats::median(
            d$depth
          ))
        )
      }
    }
  )
  output$k_depth_note <- renderUI(
    {
      d <- filtered()
      if (
        !nrow(
          d
        )
      ) {
        return(
          "no matching event"
        )
      }
      sprintf(
        "%.0f%% shallower than 70 km",
        100 *
          mean(
            d$depth <
              70
          )
      )
    }
  )

  output$k_stations <- renderText(
    {
      d <- filtered()
      if (
        !nrow(
          d
        )
      ) {
        "—"
      } else {
        sprintf(
          "%d",
          round(stats::median(
            d$stations
          ))
        )
      }
    }
  )
  output$k_stations_note <- renderUI(
    "median stations per event"
  )

  # -- overview: severity gauge + map + strongest events -----------------------
  observe(
    {
      share <- severity_share(filtered())
      for (s in severity_levels) {
        update_bs_progress(
          paste0(
            "sev_",
            tolower(
              s
            )
          ),
          value = share[[
            s
          ]],
          label = if (
            share[[
              s
            ]] >=
              8
          ) {
            sprintf(
              "%.0f%%",
              share[[
                s
              ]]
            )
          } else {
            ""
          }
        )
      }
    }
  )

  output$map <- renderPlot(
    {
      d <- filtered()
      fg <- if (
        isTRUE(
          input$dark
        )
      ) {
        "#e2e8f0"
      } else {
        "#1e293b"
      }
      grid_col <- if (
        isTRUE(
          input$dark
        )
      ) {
        "#334155"
      } else {
        "#e2e8f0"
      }
      op <- par(
        bg = NA,
        fg = fg,
        col.axis = fg,
        col.lab = fg,
        mar = c(
          4.2,
          4.2,
          0.5,
          0.5
        )
      )
      on.exit(par(
        op
      ))
      plot(
        NULL,
        xlim = range(
          events$long
        ),
        ylim = range(
          events$lat
        ),
        xlab = "Longitude (°E)",
        ylab = "Latitude",
        las = 1,
        bty = "l"
      )
      grid(
        col = grid_col,
        lty = 1
      )
      if (
        nrow(
          d
        )
      ) {
        points(
          d$long,
          d$lat,
          pch = 19,
          cex = (d$mag -
            3.5)^1.6 /
            1.6,
          col = grDevices::adjustcolor(
            layer_color[as.character(
              d$layer
            )],
            0.55
          )
        )
      } else {
        text(
          mean(range(
            events$long
          )),
          mean(range(
            events$lat
          )),
          "No events match the current filters",
          col = fg
        )
      }
      # Suva, Fiji — a fixed landmark to read the map against.
      points(
        178.44,
        -18.14,
        pch = 17,
        cex = 1.4,
        col = fg
      )
      text(
        178.44,
        -17.5,
        "Suva",
        col = fg,
        cex = 0.9
      )
      legend(
        "bottomleft",
        legend = sprintf(
          "%s (%s)",
          names(
            layer_color
          ),
          c(
            "< 70 km",
            "70–300 km",
            "> 300 km"
          )
        ),
        col = grDevices::adjustcolor(
          layer_color,
          0.75
        ),
        pch = 19,
        pt.cex = 1.4,
        bty = "n",
        text.col = fg
      )
    },
    bg = "transparent"
  )

  output$strongest <- renderUI(
    {
      d <- filtered()
      if (
        !nrow(
          d
        )
      ) {
        return(bs_card_body(bs_alert(
          "No events match the current filters.",
          color = "warning",
          class = "mb-0"
        )))
      }
      d <- head(
        d[
          order(
            -d$mag,
            -d$stations
          ),
        ],
        7
      )
      items <- lapply(
        seq_len(nrow(
          d
        )),
        function(
          i
        ) {
          bs_list_group_item(
            action = TRUE,
            value = as.character(d$id[
              i
            ]),
            tags$div(
              class = "d-flex justify-content-between align-items-center",
              tags$span(
                tags$strong(sprintf(
                  "M %.1f",
                  d$mag[
                    i
                  ]
                )),
                tags$span(
                  class = "text-body-secondary",
                  sprintf(
                    " · %d km · %s",
                    d$depth[
                      i
                    ],
                    d$zone[
                      i
                    ]
                  )
                )
              ),
              bs_badge(
                d$severity[
                  i
                ],
                color = severity_color[[as.character(d$severity[
                  i
                ])]],
                pill = TRUE
              )
            )
          )
        }
      )
      do.call(
        bs_list_group,
        c(
          list(
            "strongest_list",
            flush = TRUE
          ),
          items
        )
      )
    }
  )

  # A click on the list group reports the event id; open its record by id.
  observeEvent(
    input$strongest_list,
    {
      ev <- events[
        events$id ==
          as.integer(
            input$strongest_list
          ),
      ]
      output$event_detail <- renderUI(
        {
          tagList(
            bs_hstack(
              gap = 2,
              class = "mb-3 align-items-center",
              bs_display_heading(
                sprintf(
                  "M %.1f",
                  ev$mag
                ),
                level = 6,
                class = "mb-0"
              ),
              bs_badge(
                ev$severity,
                color = severity_color[[as.character(
                  ev$severity
                )]],
                pill = TRUE
              ),
              bs_badge(
                ev$layer,
                color = "secondary",
                pill = TRUE
              )
            ),
            bs_table(
              data.frame(
                Field = c(
                  "Zone",
                  "Latitude",
                  "Longitude",
                  "Focal depth"
                ),
                Value = c(
                  ev$zone,
                  sprintf(
                    "%.2f°",
                    ev$lat
                  ),
                  sprintf(
                    "%.2f°E",
                    ev$long
                  ),
                  sprintf(
                    "%d km",
                    ev$depth
                  )
                )
              ),
              small = TRUE,
              borderless = TRUE
            ),
            tags$p(
              class = "small text-body-secondary mb-1",
              sprintf(
                "Reported by %d of %d stations",
                ev$stations,
                max(
                  events$stations
                )
              )
            ),
            bs_progress(
              height = "0.5rem",
              bs_progress_bar(
                value = 100 *
                  ev$stations /
                  max(
                    events$stations
                  ),
                color = "info",
                aria_label = "Stations reporting"
              )
            )
          )
        }
      )
      show_bs_modal(
        "event_modal"
      )
    }
  )

  # -- events table --------------------------------------------------------------
  output$events_table <- renderUI(
    {
      d <- filtered()
      if (
        !nrow(
          d
        )
      ) {
        return(bs_alert(
          "No events match the current filters.",
          color = "warning"
        ))
      }
      d <- d[
        order(
          d[[
            input$sort_by
          ]],
          decreasing = isTRUE(
            input$sort_desc
          )
        ),
      ]
      shown <- head(
        d,
        as.integer(
          input$n_rows
        )
      )
      bs_table(
        data.frame(
          Magnitude = sprintf(
            "%.1f",
            shown$mag
          ),
          Severity = as.character(
            shown$severity
          ),
          `Depth (km)` = shown$depth,
          Zone = shown$zone,
          Latitude = sprintf(
            "%.2f°",
            shown$lat
          ),
          Longitude = sprintf(
            "%.2f°E",
            shown$long
          ),
          Stations = shown$stations,
          check.names = FALSE
        ),
        striped = TRUE,
        hover = TRUE,
        small = TRUE,
        responsive = TRUE,
        caption = sprintf(
          "%d of %d matching events",
          nrow(
            shown
          ),
          nrow(
            d
          )
        )
      )
    }
  )

  # -- about -----------------------------------------------------------------------
  output$theme_vars <- renderText(
    {
      vars <- parse_scss_variables(
        "_variables.scss"
      )
      paste(
        sprintf(
          "$%s: %s;",
          names(
            vars
          ),
          unlist(
            vars
          )
        ),
        collapse = "\n"
      )
    }
  )

  observeEvent(
    input$goto_overview,
    {
      update_bs_tabset(
        "tabs",
        selected = "overview"
      )
    }
  )

  # -- filter drawer: reset everything with the update helpers ----------------------
  observeEvent(
    input$reset,
    {
      update_bs_range(
        "f_mag",
        mag_floor
      )
      update_bs_range(
        "f_depth",
        depth_ceiling
      )
      updateCheckboxGroupInput(
        session,
        "f_sev",
        selected = severity_levels
      )
      updateRadioButtons(
        session,
        "f_zone",
        selected = "All zones"
      )
      bs_notify_toast(
        "Showing the full catalogue again.",
        title = "Filters reset",
        color = "primary"
      )
    }
  )
}

shinyApp(
  ui,
  server
)
