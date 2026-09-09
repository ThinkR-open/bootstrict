# text-like control markup is stable

    Code
      snap(bs_text_input("name", "Name", placeholder = "Jane", help = "Your full name."))
    Output
      <div class="form-group shiny-input-container">
        <label class="control-label form-label" for="name" id="name-label">Name</label>
        <input id="name" type="text" class="shiny-input-text form-control" value="" placeholder="Jane" data-update-on="change" aria-describedby="name-help"/>
        <div id="name-help" class="form-text">Your full name.</div>
      </div> 

---

    Code
      snap(bs_textarea_input("bio", "Bio", rows = 3))
    Output
      <div class="shiny-input-textarea form-group shiny-input-container">
        <label class="control-label form-label" for="bio" id="bio-label">Bio</label>
        <textarea id="bio" class="form-control" rows="3" data-update-on="change"></textarea>
      </div> 

---

    Code
      snap(bs_numeric_input("n", "N", value = 1, min = 0, max = 10))
    Output
      <div class="form-group shiny-input-container">
        <label class="control-label form-label" for="n" id="n-label">N</label>
        <input id="n" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10"/>
      </div> 

---

    Code
      snap(bs_password_input("pw", "Password", size = "lg"))
    Output
      <div class="form-group shiny-input-container">
        <label class="control-label form-label" for="pw" id="pw-label">Password</label>
        <input class="shiny-input-password form-control form-control-lg" data-update-on="change" id="pw" type="password" value=""/>
      </div> 

---

    Code
      snap(bs_select_input("s", "Select", c("a", "b")))
    Output
      <div class="form-group shiny-input-container">
        <label class="control-label form-label" for="s" id="s-label">Select</label>
        <div>
          <select id="s" class="shiny-input-select form-select"><option value="a" selected>a</option>
      <option value="b">b</option></select>
        </div>
      </div> 

# check-like control markup is stable

    Code
      snap(bs_checkbox_input("cb", "Agree"))
    Output
      <div class="form-group shiny-input-container">
        <div class="form-check">
          <label class="form-check-label">
            <input class="shiny-input-checkbox form-check-input" id="cb" type="checkbox"/>
            <span>Agree</span>
          </label>
        </div>
      </div> 

---

    Code
      snap(bs_switch_input("sw", "Enable"))
    Output
      <div class="form-group shiny-input-container">
        <div class="form-check form-switch">
          <label class="form-check-label">
            <input class="shiny-input-checkbox form-check-input" id="sw" role="switch" type="checkbox"/>
            <span>Enable</span>
          </label>
        </div>
      </div> 

---

    Code
      snap(bs_radio_input("r", "Size", c("S", "M"), inline = TRUE))
    Output
      <div id="r" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="r-label" data-bootstrict="form-check" data-bootstrict-inline="">
        <label class="control-label form-label" for="r" id="r-label">Size</label>
        <div class="shiny-options-group">
          <label class="form-check form-check-inline">
            <input type="radio" name="r" value="S" checked="checked" class="form-check-input"/>
            <span>S</span>
          </label>
          <label class="form-check form-check-inline">
            <input type="radio" name="r" value="M" class="form-check-input"/>
            <span>M</span>
          </label>
        </div>
      </div> 

---

    Code
      snap(bs_checkbox_group_input("cg", "Pick", c("a", "b")))
    Output
      <div id="cg" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="cg-label" data-bootstrict="form-check">
        <label class="control-label form-label" for="cg" id="cg-label">Pick</label>
        <div class="shiny-options-group">
          <div class="form-check">
            <label class="form-check-label">
              <input type="checkbox" name="cg" value="a" class="form-check-input"/>
              <span>a</span>
            </label>
          </div>
          <div class="form-check">
            <label class="form-check-label">
              <input type="checkbox" name="cg" value="b" class="form-check-input"/>
              <span>b</span>
            </label>
          </div>
        </div>
      </div> 

---

    Code
      snap(bs_checkbox_input("cbr", "Reverse", reverse = TRUE))
    Output
      <div class="form-group shiny-input-container">
        <div class="form-check form-check-reverse">
          <label class="form-check-label">
            <input class="shiny-input-checkbox form-check-input" id="cbr" type="checkbox"/>
            <span>Reverse</span>
          </label>
        </div>
      </div> 

# toggle button markup is stable

    Code
      snap(bs_radio_button_input("size", "Size", c(Small = "s", Large = "l")))
    Output
      <div id="size" data-bootstrict="toggle-buttons" data-bootstrict-type="radio">
        <label class="form-label" id="size-label">Size</label>
        <div class="btn-group" role="group" aria-labelledby="size-label">
          <input type="radio" class="btn-check" name="size" id="size-1" value="s" autocomplete="off" checked/>
          <label class="btn btn-outline-primary" for="size-1">Small</label>
          <input type="radio" class="btn-check" name="size" id="size-2" value="l" autocomplete="off"/>
          <label class="btn btn-outline-primary" for="size-2">Large</label>
        </div>
      </div> 

---

    Code
      snap(bs_checkbox_button_input("opts", NULL, c("a", "b")))
    Output
      <div id="opts" data-bootstrict="toggle-buttons" data-bootstrict-type="checkbox">
        <div class="btn-group" role="group" aria-label="Toggle buttons">
          <input type="checkbox" class="btn-check" name="opts" id="opts-1" value="a" autocomplete="off"/>
          <label class="btn btn-outline-primary" for="opts-1">a</label>
          <input type="checkbox" class="btn-check" name="opts" id="opts-2" value="b" autocomplete="off"/>
          <label class="btn btn-outline-primary" for="opts-2">b</label>
        </div>
      </div> 

# native control markup is stable

    Code
      snap(bs_range_input("rng", "Range", value = 5, min = 0, max = 10))
    Output
      <div>
        <label class="form-label" for="rng" id="rng-label">Range</label>
        <input id="rng" type="range" class="form-range" min="0" max="10" value="5" data-bootstrict="range"/>
      </div> 

---

    Code
      snap(bs_color_input("col", "Colour", value = "#ff6600"))
    Output
      <div>
        <label class="form-label" for="col" id="col-label">Colour</label>
        <input id="col" type="color" class="form-control form-control-color" value="#ff6600" data-bootstrict="color"/>
      </div> 

# form layout markup is stable

    Code
      snap(bs_input_group(bs_input_group_text("@"), bs_text_input("u", NULL)))
    Output
      <div class="input-group">
        <span class="input-group-text">@</span>
        <input id="u" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
      </div> 

---

    Code
      snap(bs_input_group(bs_input_group_text(bs_checkbox_input("cb", NULL)),
      bs_text_input("u", NULL)))
    Output
      <div class="input-group">
        <span class="input-group-text">
          <input class="shiny-input-checkbox form-check-input mt-0" id="cb" type="checkbox"/>
        </span>
        <input id="u" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
      </div> 

---

    Code
      snap(bs_floating_label(bs_text_input("e", "Email")))
    Output
      <div class="form-floating">
        <input id="e" type="text" class="shiny-input-text form-control" value="" data-update-on="change" placeholder=" "/>
        <label for="e">Email</label>
      </div> 

---

    Code
      snap(bs_form(bs_form_label("e", "Email"), bs_text_input("e", NULL),
      bs_form_text("We never share it.")))
    Output
      <form>
        <label class="form-label" for="e">Email</label>
        <div class="form-group shiny-input-container">
          <label class="control-label shiny-label-null form-label" for="e" id="e-label"></label>
          <input id="e" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
        </div>
        <div class="form-text">We never share it.</div>
      </form> 

---

    Code
      snap(bs_feedback(bs_text_input("user", "User"), invalid = "Taken.", state = "invalid"))
    Output
      <div class="form-group shiny-input-container">
        <label class="control-label form-label" for="user" id="user-label">User</label>
        <input class="shiny-input-text form-control is-invalid" data-update-on="change" id="user" type="text" value=""/>
        <div class="invalid-feedback">Taken.</div>
      </div> 

---

    Code
      snap(bs_valid_feedback("Looks good."))
    Output
      <div class="valid-feedback">Looks good.</div> 

---

    Code
      snap(bs_invalid_feedback("Please provide a value."))
    Output
      <div class="invalid-feedback">Please provide a value.</div> 

# the file and date controls are stable

    Code
      snap(bs_file_input("f", "Upload"))
    Output
      <div class="form-group">
        <label class="form-label" for="f" id="f-label">Upload</label>
        <input class="shiny-input-file form-control" id="f" name="f" type="file"/>
        <div id="f_progress" class="progress active shiny-file-input-progress">
          <div class="progress-bar progress-bar-striped progress-bar-animated"></div>
        </div>
      </div> 

---

    Code
      snap(bs_date_input("d", "Date"))
    Output
      <div id="d" data-bootstrict="date">
        <label class="form-label" for="d-field" id="d-label">Date</label>
        <input id="d-field" type="date" class="form-control"/>
      </div> 

---

    Code
      snap(bs_date_range_input("dr", "Range"))
    Output
      <div id="dr" data-bootstrict="date-range">
        <label class="form-label" id="dr-label">Range</label>
        <div class="input-group">
          <input id="dr-start" type="date" class="form-control" aria-label="Start date"/>
          <span class="input-group-text">to</span>
          <input id="dr-end" type="date" class="form-control" aria-label="End date"/>
        </div>
      </div> 

