# Bootstrap button

Renders a Bootstrap 5 button. When `id` is supplied the button is wired
as a Shiny action button: `input$id` holds the click count, exactly like
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html).

## Usage

``` r
bs_button(
  id = NULL,
  label = NULL,
  ...,
  color = "primary",
  outline = FALSE,
  size = NULL,
  disabled = FALSE,
  href = NULL,
  type = "button",
  class = NULL
)
```

## Arguments

- id:

  Optional input id. When set, the click count is reported as
  `input$id`.

- label:

  Button label (text or tags). Can also be passed via `...`.

- ...:

  Additional content and named HTML attributes.

- color:

  One of the eight Bootstrap theme colours, or `"link"`.

- outline:

  If `TRUE`, an outline button (`.btn-outline-*`).

- size:

  `"sm"` or `"lg"`.

- disabled:

  If `TRUE`, the button is disabled.

- href:

  Optional URL; renders an `<a>` styled as a button.

- type:

  Button `type` attribute (`"button"`, `"submit"`, `"reset"`).

- class:

  Extra classes.

## Value

A button (or anchor) tag.

## Examples

``` r
bs_button("go", "Go", color = "primary")
#> <button id="go" class="btn btn-primary action-button" type="button">Go</button>
bs_button(label = "Cancel", color = "secondary", outline = TRUE)
#> <button class="btn btn-outline-secondary" type="button">Cancel</button>
```
