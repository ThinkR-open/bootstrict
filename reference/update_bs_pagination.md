# Set the active page of a pager from the server

Activates the
[`bs_page_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_page_item.md)
carrying `selected` as its `value` inside the
[`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md)
registered under `id`, and reports the change back as `input$id`.

## Usage

``` r
update_bs_pagination(
  id,
  selected = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Pager id, as passed to
  [`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md)
  or
  [`bs_pagination_numbered()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination_numbered.md).

- selected:

  `value` of the item to activate. For a numbered pager this is the page
  number as a string.

- session:

  The Shiny session.

## Value

Nothing, called for its side effect.

## See also

[`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md)

## Examples

``` r
if (interactive()) update_bs_pagination("pager", selected = "3")
```
