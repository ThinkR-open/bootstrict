/* bootstrict tooltip / popover / scrollspy initialisers ---------------------
 *
 * Tooltips, popovers and (for dynamically inserted UI) scrollspy are not
 * auto-initialised by Bootstrap.
 *
 * Tooltips and popovers decorate a tag that usually belongs to something else
 * (an action button, an output). They are therefore driven by the DOM, not by
 * a Shiny input binding: Shiny binds at most one input per element and later
 * registrations take precedence, so a binding here would claim the element and
 * its real input would never bind (a tooltipped bs_button() would stop
 * reporting clicks). Scrollspy is a bootstrict widget of its own and does
 * report input$id, so it stays a real binding.
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // --- tooltips & popovers -----------------------------------------------

  var TIP_SELECTOR = "[data-bootstrict-tip]";

  function tipComponent(el) {
    return el.getAttribute("data-bootstrict-tip") === "popover"
      ? "Popover"
      : "Tooltip";
  }

  // Apply fn to `root` and to every decorated descendant. Works on detached
  // nodes, so removals can be cleaned up after the fact.
  function eachTip(root, fn) {
    if (!root || root.nodeType !== 1) return;
    if (root.matches(TIP_SELECTOR)) fn(root);
    var found = root.querySelectorAll(TIP_SELECTOR);
    for (var i = 0; i < found.length; i++) fn(found[i]);
  }

  function initTip(el) {
    bootstrict.bs(tipComponent(el), el);
  }

  function disposeTip(el) {
    var component = window.bootstrap && window.bootstrap[tipComponent(el)];
    if (!component) return;
    var inst = component.getInstance(el);
    // Dispose removes the floating .tooltip/.popover element, which would
    // otherwise be orphaned when dynamic UI removes its trigger while open.
    if (inst) inst.dispose();
  }

  function watchTips() {
    eachTip(document.body, initTip);
    if (!window.MutationObserver) return;
    // Covers renderUI / insertUI / modal bodies: anything Shiny swaps in.
    new window.MutationObserver(function (records) {
      records.forEach(function (record) {
        Array.prototype.forEach.call(record.removedNodes, function (node) {
          eachTip(node, disposeTip);
        });
        Array.prototype.forEach.call(record.addedNodes, function (node) {
          eachTip(node, initTip);
        });
      });
    }).observe(document.body, { childList: true, subtree: true });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", watchTips);
  } else {
    watchTips();
  }

  // --- scrollspy ----------------------------------------------------------

  // Bootstrap only scans [data-bs-spy] once, on window.load, so a scrollspy
  // inserted via renderUI would otherwise never initialise.
  // A scrollspy inside a hidden tab pane measures a zero-height container, so
  // it never activates anything and reports nothing. Bootstrap has no idea the
  // pane became visible: refresh it when the tab is shown.
  $(document).on("shown.bs.tab", function (event) {
    var pane = document.querySelector(
      event.target.getAttribute("data-bs-target") ||
        event.target.getAttribute("href") ||
        ""
    );
    if (!pane) return;
    pane.querySelectorAll("[data-bootstrict='scrollspy']").forEach(function (el) {
      var inst =
        window.bootstrap &&
        window.bootstrap.ScrollSpy &&
        window.bootstrap.ScrollSpy.getInstance(el);
      if (inst) inst.refresh();
    });
  });

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
    unsubscribe: function (el) {
      if (window.bootstrap && window.bootstrap.ScrollSpy) {
        var inst = window.bootstrap.ScrollSpy.getInstance(el);
        if (inst) inst.dispose();
      }
    }
  });
})(window);
