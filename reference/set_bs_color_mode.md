# Switch the Bootstrap colour mode from the server

Sets the Bootstrap 5.3 colour mode (`data-bs-theme`) on the document
root, switching every component between light and dark. Set the initial
mode with the `color_mode` argument of
[`bs_page()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md).

## Usage

``` r
set_bs_color_mode(mode, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- mode:

  `"light"`, `"dark"`, or `"auto"` to follow the operating system.

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Details

A choice is remembered in the browser's `localStorage`, so it survives a
reload; `"auto"` forgets it and follows the operating system again. The
mode actually in force is reported as `input$bootstrict_color_mode`,
which is `"light"` or `"dark"` even when the preference is `"auto"`.

## Examples

``` r
if (interactive()) set_bs_color_mode("dark")
```
