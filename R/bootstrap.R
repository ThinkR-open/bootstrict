# Vendored Bootstrap --------------------------------------------------------

#' The Bootstrap version bootstrict ships
#'
#' bootstrict vendors its own copy of Bootstrap under `inst/lib/bootstrap`
#' rather than compiling against whatever version a theming package happens to
#' bundle, so this is the version that actually reaches the browser.
#'
#' @return The Bootstrap version, as a string.
#' @export
#'
#' @examples
#' bootstrap_version()
bootstrap_version <- function() {
  readLines(
    file.path(
      bootstrap_lib(),
      "VERSION"
    ),
    warn = FALSE
  )[[
    1L
  ]]
}

#' Path to the vendored Bootstrap tree.
#' @noRd
bootstrap_lib <- function() {
  system.file(
    "lib",
    "bootstrap",
    package = "bootstrict"
  )
}

#' The Bootstrap HTML dependency for a theme
#'
#' Compiles `theme` against the vendored Bootstrap SASS tree and returns the
#' resulting stylesheet together with Bootstrap's JavaScript bundle. The
#' dependency is named `"bootstrap"` at the vendored version, so it supersedes
#' the Bootstrap 3 stylesheet Shiny's own page functions attach.
#'
#' [bs_page()] and friends call this for you; use it directly when building a
#' page by hand. Compiled stylesheets are cached per theme for the session.
#'
#' @param theme A [bootstrict_theme()].
#'
#' @return An [htmltools::htmlDependency].
#' @export
#'
#' @examples
#' if (interactive()) {
#'   bootstrap_dep(bootstrict_theme(primary = "#ff6600"))
#' }
bootstrap_dep <- function(
  theme = bootstrict_theme()
) {
  if (
    !inherits(
      theme,
      "bootstrict_theme"
    )
  ) {
    rlang::abort(
      "`theme` must be a bootstrict_theme()."
    )
  }
  dir <- file.path(
    tempdir(),
    paste0(
      "bootstrict-bootstrap-",
      rlang::hash(
        theme
      )
    )
  )
  css <- file.path(
    dir,
    "bootstrap.min.css"
  )
  if (
    !file.exists(
      css
    )
  ) {
    dir.create(
      dir,
      showWarnings = FALSE,
      recursive = TRUE
    )
    sass::sass(
      theme_scss(
        theme
      ),
      output = css,
      options = sass::sass_options(
        output_style = "compressed"
      )
    )
    file.copy(
      file.path(
        bootstrap_lib(),
        c(
          "bootstrap.bundle.min.js",
          "bootstrap.bundle.min.js.map"
        )
      ),
      dir
    )
  }
  htmltools::htmlDependency(
    name = "bootstrap",
    version = bootstrap_version(),
    src = c(
      file = dir
    ),
    stylesheet = "bootstrap.min.css",
    script = "bootstrap.bundle.min.js",
    meta = list(
      viewport = "width=device-width, initial-scale=1, shrink-to-fit=no"
    ),
    all_files = TRUE
  )
}

#' The SASS source for a theme.
#'
#' Bootstrap's own import stack with the theme's variables spliced into the two
#' layers that can compile them.
#' @noRd
theme_scss <- function(
  theme
) {
  stack <- bootstrap_imports()
  c(
    stack$functions,
    scss_assignments(
      theme$defaults
    ),
    stack$config,
    scss_assignments(
      theme$declarations
    ),
    stack$rules
  )
}

# Where a customiser needs a seam in Bootstrap's import stack: its variables
# can only be overridden after "functions" (they call its colour helpers) and
# before "variables", while a value derived from Bootstrap's own variables can
# only be set once the whole configuration block has run.
bootstrap_config_imports <- c(
  "variables",
  "variables-dark",
  "maps",
  "mixins",
  "utilities"
)

#' Bootstrap's import stack, split at those two seams.
#'
#' Read from `bootstrap.scss` rather than listed here, so vendoring a release
#' that adds or drops a component needs no change on the R side.
#' @noRd
bootstrap_imports <- function() {
  scss <- file.path(
    bootstrap_lib(),
    "scss"
  )
  entrypoint <- readLines(
    file.path(
      scss,
      "bootstrap.scss"
    ),
    warn = FALSE
  )
  all <- unlist(regmatches(
    entrypoint,
    regexpr(
      '(?<=@import ")[^"]+',
      entrypoint,
      perl = TRUE
    )
  ))
  imports <- function(
    which
  )
    sprintf(
      '@import "%s";',
      file.path(
        scss,
        which
      )
    )
  list(
    functions = imports(
      "functions"
    ),
    config = imports(
      bootstrap_config_imports
    ),
    rules = imports(setdiff(
      all,
      c(
        "functions",
        bootstrap_config_imports
      )
    ))
  )
}

#' A named list of variables as SASS assignments, in order.
#' @noRd
scss_assignments <- function(
  vars
) {
  if (
    !length(
      vars
    )
  ) {
    return(character())
  }
  values <- vapply(
    vars,
    function(
      value
    ) {
      if (
        is.logical(
          value
        )
      )
        tolower(as.character(
          value
        )) else
        as.character(
          value
        )
    },
    character(
      1
    )
  )
  sprintf(
    "$%s: %s;",
    names(
      vars
    ),
    values
  )
}
