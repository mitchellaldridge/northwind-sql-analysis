-- Which products generate the most total revenue?

SELECT p.product_name, SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenue
FROM products p
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Which product categories generate the most total revenue?

SELECT c.category_name, SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenue
FROM order_details od
JOIN products p
ON od.product_id = p.product_id
JOIN categories c
ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Which countries generate the most total revenue?

SELECT c.country, SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenue
FROM order_details od
JOIN orders o
ON od.order_id = o.order_id
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC
LIMIT 10;

-- What is the monthly sales trend over time?

SELECT EXTRACT(year FROM o.order_date) AS year, EXTRACT(month FROM o.order_date) AS month, SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenue
FROM order_details od
JOIN orders o
ON od.order_id = o.order_id
GROUP BY year, month
ORDER BY year, month;

-- Which employees generate the most total revenue?

SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name, SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenue
FROM order_details od
JOIN orders o
ON od.order_id = o.order_id
JOIN employees e
ON o.employee_id = e.employee_id
GROUP BY full_name
ORDER BY total_revenue DESC
LIMIT 10;
