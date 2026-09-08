/* bootstrict nav binding ---------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  var ITEM = ".nav-link";

  function activate(root, link) {
    root.querySelectorAll(ITEM + ".active").forEach(function (other) {
      other.classList.remove("active");
      other.removeAttribute("aria-current");
    });
    link.classList.add("active");
    link.setAttribute("aria-current", "page");
  }

  // Report the data-value of the active link. Tabsets have their own binding
  // and their own marker, so the two never overlap.
  bootstrict.eventBinding({
    name: "bootstrict.nav",
    selector: "[data-bootstrict='nav']",
    // Resubmitted on user clicks (below) and on server-driven updates, which
    // dispatch a synthetic event on the root.
    events: ["bootstrict:nav"],
    getValue: function (el) {
      var active = el.querySelector(ITEM + ".active");
      return active ? active.getAttribute("data-value") : null;
    },
    subscribe: function (el, callback, ns) {
      $(el).on("click" + ns, function (e) {
        var link = e.target.closest(ITEM);
        if (!link || !el.contains(link)) return;
        // These are anchors with href="#": selecting must not jump to the top.
        e.preventDefault();
        if (link.classList.contains("disabled")) return;
        activate(el, link);
        callback();
      });
    }
  });

  // Server -> client: activate the link carrying the given data-value.
  bootstrict.addHandler("nav.update", function (msg) {
    var root = document.getElementById(msg.id);
    if (!root) return bootstrict.missing("nav.update", msg.id);
    if (msg.selected === null || typeof msg.selected === "undefined") return;

    var value = msg.selected;
    var link = root.querySelector(
      ITEM + "[data-value='" +
        (window.CSS && CSS.escape ? CSS.escape(value) : value) +
        "']"
    );
    if (!link) {
      console.warn(
        "bootstrict: nav.update — no link with value '" + value +
          "' in #" + msg.id + "; selection left unchanged."
      );
      return;
    }
    activate(root, link);
    $(root).trigger("bootstrict:nav");
  });
})(window);
