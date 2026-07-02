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
    initialize: function (el) {
      // Bootstrap only scans for [data-bs-ride] once, on window.load: a
      // carousel inserted later (renderUI/insertUI) would never autoplay.
      // Creating the instance at bind time honours the data attributes.
      bootstrict.bs("Carousel", el);
    },
    getValue: function (el) {
      var active = el.querySelector(".carousel-item.active");
      if (!active) return null;
      var items = Array.prototype.slice.call(
        active.parentNode.querySelectorAll(".carousel-item")
      );
      return items.indexOf(active);
    },
    unsubscribe: function (el) {
      // Dispose so a removed autoplay carousel stops its cycle timer.
      if (window.bootstrap && window.bootstrap.Carousel) {
        var inst = window.bootstrap.Carousel.getInstance(el);
        if (inst) inst.dispose();
      }
    }
  });

  // Server -> client: jump to a slide or step in a direction.
  bootstrict.addHandler("carousel.update", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("carousel.update", msg.id);
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
