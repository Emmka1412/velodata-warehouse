-- Q8. Quel pays a le panier moyen le plus élevé ?
-- Le pays qui vend le plus (Q3) est-il aussi celui qui dépense le plus par commande ?
SELECT
    c.country,
    COUNT(DISTINCT f.order_number)                                      AS nb_commandes,
    SUM(f.sales_amount)                                                 AS chiffre_affaires,
    ROUND(SUM(f.sales_amount)::NUMERIC / COUNT(DISTINCT f.order_number), 2) AS panier_moyen
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY panier_moyen DESC;
