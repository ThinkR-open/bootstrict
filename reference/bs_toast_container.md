# Position toasts on screen

A fixed-position container that holds and lays out one or more
[`bs_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_toast.md)s.

## Usage

``` r
bs_toast_container(..., placement = "top-end", class = NULL)
```

## Arguments

- ...:

  Toasts and named HTML attributes applied to the container.

- placement:

  Where to anchor the container. One of `"top-start"`, `"top-center"`,
  `"top-end"`, `"middle-start"`, `"middle-center"`, `"middle-end"`,
  `"bottom-start"`, `"bottom-center"` or `"bottom-end"`.

- class:

  Extra classes.

## Value

A toast container tag.

## Examples

``` r
bs_toast_container(
  bs_toast("hello", "Hi there", title = "Greeting"),
  placement = "top-end"
)
#> <div class="toast-container position-fixed p-3 top-0 end-0">
#>   <div id="hello" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bootstrict="toast" data-bs-delay="5000">
#>     <div class="toast-header">
#>       <strong class="me-auto">Greeting</strong>
#>       <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="toast"></button>
#>     </div>
#>     <div class="toast-body">Hi there</div>
#>   </div>
#> </div>
```
