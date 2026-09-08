/* bootstrict toggle-button binding ------------------------------------------
 *
 * Bootstrap's segmented control (.btn-check) is native markup: the inputs are
 * siblings of their labels, with no shiny wrapper to delegate to. The binding
 * reports the checked value(s) of the group.
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  function inputs(el) {
    return Array.prototype.slice.call(el.querySelectorAll(".btn-check"));
  }

  function checked(el) {
    return inputs(el)
      .filter(function (input) {
        return input.checked;
      })
      .map(function (input) {
        return input.value;
      });
  }

  bootstrict.eventBinding({
    name: "bootstrict.togglebuttons",
    selector: "[data-bootstrict='toggle-buttons']",
    events: ["change"],
    getValue: function (el) {
      var values = checked(el);
      // A radio group is a single value; a checkbox group is a set, and an
      // empty one must reach R as character(0), not NULL.
      if (el.getAttribute("data-bootstrict-type") === "radio") {
        return values.length ? values[0] : null;
      }
      return values;
    },
    getType: function (el) {
      return el.getAttribute("data-bootstrict-type") === "radio"
        ? null
        : "bootstrict.character";
    }
  });

  // Server -> client: check exactly the requested values.
  bootstrict.addHandler("togglebuttons.update", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("togglebuttons.update", msg.id);

    var wanted = msg.clear
      ? []
      : msg.selected === null || typeof msg.selected === "undefined"
        ? null
        : [].concat(msg.selected);
    if (wanted === null) return;

    if (el.getAttribute("data-bootstrict-type") === "radio") {
      wanted = wanted.slice(0, 1);
    }
    var known = inputs(el).map(function (input) {
      return input.value;
    });
    wanted.forEach(function (value) {
      if (known.indexOf(value) === -1) {
        console.warn(
          "bootstrict: togglebuttons.update — no button with value '" +
            value + "' in #" + msg.id + "."
        );
      }
    });

    inputs(el).forEach(function (input) {
      input.checked = wanted.indexOf(input.value) !== -1;
    });
    $(el).trigger("change");
  });
})(window);
