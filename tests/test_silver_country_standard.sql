SELECT DISTINCT cntry
FROM silver.erp_loc_a101
WHERE cntry NOT IN ('United States', 'Australia', 'United Kingdom',
                    'France', 'Germany', 'Canada', 'n/a');
