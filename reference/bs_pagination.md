# Bootstrap pagination

A list of page links, built from
[`bs_page_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_page_item.md)s.
For a quick numbered pager use
[`bs_pagination_numbered()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination_numbered.md).

## Usage

``` r
bs_pagination(
  ...,
  id = NULL,
  size = NULL,
  align = NULL,
  label = "Page navigation",
  class = NULL
)
```

## Arguments

- ...:

  Page items built with
  [`bs_page_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_page_item.md),
  plus named HTML attributes applied to the `<ul>`.

- id:

  Optional pager id. The active item's `value` is reported as
  `input$id`.

- size:

  Size modifier: `"sm"` or `"lg"` (`.pagination-sm`/`.pagination-lg`).

- align:

  Horizontal alignment of the pager: `"start"`, `"center"` or `"end"`
  (maps to `.justify-content-*`).

- label:

  Accessible label for the surrounding `<nav>` (`aria-label`).

- class:

  Extra classes for the `<ul>`.

## Value

A `<nav>` pagination tag.

## Details

Given an `id`, the pager reports the `value` of the active item as
`input$id` and is driven from the server with
[`update_bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_pagination.md).
Clicking an item makes it active without leaving the page, so the pager
drives the app rather than a URL.

## See also

[`update_bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_pagination.md)

## Examples

``` r
bs_pagination(
  bs_page_item("Previous", href = "#"),
  bs_page_item("1", href = "#", active = TRUE),
  bs_page_item("2", href = "#"),
  bs_page_item("Next", href = "#")
)
#> <nav aria-label="Page navigation">
#>   <ul class="pagination">
#>     <li data-value="Previous" class="page-item">
#>       <a class="page-link" href="#">Previous</a>
#>     </li>
#>     <li data-value="1" class="page-item active">
#>       <a class="page-link" href="#" aria-current="page">1</a>
#>     </li>
#>     <li data-value="2" class="page-item">
#>       <a class="page-link" href="#">2</a>
#>     </li>
#>     <li data-value="Next" class="page-item">
#>       <a class="page-link" href="#">Next</a>
#>     </li>
#>   </ul>
#> </nav>
```
