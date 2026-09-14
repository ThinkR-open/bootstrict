# Bootstrap collapse

A toggleable container that shows or hides content. Pair it with a
[`bs_collapse_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse_trigger.md)
(declarative, no server round trip) and/or drive it from the server with
[`update_bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_collapse.md).
Its shown/hidden state is reported to the server as `input$id` (`TRUE`
when visible).

## Usage

``` r
bs_collapse(id, ..., open = FALSE, horizontal = FALSE, class = NULL)
```

## Arguments

- id:

  Collapse id; visibility state available as `input$id`.

- ...:

  Collapse content and named HTML attributes.

- open:

  If `TRUE`, the collapse is visible initially (`.show`).

- horizontal:

  If `TRUE`, collapse transitions width instead of height
  (`.collapse-horizontal`).

- class:

  Extra classes.

## Value

A collapse tag.

## Examples

``` r
bs_collapse("more", "Hidden content revealed on toggle.")
#> <div id="more" class="collapse" data-bootstrict="collapse">Hidden content revealed on toggle.</div>
```
