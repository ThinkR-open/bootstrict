# A Bootstrap 5.3 page

Shiny's page constructors wired to the Bootstrap bootstrict vendors, the
bootstrict dependency and a theme. Use these as the outermost call of a
Shiny UI.

## Usage

``` r
bs_page(
  ...,
  title = NULL,
  theme = bootstrict_theme(),
  color_mode = NULL,
  lang = "en"
)

bs_page_fluid(
  ...,
  title = NULL,
  theme = bootstrict_theme(),
  color_mode = NULL,
  lang = "en"
)

bs_page_fillable(
  ...,
  title = NULL,
  theme = bootstrict_theme(),
  color_mode = NULL,
  lang = "en"
)
```

## Arguments

- ...:

  UI elements, and named HTML attributes for the page body.

- title:

  Page title (browser tab).

- theme:

  A
  [`bootstrict_theme()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_theme.md).
  Defaults to stock Bootstrap.

- color_mode:

  Initial Bootstrap colour mode: `"light"`, `"dark"`, or `"auto"` to
  follow the operating system. A mode the user later chose is remembered
  in the browser and wins over this initial value. Switch it from the
  server with
  [`set_bs_color_mode()`](https://thinkr-open.github.io/bootstrict/reference/set_bs_color_mode.md),
  and read the mode in force as `input$bootstrict_color_mode`.

- lang:

  Document language (`<html lang>`).

## Value

A UI definition.

## Examples

``` r
if (interactive()) {
  bs_page(
    theme = bootstrict_theme(primary = "#ff6600"),
    bs_container(bs_card(bs_card_body("Hello")))
  )
  bs_page_fluid(bs_container("Full width", fluid = TRUE))
  bs_page_fillable(bs_container("Fills the viewport"))
}
```
