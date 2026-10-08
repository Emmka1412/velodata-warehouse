SELECT sls_prd_key 
FROM silver.crm_sales_details
WHERE sls_sales IS NULL OR sls_price IS NULL OR sls_sales <> sls_quantity * sls_price;
