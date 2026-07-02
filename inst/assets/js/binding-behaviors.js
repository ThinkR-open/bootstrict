/* bootstrict tooltip / popover / scrollspy initialisers ---------------------
 *
 * Tooltips, popovers and (for dynamically inserted UI) scrollspy are not
 * auto-initialised by Bootstrap. The tooltip/popover bindings are not real
 * Shiny inputs (getValue returns null); they exist so each decorated element
 * gets a Bootstrap instance created on bind and disposed on unbind. The
 * scrollspy binding also reports the href of the active nav link as input$id.
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Unique fallback ids for elements without one. A counter (persisted on the
  // element) — not a timestamp: several tooltips bind within the same
  // millisecond, and rebinds must keep their id stable.
  var tipCounter = 0;
  function tipId(el, prefix) {
    if (el.id) return el.id;
    if (!el.getAttribute("data-bootstrict-tip-id")) {
      tipCounter += 1;
      el.setAttribute("data-bootstrict-tip-id", prefix + "-" + tipCounter);
    }
    return el.getAttribute("data-bootstrict-tip-id");
  }

  function disposer(component) {
    return function (el) {
      if (window.bootstrap && window.bootstrap[component]) {
        var inst = window.bootstrap[component].getInstance(el);
        // Dispose removes the floating .tooltip/.popover element, which would
        // otherwise be orphaned when dynamic UI removes its trigger while
        // open.
        if (inst) inst.dispose();
      }
    };
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
    },
    unsubscribe: disposer("Tooltip")
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
    },
    unsubscribe: disposer("Popover")
  });
  if (popoverBinding) {
    popoverBinding.getId = function (el) {
      return tipId(el, "bspop");
    };
  }

  // Scrollspy: Bootstrap only scans [data-bs-spy] once, on window.load, so a
  // scrollspy inserted via renderUI would otherwise never initialise.
  bootstrict.eventBinding({
    name: "bootstrict.scrollspy",
    selector: "[data-bootstrict='scrollspy']",
    events: ["activate.bs.scrollspy"],
    initialize: function (el) {
      bootstrict.bs("ScrollSpy", el);
    },
    getValue: function (el) {
      var targetSel = el.getAttribute("data-bs-target");
      if (!targetSel) return null;
      var nav = document.querySelector(targetSel);
      if (!nav) return null;
      var active = nav.querySelector(".nav-link.active, .list-group-item.active");
      return active ? active.getAttribute("href") : null;
    },
    unsubscribe: disposer("ScrollSpy")
  });
})(window);
