SELECT order_number, customer_key, product_key
FROM gold.fact_sales
WHERE customer_key IS NULL OR product_key IS NULL;
