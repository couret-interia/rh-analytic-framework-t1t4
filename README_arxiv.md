# A Modular Analytic Framework for the Riemann Hypothesis — Proof-only package (T2, T3, Appendix)

**InterIA Mathematical Collective.**

**Date:** 2026-02-27

**Status.** Proof-only LaTeX source;
this arXiv package ships fully detailed proofs for:

- **T2** — weighted frame bound (spectral Gershgorin/Schur, different-prime refinement),
- **T3** — wave–packet localization (DCT, control of square terms),
- **Appendix** — explicit formula and technical background.

The global framework is formulated in four blocks (T1′–T4), but this arXiv v1 bundle
only includes full proofs for T2, T3, and the appendix. No claim is made here
about a complete proof of RH, nor about a fully proved T4 block.

**Claim.** RH remains open. This package provides the analytic framework and proved bounds; it does not claim a resolution of RH.

## Contents (proof-only)

- `main_arxiv.tex` (entry file)
- `proofarticle.cls` (journal-ready class; macros included)
- `theorems/T2_weighted_frame_full.tex`
- `theorems/T3_wavepacket_full.tex`
- `appendix/explicit_arch_full.tex`
- `refs.bib`
- `MANIFEST_SHA256.txt` (integrity, optional)

## Build (arXiv-compatible)

We target TeX Live (arXiv) with pdfLaTeX (no images needed).

```bash
pdflatex -halt-on-error -interaction=nonstopmode main_arxiv.tex
bibtex   main_arxiv
pdflatex -halt-on-error -interaction=nonstopmode main_arxiv.tex
pdflatex -halt-on-error -interaction=nonstopmode main_arxiv.tex
````

## Notes

- The class `proofarticle.cls` bundles only standard packages used by arXiv.
- No shell-escape; no external graphics required for the proof-only build.
- Encoding is UTF-8; T1 font encoding is set in the class.

## License

MIT (see `LICENSE`).
