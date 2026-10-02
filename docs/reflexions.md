# Questions de réflexion

## Partie 1

**Pourquoi conserver une couche Bronze brute ?**
Bronze conserve une copie brute et fidèle des sources. Si une règle de nettoyage est fausse, on la corrige et on rejoue Silver depuis Bronze, sans ré-extraire les systèmes sources. En cas de doute sur un chiffre, on peut remonter à la donnée d'origine (traçabilité).

**Pourquoi 18 494 clients CRM contre 18 484 dans l'ERP ?**
Le CRM contient 10 lignes en trop : 6 lignes en double (5 clients concernés) et 4 lignes sans identifiant. Après dédoublonnage (fiche la plus récente conservée) et suppression des lignes sans identifiant, on obtient 18 484 clients.
