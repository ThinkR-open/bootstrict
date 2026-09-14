# Bootstrap figure

Group an image with a caption. Compose `bs_figure()` with
`bs_figure_img()` and `bs_figure_caption()`.

## Usage

``` r
bs_figure(..., class = NULL)

bs_figure_img(src, ..., alt = "", class = NULL)

bs_figure_caption(..., class = NULL)
```

## Arguments

- ...:

  Figure content (image, caption) and named HTML attributes.

- class:

  Extra classes.

- src:

  Image source URL.

- alt:

  Alternative text. Defaults to `""`, which marks the image decorative;
  an `<img>` with no `alt` at all is announced by its file name instead.

## Value

A figure tag.

## Examples

``` r
bs_figure(
  bs_figure_img("photo.jpg", alt = "A photo"),
  bs_figure_caption("A caption for the image.")
)
#> <figure class="figure">
#>   <img src="photo.jpg" alt="A photo" class="figure-img img-fluid rounded"/>
#>   <figcaption class="figure-caption">A caption for the image.</figcaption>
#> </figure>
```
