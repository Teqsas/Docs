// Filterable download list.
//
// Loaded globally via `extra_javascript`. Activates only when the current
// page contains `#download-results` (i.e. /downloads/ and /en/downloads/).
//
// Reads ?q= from the URL on init, fetches /assets/downloads/manifest.json
// (built by hooks/downloads_manifest.py), filters entries by substring
// match against product code, product title, type, and filename, and
// renders a card per product with one row per file (DE/EN tagged).

(function () {
  "use strict";

  var I18N = {
    de: {
      download: "Herunterladen",
      size: "Größe",
      type: { Manual: "Bedienungsanleitung" },
      langLabel: { de: "Deutsch", en: "Englisch" },
      empty: "Keine Treffer für Ihre Suche.",
      loadError: "Downloads konnten nicht geladen werden.",
    },
    en: {
      download: "Download",
      size: "Size",
      type: { Manual: "Manual" },
      langLabel: { de: "German", en: "English" },
      empty: "No matches for your search.",
      loadError: "Could not load downloads.",
    },
  };

  function pageLang() {
    var html = document.documentElement;
    var lang = (html.getAttribute("lang") || "de").toLowerCase();
    return lang.indexOf("en") === 0 ? "en" : "de";
  }

  function manifestUrl() {
    // Page lives at /downloads/ (1 segment) or /en/downloads/ (2 segments).
    // Walk up to site root, then descend into assets/.
    var path = window.location.pathname.replace(/\/+$/, "/");
    var segments = path.split("/").filter(Boolean);
    var depth = segments.length;
    var prefix = "";
    for (var i = 0; i < depth; i++) prefix += "../";
    if (!prefix) prefix = "./";
    return prefix + "assets/downloads/manifest.json";
  }

  function formatSize(bytes) {
    if (!bytes && bytes !== 0) return "";
    var units = ["B", "KB", "MB", "GB"];
    var i = 0;
    var v = bytes;
    while (v >= 1024 && i < units.length - 1) {
      v /= 1024;
      i++;
    }
    var rounded = v >= 10 || i === 0 ? Math.round(v) : Math.round(v * 10) / 10;
    return rounded + " " + units[i];
  }

  function escapeHtml(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c];
    });
  }

  function matches(entry, query) {
    if (!query) return true;
    var q = query.toLowerCase();
    var hay = [entry.product, entry.productTitle, entry.type, entry.file]
      .filter(Boolean)
      .join(" ")
      .toLowerCase();
    return hay.indexOf(q) !== -1;
  }

  function groupByProduct(entries) {
    var groups = {};
    var order = [];
    entries.forEach(function (e) {
      if (!groups[e.product]) {
        groups[e.product] = { product: e.product, productTitle: e.productTitle, files: [] };
        order.push(e.product);
      }
      groups[e.product].files.push(e);
    });
    order.sort(function (a, b) {
      return groups[a].productTitle.localeCompare(groups[b].productTitle);
    });
    return order.map(function (k) {
      // DE before EN, then alphabetical by type.
      groups[k].files.sort(function (a, b) {
        if (a.lang !== b.lang) return a.lang === "de" ? -1 : 1;
        return (a.type || "").localeCompare(b.type || "");
      });
      return groups[k];
    });
  }

  function render(container, manifest, query, t, fileBase) {
    var filtered = manifest.filter(function (e) {
      return matches(e, query);
    });
    if (filtered.length === 0) {
      container.innerHTML = '<p class="download-empty">' + escapeHtml(t.empty) + "</p>";
      return;
    }
    var groups = groupByProduct(filtered);
    var html = groups
      .map(function (g) {
        var rows = g.files
          .map(function (f) {
            var typeLabel = (t.type && t.type[f.type]) || f.type || "";
            var langLabel = (t.langLabel && t.langLabel[f.lang]) || f.lang.toUpperCase();
            var size = f.size ? formatSize(f.size) : "";
            return (
              '<li class="download-row">' +
              '<span class="download-row__icon" aria-hidden="true">' +
              '<svg viewBox="0 0 16 16" width="20" height="20" fill="currentColor"><path d="M2 1.75A1.75 1.75 0 013.75 0h6.586c.464 0 .909.184 1.237.513l3.914 3.914c.329.329.513.773.513 1.237v8.586A1.75 1.75 0 0114.25 16H3.75A1.75 1.75 0 012 14.25V1.75zm1.75-.25a.25.25 0 00-.25.25v12.5c0 .138.112.25.25.25h10.5a.25.25 0 00.25-.25V6h-2.75A1.75 1.75 0 0110 4.25V1.5H3.75zm7.75.56V4.25c0 .138.112.25.25.25h2.44L11.5 2.06zM5 9a.75.75 0 01.75-.75h4.5a.75.75 0 010 1.5h-4.5A.75.75 0 015 9zm.75 2.25a.75.75 0 000 1.5h4.5a.75.75 0 000-1.5h-4.5z"/></svg>' +
              "</span>" +
              '<span class="download-row__main">' +
              '<span class="download-row__title">' +
              escapeHtml(typeLabel) +
              "</span>" +
              '<span class="download-row__meta">' +
              '<span class="download-badge download-badge--lang download-badge--lang-' +
              escapeHtml(f.lang) +
              '">' +
              escapeHtml(langLabel) +
              "</span>" +
              '<span class="download-badge download-badge--ext">' +
              escapeHtml((f.ext || "").toUpperCase()) +
              "</span>" +
              (size ? '<span class="download-row__size">' + escapeHtml(size) + "</span>" : "") +
              "</span>" +
              "</span>" +
              '<a class="download-row__btn md-button md-button--primary" href="' +
              escapeHtml(fileBase + f.file) +
              '" download>' +
              escapeHtml(t.download) +
              "</a>" +
              "</li>"
            );
          })
          .join("");
        return (
          '<section class="download-card">' +
          '<h2 class="download-card__title">' +
          escapeHtml(g.productTitle) +
          "</h2>" +
          '<ul class="download-card__list">' +
          rows +
          "</ul>" +
          "</section>"
        );
      })
      .join("");
    container.innerHTML = html;
  }

  function init() {
    var container = document.getElementById("download-results");
    if (!container) return;
    var input = document.getElementById("download-search");
    var lang = pageLang();
    var t = I18N[lang];

    var manifestPath = manifestUrl();
    // For asset href we need the same site-root-relative prefix as the manifest.
    var fileBase = manifestPath.replace(/assets\/downloads\/manifest\.json$/, "");

    var initialMsg = container.getAttribute("data-empty-message-initial");
    if (initialMsg) {
      container.innerHTML = '<p class="download-empty">' + initialMsg + "</p>";
    }

    var params = new URLSearchParams(window.location.search);
    var initialQuery = params.get("q") || "";
    if (input) input.value = initialQuery;

    fetch(manifestPath, { credentials: "same-origin" })
      .then(function (r) {
        if (!r.ok) throw new Error("HTTP " + r.status);
        return r.json();
      })
      .then(function (manifest) {
        render(container, manifest, initialQuery, t, fileBase);
        if (input) {
          input.addEventListener("input", function () {
            var q = input.value;
            var url = new URL(window.location.href);
            if (q) url.searchParams.set("q", q);
            else url.searchParams.delete("q");
            window.history.replaceState({}, "", url);
            render(container, manifest, q, t, fileBase);
          });
        }
      })
      .catch(function (err) {
        // eslint-disable-next-line no-console
        console.error("downloads.js: failed to load manifest", err);
        container.innerHTML = '<p class="download-empty">' + escapeHtml(t.loadError) + "</p>";
      });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
