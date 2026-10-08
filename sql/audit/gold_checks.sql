-- =========================================================
-- Contrôles de la couche Gold : chaque ligne doit afficher OK
-- =========================================================
SELECT 'dim_customers : 18 484 clients' AS controle,
       CASE WHEN COUNT(*) = 18484 THEN 'OK' ELSE 'KO' END AS resultat FROM gold.dim_customers
UNION ALL
SELECT 'dim_customers : customer_key unique',
       CASE WHEN COUNT(DISTINCT customer_key) = COUNT(*) THEN 'OK' ELSE 'KO' END FROM gold.dim_customers
UNION ALL
SELECT 'dim_customers : 15 genres restés n/a après fusion',
       CASE WHEN COUNT(*) = 15 THEN 'OK' ELSE 'KO' END FROM gold.dim_customers WHERE gender = 'n/a'
UNION ALL
SELECT 'dim_customers : tous les clients ont un pays',
       CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'KO' END FROM gold.dim_customers WHERE country IS NULL
UNION ALL
SELECT 'dim_products : 295 produits actuels',
       CASE WHEN COUNT(*) = 295 THEN 'OK' ELSE 'KO' END FROM gold.dim_products
UNION ALL
SELECT 'dim_products : product_number unique',
       CASE WHEN COUNT(DISTINCT product_number) = COUNT(*) THEN 'OK' ELSE 'KO' END FROM gold.dim_products
UNION ALL
SELECT 'fact_sales : 60 398 lignes de vente',
       CASE WHEN COUNT(*) = 60398 THEN 'OK' ELSE 'KO' END FROM gold.fact_sales
UNION ALL
SELECT 'fact_sales : aucune vente orpheline',
       CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'KO' END FROM gold.fact_sales
       WHERE customer_key IS NULL OR product_key IS NULL
UNION ALL
SELECT 'fact_sales : chiffre d''affaires = 29 356 250',
       CASE WHEN SUM(sales_amount) = 29356250 THEN 'OK' ELSE 'KO' END FROM gold.fact_sales;
