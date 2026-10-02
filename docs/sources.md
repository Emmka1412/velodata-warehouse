# Inventaire des sources

## 1. Fichiers sources

| Système | Fichier | Lignes | Grain (une ligne = ...) | Clé candidate |
| --- | --- | --- | --- | --- |
| CRM | cust_info.csv | 18 494 | un client (fiche client) | `cst_id` (non unique : doublons à traiter) |
| CRM | prd_info.csv | 397 | une version d'un produit sur une période | `prd_id` |
| CRM | sales_details.csv | 60 398 | un produit dans une commande | `sls_ord_num` + `sls_prd_key` |
| ERP | CUST_AZ12.csv | 18 484 | un client (date de naissance, genre) | `CID` |
| ERP | LOC_A101.csv | 18 484 | un client (pays) | `CID` |
| ERP | PX_CAT_G1V2.csv | 37 | une sous-catégorie de produits | `ID` |

## 2. Règles d'intégration (clés)

| Relation | Côté A | Côté B | Transformation |
| --- | --- | --- | --- |
| Client CRM ↔ ERP démographie | `cst_key` = AW00011000 | `CID` = NASAW00011000 | Retirer le préfixe `NAS` du CID |
| Client CRM ↔ ERP localisation | `cst_key` = AW00011000 | `CID` = AW-00011000 | Supprimer le tiret `-` du CID |
| Produit CRM ↔ catégorie ERP | `prd_key` = BI-RB-BK-R93R-62 | `ID` = BI_RB | 5 premiers caractères de prd_key, `-` remplacé par `_` |
| Vente ↔ produit | `sls_prd_key` = BK-R93R-62 | `prd_key` = BI-RB-BK-R93R-62 | prd_key à partir du 7e caractère |
| Vente ↔ client | `sls_cust_id` = 21768 | `cst_id` = 21768 | Aucune (même format) |
