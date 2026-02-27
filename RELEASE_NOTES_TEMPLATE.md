> **“From analysis to clarity: a proof of the framework — not of Riemann, but of rigor itself.”**

# InterIA — Analytic Framework (T1′–T4) {{VERSION}}

**Date:** {{DATE}}

**Status:** Proof-only · journal-ready · arXiv-compatible

**arXiv:** upload `dist/arxiv_package.tar.gz` · **Zenodo:** full release (code + PDFs)

**DOI (Zenodo):** `10.5281/zenodo.18802769`

**License:** MIT © 2026 **Alexandre Couret** & **InterIA Collaborators**

## Highlights

- Complete analytic framework chain T1′→T4 (proof-only): Δ₃/Σ²/SFF alignment, FAIR bundle.
- Audits λ(Couret) FR/EN, dependency maps, guides, demos.

## Assets

- All-docs ZIP (curated PDFs)
- FINAL bundle (reproducible FAIR package + manifest)

---

## Overview (EN)

This release ships a **journal-ready LaTeX repository** implementing a complete
**analytic proof framework** (T1′–T4) for RH-related bounds:
T2 (weighted frame bound), T3 (wave-packet localization), and an appendix on
the explicit formula/archimedean control. It is **not** a resolution of RH.

**Honesty note:** we prove **bounds within a framework**, not RH.

### Contents

- **Mathematics:**
  **T1′** (Guinand–Weil, recalled),
  **T2** (Gershgorin/Schur + refined different-prime estimate),
  **T3** (wave-packet; explicit DCT; prime-side w/o square),
  **T4** (cross-positivity criterion),
  Appendix (IBP bound on the archimedean term).
- **Engineering:** LaTeX class `proofarticle.cls`,
  unified Makefile, CI (PDF builds),
  arXiv tarball maker, SHA-256 manifest.
- **Accessibility:** personas, dictionary, storyboard, micro-example (T2), FAQ,
  bilingual summaries; full dependency graph (TikZ→PNG).

---

## Aperçu (FR)

Cette version fournit un **dépôt LaTeX prêt-journal** pour un **cadre analytique**
(T1′–T4) et des **bornes démontrées** : T2 (borne de trame pondérée),
T3 (localisation par paquets d’ondes), avec une **annexe** (formule explicite /
contrôle archimédien).
**Note d’honnêteté :** il s’agit d’une **preuve du cadre et des bornes**,
pas d’une résolution de l’hypothèse de Riemann.

---

## Files shipped · Fichiers livrés

```text
main_arxiv.tex
src/main_journal.tex
src/main_journal_FR.tex
appendix/table_des_symboles_FR.tex
appendix/explicit_arch_full_FR.tex
(cls, bib, guides, audits, CI, Makefile, etc.)

dist/
arxiv_package.tar.gz
MANIFEST_SHA256.txt          # integrity manifest (optional)

Root docs:
ABOUT_INTERIA.md
RELEASE_NOTES_{{VERSION}}.md
```

---

## User notes · Note aux utilisateurs

### Verify integrity

#### GNU/LINUX

```sh
shasum -a 256 -c MANIFEST_SHA256.txt
```

#### MacOS

```sh
sha256sum -c MANIFEST_SHA256.txt
```

---

### 🔖 Citation (BibTeX)

If you use this repo, please cite the Zenodo DOI:

```bibtex
@misc{interia_t1t4_2026,
  author  = {{Alexandre Couret and InterIA Mathematical Collective}},
  title   = {A Modular Analytic Framework for the Riemann Hypothesis (T1′–T4)},
  year    = {2026},
  version = {1.0.0},
  doi     = {10.5281/zenodo.18802769},
  note    = {Proof-only analytic framework (T1′–T4): Guinand–Weil explicit, frame bound, wave-packet localization, cross-positivity.}
}
```

---

## Acknowledgments · Remerciements

With gratitude to **Bernard Couret**.
To all readers who value rigor and calm writing.

---

## About the Author / À propos de l’auteur

**Alexandre Couret — InterIA Mathematical Collective**
Bridging analytic structure and reproducible practice.
Relier structure analytique et pratiques reproductibles.

---
