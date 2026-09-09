/* bootstrict date bindings --------------------------------------------------
 *
 * Native <input type="date"> controls. shiny's dateInput would bring
 * bootstrap-datepicker with it -- a third-party stylesheet whose calendar is
 * nowhere in the Bootstrap docs -- so these are bootstrict's own.
 *
 * The value crosses as "yyyy-mm-dd" (or "" when empty) and is turned into a
 * Date by the input handlers registered in .onLoad().
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  function fields(el) {
    return Array.prototype.slice.call(el.querySelectorAll("input[type='date']"));
  }

  // A single field: the id is on the container, so the binding reads it from
  // there and the two constructors share one shape.
  bootstrict.eventBinding({
    name: "bootstrict.date",
    selector: "[data-bootstrict='date']",
    events: ["change"],
    getValue: function (el) {
      var input = fields(el)[0];
      return input ? input.value : "";
    },
    getType: function () {
      return "bootstrict.date";
    }
  });

  bootstrict.eventBinding({
    name: "bootstrict.daterange",
    selector: "[data-bootstrict='date-range']",
    events: ["change"],
    getValue: function (el) {
      return fields(el).map(function (input) {
        return input.value;
      });
    },
    getType: function () {
      return "bootstrict.daterange";
    }
  });

  // Server -> client. An absent field is left alone; "" clears it.
  function set(input, value) {
    if (input && value !== null && typeof value !== "undefined") {
      input.value = value;
    }
  }

  function bounds(input, msg) {
    if (!input) return;
    if (msg.min) input.setAttribute("min", msg.min);
    if (msg.max) input.setAttribute("max", msg.max);
  }

  bootstrict.addHandler("date.update", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("date.update", msg.id);
    var input = fields(el)[0];
    set(input, msg.value);
    bounds(input, msg);
    $(el).trigger("change");
  });

  bootstrict.addHandler("daterange.update", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("daterange.update", msg.id);
    var pair = fields(el);
    set(pair[0], msg.start);
    set(pair[1], msg.end);
    bounds(pair[0], msg);
    bounds(pair[1], msg);
    $(el).trigger("change");
  });
})(window);
