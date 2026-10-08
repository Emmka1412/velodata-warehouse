-- Q2. Quel est le chiffre d'affaires par catégorie, et quelle part du total ?
SELECT
    p.category,
    SUM(f.sales_amount) AS chiffre_affaires,
    ROUND(100.0 * SUM(f.sales_amount) / SUM(SUM(f.sales_amount)) OVER (), 1) AS pct_du_total
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY chiffre_affaires DESC;
