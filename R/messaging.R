# Server -> client messaging ------------------------------------------------

#' Send a bootstrict control message to the client
#'
#' Internal transport used by every `update_*()` helper. Dispatches
#' to the JavaScript handler registered under `method` via `bootstrict.addHandler`
#' on the client.
#'
#' @param method Name of the client-side handler.
#' @param ... Named payload fields (sent verbatim; `NULL` fields are dropped).
#' @param session The Shiny session.
#' @noRd
bs_send <- function(
  method,
  ...,
  session = shiny::getDefaultReactiveDomain()
) {
  if (
    is.null(
      session
    )
  ) {
    rlang::abort(
      "This function must be called from within a Shiny session."
    )
  }
  payload <- drop_nulls(c(
    list(
      method = method
    ),
    rlang::list2(
      ...
    )
  ))
  session$sendCustomMessage(
    "bootstrict-message",
    payload
  )
  invisible()
}

#' Namespace an id against the current Shiny module, if any.
#' @noRd
bs_ns <- function(
  id,
  session = shiny::getDefaultReactiveDomain()
) {
  if (
    !is.null(
      session
    ) &&
      !is.null(
        session$ns
      )
  )
    session$ns(
      id
    ) else
    id
}
