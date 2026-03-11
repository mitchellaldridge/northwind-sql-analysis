-- Which customers generate the most total revenue

WITH customer_revenue AS (
    SELECT c.company_name, SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenue
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_details od
    ON o.order_id = od.order_id
    GROUP BY c.company_name
)

SELECT company_name ,total_revenue
FROM customer_revenue
ORDER BY total_revenue DESC
LIMIT 10;

-- Rank customers by total revenue

WITH customer_revenue AS (
    SELECT c.company_name, SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenue
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_details od
    ON o.order_id = od.order_id
    GROUP BY c.company_name
)

SELECT *, DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS rank
FROM customer_revenue;

-- What percentage of total revenue does each customer contribute?

WITH customer_revenue AS (
    SELECT c.company_name, SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenue
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_details od
    ON o.order_id = od.order_id
    GROUP BY c.company_name
)

SELECT company_name, total_revenue AS customer_revenue_amount, (total_revenue / SUM(total_revenue) OVER()) * 100 AS percent_total_revenue
FROM customer_revenue
ORDER BY percent_total_revenue DESC;

-- How many customers make up the top 60% of revenue?

WITH customer_revenue AS (
    SELECT c.company_name, SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenue
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_details od
    ON o.order_id = od.order_id
    GROUP BY c.company_name
),
ranked_customers AS (
    SELECT company_name, total_revenue, SUM(total_revenue) OVER (ORDER BY total_revenue DESC) AS running_revenue,
        (SUM(total_revenue) OVER (ORDER BY total_revenue DESC) /
        SUM(total_revenue) OVER ()) * 100 AS cumulative_percent,
        DENSE_RANK() OVER(ORDER BY total_revenue DESC) AS rank
    FROM customer_revenue)

SELECT company_name, total_revenue, running_revenue, cumulative_percent, rank
FROM ranked_customers
WHERE cumulative_percent <= 60
ORDER BY total_revenue DESC;

-- 17 Customers make up ~60% of the total revenue.