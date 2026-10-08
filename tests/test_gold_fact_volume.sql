SELECT COUNT(*) AS nb_ventes
FROM gold.fact_sales
HAVING COUNT(*) <> 60398;
