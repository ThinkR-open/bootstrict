# Bootstrap list group

A flexible container for displaying a series of content. Compose with
`bs_list_group_item()`. When `id` is supplied the group becomes
selectable: clicking an action item (`action = TRUE` or `href`) reports
that item's `value` (its `data-value`) as `input$id`, and the selection
can be driven server-side with
[`update_bs_list_group()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_list_group.md).

## Usage

``` r
bs_list_group(
  id = NULL,
  ...,
  flush = FALSE,
  numbered = FALSE,
  horizontal = FALSE,
  class = NULL
)

bs_list_group_item(
  ...,
  value = NULL,
  active = FALSE,
  disabled = FALSE,
  color = NULL,
  action = FALSE,
  href = NULL,
  class = NULL
)
```

## Arguments

- id:

  Optional list group id. When set, the active item's value is reported
  as `input$id` and the group is wired for selection.

- ...:

  List items built with `bs_list_group_item()`, plus named HTML
  attributes.

- flush:

  If `TRUE`, render edge-to-edge without an outer border and rounded
  corners (`.list-group-flush`).

- numbered:

  If `TRUE`, render a numbered list
  (`<ol class="list-group list-group-numbered">`).

- horizontal:

  Lay items out horizontally. `TRUE` for `.list-group-horizontal`, or a
  breakpoint string (`"sm"`, `"md"`, `"lg"`, `"xl"`, `"xxl"`) for
  `.list-group-horizontal-{bp}`.

- class:

  Extra classes.

- value:

  Item value reported to the server when selected (its `data-value`).
  Only meaningful in a selectable group (when the parent
  `bs_list_group()` has an `id`).

- active:

  If `TRUE`, mark the item as the active/selected one.

- disabled:

  If `TRUE`, mark the item disabled.

- color:

  Contextual theme colour (`.list-group-item-*`).

- action:

  If `TRUE`, render an actionable `<button>` item
  (`.list-group-item-action`). Ignored when `href` is supplied (which
  always renders an actionable `<a>`).

- href:

  Link target; renders the item as an `<a>` (always actionable).

## Value

A list group tag.

## Examples

``` r
bs_list_group(
  bs_list_group_item("An item"),
  bs_list_group_item("A second item", active = TRUE)
)
#> <ul class="list-group">
#>   <li class="list-group-item">An item</li>
#>   <li class="list-group-item active" aria-current="true">A second item</li>
#> </ul>
bs_list_group_item("A link item", href = "#", value = "a")
#> <a class="list-group-item list-group-item-action" href="#" data-value="a">A link item</a>
```
