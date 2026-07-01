/* bootstrict carousel binding ---------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report the 0-based index of the active item among its siblings.
  bootstrict.eventBinding({
    name: "bootstrict.carousel",
    selector: ".carousel[data-bootstrict='carousel']",
    events: ["slid.bs.carousel"],
    getValue: function (el) {
      var active = el.querySelector(".carousel-item.active");
      if (!active) return null;
      var items = Array.prototype.slice.call(
        active.parentNode.querySelectorAll(".carousel-item")
      );
      return items.indexOf(active);
    }
  });

  // Server -> client: jump to a slide or step in a direction.
  bootstrict.addHandler("carousel.update", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return;
    var carousel = bootstrict.bs("Carousel", el);
    if (!carousel) return;

    if (msg.to !== undefined && msg.to !== null) {
      carousel.to(msg.to);
    } else if (msg.slide === "next") {
      carousel.next();
    } else if (msg.slide === "prev") {
      carousel.prev();
    }
  });
})(window);
