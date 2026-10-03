SELECT COUNT(*) FROM bronze.crm_cust_info WHERE cst_id IS NULL;


SELECT COUNT(*) FROM (
  SELECT cst_id
  FROM bronze.crm_cust_info
  WHERE cst_id IS NOT NULL
  GROUP BY cst_id
  HAVING COUNT(*) > 1
) doublons;


SELECT COUNT(*) FROM bronze.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname )
or cst_lastname <> TRIM(cst_lastname);


SELECT cst_gndr, COUNT(*) FROM bronze.crm_cust_info 
GROUP BY cst_gndr ORDER BY 2 DESC ;
SELECT cst_marital_status, COUNT(*) FROM bronze.crm_cust_info 
GROUP BY cst_marital_status ORDER BY 2 DESC ;


SELECT COUNT(*) FROM bronze.crm_prd_info
WHERE prd_cost IS NULL
OR prd_cost<0;


SELECT COUNT(*) FROM bronze.crm_prd_info
WHERE prd_start_dt > ped_end_dt;



SELECT COUNT(*) FROM bronze.crm_sales_details
WHERE LENGTH(sls_order_dt::TEXT)=8;



SELECT COUNT(*) FROM bronze.crm_sales_details
WHERE sls_sales IS NULL 
OR sls_sales <= 0
or sls_price IS NULL 
or sls_price <= 0
or sls_sales <> sls_quantity * sls_price;



SELECT COUNT(*) FROM bronze.erp_cust_az12
WHERE CURRENT_DATE < BDATE ;



SELECT COUNT(DISTINCT GEN) FROM bronze.erp_cust_az12;

SELECT gen, COUNT(*) FROM bronze.erp_cust_az12 GROUP BY gen ORDER BY 2 DESC;


SELECT COUNT(DISTINCT cntry) FROM bronze.erp_loc_a101;
SELECT cntry, COUNT(*) FROM bronze.erp_loc_a101 GROUP BY cntry ORDER BY 2 DESC;


SELECT COUNT(*) FROM bronze.crm_prd_info p
WHERE NOT EXISTS (
  SELECT 1 FROM bronze.erp_px_cat_g1v2 c
  WHERE c.id =REPLACE(SUBSTRING(p.prd_key FROM 1 FOR 5), '-', '_')
);
