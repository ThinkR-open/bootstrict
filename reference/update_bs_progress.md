# Update a progress bar from the server

Update a progress bar from the server

## Usage

``` r
update_bs_progress(
  id,
  value = NULL,
  label = NULL,
  color = NULL,
  min = NULL,
  max = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Id of the
  [`bs_progress_bar()`](https://thinkr-open.github.io/bootstrict/reference/bs_progress.md)
  track to update (namespaced automatically inside modules).

- value:

  New value.

- label:

  New text shown inside the bar.

- color:

  New theme colour (`.bg-*`).

- min, max:

  New lower / upper bounds of the scale.

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (FALSE) { # \dontrun{
update_bs_progress("load", value = 80)
} # }
```
