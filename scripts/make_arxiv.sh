#!/usr/bin/env bash
set -euo pipefail
OUT="dist/arxiv_package.tar.gz"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
python3 scripts/status_manifest.py --check
mkdir -p dist
FILES=(
  # Historical inputs, inseparable from their withdrawal notice
  "retraction_notice.tex"
  "CURRENT_STATUS.md"
  "governance/claims.json"
  "governance/evidence/ERRATUM_RH_T1T4_2026-10-13.md"
  "ERRATUM_RH_T1T4_2026-10-13.md"
  "F001_ERRATUM.md"
  "HISTORICAL_DOCUMENTS.md"
  "05-chebyshev-mod30/README.md"
  "main_arxiv.tex"
  "authors_cmd.tex"
  "proofarticle.cls"
  "theorems/T2_weighted_frame_full.tex"
  "theorems/T3_wavepacket_full.tex"
  "appendix/explicit_arch_full.tex"
  "refs.bib"
)
archive_tmp="$(mktemp -d)"
trap 'rm -rf "$archive_tmp"' EXIT
for f in "${FILES[@]}"; do
  mkdir -p "$archive_tmp/$(dirname "$f")"
  cp "$f" "$archive_tmp/$f"
done
# README: use the light arXiv version (no badges/HTML/images)
if [ -f "README_arxiv.md" ]; then
  cp "README_arxiv.md" "$archive_tmp/README.md"
elif [ -f "README.md" ]; then
  # fallback to full README if light one is missing
  cp "README.md" "$archive_tmp/README.md"
fi

# --- Build SHA256 manifest inside the historical payload --------------------
(
  cd "$archive_tmp" || exit 1

  if command -v sha256sum >/dev/null 2>&1; then
    SHA256='sha256sum'
  elif command -v shasum >/dev/null 2>&1; then
    SHA256='shasum -a 256'
  else
    echo "ERROR: no sha256 tool found (sha256sum or shasum)." >&2
    exit 2
  fi

  {
    echo "MANIFEST (sha256) — historical payload, RETRACTED AS PROOF"
    date -u +"generated_at: %Y-%m-%dT%H:%M:%SZ"
    echo
    find . -type f ! -name MANIFEST_SHA256.txt -print0 \
      | sort -z \
      | xargs -0 $SHA256
  } > MANIFEST_SHA256.txt
)
# ------------------------------------------------------------------------------

# Sanity echo
echo "arXiv payload:"
find "$archive_tmp" -maxdepth 2 -type f -print
tar -czf "$OUT" -C "$archive_tmp" .
sha256sum "$OUT" > "${OUT}.sha256"
echo "arXiv package -> $OUT + ${OUT}.sha256"
