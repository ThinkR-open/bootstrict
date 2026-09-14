# Refresh inst/lib/bootstrap from an upstream Bootstrap release.
#
# bootstrict ships Bootstrap itself rather than compiling against whatever
# version a theming package happens to bundle, so the version named in the
# DESCRIPTION is the version that reaches the browser. Run this script to move
# to a new release, then update DESCRIPTION and NEWS.md.
#
# Needs node and npm: Bootstrap's prefixes come from autoprefixer, which runs
# after Sass in Bootstrap's own build and has no equivalent in `sass`. See
# vendor-bootstrap.mjs.

version <- "5.3.8"

dest <- file.path(
  "inst",
  "lib",
  "bootstrap"
)
work <- tempfile(
  "bootstrap-vendor"
)
dir.create(
  work
)

tgz <- file.path(
  work,
  "bootstrap.tgz"
)
utils::download.file(
  sprintf(
    "https://registry.npmjs.org/bootstrap/-/bootstrap-%s.tgz",
    version
  ),
  tgz,
  mode = "wb"
)
utils::untar(
  tgz,
  exdir = work
)
src <- file.path(
  work,
  "package"
)

# Bootstrap's own browserslist targets, so the vendored prefixes are the ones
# the official dist/ ships -- the npm tarball leaves .browserslistrc out.
utils::download.file(
  sprintf(
    "https://raw.githubusercontent.com/twbs/bootstrap/v%s/.browserslistrc",
    version
  ),
  file.path(
    work,
    ".browserslistrc"
  )
)

# node resolves imports next to the script, so it runs from `work`, where the
# packages are installed.
scss <- file.path(
  normalizePath(
    dest
  ),
  "scss"
)
file.copy(
  file.path(
    "dev",
    "vendor-bootstrap.mjs"
  ),
  work
)
owd <- setwd(
  work
)
on.exit(
  setwd(
    owd
  ),
  add = TRUE
)
stopifnot(
  system2(
    "npm",
    c(
      "install",
      "--silent",
      "--no-save",
      "postcss",
      "postcss-scss",
      "autoprefixer"
    )
  ) ==
    0
)
unlink(
  scss,
  recursive = TRUE
)
stopifnot(
  system2(
    "node",
    shQuote(c(
      "vendor-bootstrap.mjs",
      file.path(
        src,
        "scss"
      ),
      scss
    ))
  ) ==
    0
)
setwd(
  owd
)

file.copy(
  file.path(
    src,
    c(
      "LICENSE",
      "dist/js/bootstrap.bundle.min.js",
      "dist/js/bootstrap.bundle.min.js.map"
    )
  ),
  dest,
  overwrite = TRUE
)
writeLines(
  version,
  file.path(
    dest,
    "VERSION"
  )
)
