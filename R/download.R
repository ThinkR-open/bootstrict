# Component: download button / link ------------------------------------------

#' Rebuild a tag's `class` attribute without `cls`.
#'
#' shiny adds one `class` entry to `attribs` per `class =` argument, so a plain
#' `tagAppendAttributes()` cannot remove a class that sits in the middle of the
#' first entry: the whole set has to be collapsed, filtered and re-attached.
#' @noRd
download_drop_class <- function(
  tag,
  cls
) {
  current <- htmltools::tagGetAttribute(
    tag,
    "class"
  )
  tag$attribs[
    names(
      tag$attribs
    ) ==
      "class"
  ] <- NULL
  keep <- setdiff(
    unlist(strsplit(
      current %||%
        "",
      "\\s+"
    )),
    c(
      "",
      cls
    )
  )
  htmltools::tagAppendAttributes(
    tag,
    class = bs_classes(
      keep
    )
  )
}

#' Bootstrap download button
#'
#' Delegates to [shiny::downloadButton()] and adapts its markup to Bootstrap 5.
#'
#' shiny hardcodes `class = "btn btn-default shiny-download-link"`.
#' `.btn-default` is a Bootstrap 3 class with no Bootstrap 5 equivalent, so the
#' button renders with the `.btn` box but no colour, border or hover state. We
#' drop it and substitute a real 5.3 variant (`.btn-primary`,
#' `.btn-outline-secondary`, ...), matching [bs_button()]'s API.
#'
#' Everything else is left to shiny: the `shiny-download-link` class, the
#' `href` / `target` / `download` attributes and the auto-enable dance (the
#' anchor ships `.disabled` + `aria-disabled` and shiny's client enables it once
#' the matching [shiny::downloadHandler()] is registered) are untouched, so
#' `output$id <- downloadHandler(...)` works exactly as usual.
#'
#' Unlike shiny, `icon` defaults to `NULL`: shiny's default is a Font Awesome
#' icon, which is outside Bootstrap 5 and therefore outside this package.
#'
#' @param id Output id, matching the [shiny::downloadHandler()] assigned to
#'   `output$id`.
#' @param label Button label (text or tags).
#' @param ... Additional content and named HTML attributes, forwarded to the
#'   anchor.
#' @param icon Optional icon tag placed before the label. `NULL` (the default)
#'   renders no icon.
#' @param color One of the eight Bootstrap theme colours, or `"link"`.
#' @param outline If `TRUE`, an outline button (`.btn-outline-*`).
#' @param size `"sm"` or `"lg"`.
#' @param class Extra classes.
#'
#' @return An anchor tag styled as a Bootstrap button.
#' @seealso [shiny::downloadHandler()], [bs_download_link()], [bs_button()]
#' @export
#'
#' @examples
#' bs_download_button("report", "Download CSV")
#' bs_download_button("report", "Export", color = "secondary", outline = TRUE)
bs_download_button <- function(
  id,
  label = "Download",
  ...,
  icon = NULL,
  color = "primary",
  outline = FALSE,
  size = NULL,
  class = NULL
) {
  color <- match_arg(
    color,
    c(
      bs_theme_colors,
      "link"
    ),
    allow_null = FALSE
  )
  size <- match_arg(
    size,
    c(
      "sm",
      "lg"
    )
  )

  variant <- if (
    isTRUE(
      outline
    ) &&
      color !=
        "link"
  ) {
    paste0(
      "btn-outline-",
      color
    )
  } else {
    paste0(
      "btn-",
      color
    )
  }

  ctrl <- shiny::downloadButton(
    outputId = id,
    label = label,
    class = bs_classes(
      variant,
      mod(
        "btn",
        size
      ),
      class
    ),
    icon = icon,
    ...
  )

  ctrl <- download_drop_class(
    ctrl,
    "btn-default"
  )

  attach_deps(
    ctrl
  )
}

#' Bootstrap download link
#'
#' Delegates to [shiny::downloadLink()], the plain-text counterpart of
#' [bs_download_button()]. shiny's markup is already Bootstrap-5 clean here (no
#' `.btn-default`), so this only layers on the 5.3 link utilities: `color`
#' emits a `.link-*` colour class.
#'
#' @inheritParams bs_download_button
#' @param color Optional theme colour, rendered as `.link-*`.
#'
#' @return An anchor tag.
#' @seealso [shiny::downloadHandler()], [bs_download_button()]
#' @export
#'
#' @examples
#' bs_download_link("report", "Download the raw data")
#' bs_download_link("report", "Export", color = "danger")
bs_download_link <- function(
  id,
  label = "Download",
  ...,
  color = NULL,
  class = NULL
) {
  color <- match_arg(
    color,
    bs_theme_colors
  )

  ctrl <- shiny::downloadLink(
    outputId = id,
    label = label,
    class = bs_classes(
      mod(
        "link",
        color
      ),
      class
    ),
    ...
  )

  attach_deps(
    ctrl
  )
}
