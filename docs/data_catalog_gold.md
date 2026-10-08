# Catalogue de données — couche Gold

## gold.dim_customers

Une ligne par client (18 484). Fusion du CRM (source maître) et de l'ERP.

| Colonne | Type | Description |
| --- | --- | --- |
| customer_key | BIGINT | Clé de substitution, générée par l'entrepôt |
| customer_id | INT | Identifiant client du CRM |
| customer_number | VARCHAR | Code client métier (ex. AW00011000) |
| first_name | VARCHAR | Prénom |
| last_name | VARCHAR | Nom |
| country | VARCHAR | Pays (ERP), normalisé ; n/a si inconnu |
| marital_status | VARCHAR | Single / Married / n/a |
| gender | VARCHAR | Female / Male / n/a. CRM prioritaire, ERP en repli |
| birthdate | DATE | Date de naissance (ERP) ; NULL si invalide |
| create_date | DATE | Date de création de la fiche dans le CRM |

## gold.dim_products

À compléter : une phrase de description, puis le tableau des 11 colonnes.

## gold.fact_sales

À compléter : une phrase de description, puis le tableau des 9 colonnes.
