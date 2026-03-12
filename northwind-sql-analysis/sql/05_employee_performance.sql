-- Which employees generated the highest average order value?

WITH order_totals AS (
    SELECT o.order_id, o.employee_id, SUM((od.quantity * od.unit_price) * (1 - od.discount)) AS order_total
    FROM order_details od
    JOIN orders o
    ON od.order_id = o.order_id
    GROUP BY o.order_id, o.employee_id
),

employee_order_summary AS (
    SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name, COUNT(ot.order_id) AS total_orders,
           ROUND(SUM(ot.order_total)::numeric, 2) AS total_revenue, ROUND(AVG(ot.order_total)::numeric, 2) AS avg_order_value, ROUND(MAX(ot.order_total)::numeric, 2) AS largest_order,
           ROUND(MIN(ot.order_total)::numeric, 2) AS smallest_order, DENSE_RANK() OVER(ORDER BY AVG(ot.order_total) DESC) AS rank_for_average
    FROM employees e
    JOIN order_totals ot
    ON e.employee_id = ot.employee_id
    GROUP BY e.employee_id, full_name
)

SELECT employee_id, full_name, total_orders, total_revenue, avg_order_value, largest_order, smallest_order, rank_for_average
FROM employee_order_summary
ORDER BY rank_for_average;

-- Which employees sell the most distinct products and categories?

WITH employee_sales AS (
    SELECT
        e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name, o.order_id,
        p.product_id, c.category_id, (od.quantity * od.unit_price) * (1 - od.discount) AS revenue
    FROM employees e
    JOIN orders o
        ON e.employee_id = o.employee_id
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON od.product_id = p.product_id
    JOIN categories c
        ON p.category_id = c.category_id
)

SELECT employee_id, full_name, COUNT(DISTINCT order_id) AS total_orders, COUNT(DISTINCT product_id) AS distinct_products_sold,
       COUNT(DISTINCT category_id) AS distinct_categories_sold, ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM employee_sales
GROUP BY employee_id, full_name
ORDER BY distinct_categories_sold DESC, distinct_products_sold DESC, total_revenue DESC;

