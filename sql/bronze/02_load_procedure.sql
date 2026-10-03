
CREATE OR REPLACE PROCEDURE bronze.load_bronze(p_data_dir TEXT DEFAULT '/data')
LANGUAGE plpgsql AS $$
DECLARE
  t0 TIMESTAMPTZ;   
  n  BIGINT;       
  r  RECORD;        
BEGIN
 
  FOR r IN SELECT * FROM (VALUES
      ('crm_cust_info',     'source_crm/cust_info.csv'),
      ('crm_prd_info',      'source_crm/prd_info.csv'),
      ('crm_sales_details', 'source_crm/sales_details.csv'),
      ('erp_cust_az12',     'source_erp/CUST_AZ12.csv'),
      ('erp_loc_a101',      'source_erp/LOC_A101.csv'),
      ('erp_px_cat_g1v2',   'source_erp/PX_CAT_G1V2.csv')) AS s(tbl, file)
  LOOP
    t0 := clock_timestamp();

    
    EXECUTE format('TRUNCATE bronze.%I', r.tbl);

    
    EXECUTE format('COPY bronze.%I FROM %L WITH (FORMAT csv, HEADER true)',
                   r.tbl, p_data_dir || '/' || r.file);

    
    GET DIAGNOSTICS n = ROW_COUNT;

    
    INSERT INTO ops.etl_log(layer, table_name, rows_loaded, started_at, ended_at)
    VALUES ('bronze', r.tbl, n, t0, clock_timestamp());

    RAISE NOTICE 'bronze.% : % lignes', r.tbl, n;
  END LOOP;
END $$;
