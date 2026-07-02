# Bootstrap 5.3 additions and idioms: colour modes, .nav-underline,
# .progress-stacked, .object-fit-*, icon links, data-bs-title, and the
# aria-describedby help wiring. (test-bs52.R covers the 5.1/5.2 additions.)

render53 <- function(x) as.character(x)

bs53_mock_session <- function() {
  store <- new.env(parent = emptyenv())
  store$custom <- list()
  list(
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
}

# --- colour modes -----------------------------------------------------------

test_that("bs_page sets the initial colour mode on the body", {
  html <- render53(bs_page("x", color_mode = "dark"))
  expect_match(html, "data-bs-theme=\"dark\"")
  expect_no_match(render53(bs_page("x")), "data-bs-theme")
  expect_error(bs_page("x", color_mode = "sepia"))
})

test_that("set_bs_color_mode dispatches the colormode.set message", {
  s <- bs53_mock_session()
  set_bs_color_mode("dark", session = s)
  msg <- s$.store$custom[[1]]
  expect_equal(msg$type, "bootstrict-message")
  expect_equal(msg$message$method, "colormode.set")
  expect_equal(msg$message$mode, "dark")
  expect_error(set_bs_color_mode("sepia", session = s))
})

test_that("dark component variants emit data-bs-theme, not legacy classes", {
  navbar <- render53(bs_navbar(theme = "dark", bg = "dark"))
  expect_match(navbar, "data-bs-theme=\"dark\"")
  expect_no_match(navbar, "navbar-dark")

  close <- render53(bs_close_button(white = TRUE))
  expect_match(close, "data-bs-theme=\"dark\"")
  expect_no_match(close, "btn-close-white")
})

test_that("bs_navbar accepts the 5.3 body background utilities", {
  expect_match(
    render53(bs_navbar(bg = "body-tertiary")),
    "bg-body-tertiary"
  )
  expect_error(bs_navbar(bg = "purple"))
})

# --- nav underline ----------------------------------------------------------

test_that("nav and tabset accept type = 'underline'", {
  expect_match(
    render53(bs_nav(bs_nav_item(bs_nav_link("A")), type = "underline")),
    "nav nav-underline"
  )
  expect_match(
    render53(bs_tabset(
      "t",
      bs_tab_panel("A", "a"),
      type = "underline"
    )),
    "nav nav-underline"
  )
})

# --- progress: 5.3 track markup + stacked ----------------------------------

test_that("bs_progress_bar builds a 5.3 track (role/aria on .progress)", {
  html <- render53(bs_progress_bar(
    value = 25,
    id = "load",
    aria_label = "Loading"
  ))
  track <- regmatches(html, regexpr("<div[^>]*class=\"progress\"[^>]*>", html))
  expect_match(track, "id=\"load\"")
  expect_match(track, "role=\"progressbar\"")
  expect_match(track, "aria-label=\"Loading\"")
  expect_match(track, "aria-valuenow=\"25\"")
  bar <- regmatches(html, regexpr("<div class=\"progress-bar\"[^>]*>", html))
  expect_match(bar, "width: 25%")
  expect_no_match(bar, "role=")
})

test_that("several bars stack into .progress-stacked with widths on tracks", {
  html <- render53(bs_progress(
    bs_progress_bar(value = 15, color = "success"),
    bs_progress_bar(value = 30, color = "danger")
  ))
  expect_match(html, "class=\"progress-stacked\"")
  tracks <- regmatches(
    html,
    gregexpr("<div[^>]*class=\"progress\"[^>]*>", html)
  )[[1]]
  expect_length(tracks, 2L)
  expect_match(tracks[[1]], "width: 15%")
  expect_match(tracks[[2]], "width: 30%")
  # inner bars carry no inline width in the stacked layout
  bars <- regmatches(
    html,
    gregexpr("<div class=\"progress-bar[^\"]*\"[^>]*>", html)
  )[[1]]
  expect_no_match(bars[[1]], "width:")
  expect_no_match(bars[[2]], "width:")
})

test_that("bs_progress single-bar keeps height and extra attributes", {
  html <- render53(bs_progress(
    bs_progress_bar(value = 50, id = "p"),
    height = "20px",
    class = "extra",
    `data-x` = "y"
  ))
  expect_match(html, "height: 20px")
  expect_match(html, "extra")
  expect_match(html, "data-x=\"y\"")
  expect_no_match(html, "progress-stacked")
})

test_that("bs_progress rejects non-bar children", {
  expect_error(
    bs_progress(htmltools::div("nope")),
    "bs_progress_bar"
  )
})

# --- content helpers --------------------------------------------------------

test_that("bs_img applies object-fit utilities", {
  expect_match(
    render53(bs_img("x.png", object_fit = "cover")),
    "object-fit-cover"
  )
  expect_error(bs_img("x.png", object_fit = "stretch"))
})

test_that("bs_icon_link renders the 5.3 helper", {
  html <- render53(bs_icon_link("Docs", href = "/docs"))
  expect_match(html, "<a class=\"icon-link\" href=\"/docs\"")
  expect_match(
    render53(bs_icon_link("Docs", hover = TRUE)),
    "icon-link icon-link-hover"
  )
})

# --- misc 5.3 markup details ------------------------------------------------

test_that("tab panes are focusable (tabindex=0)", {
  html <- render53(bs_tabset("t", bs_tab_panel("A", "a")))
  pane <- regmatches(html, regexpr("<div[^>]*role=\"tabpanel\"[^>]*>", html))
  expect_match(pane, "tabindex=\"0\"")
})

test_that("form help is wired to its control via aria-describedby", {
  html <- render53(bs_text_input("mail", "Email", help = "Never shared."))
  expect_match(html, "aria-describedby=\"mail-help\"")
  expect_match(html, "id=\"mail-help\"")
  # also for native inputs
  range <- render53(bs_range_input("vol", "Vol", help = "0-100"))
  expect_match(range, "aria-describedby=\"vol-help\"")
})
