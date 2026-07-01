/* bootstrict tooltip & popover initialisers --------------------------------
 *
 * Tooltips and popovers are not auto-initialised by Bootstrap. These two
 * bindings are not real Shiny inputs (getValue returns null); they exist only
 * so each decorated element gets a Bootstrap instance created on bind.
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Stable-ish id fallback for elements without an id (these are not real
  // inputs, so the id only needs to be unique enough not to collide).
  function tipId(el, prefix) {
    return el.id || (prefix + "-" + Math.round(performance.now()));
  }

  var tooltipBinding = bootstrict.eventBinding({
    name: "bootstrict.tooltip",
    selector: "[data-bootstrict-tip='tooltip']",
    events: [],
    initialize: function (el) {
      bootstrict.bs("Tooltip", el);
    },
    getValue: function () {
      return null;
    }
  });
  if (tooltipBinding) {
    tooltipBinding.getId = function (el) {
      return tipId(el, "bstip");
    };
  }

  var popoverBinding = bootstrict.eventBinding({
    name: "bootstrict.popover",
    selector: "[data-bootstrict-tip='popover']",
    events: [],
    initialize: function (el) {
      bootstrict.bs("Popover", el);
    },
    getValue: function () {
      return null;
    }
  });
  if (popoverBinding) {
    popoverBinding.getId = function (el) {
      return tipId(el, "bspop");
    };
  }
})(window);
