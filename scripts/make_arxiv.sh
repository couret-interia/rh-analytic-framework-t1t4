#!/usr/bin/env bash
set -euo pipefail
OUT="dist/arxiv_package.tar.gz"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
FILES=(
  # proof-only inputs
  "main_arxiv.tex"
  "authors_cmd.tex"
  "proofarticle.cls"
  "theorems/T2_weighted_frame_full.tex"
  "theorems/T3_wavepacket_full.tex"
  "appendix/explicit_arch_full.tex"
  "refs.bib"
)
TMPDIR="$(mktemp -d)"; mkdir -p "$TMPDIR"
for f in "${FILES[@]}"; do
  mkdir -p "$TMPDIR/$(dirname "$f")"
  cp "$f" "$TMPDIR/$f"
done
# README: use the light arXiv version (no badges/HTML/images)
if [ -f "README_arxiv.md" ]; then
  cp "README_arxiv.md" "$TMPDIR/README.md"
elif [ -f "README.md" ]; then
  # fallback to full README if light one is missing
  cp "README.md" "$TMPDIR/README.md"
fi

# --- Build SHA256 manifest inside the payload (proof-only) --------------------
(
  cd "$TMPDIR" || exit 1

  if command -v sha256sum >/dev/null 2>&1; then
    SHA256='sha256sum'
  elif command -v shasum >/dev/null 2>&1; then
    SHA256='shasum -a 256'
  else
    echo "ERROR: no sha256 tool found (sha256sum or shasum)." >&2
    exit 2
  fi

  {
    echo "MANIFEST (sha256) — proof-only payload"
    date -u +"generated_at: %Y-%m-%dT%H:%M:%SZ"
    echo
    find . -maxdepth 2 -type f -print0 \
      | sort -z \
      | xargs -0 $SHA256
  } > MANIFEST_SHA256.txt
)
# ------------------------------------------------------------------------------

# Sanity echo
echo "arXiv payload:"
find "$TMPDIR" -maxdepth 2 -type f -print
# Build a simple SHA256 manifest inside the payload (proof-only)
( cd "$TMPDIR" && \
  { echo "MANIFEST (sha256) — arXiv payload"; date -u +"generated_at: %Y-%m-%dT%H:%M:%SZ"; echo; \
    find . -maxdepth 2 -type f -print0 | sort -z | xargs -0 sha256sum; } \
  > MANIFEST_SHA256.txt )
tar -czf "$OUT" -C "$TMPDIR" .
sha256sum "$OUT" > "${OUT}.sha256"
echo "arXiv package -> $OUT + ${OUT}.sha256"
