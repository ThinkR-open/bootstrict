# Theming & designer SASS hand-off ------------------------------------------

#' Parse a SASS/SCSS variable sheet into a named list
#'
#' Reads a `_variables.scss` style file (the kind a designer exports) and
#' extracts top-level `$name: value;` declarations into a named list suitable
#' for passing to [bootstrict_theme()] or [bslib::bs_theme()]. Trailing
#' `!default` / `!global` flags and line/block comments are stripped. Values
#' are returned verbatim as strings (Sass resolves them at compile time), so
#' maps, functions and colour expressions all pass straight through.
#'
#' The file is scanned rather than read line by line, so a declaration may
#' span as many lines as it likes (`$theme-colors`, `$grid-breakpoints` and
#' `$spacers` always do), and a `;`, `//` or `/* */` inside a quoted string or
#' an unquoted `url()` is read as data. Anything that is not a top-level
#' variable declaration — `@use`/`@import`, a rule block — is ignored. A final
#' declaration with no trailing `;` is still read.
#'
#' @param path Path to a `.scss` file (SCSS syntax, `$name: value;` — the
#'   indented `.sass` syntax has no semicolons and cannot be parsed).
#'
#' @return A named list of Sass variable values. Names use the Bootstrap
#'   convention without the leading `$` (e.g. `primary`, `font-family-base`).
#' @export
#'
#' @examples
#' tmp <- tempfile(fileext = ".scss")
#' writeLines(c("$primary: #ff6600;", "$border-radius: 0.5rem !default;"), tmp)
#' parse_scss_variables(tmp)
parse_scss_variables <- function(
  path
) {
  if (
    !file.exists(
      path
    )
  ) {
    rlang::abort(sprintf(
      "SASS variable file not found: %s",
      path
    ))
  }
  txt <- paste(
    readLines(
      path,
      warn = FALSE
    ),
    collapse = "\n"
  )
  out <- list()
  for (stmt in scss_statements(
    txt
  )) {
    m <- regmatches(
      stmt,
      regexec(
        "(?s)^\\s*\\$([A-Za-z0-9_-]+)\\s*:\\s*(.*)$",
        stmt,
        perl = TRUE
      )
    )[[
      1
    ]]
    if (
      length(
        m
      ) !=
        3
    ) {
      # Not a variable declaration: an @import/@use, a rule block, stray text.
      next
    }
    value <- trimws(m[[
      3
    ]])
    repeat {
      stripped <- trimws(sub(
        "!(default|global)\\s*$",
        "",
        value
      ))
      if (
        identical(
          stripped,
          value
        )
      )
        break
      value <- stripped
    }
    if (
      nzchar(
        value
      )
    ) {
      out[[m[[
        2
      ]]]] <- value
    }
  }
  out
}

#' Split SCSS source into its top-level `;`-terminated statements.
#'
#' A character scanner rather than a line-wise regex, because every delimiter
#' is context sensitive: a declaration spans as many lines as it likes (every
#' Bootstrap map does), and `;`, `//` and `/* */` are ordinary characters
#' inside a quoted string or an unquoted `url()`. Comments are dropped; a
#' rule block (`.foo { ... }`) is discarded; a final statement with no
#' trailing `;` is still returned.
#' @noRd
scss_statements <- function(
  txt
) {
  chars <- strsplit(
    txt,
    "",
    fixed = TRUE
  )[[
    1
  ]]
  n <- length(
    chars
  )
  # Preallocated output buffer: growing a vector one character at a time is
  # quadratic, and Bootstrap's own sheet is ~60k characters.
  keep <- character(
    n
  )
  k <- 0L
  push <- function(
    ch
  ) {
    k <<- k +
      1L
    keep[[
      k
    ]] <<- ch
  }
  statements <- character()
  start <- 1L
  # Open brackets, so a `}` can tell a rule block from a `#{}` interpolation.
  stack <- character()
  i <- 1L

  while (
    i <=
      n
  ) {
    ch <- chars[[
      i
    ]]
    nxt <- if (
      i <
        n
    )
      chars[[
        i +
          1L
      ]] else
      ""

    if (
      ch ==
        "/" &&
        nxt ==
          "/"
    ) {
      while (
        i <=
          n &&
          chars[[
            i
          ]] !=
            "\n"
      )
        i <- i +
          1L
      next
    }
    if (
      ch ==
        "/" &&
        nxt ==
          "*"
    ) {
      i <- i +
        2L
      while (
        i <=
          n &&
          !(chars[[
            i
          ]] ==
            "*" &&
            identical(
              chars[
                i +
                  1L
              ],
              "/"
            ))
      ) {
        i <- i +
          1L
      }
      i <- i +
        2L
      next
    }
    if (
      ch ==
        "\"" ||
        ch ==
          "'"
    ) {
      push(
        ch
      )
      i <- i +
        1L
      while (
        i <=
          n
      ) {
        cur <- chars[[
          i
        ]]
        push(
          cur
        )
        i <- i +
          1L
        if (
          cur ==
            "\\" &&
            i <=
              n
        ) {
          push(chars[[
            i
          ]])
          i <- i +
            1L
        } else if (
          cur ==
            ch
        ) {
          break
        }
      }
      next
    }
    # Sass reads no comment inside an unquoted url(): copy it through whole.
    if (
      tolower(substr(
        txt,
        i,
        i +
          3L
      )) ==
        "url("
    ) {
      open <- 0L
      while (
        i <=
          n
      ) {
        cur <- chars[[
          i
        ]]
        push(
          cur
        )
        i <- i +
          1L
        if (
          cur ==
            "("
        )
          open <- open +
            1L
        if (
          cur ==
            ")"
        ) {
          open <- open -
            1L
          if (
            open ==
              0L
          )
            break
        }
      }
      next
    }

    if (
      ch %in%
        c(
          "(",
          "["
        )
    ) {
      stack <- c(
        stack,
        "paren"
      )
    } else if (
      ch ==
        "{"
    ) {
      stack <- c(
        stack,
        if (
          i >
            1L &&
            chars[[
              i -
                1L
            ]] ==
              "#"
        )
          "interp" else
          "block"
      )
    }

    if (
      ch ==
        ";" &&
        !length(
          stack
        )
    ) {
      if (
        k >=
          start
      ) {
        statements <- c(
          statements,
          paste(
            keep[
              start:k
            ],
            collapse = ""
          )
        )
      }
      start <- k +
        1L
      i <- i +
        1L
      next
    }

    push(
      ch
    )
    i <- i +
      1L

    if (
      ch %in%
        c(
          ")",
          "]",
          "}"
        )
    ) {
      closed <- if (
        length(
          stack
        )
      )
        stack[[length(
          stack
        )]] else
        ""
      stack <- utils::head(
        stack,
        -1L
      )
      # A rule block carries declarations of its own; drop it whole rather
      # than letting it bleed into the next statement.
      if (
        closed ==
          "block" &&
          !length(
            stack
          )
      ) {
        start <- k +
          1L
      }
    }
  }

  if (
    k >=
      start
  ) {
    statements <- c(
      statements,
      paste(
        keep[
          start:k
        ],
        collapse = ""
      )
    )
  }
  statements
}

#' Create a Bootstrap 5 theme for a bootstrict UI
#'
#' A thin wrapper around [bslib::bs_theme()] pinned to Bootstrap 5 that also
#' accepts a designer's exported SASS variable sheet. Variables from
#' `variables` are merged with (and overridden by) any variables passed through
#' `...`, then handed to `bslib`.
#'
#' @param ... Sass variables / arguments forwarded to [bslib::bs_theme()].
#'   Named values like `primary = "#ff6600"` override Bootstrap defaults.
#' @param variables Optional path to a `.scss` variable sheet, or a named list
#'   (as returned by [parse_scss_variables()]).
#' @param bootswatch,preset Optional Bootswatch / preset name (see
#'   [bslib::bs_theme()]).
#'
#' @return A [bslib::bs_theme()] object.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   bootstrict_theme(primary = "#ff6600", "font-size-base" = "1rem")
#' }
bootstrict_theme <- function(
  ...,
  variables = NULL,
  bootswatch = NULL,
  preset = NULL
) {
  dots <- rlang::list2(
    ...
  )

  file_vars <- list()
  if (
    !is.null(
      variables
    )
  ) {
    file_vars <- if (
      is.character(
        variables
      ) &&
        length(
          variables
        ) ==
          1L &&
        file.exists(
          variables
        )
    ) {
      parse_scss_variables(
        variables
      )
    } else if (
      is.list(
        variables
      )
    ) {
      variables
    } else {
      rlang::abort(
        "`variables` must be a path to a .scss file or a named list."
      )
    }
  }

  # `...` wins over file variables on name clash.
  merged <- utils::modifyList(
    file_vars,
    dots
  )

  args <- c(
    list(
      version = 5
    ),
    if (
      !is.null(
        bootswatch
      )
    )
      list(
        bootswatch = bootswatch
      ),
    if (
      !is.null(
        preset
      )
    )
      list(
        preset = preset
      ),
    merged
  )
  do.call(
    bslib::bs_theme,
    args
  )
}

#' Activate bootstrict inside a UI
#'
#' Returns the bootstrict HTML dependency (Shiny input bindings + supporting
#' CSS) so it can be dropped anywhere in a UI. Page constructors such as
#' [bs_page()] call this for you; use it directly when embedding bootstrict
#' widgets into a UI you build by hand.
#'
#' @return An [htmltools::htmlDependency].
#' @export
use_bootstrict <- function() {
  bootstrict_dep()
}

#' Switch the Bootstrap colour mode from the server
#'
#' Sets the Bootstrap 5.3 colour mode (`data-bs-theme`) on the page body,
#' switching every component between light and dark. Set the initial mode
#' with the `color_mode` argument of [bs_page()].
#'
#' @param mode `"light"` or `"dark"`.
#' @param session The Shiny session.
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @export
#'
#' @examples
#' if (interactive()) set_bs_color_mode("dark")
set_bs_color_mode <- function(
  mode,
  session = shiny::getDefaultReactiveDomain()
) {
  mode <- match_arg(
    mode,
    c(
      "light",
      "dark"
    ),
    allow_null = FALSE
  )
  bs_send(
    "colormode.set",
    mode = mode,
    session = session
  )
}
