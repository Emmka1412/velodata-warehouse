-- Q3. Quel est le chiffre d'affaires par pays ?
SELECT
    c.country,
    SUM(f.sales_amount) AS chiffre_affaires
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY chiffre_affaires DESC;
