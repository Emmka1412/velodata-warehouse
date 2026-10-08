SELECT prd_end_dt, prd_start_dt 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;
