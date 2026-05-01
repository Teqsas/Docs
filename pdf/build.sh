#!/usr/bin/env bash
# Build all manual PDFs (every product directory x every supported language)
# into build/. Products are discovered automatically — adding a new product
# is "create docs/<NAME>/Manual/manual_*.md and a docs/<NAME>/index.md with
# a 'title:' frontmatter field" and nothing else.

set -euo pipefail

REPO_ROOT="${GITHUB_WORKSPACE:-$(cd "$(dirname "$0")/.." && pwd)}"
mkdir -p "$REPO_ROOT/build"

# Languages: docs/ for de, docs/en/ for en. Adding a new language is one
# entry per map.
declare -A LANG_DIRS=(
  [de]="docs"
  [en]="docs/en"
)
declare -A LANG_SUBTITLES=(
  [de]="Bedienungsanleitung"
  [en]="User Manual"
)
declare -A LANG_REGIONS=(
  [de]="DE"
  [en]="GB"
)

# Discover product directories. A product is any docs/<X>/ that has a Manual/
# subdirectory and is not the language mirror (en/).
mapfile -t PRODUCTS < <(
  find "$REPO_ROOT/docs" -mindepth 2 -maxdepth 2 -type d -name Manual \
    | awk -F/ -v repo="$REPO_ROOT/docs/" '
        {
          rel = substr($0, length(repo) + 1)
          n = split(rel, parts, "/")
          if (parts[1] != "en") print parts[1]
        }
      ' | sort -u
)

read_field() {
  local file="$1" key="$2" default="$3"
  python3 "$REPO_ROOT/pdf/read_frontmatter.py" "$file" "$key" "$default"
}

failures=()
built=()
failed_logs_file="$REPO_ROOT/build/failed_logs.txt"
: > "$failed_logs_file"

for lang in de en; do
  base="${LANG_DIRS[$lang]}"
  subtitle="${LANG_SUBTITLES[$lang]}"
  region="${LANG_REGIONS[$lang]}"

  for product in "${PRODUCTS[@]}"; do
    manual_dir="$REPO_ROOT/$base/$product/Manual"
    index_file="$REPO_ROOT/$base/$product/index.md"

    if [[ ! -d "$manual_dir" ]]; then
      echo "skip ${product}/${lang}: ${manual_dir} missing"
      continue
    fi

    # Resolve display title:
    # 1) frontmatter title in the language-specific index.md
    # 2) frontmatter title in the German index.md (fallback for missing EN frontmatter)
    # 3) directory name as last resort
    title=$(read_field "$index_file" title "")
    if [[ -z "$title" && "$lang" != "de" ]]; then
      title=$(read_field "$REPO_ROOT/docs/$product/index.md" title "")
    fi
    [[ -z "$title" ]] && title="$product"

    # Cover image (optional). Path is relative to docs/, e.g. assets/foo/bar.png.
    # Typst image() with --root=$REPO_ROOT accepts /docs/... as repo-absolute.
    cover_image=$(read_field "$index_file" cover_image "")
    if [[ -z "$cover_image" && "$lang" != "de" ]]; then
      cover_image=$(read_field "$REPO_ROOT/docs/$product/index.md" cover_image "")
    fi

    mapfile -t numbered < <(find "$manual_dir" -maxdepth 1 -name 'manual_[0-9]*.md' | sort -V)
    files=("${numbered[@]}")
    [[ -f "$manual_dir/manual_ce.md" ]] && files+=("$manual_dir/manual_ce.md")

    if [[ ${#files[@]} -eq 0 ]]; then
      echo "skip ${product}/${lang}: no manual files"
      continue
    fi

    out_pdf="$REPO_ROOT/build/${product}_${lang^^}.pdf"
    log_file="$REPO_ROOT/build/${product}_${lang^^}.log"
    cover_file="$REPO_ROOT/build/cover_${product}_${lang}.typ"

    {
      printf '#cover(\n'
      printf '  title: "%s",\n' "${title//\"/\\\"}"
      printf '  subtitle: "%s",\n' "${subtitle//\"/\\\"}"
      printf '  vendor: "TEQSAS PRODUCTS",\n'
      printf '  logo: "/docs/assets/logo.png",\n'
      if [[ -n "$cover_image" ]]; then
        printf '  hero: "/docs/%s",\n' "$cover_image"
      fi
      printf ')\n'
    } > "$cover_file"

    echo "=== Building ${product}/${lang} -> ${out_pdf}"

    set +e
    {
      for f in "${files[@]}"; do
        cat "$f"
        printf '\n\n'
      done
    } | python3 "$REPO_ROOT/pdf/preprocess_admonitions.py" \
      | ( cd "$manual_dir" && pandoc \
          --from=markdown+fenced_divs \
          --pdf-engine=typst \
          --pdf-engine-opt="--root=$REPO_ROOT" \
          --include-in-header="$REPO_ROOT/pdf/preamble.typ" \
          --include-before-body="$cover_file" \
          --lua-filter="$REPO_ROOT/pdf/images.lua" \
          --lua-filter="$REPO_ROOT/pdf/admonitions.lua" \
          --toc \
          -V title="${title} — ${subtitle}" \
          -V toc-depth=3 \
          -V lang="$lang" \
          -V region="$region" \
          -V mainfont=Ubuntu \
          -V monofont="Ubuntu Mono" \
          --verbose \
          -o "$out_pdf" ) 2>&1 | tee "$log_file"
    rc=${PIPESTATUS[1]}
    set -e

    if [[ $rc -eq 0 && -f "$out_pdf" ]]; then
      built+=("${product}/${lang}")
    else
      failures+=("${product}/${lang} (exit ${rc})")
      basename "$log_file" >> "$failed_logs_file"
    fi
    echo
  done
done

echo "=== Summary ==="
echo "Discovered products: ${PRODUCTS[*]}"
echo "Built: ${#built[@]}"
for b in "${built[@]}"; do echo "  ok   $b"; done
echo "Failed: ${#failures[@]}"
for f in "${failures[@]}"; do echo "  FAIL $f"; done

ls -la "$REPO_ROOT/build/"

if [[ ${#failures[@]} -gt 0 ]]; then
  exit 1
fi
