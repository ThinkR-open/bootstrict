# Bootstrap image

Bootstrap image

## Usage

``` r
bs_img(
  src,
  ...,
  fluid = FALSE,
  thumbnail = FALSE,
  rounded = FALSE,
  object_fit = NULL,
  alt = "",
  class = NULL
)
```

## Arguments

- src:

  Image source URL.

- ...:

  Extra named HTML attributes applied to the `<img>`.

- fluid:

  Make the image responsive (`.img-fluid`).

- thumbnail:

  Render with a rounded thumbnail border (`.img-thumbnail`).

- rounded:

  Add rounded corners (`.rounded`).

- object_fit:

  How the image fills its box (Bootstrap 5.3 `.object-fit-*` utility):
  `"contain"`, `"cover"`, `"fill"`, `"scale"` (scale-down) or `"none"`.

- alt:

  Alternative text. Defaults to `""`, which marks the image decorative;
  an `<img>` with no `alt` at all is announced by its file name instead.

- class:

  Extra classes.

## Value

An image tag.

## Examples

``` r
bs_img("logo.png", alt = "Logo", fluid = TRUE)
#> <img src="logo.png" alt="Logo" class="img-fluid"/>
```
