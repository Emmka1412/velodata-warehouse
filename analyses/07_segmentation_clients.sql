-- =========================================================
-- Q7. Peut-on segmenter nos clients pour adapter nos actions commerciales ?
-- =========================================================
-- Date de référence : la dernière commande des données (28/01/2014),
-- et non la date du jour : les données s'arrêtent en janvier 2014.
--
-- Règles de segmentation (évaluées dans cet ordre) :
--   Nouveau     : première commande dans les 12 derniers mois des données
--   VIP         : client plus ancien, CA total > 5 000
--   Régulier    : client plus ancien, CA <= 5 000, au moins 2 commandes
--   Occasionnel : client plus ancien, une seule commande
--
-- Justification du seuil VIP (distribution du CA par client) :
--   médiane = 271,50 ; 75e percentile = 2 511 ; 90e percentile = 4 827.
--   5 000 est proche du 90e percentile : les VIP sont environ les 10 % meilleurs clients.
-- =========================================================
WITH reference AS (
    SELECT MAX(order_date) AS date_ref
    FROM gold.fact_sales
),
par_client AS (
    SELECT
        f.customer_key,
        SUM(f.sales_amount)            AS ca_total,
        COUNT(DISTINCT f.order_number) AS nb_commandes,
        MIN(f.order_date)              AS premiere_commande
    FROM gold.fact_sales f
    WHERE f.order_date IS NOT NULL
    GROUP BY f.customer_key
),
segments AS (
    SELECT
        pc.*,
        CASE
            WHEN pc.premiere_commande > r.date_ref - INTERVAL '12 months' THEN 'Nouveau'
            WHEN pc.ca_total > 5000                                        THEN 'VIP'
            WHEN pc.nb_commandes >= 2                                      THEN 'Régulier'
            ELSE                                                                'Occasionnel'
        END AS segment
    FROM par_client pc
    CROSS JOIN reference r
)
SELECT
    segment,
    COUNT(*)                                                     AS nb_clients,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)           AS pct_clients,
    SUM(ca_total)                                                AS chiffre_affaires,
    ROUND(100.0 * SUM(ca_total) / SUM(SUM(ca_total)) OVER (), 1) AS pct_ca,
    ROUND(AVG(ca_total), 2)                                      AS ca_moyen_par_client
FROM segments
GROUP BY segment
ORDER BY chiffre_affaires DESC;