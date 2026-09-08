/* bootstrict pagination binding --------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // `.active` and data-value live on the <li class="page-item">, while the
  // clickable element is the <a class="page-link"> inside it, and Bootstrap
  // puts aria-current on that anchor.
  var ITEM = ".page-item";

  // Prev/next carry no data-value: they move to the neighbouring page rather
  // than being a selection of their own, and are disabled at either end.
  function pages(root) {
    return Array.prototype.slice.call(
      root.querySelectorAll(ITEM + "[data-value]")
    );
  }

  function syncSteps(root) {
    var all = pages(root);
    var index = all.indexOf(root.querySelector(ITEM + ".active"));
    root.querySelectorAll(ITEM).forEach(function (item) {
      var step = item.querySelector("[data-bootstrict-step]");
      if (!step) return;
      var atEnd =
        step.getAttribute("data-bootstrict-step") === "prev"
          ? index <= 0
          : index < 0 || index >= all.length - 1;
      item.classList.toggle("disabled", atEnd);
      if (atEnd) {
        step.setAttribute("aria-disabled", "true");
        step.setAttribute("tabindex", "-1");
      } else {
        step.removeAttribute("aria-disabled");
        step.removeAttribute("tabindex");
      }
    });
  }

  function activate(root, item) {
    root.querySelectorAll(ITEM + ".active").forEach(function (other) {
      other.classList.remove("active");
      var link = other.querySelector(".page-link");
      if (link) link.removeAttribute("aria-current");
    });
    item.classList.add("active");
    var link = item.querySelector(".page-link");
    if (link) link.setAttribute("aria-current", "page");
  }

  bootstrict.eventBinding({
    name: "bootstrict.pagination",
    selector: ".pagination[data-bootstrict='pagination']",
    events: ["bootstrict:pagination"],
    getValue: function (el) {
      var active = el.querySelector(ITEM + ".active");
      return active ? active.getAttribute("data-value") : null;
    },
    subscribe: function (el, callback, ns) {
      $(el).on("click" + ns, function (e) {
        var item = e.target.closest(ITEM);
        if (!item || !el.contains(item)) return;
        // href="#" would jump to the top of the page.
        e.preventDefault();
        if (item.classList.contains("disabled")) return;

        var step = item.querySelector("[data-bootstrict-step]");
        if (step) {
          var all = pages(el);
          var index = all.indexOf(el.querySelector(ITEM + ".active"));
          var moved =
            all[
              index +
                (step.getAttribute("data-bootstrict-step") === "prev" ? -1 : 1)
            ];
          if (!moved) return;
          activate(el, moved);
          syncSteps(el);
          callback();
          return;
        }

        if (!item.hasAttribute("data-value")) return;
        activate(el, item);
        syncSteps(el);
        callback();
      });
    }
  });

  bootstrict.addHandler("pagination.update", function (msg) {
    var root = document.getElementById(msg.id);
    if (!root) return bootstrict.missing("pagination.update", msg.id);
    if (msg.selected === null || typeof msg.selected === "undefined") return;

    var value = msg.selected;
    var item = root.querySelector(
      ITEM + "[data-value='" +
        (window.CSS && CSS.escape ? CSS.escape(value) : value) +
        "']"
    );
    if (!item) {
      console.warn(
        "bootstrict: pagination.update — no page with value '" + value +
          "' in #" + msg.id + "; selection left unchanged."
      );
      return;
    }
    activate(root, item);
    syncSteps(root);
    $(root).trigger("bootstrict:pagination");
  });
})(window);
