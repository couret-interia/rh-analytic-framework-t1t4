# F-001 — retrait d’une ancienne observation empirique (9 octobre 2026)

L'ancienne affirmation selon laquelle la proportion des premiers dans les classes
`{1,11,29}` modulo 30 serait mesurée autour de `0,378` est réfutée. Elle ne doit
plus être citée comme mesure, validation numérique ou résultat scientifique acquis.

Selon le [rapport correctif du 7 octobre 2026](https://docs.google.com/document/d/1A9TT9PYQLyBzGG-99TydmA6v0PZL1pLRU6FAWxM9Lzc/edit),
la proportion recalculée à `x = 10^9` vaut `0,3749982` (valeur arrondie).
Le [Journal F, entrée F-001](https://docs.google.com/document/d/1Cln8aCg1p76nkk54Ng7Yj6IeRMiYVNl14DeAAeBvJIE/edit)
retire explicitement les anciennes tables donnant environ `0,378` comme mesure.
Ces sources restent soumises à leurs propres droits d'accès.

## Observable et portée

On considère les huit classes inversibles modulo 30. Pour
`S = {1,11,29}`, le rapport emploie la proportion

`F(x) = (pi(x;30,1) + pi(x;30,11) + pi(x;30,29)) / (pi(x)-3)`

aux bornes où les premiers 2, 3 et 5 sont exclus. La référence asymptotique
classique est `3/8 = 0,375`. La constante géométrique
`1/sqrt(7) = 0,377964473...` est un autre objet : son existence ne constitue
pas une mesure de cette proportion.

Ce fichier rapporte une correction déjà établie par les sources ci-dessus.
Il ne présente pas une nouvelle exécution du crible à `10^9`.
Le `D(X)` défini dans [05-chebyshev-mod30](05-chebyshev-mod30/README.md)
compare six classes non carrées à deux classes carrées : c'est encore
un autre observable, dont les contrôles finis ne valident pas l'ancien F.

## Archives et reproductibilité

Les anciennes tables peuvent être conservées pour documenter l'histoire du
programme, à condition de porter un avertissement explicite renvoyant à F-001.
Les versions archivées et les DOI antérieurs ne sont pas réécrits par cet ajout.
Une CI réussie vérifie uniquement les assertions exécutées à ses bornes ;
elle ne transforme pas cette correction documentaire en avancée mathématique.
