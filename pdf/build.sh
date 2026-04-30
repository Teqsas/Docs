#!/usr/bin/env bash
# Build all manual PDFs (5 products x 2 languages = 10 PDFs) into build/.

set -euo pipefail

REPO_ROOT="${GITHUB_WORKSPACE:-$(cd "$(dirname "$0")/.." && pwd)}"
mkdir -p "$REPO_ROOT/build"

# Product key -> human-readable title for the cover
declare -A TITLES=(
  [PANC]="PAN-C"
  [LAPTEQPLUS]="LAP-TEQ PLUS"
  [LAPTEQPLUSATMOSPHERE]="LAP-TEQ PLUS Atmosphere"
  [LAPTEQPLUSELEVATION]="LAP-TEQ PLUS Elevation"
  [INTERFACE]="LAP-TEQ PLUS INTERFACE"
)

# Language code -> docs root and per-language metadata
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

failures=()
built=()
failed_logs_file="$REPO_ROOT/build/failed_logs.txt"
: > "$failed_logs_file"

for lang in de en; do
  base="${LANG_DIRS[$lang]}"
  subtitle="${LANG_SUBTITLES[$lang]}"
  region="${LANG_REGIONS[$lang]}"
  for product in "${!TITLES[@]}"; do
    title="${TITLES[$product]}"
    manual_dir="$REPO_ROOT/$base/$product/Manual"
    if [[ ! -d "$manual_dir" ]]; then
      echo "skip ${product}/${lang}: ${manual_dir} missing"
      continue
    fi

    # Numbered chapters in natural order, then manual_ce.md as the appendix.
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

    cat > "$cover_file" <<EOF
#cover(
  title: "${title}",
  subtitle: "${subtitle}",
  vendor: "TEQSAS PRODUCTS",
  logo: "/docs/assets/logo.png",
)
EOF

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
echo "Built: ${#built[@]}"
for b in "${built[@]}"; do echo "  ok   $b"; done
echo "Failed: ${#failures[@]}"
for f in "${failures[@]}"; do echo "  FAIL $f"; done

ls -la "$REPO_ROOT/build/"

if [[ ${#failures[@]} -gt 0 ]]; then
  exit 1
fi
