# Dependency plumbing -------------------------------------------------------

#' The bootstrict HTML dependency (Shiny input bindings + supporting CSS)
#'
#' Loads every JavaScript file shipped in `inst/assets/js`, forcing
#' `bootstrict-core.js` first (it defines the `window.bootstrict` namespace that
#' the per-component binding files rely on), followed by the supporting
#' stylesheet. Component binding files are discovered dynamically, so adding a
#' new binding is just a matter of dropping a `.js` file in that directory.
#'
#' @return An [htmltools::htmlDependency].
#' @export
bootstrict_dep <- function() {
  assets <- system.file(
    "assets",
    package = "bootstrict"
  )
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
