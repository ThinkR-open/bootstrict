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
  # strip block comments /* ... */ (with (?s) so multi-line comments — the
  # usual exported-file header — are removed too) and line comments // ...
  txt <- gsub(
    "(?s)/\\*.*?\\*/",
    "",
    txt,
    perl = TRUE
  )
  lines <- unlist(strsplit(
    txt,
    "\n",
    fixed = TRUE
  ))
  lines <- sub(
    "//.*$",
    "",
    lines
  )
  # gregexpr: capture every declaration on a line, not just the first.
  decls <- regmatches(
    lines,
    gregexpr(
      "\\$[A-Za-z0-9_-]+\\s*:\\s*[^;]+;",
      lines
    )
  )
  decls <- unlist(
    decls
  )

  out <- list()
  for (d in decls) {
    m <- regmatches(
      d,
      regexec(
        "\\$([A-Za-z0-9_-]+)\\s*:\\s*(.+);\\s*$",
        d
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
      # nocov start
      # Defensive: every `decls` element already matched the extraction regex,
      # so the stricter capture regex above always yields 3 groups. Unreachable.
      next
      # nocov end
    }
    name <- m[[
      2
    ]]
    value <- trimws(m[[
      3
    ]])
    value <- trimws(sub(
      "!default\\s*$",
      "",
      value
    ))
    value <- trimws(sub(
      "!global\\s*$",
      "",
      value
    ))
    out[[
      name
    ]] <- value
  }
  out
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
