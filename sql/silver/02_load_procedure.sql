CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql AS $$
DECLARE
  t0 TIMESTAMPTZ;
  n  BIGINT;
BEGIN



  t0 := clock_timestamp();
  TRUNCATE silver.crm_cust_info;
  INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname,
                                    cst_marital_status, cst_gndr, cst_create_date)
  SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname),                                         
    TRIM(cst_lastname),                                          
    CASE UPPER(TRIM(cst_marital_status)) WHEN 'S' THEN 'Single'
                                         WHEN 'M' THEN 'Married'
                                         ELSE 'n/a' END,         
    CASE UPPER(TRIM(cst_gndr)) WHEN 'F' THEN 'Female'
                               WHEN 'M' THEN 'Male'
                               ELSE 'n/a' END,                   
    cst_create_date
  FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rn
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL                                     
  ) t
  WHERE rn = 1;                                                  
  GET DIAGNOSTICS n = ROW_COUNT;
  INSERT INTO ops.etl_log(layer, table_name, rows_loaded, started_at, ended_at)
  VALUES ('silver', 'crm_cust_info', n, t0, clock_timestamp());




  t0 := clock_timestamp();
  TRUNCATE silver.crm_prd_info;
  INSERT INTO silver.crm_prd_info (prd_id, cat_id, prd_key, prd_nm, prd_cost,
                                   prd_line, prd_start_dt, prd_end_dt)
  SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key FROM 1 FOR 5), '-', '_'),         
    SUBSTRING(prd_key FROM 7),                                   
    TRIM(prd_nm),
    COALESCE(prd_cost, 0),                                       
    CASE UPPER(TRIM(prd_line)) WHEN 'M' THEN 'Mountain'
                               WHEN 'R' THEN 'Road'
                               WHEN 'S' THEN 'Other Sales'
                               WHEN 'T' THEN 'Touring'
                               ELSE 'n/a' END,                   
    prd_start_dt,
    LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1   
  FROM bronze.crm_prd_info;
  GET DIAGNOSTICS n = ROW_COUNT;
  INSERT INTO ops.etl_log(layer, table_name, rows_loaded, started_at, ended_at)
  VALUES ('silver', 'crm_prd_info', n, t0, clock_timestamp());




  t0 := clock_timestamp();
  TRUNCATE silver.crm_sales_details;
  INSERT INTO silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt,
                                        sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
  SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_dt <= 0 OR LENGTH(sls_order_dt::TEXT) <> 8 THEN NULL
         ELSE TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD') END,       
    CASE WHEN sls_ship_dt <= 0 OR LENGTH(sls_ship_dt::TEXT) <> 8 THEN NULL
         ELSE TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD') END,
    CASE WHEN sls_due_dt <= 0 OR LENGTH(sls_due_dt::TEXT) <> 8 THEN NULL
         ELSE TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD') END,
    CASE WHEN sls_sales IS NULL OR sls_sales <= 0
              OR sls_sales <> sls_quantity * ABS(sls_price)
         THEN sls_quantity * ABS(sls_price)
         ELSE sls_sales END,                                     
    sls_quantity,
    CASE WHEN sls_price IS NULL OR sls_price <= 0
         THEN sls_sales / NULLIF(sls_quantity, 0)
         ELSE sls_price END                                      
  FROM bronze.crm_sales_details;
  GET DIAGNOSTICS n = ROW_COUNT;
  INSERT INTO ops.etl_log(layer, table_name, rows_loaded, started_at, ended_at)
  VALUES ('silver', 'crm_sales_details', n, t0, clock_timestamp());




  t0 := clock_timestamp();
  TRUNCATE silver.erp_cust_az12;
  INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
  SELECT
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid FROM 4) ELSE cid END,          
    CASE WHEN bdate > CURRENT_DATE THEN NULL ELSE bdate END,                    
    CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
         WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')   THEN 'Male'
         ELSE 'n/a' END                                                         
  FROM bronze.erp_cust_az12;
  GET DIAGNOSTICS n = ROW_COUNT;
  INSERT INTO ops.etl_log(layer, table_name, rows_loaded, started_at, ended_at)
  VALUES ('silver', 'erp_cust_az12', n, t0, clock_timestamp());




  t0 := clock_timestamp();
  TRUNCATE silver.erp_loc_a101;
  INSERT INTO silver.erp_loc_a101 (cid, cntry)
  SELECT
    REPLACE(cid, '-', ''),                                                      
    CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
         WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
         WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'n/a'
         ELSE TRIM(cntry) END                                                   
  FROM bronze.erp_loc_a101;
  GET DIAGNOSTICS n = ROW_COUNT;
  INSERT INTO ops.etl_log(layer, table_name, rows_loaded, started_at, ended_at)
  VALUES ('silver', 'erp_loc_a101', n, t0, clock_timestamp());




  t0 := clock_timestamp();
  TRUNCATE silver.erp_px_cat_g1v2;
  INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
  SELECT TRIM(id), TRIM(cat), TRIM(subcat), TRIM(maintenance)
  FROM bronze.erp_px_cat_g1v2;
  GET DIAGNOSTICS n = ROW_COUNT;
  INSERT INTO ops.etl_log(layer, table_name, rows_loaded, started_at, ended_at)
  VALUES ('silver', 'erp_px_cat_g1v2', n, t0, clock_timestamp());

  RAISE NOTICE 'Silver chargé.';
END $$;
