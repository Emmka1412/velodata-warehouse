-- Q6. Comment le chiffre d'affaires évolue-t-il mois par mois, et quel est son cumul ?
SELECT
    DATE_TRUNC('month', order_date)::DATE AS mois,
    SUM(sales_amount)                     AS chiffre_affaires,
    SUM(SUM(sales_amount)) OVER (ORDER BY DATE_TRUNC('month', order_date)) AS ca_cumule
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY mois;
