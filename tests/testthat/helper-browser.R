# Helpers for the browser tests (test-browser.R).
#
# The bindings are ~940 lines of JS that as.character() never executes: every
# blocker the audit found lived there and none was visible to the markup
# tests. These helpers boot the fixture app in a background process and drive
# it with chromote.

skip_if_no_browser <- function() {
  testthat::skip_on_cran()
  testthat::skip_if_not_installed(
    "chromote"
  )
  testthat::skip_if_not_installed(
    "callr"
  )
  chrome <- tryCatch(
    chromote::find_chrome(),
    error = function(
      e
    )
      NULL
  )
  testthat::skip_if(
    is.null(
      chrome
    ) ||
      !nzchar(
        chrome
      ),
    "no Chrome available"
  )
}

# Start the fixture app in a background R process and return a handle. The app
# is loaded from the package under test, so pkgload::load_all() during
# devtools::test() and the installed package during R CMD check both work.
start_fixture_app <- function(
  app_dir = testthat::test_path(
    "apps/bindings"
  )
) {
  port <- httpuv::randomPort()
  lib <- .libPaths()
  # The app runs in its own process, so it cannot see a pkgload::load_all()
  # namespace: hand it the source path when we are testing the development
  # version, and let it attach the installed package otherwise.
  source_path <- NULL
  if (
    requireNamespace(
      "pkgload",
      quietly = TRUE
    ) &&
      isTRUE(tryCatch(
        pkgload::is_dev_package(
          "bootstrict"
        ),
        error = function(
          e
        )
          FALSE
      ))
  ) {
    source_path <- system.file(
      package = "bootstrict"
    )
  }
  process <- callr::r_bg(
    function(
      dir,
      port,
      lib,
      source_path
    ) {
      .libPaths(
        lib
      )
      if (
        is.null(
          source_path
        )
      ) {
        library(
          bootstrict
        )
      } else {
        pkgload::load_all(
          source_path,
          quiet = TRUE
        )
      }
      shiny::runApp(
        dir,
        port = port,
        launch.browser = FALSE,
        quiet = TRUE
      )
    },
    args = list(
      dir = normalizePath(
        app_dir
      ),
      port = port,
      lib = lib,
      source_path = source_path
    ),
    supervise = TRUE
  )
  url <- paste0(
    "http://127.0.0.1:",
    port,
    "/"
  )

  # Wait for the server to accept connections.
  deadline <- Sys.time() +
    30
  repeat {
    if (
      !process$is_alive()
    ) {
      stop(
        "fixture app died on startup:\n",
        paste(
          process$read_all_error_lines(),
          collapse = "\n"
        )
      )
    }
    ok <- tryCatch(
      {
        con <- suppressWarnings(url(
          url,
          open = "rb"
        ))
        on.exit(
          close(
            con
          ),
          add = TRUE
        )
        length(readBin(
          con,
          "raw",
          1L
        )) >
          0L
      },
      error = function(
        e
      )
        FALSE
    )
    if (
      isTRUE(
        ok
      )
    )
      break
    if (
      Sys.time() >
        deadline
    ) {
      process$kill()
      stop(
        "fixture app did not come up within 30s"
      )
    }
    Sys.sleep(
      0.2
    )
  }

  session <- chromote::ChromoteSession$new()
  errors <- new.env(
    parent = emptyenv()
  )
  errors$js <- character()
  session$Runtime$enable()
  session$Runtime$exceptionThrown(
    function(
      msg
    ) {
      details <- msg$exceptionDetails
      errors$js <- c(
        errors$js,
        details$exception$description %||%
          details$text %||%
          "exception"
      )
    }
  )
  session$Page$navigate(
    url
  )

  app <- list(
    process = process,
    session = session,
    errors = errors
  )
  # Wait for Shiny to connect, so initial input values have been sent.
  wait_until(
    app,
    "window.Shiny && Shiny.shinyapp && Shiny.shinyapp.isConnected()"
  )
  app
}

stop_fixture_app <- function(
  app
) {
  try(
    app$session$close(),
    silent = TRUE
  )
  try(
    app$process$kill(),
    silent = TRUE
  )
  invisible()
}

# Evaluate an expression in the page and return its value.
js <- function(
  app,
  expr
) {
  app$session$Runtime$evaluate(
    expr,
    returnByValue = TRUE
  )$result$value
}

# Poll a JS predicate until it is TRUE. Returns FALSE on timeout so a test can
# report a useful failure rather than a chromote error.
wait_until <- function(
  app,
  expr,
  timeout = 10
) {
  deadline <- Sys.time() +
    timeout
  repeat {
    if (
      isTRUE(js(
        app,
        expr
      ))
    ) {
      return(
        TRUE
      )
    }
    if (
      Sys.time() >
        deadline
    ) {
      return(
        FALSE
      )
    }
    Sys.sleep(
      0.1
    )
  }
}

# Click an element by id and let Shiny round-trip.
click <- function(
  app,
  id
) {
  js(
    app,
    sprintf(
      'document.getElementById("%s").click()',
      id
    )
  )
  Sys.sleep(
    0.4
  )
  invisible()
}

# A JS expression yielding the value Shiny currently holds for an input.
# Shiny keys some inputs with a `:type` suffix -- an action button is
# `id:shiny.action` -- so the key is looked up by prefix.
shiny_value <- function(
  id
) {
  sprintf(
    paste0(
      '(function(){var v = Shiny.shinyapp.$inputValues;',
      'var k = Object.keys(v).filter(function(n){',
      'return n === "%s" || n.indexOf("%s:") === 0;})[0];',
      'return k === undefined ? undefined : v[k];})()'
    ),
    id,
    id
  )
}

# That value as JSON, so any shape survives the trip back.
input_value <- function(
  app,
  id
) {
  js(
    app,
    paste0(
      "JSON.stringify(",
      shiny_value(
        id
      ),
      ")"
    )
  )
}

# The Shiny input binding that owns an element, or "" when none does.
binding_of <- function(
  app,
  id
) {
  js(
    app,
    sprintf(
      paste0(
        '(function(){var b = $(document.getElementById("%s"))',
        '.data("shiny-input-binding"); return b ? b.name : "";})()'
      ),
      id
    )
  )
}

js_errors <- function(
  app
)
  app$errors$js

`%+%` <- function(
  a,
  b
)
  paste0(
    a,
    b
  )
