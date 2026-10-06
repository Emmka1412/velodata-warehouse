SELECT 'A1-A2 clients uniques, sans id NULL' AS controle,
       CASE WHEN COUNT(*) = 18484 AND COUNT(DISTINCT cst_id) = 18484 AND COUNT(cst_id) = 18484
            THEN 'OK' ELSE 'KO' END AS resultat FROM silver.crm_cust_info
UNION ALL
SELECT 'A3 noms sans espaces parasites',
       CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'KO' END FROM silver.crm_cust_info
       WHERE cst_firstname <> TRIM(cst_firstname) OR cst_lastname <> TRIM(cst_lastname)
UNION ALL
SELECT 'A5 aucun coût NULL',
       CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'KO' END FROM silver.crm_prd_info WHERE prd_cost IS NULL
UNION ALL
SELECT 'A6 dates produits cohérentes',
       CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'KO' END FROM silver.crm_prd_info WHERE prd_end_dt < prd_start_dt
UNION ALL
SELECT 'A6 295 produits actuels',
       CASE WHEN COUNT(*) = 295 THEN 'OK' ELSE 'KO' END FROM silver.crm_prd_info WHERE prd_end_dt IS NULL
UNION ALL
SELECT 'A7 19 ventes sans date conservées',
       CASE WHEN COUNT(*) FILTER (WHERE sls_order_dt IS NULL) = 19 AND COUNT(*) = 60398
            THEN 'OK' ELSE 'KO' END FROM silver.crm_sales_details
UNION ALL
SELECT 'A8 montant = quantité × prix',
       CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'KO' END FROM silver.crm_sales_details
       WHERE sls_sales IS NULL OR sls_price IS NULL OR sls_sales <> sls_quantity * sls_price
UNION ALL
SELECT 'A9 aucune naissance future',
       CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'KO' END FROM silver.erp_cust_az12 WHERE bdate > CURRENT_DATE
UNION ALL
SELECT 'A10 genre ERP : 3 valeurs',
       CASE WHEN COUNT(DISTINCT gen) = 3 THEN 'OK' ELSE 'KO' END FROM silver.erp_cust_az12
UNION ALL
SELECT 'A11 pays : 7 valeurs',
       CASE WHEN COUNT(DISTINCT cntry) = 7 THEN 'OK' ELSE 'KO' END FROM silver.erp_loc_a101
UNION ALL
SELECT 'Intégration : 100 % des clients reliés à l''ERP',
       CASE WHEN COUNT(*) = 18484 THEN 'OK' ELSE 'KO' END
       FROM silver.crm_cust_info c
       JOIN silver.erp_cust_az12 e ON c.cst_key = e.cid
       JOIN silver.erp_loc_a101 l ON c.cst_key = l.cid;
