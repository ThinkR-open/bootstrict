# Dependency plumbing -------------------------------------------------------

#' The bootstrict HTML dependency (Shiny input bindings + supporting CSS)
#'
#' Loads every JavaScript file shipped in `inst/assets/js`, forcing
#' `bootstrict-core.js` first (it defines the `window.bootstrict` namespace that
#' the per-component binding files rely on), followed by the supporting
#' stylesheet. Component binding files are discovered dynamically, so adding a
#' new binding is just a matter of dropping a `.js` file in that directory.
#' The dependency is built once per session and cached (every widget calls
#' this, and the installed files cannot change mid-session).
#'
#' @return An [htmltools::htmlDependency].
#' @export
bootstrict_dep <- function() {
  dep <- bootstrict_dep_cache$dep
  if (
    !is.null(
      dep
    )
  ) {
    return(
      dep
    )
  }
  dep <- build_bootstrict_dep(system.file(
    "assets",
    package = "bootstrict"
  ))
  bootstrict_dep_cache$dep <- dep
  dep
}

# Session-lifetime cache (reset on load_all()/library()).
bootstrict_dep_cache <- new.env(
  parent = emptyenv()
)

#' Build the bootstrict dependency from an assets directory.
#'
#' Separated from [bootstrict_dep()] (which memoises) so the discovery logic
#' can be tested against an arbitrary directory.
#' @noRd
build_bootstrict_dep <- function(
  assets
) {
  js_dir <- file.path(
    assets,
    "js"
  )
  all_js <- sort(list.files(
    js_dir,
    pattern = "\\.js$"
  ))
  core <- "bootstrict-core.js"
  scripts <- c(
    intersect(
      core,
      all_js
    ),
    setdiff(
      all_js,
      core
    )
  )

  css <- if (
    file.exists(file.path(
      assets,
      "css",
      "bootstrict.css"
    ))
  ) {
    file.path(
      "css",
      "bootstrict.css"
    )
  } else {
    NULL
  }

  htmltools::htmlDependency(
    name = "bootstrict",
    version = as.character(utils::packageVersion(
      "bootstrict"
    )),
    src = c(
      file = assets
    ),
    script = file.path(
      "js",
      scripts
    ),
    stylesheet = css,
    all_files = FALSE
  )
}

#' Attach the bootstrict dependency to a tag without clobbering existing deps.
#'
#' Keeps `x` as the same tag object (so it stays composable with
#' `tagAppendChild()` etc.) while appending our dependency metadata.
#' @noRd
attach_deps <- function(
  x
) {
  htmltools::attachDependencies(
    x,
    bootstrict_dep(),
    append = TRUE
  )
}
