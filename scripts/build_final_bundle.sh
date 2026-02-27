#!/usr/bin/env bash
set -euo pipefail

BUNDLE="couret-interia_rh-analytic-framework-t1t4-v1.0.0FINAL_bundle.zip"
ROOT="$(pwd)"

need() {
  local miss=0
  for f in "$@"; do
    [[ -e "$f" ]] && { echo "✅ : $f"; } || { echo "❌ Missing: $f"; miss=1; }
  done
  (( miss == 0 )) || exit 1
}

echo "▶️  Rebuild (best-effort)"
if command -v make >/dev/null 2>&1; then
  make build || true
fi

echo "▶️  Checking required artifacts…"
# tolérant sur audit (light) FR/EN
AUDIT_LC="audits/audit_lambda_couret_"
need \
  main_arxiv.pdf \
  src/main_journal.pdf \
  src/main_journal_FR.pdf \
  dist/arxiv_package.tar.gz \
  "${AUDIT_LC}EN.pdf" \
  "${AUDIT_LC}FR.pdf" \
  "${AUDIT_LC}light_EN.pdf" \
  "${AUDIT_LC}light_FR.pdf" \
  index.html \
  ABOUT_INTERIA.md \
  RELEASE_NOTES_TEMPLATE.md \
  CITATION.cff \
  LICENSE

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP"/{proof-article,dist}

echo "▶️  Assemble proof-article/"
rsync -a --delete \
  --exclude 'memo' --exclude '.git' --exclude '.github' \
  *.pdf *.tex *.bib *.cls \
  src audits docs README_hero*.md \
  "$TMP/proof-article/" 2>/dev/null || true

echo "▶️  Root files"
cp -a ABOUT_INTERIA.md CITATION.cff LICENSE "$TMP/"

# -- Générer release notes du template
echo "▶️  RELEASE_NOTES_v1.0.0"
TAG="v1.0.0"
TODAY="$(date -u +%Y-%m-%d)"
sed \
  -e "s/{{VERSION}}/${TAG}/g" \
  -e "s/{{DATE}}/${TODAY}/g" \
  RELEASE_NOTES_TEMPLATE.md > "$TMP/RELEASE_NOTES_${TAG}.md"

# -- Réécrire une version bundle-safe de index.html (liens -> proof-article/…)
echo "▶️  index.html (bundle-safe links)"
sed -E \
  -e 's@(src|href)="(src|docs|audits)/@\1="proof-article/\2/@g' \
  index.html > "$TMP/index.html"

echo "▶️  Sanity check (index.html local links)"
grep -Eno 'href="(!https?://|#|proof-article/|dist/)[^"]+"' "$TMP/index.html" || true
grep -Eno 'src="(!https?://|#|proof-article/)[^"]+"' "$TMP/index.html" || true

echo "▶️  Dist/"
cp -a dist/arxiv_package.tar.gz "$TMP/dist/"

echo "▶️  Manifest SHA256"
(
  cd "$TMP"
  tmplist="$(mktemp)"
  LC_ALL=C find . -type f ! -name 'MANIFEST_SHA256.txt' -print0 \
    | sort -z > "$tmplist"

  # Choix de l’outil hachage
  if command -v sha256sum >/dev/null 2>&1; then SUM=(sha256sum); COL=2
  else SUM=(shasum -a 256); COL=2; fi

  : > MANIFEST_SHA256.txt
  xargs -0 "${SUM[@]}" < "$tmplist" \
    | LC_ALL=C sort -k "$COL","$COL" > MANIFEST_SHA256.txt
  rm -f "$tmplist"
)

echo "▶️  Zip → $BUNDLE"
(
  cd "$TMP"
  zip -qr "../$BUNDLE" \
    proof-article dist \
    index.html ABOUT_INTERIA.md RELEASE_NOTES_v1.0.0.md CITATION.cff LICENSE \
    MANIFEST_SHA256.txt
)
mv "$TMP/../$BUNDLE" "$ROOT/$BUNDLE"
echo "✅ Done: $BUNDLE"
