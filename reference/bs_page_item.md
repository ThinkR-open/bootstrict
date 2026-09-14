# Bootstrap pagination item

A single `<li class="page-item">` carrying a `.page-link` anchor. Use
inside
[`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md).

## Usage

``` r
bs_page_item(
  ...,
  value = NULL,
  href = "#",
  active = FALSE,
  disabled = FALSE,
  class = NULL
)
```

## Arguments

- ...:

  Link content (text or tags) and named HTML attributes applied to the
  `<a class="page-link">`.

- value:

  Value reported as `input$id` by the enclosing
  [`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md)
  when this item is active. Defaults to the item's text.

- href:

  Link target.

- active:

  If `TRUE`, mark as the current page (`.active`,
  `aria-current="page"`).

- disabled:

  If `TRUE`, render as a non-interactive link (`.disabled`,
  `tabindex="-1"`, `aria-disabled="true"`).

- class:

  Extra classes for the `<li>`.

## Value

A `<li>` page-item tag.

## Examples

``` r
bs_page_item("1", href = "#", active = TRUE)
#> <li data-value="1" class="page-item active">
#>   <a class="page-link" href="#" aria-current="page">1</a>
#> </li>
```
