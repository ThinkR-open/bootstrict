# Component: card -----------------------------------------------------------

#' Bootstrap card
#'
#' A flexible content container. Compose with [bs_card_header()],
#' [bs_card_body()], [bs_card_footer()], [bs_card_img()] and the card text
#' helpers.
#'
#' @param ... Card content (headers, bodies, images, ...) and named HTML
#'   attributes.
#' @param color Background theme colour (`.text-bg-*`), one of the Bootstrap
#'   theme colours.
#' @param border Border theme colour (`.border-*`).
#' @param class Extra classes.
#'
#' @return A card tag.
#' @export
#'
#' @examples
#' bs_card(
#'   bs_card_header("Featured"),
#'   bs_card_body(
#'     bs_card_title("Card title"),
#'     bs_card_text("Some quick example text.")
#'   )
#' )
bs_card <- function(
  ...,
  color = NULL,
  border = NULL,
  class = NULL
) {
  color <- check_color(
    color
  )
  border <- check_color(
    border
  )
  attach_deps(htmltools::div(
    class = bs_classes(
      "card",
      mod(
        "text-bg",
        color
      ),
      mod(
        "border",
        border
      ),
      class
    ),
    ...
  ))
}

#' @rdname bs_card
#' @export
bs_card_body <- function(
  ...,
  class = NULL
) {
  htmltools::div(
    class = bs_classes(
      "card-body",
      class
    ),
    ...
  )
}

#' @rdname bs_card
#' @export
bs_card_header <- function(
  ...,
  class = NULL
) {
  htmltools::div(
    class = bs_classes(
      "card-header",
      class
    ),
    ...
  )
}

#' @rdname bs_card
#' @export
bs_card_footer <- function(
  ...,
  class = NULL
) {
  htmltools::div(
    class = bs_classes(
      "card-footer",
      class
    ),
    ...
  )
}

#' @rdname bs_card
#' @param level Heading level (1-6) for the card title / subtitle.
#' @export
bs_card_title <- function(
  ...,
  level = 5,
  class = NULL
) {
  tag_name <- paste0(
    "h",
    level
  )
  htmltools::tag(
    tag_name,
    list(
      class = bs_classes(
        "card-title",
        class
      ),
      ...
    )
  )
}

#' @rdname bs_card
#' @export
bs_card_subtitle <- function(
  ...,
  level = 6,
  class = NULL
) {
  tag_name <- paste0(
    "h",
    level
  )
  htmltools::tag(
    tag_name,
    list(
      class = bs_classes(
        "card-subtitle",
        "mb-2",
        "text-body-secondary",
        class
      ),
      ...
    )
  )
}

#' @rdname bs_card
#' @export
bs_card_text <- function(
  ...,
  class = NULL
) {
  htmltools::tags$p(
    class = bs_classes(
      "card-text",
      class
    ),
    ...
  )
}

#' @rdname bs_card
#' @param href Link target for [bs_card_link()].
#' @export
bs_card_link <- function(
  ...,
  href = "#",
  class = NULL
) {
  htmltools::tags$a(
    href = href,
    class = bs_classes(
      "card-link",
      class
    ),
    ...
  )
}

#' @rdname bs_card
#' @param src Image source URL.
#' @param position Image placement: `"top"`, `"bottom"`, or `"overlay"` (use
#'   together with [bs_card_img_overlay()]).
#' @param alt Image alt text.
#' @export
bs_card_img <- function(
  src,
  position = c(
    "top",
    "bottom",
    "overlay"
  ),
  alt = NULL,
  ...,
  class = NULL
) {
  position <- match.arg(
    position
  )
  img_class <- switch(
    position,
    top = "card-img-top",
    bottom = "card-img-bottom",
    overlay = "card-img"
  )
  htmltools::tags$img(
    src = src,
    alt = alt,
    class = bs_classes(
      img_class,
      class
    ),
    ...
  )
}

#' @rdname bs_card
#' @export
bs_card_img_overlay <- function(
  ...,
  class = NULL
) {
  htmltools::div(
    class = bs_classes(
      "card-img-overlay",
      class
    ),
    ...
  )
}

#' Group cards into an equal-width, attached grid
#' @rdname bs_card
#' @export
bs_card_group <- function(
  ...,
  class = NULL
) {
  attach_deps(htmltools::div(
    class = bs_classes(
      "card-group",
      class
    ),
    ...
  ))
}
