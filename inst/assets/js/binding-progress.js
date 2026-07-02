/* bootstrict progress binding ---------------------------------------------
 *
 * Progress is display-only (not a Shiny input), so there is no eventBinding:
 * just a server -> client handler driven by update_bs_progress(). Bootstrap
 * 5.3 markup: the id, role and aria-value* attributes live on the `.progress`
 * track; the inner `.progress-bar` is purely visual. In a `.progress-stacked`
 * group the width lives on the track, otherwise on the bar.
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Theme background classes swapped by the `color` field. Only these are
  // touched: user-supplied bg-opacity-* / bg-gradient / custom bg-* classes
  // must survive an update.
  var THEME_BG = [
    "bg-primary", "bg-secondary", "bg-success", "bg-danger",
    "bg-warning", "bg-info", "bg-light", "bg-dark"
  ];

  function num(x, fallback) {
    var n = parseFloat(x);
    return isNaN(n) ? fallback : n;
  }

  // Server -> client: update a progress track's value / label / colour /
  // bounds.
  bootstrict.addHandler("progress.update", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("progress.update", msg.id);

    // The id belongs on the .progress track; tolerate a bar id.
    var track = el.classList.contains("progress")
      ? el
      : el.closest(".progress") || el;
    var bar = track.querySelector(".progress-bar") || track;

    // Resolve the effective scale, preferring fresh values from the message.
    var min = msg.min != null ? num(msg.min, 0) :
      num(track.getAttribute("aria-valuemin"), 0);
    var max = msg.max != null ? num(msg.max, 100) :
      num(track.getAttribute("aria-valuemax"), 100);

    if (msg.min != null) track.setAttribute("aria-valuemin", min);
    if (msg.max != null) track.setAttribute("aria-valuemax", max);

    // Recompute the width whenever the value *or* the scale changes — a
    // min/max-only update must not leave a stale width behind.
    if (msg.value != null || msg.min != null || msg.max != null) {
      var value = msg.value != null ? num(msg.value, 0) :
        num(track.getAttribute("aria-valuenow"), 0);
      var span = max - min;
      var pct = span === 0 ? 0 : Math.round((100 * (value - min)) / span);
      pct = Math.max(0, Math.min(100, pct));
      var stacked = track.parentElement &&
        track.parentElement.classList.contains("progress-stacked");
      (stacked ? track : bar).style.width = pct + "%";
      if (msg.value != null) track.setAttribute("aria-valuenow", value);
    }

    if (msg.label != null) {
      bar.textContent = msg.label;
    }

    if (msg.color != null) {
      // Swap only the theme bg-* class for the new one.
      bar.className = bar.className
        .split(/\s+/)
        .filter(function (c) {
          return c && THEME_BG.indexOf(c) === -1;
        })
        .concat("bg-" + msg.color)
        .join(" ");
    }
  });
})(window);
