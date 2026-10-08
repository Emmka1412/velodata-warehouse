-- Q6. Comment le chiffre d'affaires évolue-t-il mois par mois, et quel est son cumul ?
SELECT
    DATE_TRUNC('month', order_date)::DATE AS mois,
    SUM(sales_amount)                     AS chiffre_affaires,
    SUM(SUM(sales_amount)) OVER (ORDER BY DATE_TRUNC('month', order_date)) AS ca_cumule
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY mois;

-- Note : le cumul final (29 351 258) est inférieur au CA total (29 356 250).
-- Écart de 4 992 = les 19 ventes sans date de commande (anomalie A7),
-- incluses dans le total mais rattachées à aucun mois.
