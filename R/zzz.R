.onLoad <- function(
  libname,
  pkgname
) {
  # A checkbox toggle group must reach R as a character vector, including when
  # nothing is checked: without a handler an empty JSON array arrives as
  # `list()`, so `input$id` would change type with the selection.
  shiny::registerInputHandler(
    "bootstrict.character",
    function(
      value,
      session,
      name
    ) {
      if (
        is.null(
          value
        )
      ) {
        return(character())
      }
      as.character(unlist(
        value,
        use.names = FALSE
      ))
    },
    force = TRUE
  )

  # `<input type="date">` hands over "yyyy-mm-dd", or "" when empty. Convert
  # once here so `input$id` is a `Date` -- the R-side type shiny's dateInput
  # gave, which is worth keeping even though its widget is not.
  shiny::registerInputHandler(
    "bootstrict.date",
    function(
      value,
      session,
      name
    ) {
      parse_date_value(
        value
      )
    },
    force = TRUE
  )
  shiny::registerInputHandler(
    "bootstrict.daterange",
    function(
      value,
      session,
      name
    ) {
      parse_date_value(unlist(
        value,
        use.names = FALSE
      ))
    },
    force = TRUE
  )
  invisible()
}

#' `"yyyy-mm-dd"` strings from the browser to a `Date`.
#'
#' An empty field is `NA`, so a range keeps its two positions rather than
#' collapsing when only one end is set.
#' @noRd
parse_date_value <- function(
  value
) {
  if (
    is.null(
      value
    ) ||
      !length(
        value
      )
  ) {
    return(
      NULL
    )
  }
  chr <- as.character(
    value
  )
  chr[
    !nzchar(
      chr
    )
  ] <- NA_character_
  as.Date(
    chr,
    format = "%Y-%m-%d"
  )
}
