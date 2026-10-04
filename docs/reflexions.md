# Questions de réflexion

## Partie 1

**Pourquoi conserver une couche Bronze brute ?**
Bronze conserve une copie brute et fidèle des sources. Si une règle de nettoyage est fausse, on la corrige et on rejoue Silver depuis Bronze, sans ré-extraire les systèmes sources. En cas de doute sur un chiffre, on peut remonter à la donnée d'origine (traçabilité).

**Pourquoi 18 494 clients CRM contre 18 484 dans l'ERP ?**
Le CRM contient 10 lignes en trop : 6 lignes en double (5 clients concernés) et 4 lignes sans identifiant. Après dédoublonnage (fiche la plus récente conservée) et suppression des lignes sans identifiant, on obtient 18 484 clients.

**Pourquoi retirer le préfixe NAS avant de relier les fichiers clients ?**
Une jointure exige des clés strictement identiques. L'ERP préfixe l'identifiant client par NAS : sans retirer ce préfixe, aucun client ne se relie, et on perd silencieusement les données démographiques.

## Partie 2

**Full load : avantages et limites ?**
Le full load vide puis recharge toute la table : simple, toujours cohérent avec la source, sans suivi des changements. Sur de très gros volumes, le temps de chargement devient trop long : on passe alors à un chargement incrémental.

**Pourquoi typer le Bronze en TEXT ?**
COPY est tout ou rien : une seule valeur incompatible fait échouer tout le chargement. En TEXT, on accepte tout et on reporte le contrôle des types en Silver. Dans ce projet, les sources étant stables, on a choisi des types précis dès le Bronze.

**Pourquoi clock_timestamp() et pas now() ?**
now() est figé au début de la transaction : début et fin auraient la même valeur, et chaque durée vaudrait 0. clock_timestamp() renvoie l'heure réelle à chaque appel.

**Différence entre %I et %L dans format() ?**
%I insère un identifiant (nom de table), %L un littéral (chaîne, chemin). Les deux échappent la valeur, ce qui protège des injections SQL, contrairement à une concaténation avec ||.

**Pourquoi TRUNCATE avant le chargement ?**
Sans TRUNCATE, chaque exécution dupliquerait les données. Vider la table rend le chargement idempotent : on peut le relancer sans changer le résultat.

## Partie 3

**Date de naissance future : supprimer le client ou la date ?**
Seulement la date (mise à NULL). Supprimer le client ferait disparaître ses achats, son pays et son genre de toutes les analyses, pour une seule valeur fausse.

**17 clients nés avant 1925 : anomalie ou réalité ?**
Improbable, pas impossible : je ne corrige pas moi-même. Je conserve les données et je signale les cas au métier, qui peut vérifier.

**Pourquoi garder les ventes sans date de commande ?**
Supprimer ces 19 ventes sous-estimerait silencieusement le chiffre d'affaires. Elles comptent dans le total, mais n'apparaissent dans aucune période.

**Correction d'un montant incohérent ?**
Quantité 2, prix 50, montant -100 : le montant est invalide, on le recalcule à 2 × 50 = 100. Deux valeurs fiables suffisent à retrouver la troisième.

**Recalcul des dates de fin de produit ?**
Fin d'une version = début de la version suivante - 1 jour, calculé avec LEAD(). Versions 2011, 2012, 2013 : fins au 30/06/2012, 30/06/2013 et NULL (version en cours).
