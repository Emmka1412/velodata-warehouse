SELECT product_number, COUNT(*)
FROM gold.dim_products
GROUP BY product_number
HAVING COUNT(*) > 1 OR product_number IS NULL;
