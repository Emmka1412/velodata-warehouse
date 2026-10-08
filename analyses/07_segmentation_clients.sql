-- Q7. Peut-on segmenter nos clients en VIP, réguliers et nouveaux ?
-- Règles (à justifier avec la distribution du CA par client) :
--   VIP      : client depuis au moins 12 mois ET plus de 5 000 de CA
--   Régulier : client depuis au moins 12 mois ET 5 000 de CA ou moins
--   Nouveau  : client depuis moins de 12 mois
-- Ancienneté = écart entre première et dernière commande.
WITH par_client AS (
    SELECT
        customer_key,
        SUM(sales_amount) AS ca_total,
        MIN(order_date)   AS premiere_commande,
        MAX(order_date)   AS derniere_commande,
        (EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12
         + EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date)))) AS anciennete_mois
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL AND customer_key IS NOT NULL
    GROUP BY customer_key
)
SELECT
    CASE
        WHEN anciennete_mois >= 12 AND ca_total >  5000 THEN 'VIP'
        WHEN anciennete_mois >= 12 AND ca_total <= 5000 THEN 'Régulier'
        ELSE 'Nouveau'
    END AS segment,
    COUNT(*)      AS nb_clients,
    SUM(ca_total) AS chiffre_affaires
FROM par_client
GROUP BY 1
ORDER BY nb_clients DESC;
