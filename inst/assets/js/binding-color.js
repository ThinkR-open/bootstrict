/* bootstrict color binding ------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report the picked colour as a "#rrggbb" string. Scoped to bootstrict's
  // own marker so a hand-written .form-control-color is not hijacked.
  bootstrict.eventBinding({
    name: "bootstrict.color",
    selector: "input[type='color'].form-control-color[data-bootstrict='color']",
    events: ["input", "change"],
    getValue: function (el) {
      return el.value;
    },
    // Server -> client (via update_bs_color() / session$sendInputMessage()).
    receiveMessage: function (el, data) {
      if (data.value !== null && typeof data.value !== "undefined") {
        el.value = data.value;
        $(el).trigger("change");
      }
    }
  });
})(window);
