/* bootstrict accordion binding -------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report the data-value of every open panel.
  bootstrict.eventBinding({
    name: "bootstrict.accordion",
    selector: ".accordion[data-bootstrict='accordion']",
    events: ["shown.bs.collapse", "hidden.bs.collapse"],
    getValue: function (el) {
      return Array.prototype.slice
        .call(el.querySelectorAll(".accordion-collapse.show"))
        .map(function (c) {
          return c.getAttribute("data-value");
        });
    }
  });

  // Server -> client: open / close panels by value.
  bootstrict.addHandler("accordion.update", function (msg) {
    var acc = document.getElementById(msg.id);
    if (!acc) return;

    function panelByValue(v) {
      return acc.querySelector(
        ".accordion-collapse[data-value='" + (window.CSS && CSS.escape ? CSS.escape(v) : v) + "']"
      );
    }

    if (msg.close === "__all__") {
      acc.querySelectorAll(".accordion-collapse.show").forEach(function (c) {
        bootstrict.bs("Collapse", c).hide();
      });
    } else if (Array.isArray(msg.close)) {
      msg.close.forEach(function (v) {
        var p = panelByValue(v);
        if (p) bootstrict.bs("Collapse", p).hide();
      });
    }

    if (Array.isArray(msg.open)) {
      msg.open.forEach(function (v) {
        var p = panelByValue(v);
        if (p) bootstrict.bs("Collapse", p).show();
      });
    }
  });
})(window);
