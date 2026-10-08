-- Chaque client apparaît une seule fois, avec un identifiant non NULL (A1, A2)
SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;
