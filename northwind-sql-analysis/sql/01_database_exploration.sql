-- Row counts per table

SELECT 'customers' AS table_name, COUNT(*) FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers;

-- Customers by country

SELECT
    country,
    COUNT(*) AS num_customers
FROM customers
GROUP BY country
ORDER BY num_customers DESC;

-- Orders per year

SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    COUNT(*) AS num_orders
FROM orders
GROUP BY year
ORDER BY year;

-- Products by category

SELECT
    c.category_name,
    COUNT(*) AS num_products
FROM products p
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY num_products DESC;

-- Top 10 Customers By Order

SELECT
    c.company_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.company_name
ORDER BY total_orders DESC
LIMIT 10;

