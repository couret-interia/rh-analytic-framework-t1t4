# 📜 CHANGELOG — InterIA / Proof-Article / A Modular Analytic Framework for the Riemann Hypothesis (T1′–T4)

> **Honesty note:** RH remains open.
> This repository formalizes the *analytic framework* (T1′–T4) and
> the proved bounds; it does **not** claim to prove RH. \
> Version 1.0.0 — 2026-02-27
> *“Proof-only analytic framework for the Riemann Hypothesis”*

- First public release (journals EN/FR, guides, demos, λ-audit).
- arXiv-ready tarball (`dist/arxiv_package.tar.gz`), FAIR metadata (CFF, Zenodo).
- Make targets: `all-pdf`, `zip-pdf`, `zip-final-bundle`, `arxiv`, `guide(beamer)`.

---

## 🚀 Added

- **Full analytic proof chain T1′–T4** (Guinand–Weil explicit → Weighted Frame Bound → Wave-Packet Localization → Cross-Positivity).
- **`proofarticle.cls`** — minimal class with PW/Ξ/weights macros and journal layout.
- **Detailed proofs (EN)**:
  - T2: Gershgorin/Schur bound, refined different-prime case.
  - T3: frame→integral lemma, explicit dominated convergence, prime-side w/o square.
  - Appendix: Guinand–Weil explicit formula + Archimedean IBP bound.
- **Interdisciplinary accessibility kit:** personas, dictionary, storyboard, bridges, micro-example, FAQ.
- **Beamer & PDF guides:** short slide deck + 2-page guide.
- **CI GitHub Actions:** LaTeX build (journal, Beamer, guide) + artifacts upload.
- **arXiv-ready tarball:** proof-only, clean class, manifest included (`MANIFEST_SHA256.txt`).
- **Zenodo metadata (`zenodo.json`)** + **CITATION.cff**.

---

## 🧩 Changed / Improved

- Proof structure refactored → `src/main_journal.tex` (reader-friendly).
- Added `README_arxiv.md` (minimal for arXiv) + README hero (badges, dependency graph).
- Simplified file tree; no nested directories in arXiv package.
- Added `make zip-pdf` target (local helper: bundle all generated PDFs into `dist/all_pdfs.zip`).
- Fixed find-warning in `make_arxiv.sh` (`-maxdepth` before tests).
- Added portable SHA-256 manifest generator (`sha256sum` ↔ `shasum`).

---

## 🐛 Fixed

- Corrected **prime-side sum** in T3 (`φ_T` not squared).
- Fixed **notation consistency** (Ξ_A, λ_min(G^(w)), Θ_w(A)).
- Removed redundant “weighted by w_α” term in T2.
- Improved Archimedean bound (explicit DCT).
- Resolved character encoding issues (`\DeclareUnicodeCharacter{2032}{\prime}` in class).
- Sanitized all LaTeX inputs for arXiv (UTF-8 + standard packages only).

---

## 🏗️ Repository / Build

- `make all-pdf` → builds everything (journal, audits, Beamer, FR/EN demos, guides).
- `make arxiv` → builds `dist/arxiv_package.tar.gz` + `MANIFEST_SHA256.txt`.
- `make zip-final-bundle` → full FAIR bundle.
- `make zip-pdf` → local helper (bundle all generated PDFs in root of `dist/all_pdfs.zip`)
- `make zenodo` → `zip-pdf` + `zip-final-bundle` (`all-zip` alias).

---

## 🔖 Meta

- **License:** MIT (© 2026 Alexandre Couret & InterIA Collaborators).
- **arXiv category:** `math.NT` (secondary: `math.CA`).
- **Zenodo keywords:** mathematics, number-theory, riemann-hypothesis, frame-theory, schur-test, wave-packets, reproducibility.
- **Release tag:** `v1.0.0`.
- **Commit motto:** *“From analysis to clarity — proof of the framework, not of RH.”*
