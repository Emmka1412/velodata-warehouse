# Rapport qualité — couche Bronze

Audit réalisé avec `sql/audit/bronze_profiling.sql`.

| # | Anomalie | Volume | Décision |
| --- | --- | --- | --- |
| A1 | Clients sans identifiant | 4 lignes | Écarter : un client sans identifiant ne peut être relié à rien |
| A2 | Clients en double | 5 identifiants | Garder la fiche la plus récente (`cst_create_date`) |
| A3 | Espaces parasites dans les noms | 29 lignes | Corriger avec `TRIM` |
| A4 | Genre et état civil codés (F/M, S/M) ou vides | 4 578 / 7 lignes vides | ??? |
| A5 | Coût produit manquant | 2 lignes | ??? |
| A6 | Date de fin antérieure à la date de début | 200 lignes | ??? |
| A7 | Date de commande invalide | 19 lignes | ??? |
| A8 | Montant ou prix incohérent | 35 lignes | ??? |
| A9 | Date de naissance dans le futur | 16 lignes | ??? |
| A10 | Genre ERP écrit de 8 façons | 8 variantes | ??? |
| A11 | Pays écrit de 12 façons (US, USA, DE…) | 12 variantes | ??? |
| A12 | Produits sans catégorie ERP | 7 produits | ??? |
