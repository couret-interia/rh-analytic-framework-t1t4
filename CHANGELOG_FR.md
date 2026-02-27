# 📜 CHANGELOG — InterIA / Proof-Article / Cadre Analytique Modulaire pour l’Hypothèse de Riemann (T1′–T4)

> **Note d’honnêteté :** l’hypothèse de Riemann reste ouverte.
> Ce dépôt formalise le *cadre analytique* (T1′–T4) et les bornes démontrées ;
> il ne prétend **pas** prouver RH. \
> Version 1.0.0 — 2026-02-27
> *“Preuve-seule Cadre Analytique Modulaire pour l’Hypothèse de Riemann”*

- Première release publique (journaux EN/FR, guides, démos, audit λ(Couret)).
- Tarball arXiv prêt à l’emploi (`dist/arxiv_package.tar.gz`), métadonnées FAIR (CFF, Zenodo).
- Cibles Make : `all-pdf`, `zip-pdf`, `zip-final-bundle`, `arxiv`, `guide(beamer)`.

---

## 🚀 Ajouts

- **Chaîne de preuve analytique complète T1′–T4**  (formule explicite de Guinand–Weil → borne de trame pondérée → localisation par paquets d’ondes → positivité croisée).
- **`proofarticle.cls`** — classe LaTeX minimale avec macros PW/Ξ/poids et mise en forme journal.
- **Preuves détaillées (EN)** :
  - T2 : borne de Gershgorin/Schur, cas « different-prime » affiné.
  - T3 : lemme frame→intégrale, convergence dominée explicite, côté premiers sans carré.
  - Annexe : formule explicite de Guinand–Weil + borne archimédienne (IBP).
- **Kit d’accessibilité interdisciplinaire** : personas, dictionnaire, storyboard, ponts, micro-exemple, FAQ.
- **Guides Beamer & PDF** : mini diaporama + guide 2 pages.
- **CI GitHub Actions** : build LaTeX (journal, Beamer, guide) + upload des artefacts.
- **Tarball arXiv** : proof-only, classe allégée, manifest inclus (`MANIFEST_SHA256.txt`).
- **Métadonnées Zenodo (`zenodo.json`)** + **CITATION.cff**.

---

## 🧩 Changements / Améliorations

- Structure de la preuve refactorisée → `src/main_journal.tex` (lecture plus fluide).
- Ajout de `README_arxiv.md` (minimal pour arXiv) + README « hero » (badges, carte de dépendances).
- Arborescence simplifiée ; aucun sous-répertoire exotique dans le package arXiv.
- Ajout de la cible `make zip-pdf` (helper local : regroupe tous les PDF générés dans `dist/all_pdfs.zip`).
- Correction d’un avertissement `find` dans `scripts/make_arxiv.sh` (`-maxdepth` placé avant les tests).
- Ajout d’un générateur de manifest SHA-256 portable (`sha256sum` ↔ `shasum`).

---

## 🐛 Corrections

- Correction de la **somme côté premiers** dans T3 (`φ_T` non au carré).
- Harmonisation de la **notation** (Ξ_A, λ_min(G^(w)), Θ_w(A)).
- Suppression d’un terme redondant « weighted by w_α » dans T2.
- Amélioration de la borne archimédienne (DCT explicite).
- Résolution des soucis d’encodage (`\DeclareUnicodeCharacter{2032}{\prime}` dans la classe).
- Sanitation des entrées LaTeX pour arXiv (UTF-8 + packages standards uniquement).

---

## 🏗️ Dépôt / Build

- `make all-pdf` → génère tout (journal, audits λ, Beamer, démos FR/EN, guides).
- `make arxiv` → produit `dist/arxiv_package.tar.gz` + `MANIFEST_SHA256.txt`.
- `make zip-pdf` → helper local, regroupe tous les PDF générés dans `dist/all_pdfs.zip`.
- `make zip-final-bundle` → bundle FAIR complet (scripts, sources, manifest, index.html…).
- `make zenodo` → alias de `all-zip` (= `zip-pdf` + `zip-final-bundle`), pratique pour préparer une release Zenodo.

---

## 🔖 Meta

- **Licence :** MIT (© 2026 Alexandre Couret & InterIA Collaborators).
- **Catégorie arXiv :** `math.NT` (secondaire : `math.CA`).
- **Mots-clés Zenodo :** mathematics, number-theory, riemann-hypothesis, analytic-framework, explicit-formula, frame-theory, schur-test, gershgorin, wave-packets, random-matrix-theory, spectral-form-factor, latex, arxiv, zenodo, reproducibility.
- **Tag de release :** `v1.0.0`.
- **Devise de commit :** *« From analysis to clarity — proof of the framework, not of RH. »*
