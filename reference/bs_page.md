# A Bootstrap 5 page

Thin wrappers over
[`bslib::page()`](https://rstudio.github.io/bslib/reference/page.html) /
[`bslib::page_fluid()`](https://rstudio.github.io/bslib/reference/page.html)
pinned to Bootstrap 5 that wire in the bootstrict dependency and default
theme. Use these as the outermost call of a Shiny UI.

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
  [`bootstrict_theme()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_theme.md)
  /
  [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
  object. Defaults to a stock Bootstrap 5 theme.

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
