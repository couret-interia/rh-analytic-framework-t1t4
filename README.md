# T1′–T4 historical archive

> **WITHDRAWN AS PROOF — 2026-10-13.** The historical T1′–T4 argument is invalid as a proof of the Riemann hypothesis. T2 omits nonzero Gram-matrix diagonal terms; T3 asserts an incompatible wave-packet normalization. [Erratum](https://github.com/alexcour/couret-finite-verifications/blob/5bfca060ce3a4ed5687bd80d0cccab73767074b3/ERRATUM_RH_T1T4_2026-10-13.md).

## Current scientific status

The register below records each status and its evidence. Each statement retains its own verification scope.

- [CURRENT_STATUS.md](CURRENT_STATUS.md)
- [governance/claims.json](governance/claims.json)
- [Local erratum copy](governance/evidence/ERRATUM_RH_T1T4_2026-10-13.md)
- [F-001](F001_ERRATUM.md)

## Historical documents

Earlier texts remain available at their historical commit. Their titles and conclusions record the earlier state and must be read with this withdrawal.

- [Archive v1.0.0](https://github.com/couret-interia/rh-analytic-framework-t1t4/tree/2ce7cca9b79c537a1893ee316ccf5c7be6af8912)
- [Copies avec notice / Copies with notices](HISTORICAL_DOCUMENTS.md)
- [DOI historique / Historical DOI](https://doi.org/10.5281/zenodo.18802769)
- [Galerie historique / Historical gallery](https://couret-interia.github.io/rh-analytic-framework-t1t4/#gallery)

## Reproduction

```bash
python3 scripts/status_manifest.py --check
python3 -m unittest discover -s tests -v
```

These commands check documentary consistency and source digests. They do not constitute mathematical review or an audit of prior art.

[English](README.md) · [Français](README_FR.md) · [Maintenance](governance/README.md)
