/* bootstrict range binding ------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report the slider's numeric value; debounced so dragging stays cheap.
  bootstrict.eventBinding({
    name: "bootstrict.range",
    selector: "input[type='range'].form-range",
    events: ["input", "change"],
    getValue: function (el) {
      return Number(el.value);
    },
    // Server -> client (via update_bs_range() / session$sendInputMessage()).
    receiveMessage: function (el, data) {
      if (data.value !== null && typeof data.value !== "undefined") {
        el.value = data.value;
        $(el).trigger("change");
      }
    },
    ratePolicy: { policy: "debounce", delay: 250 }
  });
})(window);
