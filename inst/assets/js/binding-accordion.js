/* bootstrict accordion binding -------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Direct panels of *this* accordion only — an accordion nested inside a
  // panel body must not leak its state into (or receive events from) the
  // outer one.
  function ownPanels(el, extra) {
    return Array.prototype.slice.call(
      el.querySelectorAll(
        ":scope > .accordion-item > .accordion-collapse" + (extra || "")
      )
    );
  }

  // Report the data-value of every open panel (null when none are open).
  bootstrict.eventBinding({
    name: "bootstrict.accordion",
    selector: ".accordion[data-bootstrict='accordion']",
    events: ["shown.bs.collapse", "hidden.bs.collapse"],
    eventFilter: function (el, e) {
      // Ignore collapse events bubbling out of a nested accordion.
      var owner = e.target.closest(".accordion[data-bootstrict='accordion']");
      return owner === el;
    },
    getValue: function (el) {
      var open = ownPanels(el, ".show").map(function (c) {
        return c.getAttribute("data-value");
      });
      return open.length ? open : null;
    },
    unsubscribe: function (el) {
      if (window.bootstrap && window.bootstrap.Collapse) {
        ownPanels(el).forEach(function (c) {
          var inst = window.bootstrap.Collapse.getInstance(c);
          if (inst) inst.dispose();
        });
      }
    }
  });

  // Server -> client: open / close panels by value ("__all__" targets all).
  bootstrict.addHandler("accordion.update", function (msg) {
    var acc = document.getElementById(msg.id);
    if (!acc) return bootstrict.missing("accordion.update", msg.id);

    function panelByValue(v) {
      return acc.querySelector(
        ":scope > .accordion-item > .accordion-collapse[data-value='" +
          (window.CSS && CSS.escape ? CSS.escape(v) : v) +
          "']"
      );
    }
    function act(panel, method) {
      var inst = bootstrict.bs("Collapse", panel);
      if (inst) inst[method]();
    }

    if (msg.close === "__all__") {
      ownPanels(acc, ".show").forEach(function (c) {
        act(c, "hide");
      });
    } else if (Array.isArray(msg.close)) {
      msg.close.forEach(function (v) {
        var p = panelByValue(v);
        if (p) act(p, "hide");
      });
    }

    if (msg.open === "__all__") {
      ownPanels(acc).forEach(function (c) {
        act(c, "show");
      });
    } else if (Array.isArray(msg.open)) {
      msg.open.forEach(function (v) {
        var p = panelByValue(v);
        if (p) act(p, "show");
      });
    }
  });
})(window);
