# Bootstrap carousel

A slideshow component for cycling through a series of items
(`bs_carousel_item()`s). The 0-based index of the active slide is
reported to the server as `input$id`, and can be driven server-side with
[`update_bs_carousel()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_carousel.md).

## Usage

``` r
bs_carousel(
  id,
  ...,
  indicators = TRUE,
  controls = TRUE,
  fade = FALSE,
  autoplay = TRUE,
  interval = NULL,
  wrap = TRUE,
  keyboard = TRUE,
  pause = "hover",
  touch = TRUE,
  dark = FALSE,
  class = NULL
)

bs_carousel_item(
  ...,
  active = FALSE,
  interval = NULL,
  caption = NULL,
  class = NULL
)
```

## Arguments

- id:

  Carousel id; the active slide index is available as `input$id`.

- ...:

  Items built with `bs_carousel_item()` (and named HTML attributes).

- indicators:

  If `TRUE`, render the clickable slide indicators.

- controls:

  If `TRUE`, render the previous / next control buttons.

- fade:

  If `TRUE`, crossfade between slides instead of sliding
  (`.carousel-fade`).

- autoplay:

  `TRUE` (default) starts cycling on load (`data-bs-ride="carousel"`);
  `FALSE` omits the attribute so the carousel only ever advances on user
  interaction; `"resume"` is Bootstrap's `data-bs-ride="true"`, which
  starts cycling after the first interaction.

- interval:

  Cycling interval in milliseconds (sets `data-bs-interval`).

- wrap:

  If `FALSE`, stop at the last slide instead of cycling round.

- keyboard:

  If `FALSE`, ignore the arrow keys.

- pause:

  `"hover"` (Bootstrap's default) pauses on mouseover; `FALSE` never
  pauses.

- touch:

  If `FALSE`, disable swipe gestures on touch screens.

- dark:

  If `TRUE`, the dark variant via `data-bs-theme="dark"` (the Bootstrap
  5.3 idiom; `.carousel-dark` is deprecated).

- class:

  Extra classes.

- active:

  If `TRUE`, this item is shown first. Exactly one item per carousel is
  active; `bs_carousel()` defaults the first item if none is set.

- caption:

  Optional caption content placed in a `.carousel-caption` (hidden on
  small screens, `d-none d-md-block`).

## Value

A carousel tag.

## Examples

``` r
bs_carousel(
  "demo",
  bs_carousel_item(htmltools::img(src = "1.jpg"), active = TRUE),
  bs_carousel_item(htmltools::img(src = "2.jpg"))
)
#> <div id="demo" class="carousel slide" data-bootstrict="carousel" data-bs-ride="carousel">
#>   <div class="carousel-indicators">
#>     <button type="button" data-bs-target="#demo" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
#>     <button type="button" data-bs-target="#demo" data-bs-slide-to="1" aria-label="Slide 2"></button>
#>   </div>
#>   <div class="carousel-inner">
#>     <div class="carousel-item active">
#>       <img src="1.jpg"/>
#>     </div>
#>     <div class="carousel-item">
#>       <img src="2.jpg"/>
#>     </div>
#>   </div>
#>   <button class="carousel-control-prev" type="button" data-bs-target="#demo" data-bs-slide="prev">
#>     <span class="carousel-control-prev-icon" aria-hidden="true"></span>
#>     <span class="visually-hidden">Previous</span>
#>   </button>
#>   <button class="carousel-control-next" type="button" data-bs-target="#demo" data-bs-slide="next">
#>     <span class="carousel-control-next-icon" aria-hidden="true"></span>
#>     <span class="visually-hidden">Next</span>
#>   </button>
#> </div>
```
