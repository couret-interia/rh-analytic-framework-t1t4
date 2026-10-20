# Erratum scientifique public — T1′–T4 (13 octobre 2026)

**Statut : chaîne de démonstration invalidée / withdrawn as a proof argument.**
**Objet : archive historique** du dépôt [`couret-interia/rh-analytic-framework-t1t4`](https://github.com/couret-interia/rh-analytic-framework-t1t4). Ce document n'établit **aucun** résultat nouveau sur l'hypothèse de Riemann et ne prétend pas remplacer une relecture indépendante.

## Conclusion explicite

La chaîne T1′–T4 publiée en février 2026 **ne démontre pas** l'hypothèse de Riemann. Ce n'est pas simplement une preuve « en attente de vérification » : au moins deux de ses passages centraux contiennent des erreurs vérifiables dans les sources mathématiques. Les expressions historiques *complete proof framework*, *Proof-Article*, *journal-ready*, *fully detailed proofs* (pour T2/T3) et les intitulés de PDF de type *démonstration finale de RH* ne décrivent **pas** le statut scientifique actuel et doivent être retirés des présentations actives ou accompagnés d'un avertissement immédiatement visible.

Les documents d'époque doivent demeurer accessibles, clairement signalés **RETRACTED AS PROOF / ARCHIVE HISTORIQUE — ARGUMENT INVALIDÉ**, pour conserver la traçabilité des erreurs. L'archive et ses identifiants pérennes ne sont pas effacés ni réécrits rétroactivement.

## 1. T2 : borne inférieure de la matrice de Gram non démontrée et argument faux

Source : [`theorems/T2_weighted_frame_full.tex`](https://github.com/couret-interia/rh-analytic-framework-t1t4/blob/main/theorems/T2_weighted_frame_full.tex).

Le texte pose
```text
G[a,b] = sqrt(w[a]) * phi_hat(xi[a]-xi[b]) * sqrt(w[b]),
w[p,k] = (log p)/p^(k/2),  phi_hat(0) = 1.
```

Il s'ensuit **exactement** que `G[a,a] = w[a]`, et **non** `1`. Pour toute matrice hermitienne G, le quotient de Rayleigh impose `lambda_min(G) <= min_a w[a]`. En particulier, l'ensemble croissant des puissances premières contient des poids tendant vers zéro.

La preuve publiée écrit `R = G-I` puis majore `||R||` par les seules sommes des coefficients **hors diagonale**. Or les éléments diagonaux de `R` valent `w[a]-1`, et ne peuvent être omis. La conclusion `lambda_min(G) >= 1-Theta_w(A)`, avec `Theta_w(A)` défini par ces seules sommes hors diagonale, ne résulte pas du test de Schur ou de Gershgorin.

**Contre-exemple direct à cette borne telle qu'écrite.** Pour chaque A fixé contenant la fréquence `log 2`, les fréquences `xi[p,k]` de l'ensemble fini `Xi_A` sont distinctes. Choisir une fonction paire lisse `phi_hat` qui vaut 1 en 0 et est supportée dans un voisinage de 0 plus petit que leur séparation minimale annule tous les termes hors diagonale. Donc `Theta_w(A)=0` tandis que
```text
lambda_min(G) <= w[2,1] = (log 2)/sqrt(2) < 1.
```
L'inégalité annoncée donnerait `lambda_min(G) >= 1` : contradiction. Le choix du support peut être rendu assez petit pour respecter `supp phi_hat subset [-A,A]`.

**Décision :** le « théorème T2 » et sa démonstration ne sont pas des résultats acquis sous leur formulation publiée.

## 2. T3 : normalisation incompatible avec le paquet construit

Source : [`theorems/T3_wavepacket_full.tex`](https://github.com/couret-interia/rh-analytic-framework-t1t4/blob/main/theorems/T3_wavepacket_full.tex).

Le fichier définit, pour un `b` fixé à support compact et `gamma_0>0`,
```text
phi_hat_T(gamma) = (1/2) * [b(sqrt(T)*(gamma-gamma_0)) +
                              b(sqrt(T)*(gamma+gamma_0))].
```

Pour T assez grand les deux bosses ont des supports disjoints, donc
```text
integral_R |phi_hat_T(gamma)|^2 dgamma
    = (1/(2*sqrt(T))) * integral_R |b(u)|^2 du
    -> 0.
```

À convention de Fourier fixe, Plancherel implique également `||phi_T||_2 -> 0`. La même construction affirme pourtant `||phi_T||_2=1`, et le lemme « frame-to-integral » annonce une intégrale égale à 1. Ces assertions ne peuvent pas être vraies ensemble.

De plus, à A fixé, `Xi_A` est **fini** : une somme sur ses points ne devient pas, sans argument supplémentaire, l'intégrale continue annoncée lorsque T tend vers l'infini. La « capture » qui soutient la contradiction n'est donc pas établie. L'utilisation de la formule explicite pour un zéro `beta+i*gamma` hors de la droite critique doit aussi être reconstruite avec les conventions de test correctes ; la formule rédigée uniquement en ordonnées ne suffit pas telle quelle.

**Décision :** ni le lemme de localisation ni la contradiction finale ne prouvent RH.

## 3. Portée et statut des autres dossiers

Cet erratum invalide **la chaîne T1′–T4 comme preuve**, sans transformer automatiquement en faux les calculs finis d'autres dépôts. Ces autres résultats exigent séparément : (E) vérification de la preuve, (Q) reproductibilité, (N) comparaison aux antériorités, (R) relecture indépendante. Une CI verte ou un DOI ne valident ni E ni N ni R.

Le retrait historique `lambda ≈ 0,378` est documenté séparément dans [F-001](F001_ERRATUM.md) ; la fréquence asymptotique classique des classes `{1,11,29}` modulo 30 parmi les huit classes inversibles est `3/8`, par Dirichlet.

## 4. Corrections publiques encore nécessaires

- [ ] Modifier la page d'accueil, les README EN/FR et « hero » du dépôt d'origine : afficher le retrait en tête **sans** conserver de statut promotionnel incompatible.
- [ ] Remplacer les titres, abstracts et couvertures dans les sources LaTeX actives ; reconstruire les PDF rendus publics avec un avertissement inséparable, sans faire disparaître les versions historiques.
- [ ] Rebaptiser ou contextualiser « Proof Gallery » sur GitHub Pages et corriger les pages du site `couret-interia.fr`.
- [ ] Déposer une notice de correction/metadata sur Zenodo (et HAL si applicable) après vérification des notices directement sur ces plateformes, tout en conservant les identifiants historiques.
- [ ] Inventorier toutes les URL restant susceptibles de faire croire à une démonstration de RH ; vérifier chaque correction publiée.

Ces tâches **ne sont pas déclarées exécutées** par la seule publication de cet erratum. La mise à jour du dépôt d'origine nécessite un compte GitHub doté des droits d'écriture.

## Source et méthode

Vérification mathématique par inspection directe des fichiers `T2_weighted_frame_full.tex`, `T3_wavepacket_full.tex` et `appendix/explicit_arch_full.tex` sur la branche principale du dépôt historique, 13 octobre 2026. Les contre-calculs numériques rapportés dans un audit externe ne sont **pas** revendiqués comme reproduits dans cet erratum.

---

**English summary.** The historical T1′–T4 argument does **not** prove the Riemann hypothesis. In T2, the Gram matrix diagonal is `w[a]`, not 1; the alleged Schur bound drops nonzero diagonal terms, and a narrow Fourier bump gives a direct counterexample to the stated inequality. In T3, the displayed wave-packet has squared Fourier norm `||b||²/(2 sqrt(T)) -> 0`, contradicting the asserted unit normalization; the finite-to-continuum capture lemma is unproved. The original materials should be preserved with prominent withdrawn-proof notices, and all active public-facing claims corrected. This note does not claim an independently refereed result.
