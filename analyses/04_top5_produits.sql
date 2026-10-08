-- Q4. Quels sont nos 5 meilleurs produits en chiffre d'affaires ?
SELECT
    p.product_name,
    SUM(f.sales_amount) AS chiffre_affaires
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY chiffre_affaires DESC
LIMIT 5;
