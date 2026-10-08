-- Aucun prénom ou nom avec espaces parasites (A3)
SELECT cst_id, cst_firstname, cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname)
   OR cst_lastname  <> TRIM(cst_lastname);
