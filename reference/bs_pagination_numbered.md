# Build a numbered pager

Convenience wrapper around
[`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md)
that lays out a "Previous" control, page numbers `1..n` (the `current`
one active) and a "Next" control.

## Usage

``` r
bs_pagination_numbered(
  n,
  current = 1,
  ...,
  id = NULL,
  href_template = NULL,
  size = NULL,
  align = NULL,
  label = "Page navigation",
  class = NULL
)
```

## Arguments

- n:

  Total number of pages.

- current:

  Currently active page number (1-based).

- ...:

  Additional named HTML attributes forwarded to
  [`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md)'s
  `<ul>`.

- id:

  Optional pager id. The active page number is reported as `input$id`
  and can be set with
  [`update_bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_pagination.md).

- href_template:

  Optional [`sprintf()`](https://rdrr.io/r/base/sprintf.html)-style
  template used to build each page's `href` from its page number, e.g.
  `"?page=%d"`. When `NULL`, every link uses `"#"`.

- size:

  Size modifier passed to
  [`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md).

- align:

  Alignment passed to
  [`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md).

- label:

  Accessible label passed to
  [`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md).

- class:

  Extra classes for the `<ul>`.

## Value

A `<nav>` pagination tag.

## Examples

``` r
bs_pagination_numbered(5, current = 2)
#> <nav aria-label="Page navigation">
#>   <ul class="pagination">
#>     <li class="page-item">
#>       <a class="page-link" href="#" data-bootstrict-step="prev">Previous</a>
#>     </li>
#>     <li data-value="1" class="page-item">
#>       <a class="page-link" href="#">1</a>
#>     </li>
#>     <li data-value="2" class="page-item active">
#>       <a class="page-link" href="#" aria-current="page">2</a>
#>     </li>
#>     <li data-value="3" class="page-item">
#>       <a class="page-link" href="#">3</a>
#>     </li>
#>     <li data-value="4" class="page-item">
#>       <a class="page-link" href="#">4</a>
#>     </li>
#>     <li data-value="5" class="page-item">
#>       <a class="page-link" href="#">5</a>
#>     </li>
#>     <li class="page-item">
#>       <a class="page-link" href="#" data-bootstrict-step="next">Next</a>
#>     </li>
#>   </ul>
#> </nav>
```
