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
  invisible()
}
