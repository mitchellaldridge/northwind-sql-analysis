-- Which products generate the most total revenue?

SELECT p.product_name, SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenue
FROM products p
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;
