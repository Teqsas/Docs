#!/usr/bin/env python3
# Validate every product directory in docs/ against the conventions in
# AGENTS.md before the PDF build runs. Exits 1 on any error so the
# workflow can short-circuit with a clear message.

from __future__ import annotations

import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DOCS = REPO_ROOT / "docs"

# Mandatory manual slots (see AGENTS.md → Manual-Slot-Konvention).
REQUIRED_MANUALS = ["manual_1.md", "manual_2.md", "manual_3.md", "manual_ce.md"]

LANGS = [
    ("de", DOCS),
    ("en", DOCS / "en"),
]


@dataclass
class Report:
    errors: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)

    def error(self, msg: str) -> None:
        self.errors.append(msg)

    def warn(self, msg: str) -> None:
        self.warnings.append(msg)


def read_frontmatter(path: Path) -> dict[str, str]:
    if not path.exists():
        return {}
    text = path.read_text(encoding="utf-8")
    m = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.DOTALL)
    if not m:
        return {}
    out: dict[str, str] = {}
    for line in m.group(1).splitlines():
        lm = re.match(r"^([A-Za-z_][\w-]*)\s*:\s*(.*?)\s*$", line)
        if not lm:
            continue
        key, value = lm.group(1), lm.group(2)
        if (value.startswith('"') and value.endswith('"')) or (
            value.startswith("'") and value.endswith("'")
        ):
            value = value[1:-1]
        out[key] = value
    return out


def discover_products(base: Path) -> list[str]:
    if not base.exists():
        return []
    products: list[str] = []
    for child in sorted(base.iterdir()):
        if not child.is_dir():
            continue
        if child.name.startswith("_") or child.name == "en":
            continue
        if (child / "Manual").is_dir():
            products.append(child.name)
    return products


def validate_product(product: str, report: Report) -> None:
    de_index = DOCS / product / "index.md"
    de_fm = read_frontmatter(de_index)

    if not de_index.exists():
        report.error(f"{product}: docs/{product}/index.md missing")
        return

    title_de = de_fm.get("title", "").strip()
    if not title_de:
        report.error(
            f"{product}: docs/{product}/index.md is missing the 'title' frontmatter field"
        )

    cover = de_fm.get("cover_image", "").strip()
    if cover:
        cover_path = DOCS / cover
        if not cover_path.exists():
            report.error(
                f"{product}: cover_image '{cover}' referenced in frontmatter does not exist at {cover_path}"
            )

    for slot in REQUIRED_MANUALS:
        if not (DOCS / product / "Manual" / slot).exists():
            report.error(f"{product}: required slot Manual/{slot} is missing")

    en_index = DOCS / "en" / product / "index.md"
    if not en_index.exists():
        report.warn(
            f"{product}: no English mirror at docs/en/{product}/index.md (PDF will fall back to DE title)"
        )
    else:
        en_fm = read_frontmatter(en_index)
        if not en_fm.get("title", "").strip():
            report.warn(
                f"{product}: docs/en/{product}/index.md has no 'title' frontmatter — will fall back to DE"
            )

    en_manual = DOCS / "en" / product / "Manual"
    if en_manual.is_dir():
        for slot in REQUIRED_MANUALS:
            if not (en_manual / slot).exists():
                report.warn(
                    f"{product}: English Manual/{slot} is missing"
                )


def main() -> int:
    report = Report()

    products = discover_products(DOCS)
    if not products:
        report.error("No product directories discovered under docs/")
    for product in products:
        validate_product(product, report)

    if report.warnings:
        print("Warnings:")
        for w in report.warnings:
            print(f"  - {w}")

    if report.errors:
        print("Errors:")
        for e in report.errors:
            print(f"  - {e}")
        print(f"\nValidation FAILED ({len(report.errors)} errors, {len(report.warnings)} warnings)")
        return 1

    print(
        f"\nValidation OK — {len(products)} products, "
        f"{len(report.warnings)} warnings, 0 errors"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
