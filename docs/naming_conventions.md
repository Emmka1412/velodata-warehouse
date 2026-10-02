# Conventions de nommage

| Règle | Format | Exemple |
| --- | --- | --- |
| Casse et langue | `snake_case`, anglais | `customer_key`, `order_date` |
| Tables Bronze et Silver | `<système>_<table_source>` | `bronze.crm_cust_info`, `silver.erp_loc_a101` |
| Dimensions Gold | `dim_<entité>` (pluriel) | `gold.dim_customers` |
| Faits Gold | `fact_<processus>` | `gold.fact_sales` |
| Clés de substitution | `<entité>_key` | `customer_key`, `product_key` |
| Colonnes techniques | préfixe `dwh_` | `dwh_create_date` |
| Procédures | `<couche>.load_<couche>()` | `bronze.load_bronze()` |
