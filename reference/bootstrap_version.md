# The Bootstrap version bootstrict ships

bootstrict vendors its own copy of Bootstrap under `inst/lib/bootstrap`
rather than compiling against whatever version a theming package happens
to bundle, so this is the version that actually reaches the browser.

## Usage

``` r
bootstrap_version()
```

## Value

The Bootstrap version, as a string.

## Examples

``` r
bootstrap_version()
#> [1] "5.3.8"
```
