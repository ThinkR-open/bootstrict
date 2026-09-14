# Bootstrap download link

Delegates to
[`shiny::downloadLink()`](https://rdrr.io/pkg/shiny/man/downloadButton.html),
the plain-text counterpart of
[`bs_download_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_download_button.md).
shiny's markup is already Bootstrap-5 clean here (no `.btn-default`), so
this only layers on the 5.3 link utilities: `color` emits a `.link-*`
colour class.

## Usage

``` r
bs_download_link(id, label = "Download", ..., color = NULL, class = NULL)
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

- color:

  Optional theme colour, rendered as `.link-*`.

- class:

  Extra classes.

## Value

An anchor tag.

## See also

[`shiny::downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html),
[`bs_download_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_download_button.md)

## Examples

``` r
bs_download_link("report", "Download the raw data")
#> <a aria-disabled="true" class="shiny-download-link disabled" download href="" id="report" tabindex="-1" target="_blank">Download the raw data</a>
bs_download_link("report", "Export", color = "danger")
#> <a aria-disabled="true" class="shiny-download-link disabled link-danger" download href="" id="report" tabindex="-1" target="_blank">Export</a>
```
