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

## Partie 4

**Pourquoi 'n/a' plutôt que NULL pour les valeurs inconnues ?**
Pour les attributs textuels, NULL se comporte de façon imprévisible (comparaisons, filtres, jointures) et est mal géré par les outils de reporting. 'n/a' est explicite, regroupable et lisible, et évite de perdre des lignes dans les analyses. Pour les dates et montants inconnus, on conserve NULL.

**Quel type de dimension crée le recalcul de prd_end_dt ?**
Une dimension à variation lente de type 2 (SCD 2) : chaque changement crée une nouvelle ligne, avec une date de début et une date de fin de validité. La version en cours a une fin NULL. On peut ainsi retrouver le prix en vigueur à n'importe quelle date.

**Montant et prix tous deux manquants : que se passe-t-il ?**
Une équation à deux inconnues : la valeur est irrécupérable, et la procédure produit deux NULL. Ce cas n'existe pas dans les données, mais le contrôle A8 le détecterait. Un pipeline ne doit jamais laisser passer silencieusement une donnée qu'il n'a pas su corriger.

## Partie 5

**Pourquoi une clé de substitution alors que customer_id existe ?**
Elle rend l'entrepôt indépendant des sources : si le CRM change de format, ou si une fusion apporte des identifiants en double, les jointures restent valides. Elle permet aussi d'historiser une dimension en SCD 2 (plusieurs versions d'un même client), et les jointures sur un entier sont plus rapides.

**Qui valide la règle « CRM source maître » pour les 57 conflits de genre ?**
Le métier, pas le data engineer : le responsable des données clients (data owner). J'ai appliqué une règle par défaut pour ne pas bloquer le projet, en la documentant comme point à valider.

**Vue, table ou vue matérialisée pour la couche Gold ?**
Une vue est toujours à jour mais recalculée à chaque lecture ; une table ou une vue matérialisée est rapide et indexable, mais figée jusqu'au rechargement. Les données d'un entrepôt ne changeant qu'au chargement, une vue matérialisée rafraîchie en fin de pipeline cumule fraîcheur et vitesse. Ici, le faible volume justifie de simples vues.

**Que deviennent les ventes de produits retirés ?**
Le filtre sur les produits actuels n'élimine que les anciennes versions : aucune vente n'est perdue. Un produit réellement retiré laisserait ses ventes sans produit (grâce au LEFT JOIN, elles ne disparaissent pas), et le contrôle d'orphelins échouerait. Amélioration possible : garder toutes les versions et joindre chaque vente à la version valide à sa date de commande.
