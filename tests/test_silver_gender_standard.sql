-- Le genre ERP vaut Female, Male ou n/a (A10)
SELECT DISTINCT gen
FROM silver.erp_cust_az12
WHERE gen IS NULL OR gen NOT IN ('Female', 'Male', 'n/a');
