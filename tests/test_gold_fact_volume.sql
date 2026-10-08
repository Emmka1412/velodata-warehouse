-- La table de faits contient exactement 60 398 ventes : ni perte, ni duplication
SELECT COUNT(*) AS nb_ventes
FROM gold.fact_sales
HAVING COUNT(*) <> 60398;
