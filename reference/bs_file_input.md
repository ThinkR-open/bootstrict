# Bootstrap file input

Delegates to
[`shiny::fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html) for
the upload plumbing, then emits the Bootstrap 5.3 markup: a plain
`<input class="form-control" type="file">`.

## Usage

``` r
bs_file_input(
  id,
  label = NULL,
  ...,
  multiple = FALSE,
  accept = NULL,
  size = NULL,
  help = NULL,
  width = NULL
)
```

## Arguments

- id:

  Input id; selected value available as `input$id`.

- label:

  Input label.

- ...:

  Extra attributes applied to the `<input type="file">` element (e.g.
  `capture`, `webkitdirectory`).

- multiple:

  Allow selecting more than one file.

- accept:

  Character vector of accepted MIME types / extensions.

- size:

  Control size: `"sm"` or `"lg"`.

- help:

  Help text rendered below the control (`.form-text`).

- width:

  CSS width (e.g. `"100%"`, `"200px"`).

## Value

A form control tag.

## Details

shiny builds the Bootstrap 3 compound widget instead – a "Browse" button
next to a readonly text box showing the file name, with the real input
hidden off-screen – which is not in the Bootstrap 5.3 docs at all. Only
shiny's own element is kept, so uploads, the progress bar and `input$id`
are unchanged; the browser draws the button and the file name itself,
which is what the 5.3 reference relies on.

## See also

[`shiny::fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html)

## Examples

``` r
bs_file_input("upload", "Upload a file", accept = ".csv")
#> <div class="form-group">
#>   <label class="form-label" for="upload" id="upload-label">Upload a file</label>
#>   <input accept=".csv" class="shiny-input-file form-control" id="upload" name="upload" type="file"/>
#>   <div id="upload_progress" class="progress active shiny-file-input-progress">
#>     <div class="progress-bar progress-bar-striped progress-bar-animated"></div>
#>   </div>
#> </div>
```
