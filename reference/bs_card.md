# Bootstrap card

A flexible content container. Compose with `bs_card_header()`,
`bs_card_body()`, `bs_card_footer()`, `bs_card_img()` and the card text
helpers.

## Usage

``` r
bs_card(..., color = NULL, border = NULL, class = NULL)

bs_card_body(..., class = NULL)

bs_card_header(..., class = NULL)

bs_card_footer(..., class = NULL)

bs_card_title(..., level = 5, class = NULL)

bs_card_subtitle(..., level = 6, class = NULL)

bs_card_text(..., class = NULL)

bs_card_link(..., href = "#", class = NULL)

bs_card_img(
  src,
  position = c("top", "bottom", "overlay"),
  alt = "",
  ...,
  class = NULL
)

bs_card_img_overlay(..., class = NULL)

bs_card_group(..., class = NULL)
```

## Arguments

- ...:

  Card content (headers, bodies, images, ...) and named HTML attributes.

- color:

  Background theme colour (`.text-bg-*`), one of the Bootstrap theme
  colours.

- border:

  Border theme colour (`.border-*`).

- class:

  Extra classes.

- level:

  Heading level (1-6) for the card title / subtitle.

- href:

  Link target for `bs_card_link()`.

- src:

  Image source URL.

- position:

  Image placement: `"top"`, `"bottom"`, or `"overlay"` (use together
  with `bs_card_img_overlay()`).

- alt:

  Image alt text.

## Value

A card tag.

## Examples

``` r
bs_card(
  bs_card_header("Featured"),
  bs_card_body(
    bs_card_title("Card title"),
    bs_card_text("Some quick example text.")
  )
)
#> <div class="card">
#>   <div class="card-header">Featured</div>
#>   <div class="card-body">
#>     <h5 class="card-title">Card title</h5>
#>     <p class="card-text">Some quick example text.</p>
#>   </div>
#> </div>

bs_card_group(
  bs_card(
    bs_card_img("cap.png", alt = ""),
    bs_card_body(
      bs_card_title("Title"),
      bs_card_subtitle("Subtitle"),
      bs_card_link("More", href = "#")
    ),
    bs_card_footer("2 days ago")
  )
)
#> <div class="card-group">
#>   <div class="card">
#>     <img src="cap.png" alt="" class="card-img-top"/>
#>     <div class="card-body">
#>       <h5 class="card-title">Title</h5>
#>       <h6 class="card-subtitle mb-2 text-body-secondary">Subtitle</h6>
#>       <a href="#" class="card-link">More</a>
#>     </div>
#>     <div class="card-footer">2 days ago</div>
#>   </div>
#> </div>
bs_card(bs_card_img("cap.png", alt = ""), bs_card_img_overlay("Over"))
#> <div class="card">
#>   <img src="cap.png" alt="" class="card-img-top"/>
#>   <div class="card-img-overlay">Over</div>
#> </div>
```
