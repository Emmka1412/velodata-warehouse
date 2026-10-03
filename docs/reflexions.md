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
