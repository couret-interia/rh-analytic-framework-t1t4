<p align="right">
  <a href="https://github.com/couret-interia/community/discussions"><img alt="💬 Discussion" src="https://img.shields.io/badge/💬-Discussion-1e88e5?labelColor=0d47a1"></a>
  <sup> · </sup>
  <a href="https://github.com/couret-interia/rh-analytic-framework-t1t4/stargazers"><img alt="⭐" src="https://img.shields.io/github/stars/couret-interia/rh-analytic-framework-t1t4.svg?style=social"></a>
  <sup> · </sup>
  <a title="Readme hero" href="README_hero.md"><sup>✨</sup></a>
  <sup> · </sup>
  <a title="Readme" href="README_FR.md"><sup>🇫🇷</sup></a>
</p>

# 🧠 InterIA — *Proof-Article v1.0.0*

## A Modular Analytic Framework for the Riemann Hypothesis (T1′–T4)

*InterIA Mathematical Collective – Couret – Unification Series, Vol. 1.*

**Release date:** 2026-02-27
**Status:** 📚 *Proof-only · journal-ready · arXiv-compatible*

---

<p align="center">
  <img src="docs/explication-grand-format/latex/graphe_dependances_dark.png" alt="T1′→T4 dependency map" width="820">
</p>

<p align="center">
  <a href="https://github.com/couret-interia/rh-analytic-framework-t1t4/releases"><img alt="GitHub release (latest SemVer)" src="https://img.shields.io/github/v/release/couret-interia/rh-analytic-framework-t1t4?display_name=release&label=Release&color=0A84FF"></a>
  <a href="https://github.com/couret-interia/rh-analytic-framework-t1t4/actions/workflows/latex.yml"><img alt="build-pdf status" src="https://img.shields.io/github/actions/workflow/status/couret-interia/rh-analytic-framework-t1t4/latex.yml?label=build-pdf&color=12B886"></a>
  <a href="https://github.com/couret-interia/rh-analytic-framework-t1t4/actions/workflows/build-and-package.yml"><img src="https://img.shields.io/github/actions/workflow/status/couret-interia/rh-analytic-framework-t1t4/build-and-package.yml?branch=main&label=CI%20build&logo=github" alt="CI build"></a>
  <a href="https://doi.org/10.5281/zenodo.18802769"><img src="https://img.shields.io/badge/DOI-10.5281%2Fzenodo.18802769-blue.svg" alt="Zenodo DOI"></a>
  <img src="https://img.shields.io/badge/license-MIT-yellow.svg" alt="MIT">
  <img src="https://img.shields.io/badge/version-1.0.0-green.svg" alt="v1.0.0">
</p>

---

### 🧾 Overview

This repository provides a **journal‑ready LaTeX implementation** of
a complete **analytic proof framework** for the Riemann Hypothesis *(T1′–T4)*:
detailed proofs, build tools, guides, and accessibility material.

> ⚠️ **Honesty note** — RH remains open. This repository formalizes
the *analytic framework* (T1′–T4) and the **proved bounds**;
it does **not** claim to prove RH.

---

### 📘 Contents

**Mathematical components:**

- **T1′** — *Guinand–Weil explicit formula* (precise recall)
- **T2** — *Weighted frame bound* (Gershgorin/Schur + refined different‑prime bound)
- **T3** — *Wave‑packet localization* (frame→integral lemma, DCT, prime‑side without squares)
- **T4** — *Cross‑positivity criterion* (Hilbert–Pólya‑compatible reading)
- **Appendix** — *Archimedean term control (IBP)*

**Interdisciplinary accessibility:**

- Personas, cross‑dictionary, storyboard, bridges, micro‑example, FAQ
- PDF & Beamer guides (see `make guide-pdf`, `make guide-beamer`)
- Full dependency graph (TikZ → PNG)

**Build & reproducibility:**

- `proofarticle.cls` — clean minimal class with macros (`\PW`, `\Xi_A`, `\Cfrw`, `\Thetaw`)
- `Makefile` — unified targets (`journal`, `guide`, `beamer`, `arxiv`, `zip-pdf`)
- `dist/arxiv_package.tar.gz` — proof‑only tarball (for arXiv)
- *Optional* `MANIFEST_SHA256.txt` — integrity manifest
- CI via GitHub Actions (LaTeX build + artifact upload)
- CI Release contains only:

  - `All-docs-Riemann-Hypothesis-T1p-T4_interIA-${TAG}.zip` (curated docs),
  - `couret-interia_rh-analytic-framework-t1t4-${TAG}_FINAL_bundle.zip` (full FAIR bundle).

---

### 🧮 Commands

```bash
make all-pdf        # build everything (journal, audits, demos, guides, Beamer)
make journal-pdf    # compile src/main_journal.tex
make guide-beamer   # create short slide deck
make arxiv          # produce dist/arxiv_package.tar.gz for arXiv upload
make zip-pdf        # local helper: bundle all PDFs into dist/all_pdfs.zip (no graphs)
make zenodo         # zip-pdf + zip-final-bundle (all-zip alias)
```

<details>

<summary>

### 🖼️ InterIA Banner

</summary>

To enable the blue–white on the first page

**Quick Compilation:**

 ```bash
make journal-pdf-banner
# or (🇫🇷):
make journal-pdf-fr-banner
```

</details>

**arXiv submission:** upload only `dist/arxiv_package.tar.gz` (proof‑only).
**Zenodo:** upload the full release (repo + PDFs).

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

### 🧩 Version summary

- **Tag:** `v1.0.0`
- **Date:** 2026-02-27
- **License:** MIT (© 2026 Alexandre Couret & InterIA Collaborators)
- **DOI:** `10.5281/zenodo.18802769`
- **Keywords:** mathematics,number-theory,riemann-hypothesis,analytic-framework,random-matrix-theory,spectral-form-factor,frame-theory,schur-test,gershgorin,wave-packets,reproducibility,arxiv,zenodo,explicit-formula,latex

---

### 👤 About the Author / InterIA Collective

See `appendix/about_author.tex` for a short section to include near the end of
the article (before the bibliography).

---

### 🤝 Contact · Collaborations · Feedback

- 💬 **Discussions (public):** <https://github.com/couret-interia/community/discussions>
- 🐞 **Issues:** <https://github.com/couret-interia/rh-analytic-framework-t1t4/issues/new/choose>
- 🧾 Zenodo (DOI) : 10.5281/zenodo.18802769
- 👥 **Organisation:** <https://github.com/couret-interia>

> For private exchanges, [use our lightweight form to reach the maintainers](https://couret-interia.fr/contact).

---

<p align="center">
  <a href="https://doi.org/10.5281/zenodo.18802769"><img src="https://img.shields.io/badge/DOI-10.5281%2Fzenodo.18802769-blue.svg" alt="Zenodo DOI"></a>
  <a href="https://github.com/couret-interia/rh-analytic-framework-t1t4/actions/workflows/latex.yml"><img src="https://img.shields.io/github/actions/workflow/status/couret-interia/rh-analytic-framework-t1t4/latex.yml?branch=main&label=CI%20build&logo=github" alt="CI build"></a>
  <img src="https://img.shields.io/badge/licence-MIT-yellow.svg" alt="MIT">
  <img src="https://img.shields.io/badge/version-1.0.0-green.svg" alt="v1.0.0">
</p>
