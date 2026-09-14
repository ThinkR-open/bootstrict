# Bootstrap download button

Delegates to
[`shiny::downloadButton()`](https://rdrr.io/pkg/shiny/man/downloadButton.html)
and adapts its markup to Bootstrap 5.

## Usage

``` r
bs_download_button(
  id,
  label = "Download",
  ...,
  icon = NULL,
  color = "primary",
  outline = FALSE,
  size = NULL,
  class = NULL
)
```

## Arguments

- id:

  Output id, matching the
  [`shiny::downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html)
  assigned to `output$id`.

- label:

  Button label (text or tags).

- ...:

  Additional content and named HTML attributes, forwarded to the anchor.

- icon:

  Optional icon tag placed before the label. `NULL` (the default)
  renders no icon.

- color:

  One of the eight Bootstrap theme colours, or `"link"`.

- outline:

  If `TRUE`, an outline button (`.btn-outline-*`).

- size:

  `"sm"` or `"lg"`.

- class:

  Extra classes.

## Value

An anchor tag styled as a Bootstrap button.

## Details

shiny hardcodes `class = "btn btn-default shiny-download-link"`.
`.btn-default` is a Bootstrap 3 class with no Bootstrap 5 equivalent, so
the button renders with the `.btn` box but no colour, border or hover
state. We drop it and substitute a real 5.3 variant (`.btn-primary`,
`.btn-outline-secondary`, ...), matching
[`bs_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_button.md)'s
API.

Everything else is left to shiny: the `shiny-download-link` class, the
`href` / `target` / `download` attributes and the auto-enable dance (the
anchor ships `.disabled` + `aria-disabled` and shiny's client enables it
once the matching
[`shiny::downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html)
is registered) are untouched, so `output$id <- downloadHandler(...)`
works exactly as usual.

Unlike shiny, `icon` defaults to `NULL`: shiny's default is a Font
Awesome icon, which is outside Bootstrap 5 and therefore outside this
package.

## See also

[`shiny::downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html),
[`bs_download_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_download_link.md),
[`bs_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_button.md)

## Examples

``` r
bs_download_button("report", "Download CSV")
#> <a id="report" href="" target="_blank" download aria-disabled="true" tabindex="-1" class="btn shiny-download-link disabled btn-primary">Download CSV</a>
bs_download_button("report", "Export", color = "secondary", outline = TRUE)
#> <a id="report" href="" target="_blank" download aria-disabled="true" tabindex="-1" class="btn shiny-download-link disabled btn-outline-secondary">Export</a>
```
