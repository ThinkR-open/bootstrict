# Bootstrap progress

A progress display. `bs_progress_bar()` builds one bar (a `.progress`
track with its `.progress-bar`); `bs_progress()` finalises it, or stacks
several bars into a Bootstrap 5.3 `.progress-stacked` group. Progress is
display-only (it reports no value to the server); drive it from the
server with
[`update_bs_progress()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_progress.md).

## Usage

``` r
bs_progress(..., height = NULL, class = NULL)

bs_progress_bar(
  value = 0,
  ...,
  min = 0,
  max = 100,
  color = NULL,
  striped = FALSE,
  animated = FALSE,
  label = NULL,
  aria_label = NULL,
  id = NULL,
  class = NULL
)
```

## Arguments

- ...:

  One or more `bs_progress_bar()`s and named HTML attributes. With two
  or more bars, the group renders as `.progress-stacked`.

- height:

  CSS height of the progress track(s) (e.g. `"20px"`, `"1rem"`).

- class:

  Extra classes.

- value:

  Current value of the bar.

- min, max:

  Lower and upper bounds of the scale.

- color:

  Bar theme colour (`.bg-*`), one of the Bootstrap theme colours.

- striped:

  If `TRUE`, apply the striped variant (`.progress-bar-striped`).

- animated:

  If `TRUE`, animate the stripes (`.progress-bar-animated`).

- label:

  Text shown inside the bar.

- aria_label:

  Accessible name of the progress track (`aria-label`).

- id:

  Id of the `.progress` track; required to target it with
  [`update_bs_progress()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_progress.md).

## Value

A progress tag.

## Examples

``` r
bs_progress(bs_progress_bar(value = 25, id = "load"))
#> <div id="load" class="progress" role="progressbar" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">
#>   <div class="progress-bar" style="width: 25%"></div>
#> </div>
# stacked (Bootstrap 5.3):
bs_progress(
  bs_progress_bar(value = 15, color = "success"),
  bs_progress_bar(value = 30, color = "danger")
)
#> <div class="progress-stacked">
#>   <div class="progress" role="progressbar" aria-valuenow="15" aria-valuemin="0" aria-valuemax="100" style="width: 15%">
#>     <div class="progress-bar bg-success"></div>
#>   </div>
#>   <div class="progress" role="progressbar" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100" style="width: 30%">
#>     <div class="progress-bar bg-danger"></div>
#>   </div>
#> </div>
bs_progress_bar(value = 75, color = "success", striped = TRUE)
#> <div class="progress" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100">
#>   <div class="progress-bar bg-success progress-bar-striped" style="width: 75%"></div>
#> </div>
```
