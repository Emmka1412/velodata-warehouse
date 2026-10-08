-- =========================================================
-- Q1. Quels sont nos indicateurs clés sur toute la période ?
-- Chiffre d'affaires, nombre de commandes, panier moyen.
-- =========================================================
SELECT
    SUM(sales_amount)                          AS chiffre_affaires,
    COUNT(DISTINCT order_number)               AS nb_commandes,
    ROUND(SUM(sales_amount)::NUMERIC
          / COUNT(DISTINCT order_number), 2)   AS panier_moyen
FROM gold.fact_sales;
