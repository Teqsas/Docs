"""MkDocs hook: build a JSON manifest of the public download assets.

Scans `docs/assets/downloads/` at build time and emits
`assets/downloads/manifest.json` into the rendered site. The downloads page
(`docs/downloads/index.md` and its EN mirror) fetches this manifest and renders
a filterable list — see `docs/javascripts/downloads.js`.

Required filename convention:
    <PRODUCT>_<TYPE>_<LANG>.<ext>

Both <TYPE> and <LANG> are mandatory. Examples:
    LAPTEQPLUSATMOSPHERE_MANUAL_DE.pdf
    PANC_DATASHEET_EN.pdf
    LAPTEQPLUS_FIRMWARE_DE.zip
    INTERFACE_DRAWING_DE.step

Files that don't match are skipped and a WARNING is logged. The file
extension is captured separately in the `ext` field — any extension is
accepted (PDF, ZIP, STEP, DXF, …).

The product display title (`productTitle`) is read from the YAML frontmatter
of `docs/<PRODUCT>/index.md` (per language, with German as fallback) so the
manifest carries human-readable names like "LAP-TEQ PLUS Atmosphere".
"""

from __future__ import annotations

import json
import logging
import re
from pathlib import Path

log = logging.getLogger("mkdocs.hooks.downloads_manifest")

DOWNLOADS_SUBDIR = "assets/downloads"
MANIFEST_REL_PATH = "assets/downloads/manifest.json"

LANG_CODES = {"DE": "de", "EN": "en"}
LANG_DOC_DIRS = {"de": "", "en": "en"}


def _read_frontmatter_title(md_path: Path) -> str:
    """Extract `title:` from a Markdown file's YAML frontmatter. Empty string if absent."""
    if not md_path.is_file():
        return ""
    try:
        text = md_path.read_text(encoding="utf-8")
    except OSError:
        return ""
    m = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.DOTALL)
    if not m:
        return ""
    for line in m.group(1).splitlines():
        line_match = re.match(r"^([A-Za-z_][\w-]*)\s*:\s*(.*?)\s*$", line)
        if not line_match or line_match.group(1) != "title":
            continue
        value = line_match.group(2)
        if (value.startswith('"') and value.endswith('"')) or (
            value.startswith("'") and value.endswith("'")
        ):
            value = value[1:-1]
        return value
    return ""


def _parse_filename(stem: str) -> tuple[str, str, str] | None:
    """Parse `<PRODUCT>_<TYPE>_<LANG>` → (product, type, lang).

    Returns None if the stem doesn't match — in particular if the type token
    is missing (e.g. the legacy `<PRODUCT>_<LANG>` form). Both product and
    type may contain further underscores; only the *last* component is the
    language token, the *first* is the product, and everything in between is
    treated as the type (joined with underscores).
    """
    parts = stem.split("_")
    if len(parts) < 3:
        return None
    lang_token = parts[-1].upper()
    if lang_token not in LANG_CODES:
        return None
    lang = LANG_CODES[lang_token]
    return parts[0], "_".join(parts[1:-1]), lang


def _resolve_product_title(docs_dir: Path, product: str, lang: str) -> str:
    """Title from `docs/<lang_dir>/<PRODUCT>/index.md`, with DE fallback, then product code."""
    lang_dir = LANG_DOC_DIRS.get(lang, "")
    candidates = []
    if lang_dir:
        candidates.append(docs_dir / lang_dir / product / "index.md")
    candidates.append(docs_dir / product / "index.md")
    for path in candidates:
        title = _read_frontmatter_title(path)
        if title:
            return title
    return product


def _build_manifest(docs_dir: Path) -> list[dict]:
    downloads_dir = docs_dir / DOWNLOADS_SUBDIR
    if not downloads_dir.is_dir():
        log.warning("downloads_manifest: %s not found, manifest will be empty", downloads_dir)
        return []
    manifest: list[dict] = []
    for asset in sorted(downloads_dir.iterdir()):
        if not asset.is_file() or asset.name.startswith("."):
            continue
        parsed = _parse_filename(asset.stem)
        if parsed is None:
            log.warning(
                "downloads_manifest: skipping %s — does not match <PRODUCT>_<TYPE>_<LANG>.<ext>",
                asset.name,
            )
            continue
        product, type_token, lang = parsed
        doc_type = type_token.replace("_", " ").title()
        ext = asset.suffix.lower().lstrip(".")
        manifest.append(
            {
                "file": f"{DOWNLOADS_SUBDIR}/{asset.name}",
                "product": product,
                "productTitle": _resolve_product_title(docs_dir, product, lang),
                "lang": lang,
                "type": doc_type,
                "ext": ext,
                "size": asset.stat().st_size,
            }
        )
    return manifest


def on_post_build(config):
    """Write the manifest into the built site after MkDocs and all plugins are done.

    Using on_post_build (instead of injecting a generated File via on_files) avoids
    a known incompatibility with mkdocs-static-i18n, which assumes every File has a
    real abs_src_path on disk.
    """
    docs_dir = Path(config["docs_dir"])
    site_dir = Path(config["site_dir"])
    manifest = _build_manifest(docs_dir)
    target = site_dir / MANIFEST_REL_PATH
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    log.info("downloads_manifest: wrote %s with %d entries", target, len(manifest))
