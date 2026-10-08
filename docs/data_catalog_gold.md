# Catalogue de données — couche Gold

## gold.dim_customers

Une ligne par client (18 484). Fusion du CRM (source maître) et de l'ERP.

| Colonne | Type | Description |
| --- | --- | --- |
| customer_key | BIGINT | Clé de substitution, générée par l'entrepôt |
| customer_id | INT | Identifiant client du CRM |
| customer_number | VARCHAR | Code client métier (ex. AW00011000), clé de jointure avec l'ERP |
| first_name | VARCHAR | Prénom, sans espaces parasites |
| last_name | VARCHAR | Nom, sans espaces parasites |
| country | VARCHAR | Pays (ERP), normalisé ; n/a si inconnu |
| marital_status | VARCHAR | Single / Married / n/a |
| gender | VARCHAR | Female / Male / n/a. CRM prioritaire, ERP en repli |
| birthdate | DATE | Date de naissance (ERP) ; NULL si dans le futur |
| create_date | DATE | Date de création de la fiche dans le CRM |

## gold.dim_products

Une ligne par produit actuellement commercialisé (295), enrichi de sa catégorie (ERP).

| Colonne | Type | Description |
| --- | --- | --- |
| product_key | BIGINT | Clé de substitution, générée par l'entrepôt |
| product_id | INT | Identifiant technique de la version du produit dans le CRM |
| product_number | VARCHAR | Référence produit (ex. BK-R93R-62), clé de jointure avec les ventes |
| product_name | VARCHAR | Nom commercial du produit |
| category_id | VARCHAR | Code catégorie extrait de la clé produit (ex. BI_RB) |
| category | VARCHAR | Catégorie (ERP) : Bikes, Accessories, Clothing… |
| subcategory | VARCHAR | Sous-catégorie (ERP) : Road Bikes, Helmets… |
| maintenance | VARCHAR | Le produit nécessite-t-il un entretien ? (Yes / No) |
| cost | INT | Coût du produit ; 0 si inconnu |
| product_line | VARCHAR | Gamme : Road / Mountain / Touring / Other Sales / n/a |
| start_date | DATE | Date de début de validité de la version en cours |

## gold.fact_sales

Une ligne par produit vendu dans une commande (60 398 lignes, 27 659 commandes).

| Colonne | Type | Description |
| --- | --- | --- |
| order_number | VARCHAR | Numéro de commande (ex. SO43697) ; plusieurs lignes par commande |
| product_key | BIGINT | Clé vers dim_products |
| customer_key | BIGINT | Clé vers dim_customers |
| order_date | DATE | Date de commande ; NULL pour 19 ventes à date invalide |
| shipping_date | DATE | Date d'expédition |
| due_date | DATE | Date d'échéance |
| sales_amount | INT | Montant de la ligne ; recalculé si incohérent (= quantity × price) |
| quantity | INT | Quantité vendue |
| price | INT | Prix unitaire ; déduit du montant s'il manquait |
