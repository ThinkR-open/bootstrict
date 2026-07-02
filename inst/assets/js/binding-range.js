/* bootstrict range binding ------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report the slider's numeric value. `input` fires continuously while
  // dragging and routes through the debounce rate policy (deferred: true);
  // `change` fires once on release and submits immediately. The selector is
  // scoped to bootstrict's own marker so a hand-written .form-range from
  // another package is not hijacked.
  bootstrict.eventBinding({
    name: "bootstrict.range",
    selector: "input[type='range'].form-range[data-bootstrict='range']",
    events: [{ name: "input", deferred: true }, "change"],
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
