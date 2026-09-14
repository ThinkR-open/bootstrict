# Bootstrap navigation list

A navigation container rendered as a Bootstrap `<ul class="nav">`.
Compose it with `bs_nav_item()` and `bs_nav_link()`. For tabs that also
switch panels use
[`bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md)
instead.

## Usage

``` r
bs_nav(
  ...,
  id = NULL,
  type = NULL,
  fill = FALSE,
  justified = FALSE,
  vertical = FALSE,
  class = NULL
)

bs_nav_item(..., class = NULL)

bs_nav_link(
  ...,
  href = "#",
  active = FALSE,
  disabled = FALSE,
  id = NULL,
  value = NULL,
  class = NULL
)
```

## Arguments

- ...:

  Navigation items (`bs_nav_item()` / `bs_nav_link()`) and named HTML
  attributes.

- id:

  Optional element id.

- type:

  Visual style: `"tabs"`, `"pills"` or `"underline"` (Bootstrap 5.3) —
  default `NULL` for a plain nav).

- fill:

  If `TRUE`, items expand to fill available width (`.nav-fill`).

- justified:

  If `TRUE`, items get equal width (`.nav-justified`).

- vertical:

  If `TRUE`, stack items vertically (`.flex-column`).

- class:

  Extra classes.

- href:

  Link target.

- active:

  If `TRUE`, mark the link as the active page (adds `.active` and
  `aria-current="page"`).

- disabled:

  If `TRUE`, mark the link disabled (`.disabled`).

- value:

  Value reported as `input$id` by the enclosing `bs_nav()` when this
  link is active. Defaults to the link's text.

## Value

A nav tag.

## Details

Given an `id`, the nav reports the `value` of the active link as
`input$id` and is driven from the server with
[`update_bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_nav.md).
Clicking a link makes it active without leaving the page, so a nav
becomes a plain selector; give each link a `value`.

## See also

[`update_bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_nav.md),
[`bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md)

## Examples

``` r
bs_nav(
  bs_nav_item(bs_nav_link("Active", active = TRUE)),
  bs_nav_item(bs_nav_link("Link")),
  type = "tabs"
)
#> <ul class="nav nav-tabs">
#>   <li class="nav-item">
#>     <a class="nav-link active" href="#" aria-current="page" data-value="Active">Active</a>
#>   </li>
#>   <li class="nav-item">
#>     <a class="nav-link" href="#" data-value="Link">Link</a>
#>   </li>
#> </ul>
```
