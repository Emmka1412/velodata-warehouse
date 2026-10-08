-- Q5. Quel est le chiffre d'affaires et le nombre de clients actifs par année ?
-- Attention : ne pas conclure sans regarder la période couverte (voir requête de contrôle).
SELECT
    EXTRACT(YEAR FROM order_date)::INT AS annee,
    SUM(sales_amount)                  AS chiffre_affaires,
    COUNT(DISTINCT customer_key)       AS clients_actifs
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY annee;

-- Contrôle : sur quelle période s'étendent les données ?
SELECT MIN(order_date) AS premiere_commande, MAX(order_date) AS derniere_commande
FROM gold.fact_sales;
