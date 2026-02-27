<p align="right">
  <a href="https://github.com/couret-interia/community/discussions"><img alt="💬 Discussion" src="https://img.shields.io/badge/💬-Discussion-1e88e5?labelColor=0d47a1"></a>
  <sup> · </sup>
  <a href="https://github.com/couret-interia/rh-analytic-framework-t1t4/stargazers"><img alt="⭐" src="https://img.shields.io/github/stars/couret-interia/rh-analytic-framework-t1t4.svg?style=social"></a>
  <sup> · </sup>
  <a title="Readme hero" href="README_hero.md"><sup>✨🇬🇧</sup></a>
  <sup> · </sup>
  <a title="Readme" href="README_FR.md"><sup>🇫🇷</sup></a>
</p>

# 🧠 InterIA — *Article de Preuve v1.0.0*

## **Cadre Analytique Modulaire pour l’Hypothèse de Riemann (T1′–T4)**

**Date de publication :** 2026-02-27
**Statut :** 📚 *Preuve-seule · prêt-journal · compatible arXiv*

---

<p align="center">
  <img src="docs/explication-grand-format/latex/graphe_dependances_dark_FR.png" width="780" alt="Carte de dépendances T1′–T4">
</p>

<h3 align="center"><em>« De l’analyse à la clarté — preuve du cadre, non de RH. »</em></h3>

---

> 🧮 **Statut :** cadre analytique complet · reproductible · preuve-seule
> *(non-résolutif ; RH demeure ouverte)* \
> 🧾 **Entretien :** [Alexandre Couret](https://github.com/alexcour)
> , [Thomas Ingles](https://github.com/sudwebdesign)
> & le **Collectif Mathématique InterIA** \
> 🔗 **Organisation GitHub :** [couret-interia](https://github.com/couret-interia) \
> 💬 **Discussions (publiques) :** <https://github.com/couret-interia/community/discussions> \
> 📧 **Pour des échanges privés :** [utilisez notre formulaire sécurisé](https://couret-interia.fr/contact)

---

### 🪶 À propos de cette publication

Ce dépôt publie le *cadre analytique de preuve* (T1′–T4) développé par
le collectif InterIA, formalisant l’intuition arithmétique modulaire de
Bernard Couret dans un environnement LaTeX moderne et reproductible.

**Objectifs :**

- Préserver et documenter l’héritage mathématique de la famille Couret.
- Fournir une architecture analytique transparente et reproductible pour
  la recherche sur RH (Rieman Hypothesis).
- Offrir un matériel éducatif ouvert (FR + EN) reliant mathématiques, physique et calcul.

> « La famille Couret s’est employée à faire revivre les travaux de Papi Couret
  — que Papa Couret avait gardés sur le coin de son bureau. »

---

### 🔧 Contenu analytique (T1′–T4)

Ce projet décrit un cadre analytique modulaire autour de quatre blocs :

- **T1′ — Reformulation explicite.**
  Mise en forme de la formule explicite de Guinand–Weil dans un cadre compatible
  avec les méthodes de cadres (frames) et de transformées discrètes.

- **T2 — Borne de frame pondérée.**
  Encadrement spectral par Gershgorin/Schur, avec raffinement *different-prime*.

- **T3 — Localisation par paquets d’ondes.**
  Construction d’un paquet d’ondes adapté à la structure spectrale et
  à la partie archimédienne, avec DCT explicite et contrôle des termes carrés.

- **T4 — Positivité croisée (framework).**
  Bloc conceptuel visant à coupler les bornes de frame et
  la localisation en un schéma de positivité croisée.
  *Dans cette version, T4 est formulé comme partie du cadre global ;
  les preuves complètes associées ne sont pas incluses dans le tarball arXiv v1
  (preuve-seule = T2, T3, appendices).*

---

### 🧰 Reproductibilité & CI

Le dépôt est structuré pour être **reproductible** :

- LaTeX modulaire (`proofarticle.cls`, `theorems/`, `appendix/`, `docs/`).
- CI GitHub pour vérifier que la compilation passe (build LaTeX).
- Scope épistémologique explicitement déclaré :
  *cadre de preuve* pour RH, sans revendication de résolution.

---

### 🔖 Référence (BibTeX)

Lorsque vous utiliser ce dépôt, veuillez S.V.P. citer le DOI de Zenodo :

```bibtex
@misc{interia_t1t4_2026_fr,
  author  = {{Alexandre Couret and InterIA Mathematical Collective}},
  title   = {A Modular Analytic Framework for the Riemann Hypothesis (T1′–T4)},
  year    = {2026},
  version = {1.0.0},
  doi     = {10.5281/zenodo.18802769},
  note    = {Cadre analytique de preuve (T1′–T4) : formule explicite de Guinand–Weil, encadrement spectral, localisation par paquet d’ondes, positivité croisée.}
}
```

---

### 📚 Explorer la *Proof Gallery*

La vue la plus à jour des PDF
(journaux, preuves détaillées, audits λ, cartes de dépendances)
est centralisée sur la page :

[🖼️ Proof Gallery](https://couret-interia.github.io/rh-analytic-framework-t1t4/#gallery)

Vous y trouverez notamment :

- les PDF de présentation T1′–T4 (FR/EN),
- les journaux de preuve pour T2/T3,
- les schémas de dépendances et vues “grand format”.

---

### 🤝 Contact InterIA

- 💬 **Discussions publiques :** [https://github.com/couret-interia/community/discussions](https://github.com/couret-interia/community/discussions)
- 🧾 **À propos du collectif :** voir [`ABOUT_INTERIA.md`](./ABOUT_INTERIA.md) (FR/EN).

Pour un échange plus ciblé (relecture, collaboration, cours),
ouvrez une discussion GitHub ou contactez directement les mainteneurs
via l’organisation **couret-interia**.

---

<p align="center">
  <a href="https://doi.org/10.5281/zenodo.18802769"><img src="https://img.shields.io/badge/DOI-10.5281%2Fzenodo.18802769-blue.svg" alt="Zenodo DOI"></a>
  <a href="https://github.com/couret-interia/rh-analytic-framework-t1t4/actions/workflows/latex.yml"><img src="https://img.shields.io/github/actions/workflow/status/couret-interia/rh-analytic-framework-t1t4/latex.yml?branch=main&label=CI%20build&logo=github" alt="CI build"></a>
  <img src="https://img.shields.io/badge/licence-MIT-yellow.svg" alt="MIT">
  <img src="https://img.shields.io/badge/version-1.0.0-green.svg" alt="v1.0.0">
</p>
