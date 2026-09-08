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
      <div id="r" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="r-label">
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
      <div id="cg" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="cg-label">
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

# native control markup is stable

    Code
      snap(bs_range_input("rng", "Range", value = 5, min = 0, max = 10))
    Output
      <div class="shiny-input-container form-group">
        <label class="form-label" for="rng" id="rng-label">Range</label>
        <input id="rng" type="range" class="form-range" min="0" max="10" value="5" data-bootstrict="range"/>
      </div> 

---

    Code
      snap(bs_color_input("col", "Colour", value = "#ff6600"))
    Output
      <div class="shiny-input-container form-group">
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

# the shiny-inherited controls are recorded as they stand

    Code
      snap(bs_file_input("f", "Upload"))
    Output
      <div class="form-group shiny-input-container">
        <label class="control-label form-label" for="f" id="f-label">Upload</label>
        <div class="input-group">
          <span class="btn btn-file btn-secondary">
            Browse...
            <input id="f" class="shiny-input-file" name="f" type="file" style="position:absolute;top:0;left:0;width:100%;height:100%; margin:0;padding:0;opacity:0;cursor:pointer;"/>
          </span>
          <input type="text" class="form-control" placeholder="No file selected" readonly="readonly"/>
        </div>
        <div id="f_progress" class="progress active shiny-file-input-progress">
          <div class="progress-bar progress-bar-striped progress-bar-animated"></div>
        </div>
      </div> 

---

    Code
      snap(bs_date_input("d", "Date"))
    Output
      <div id="d" class="shiny-date-input form-group shiny-input-container">
        <label class="control-label form-label" for="d" id="d-label">Date</label>
        <input type="text" class="form-control" aria-labelledby="d-label" title="Date format: yyyy-mm-dd" data-date-language="en" data-date-week-start="0" data-date-format="yyyy-mm-dd" data-date-start-view="month" data-date-autoclose="true" data-date-dates-disabled="null" data-date-days-of-week-disabled="null"/>
      </div> 

---

    Code
      snap(bs_date_range_input("dr", "Range"))
    Output
      <div id="dr" class="shiny-date-range-input form-group shiny-input-container">
        <label class="control-label form-label" for="dr" id="dr-label">Range</label>
        <div class="input-daterange input-group input-group-sm">
          <input class="form-control" type="text" aria-labelledby="dr-label" title="Date format: yyyy-mm-dd" data-date-language="en" data-date-week-start="0" data-date-format="yyyy-mm-dd" data-date-start-view="month" data-date-autoclose="true"/>
          <span class="input-group-addon input-group-prepend input-group-append">
            <span class="input-group-text"> to </span>
          </span>
          <input class="form-control" type="text" aria-labelledby="dr-label" title="Date format: yyyy-mm-dd" data-date-language="en" data-date-week-start="0" data-date-format="yyyy-mm-dd" data-date-start-view="month" data-date-autoclose="true"/>
        </div>
      </div> 

