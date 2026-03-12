-- Rank products by revenue within each category

WITH product_revenue AS(
    SELECT c.category_name, p.product_name,
           SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenue
    FROM order_details od
    JOIN products p
    ON od.product_id = p.product_id
    JOIN categories c
    ON p.category_id = c.category_id
    GROUP BY c.category_name, p.product_name
)

SELECT category_name, product_name, total_revenue,
       DENSE_RANK() OVER(PARTITION BY category_name ORDER BY total_revenue DESC) AS category_rank
FROM product_revenue;

-- Showcase changes in product monthly revenue rank changes by month within categories.

WITH monthly_product_revenue AS (
    SELECT
        c.category_name, p.product_name,
        DATE_TRUNC('month', o.order_date)::DATE AS order_month,
        SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS monthly_revenue
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON od.product_id = p.product_id
    JOIN categories c
        ON p.category_id = c.category_id
    GROUP BY
        c.category_name,
        p.product_name,
        DATE_TRUNC('month', o.order_date)
),
monthly_category_rank AS (
    SELECT category_name, product_name, order_month, monthly_revenue,
        DENSE_RANK() OVER (
            PARTITION BY category_name, order_month
            ORDER BY monthly_revenue DESC
        ) AS category_rank
    FROM monthly_product_revenue
),
rank_with_lag AS (
    SELECT category_name, product_name, order_month, monthly_revenue,
        category_rank,
        LAG(category_rank) OVER (
            PARTITION BY category_name, product_name
            ORDER BY order_month
        ) AS prior_month_rank
    FROM monthly_category_rank
)
SELECT category_name, product_name, order_month, monthly_revenue,
    category_rank, prior_month_rank,
    prior_month_rank - category_rank AS rank_change
FROM rank_with_lag
WHERE prior_month_rank IS NOT NULL
ORDER BY category_name, product_name, order_month;

-- How consistently did each product perform as a top seller within its category?

WITH monthly_product_revenue AS (
    SELECT
        c.category_name,
        p.product_name,
        DATE_TRUNC('month', o.order_date)::DATE AS order_month,
        SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS monthly_revenue
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON od.product_id = p.product_id
    JOIN categories c
        ON p.category_id = c.category_id
    GROUP BY
        c.category_name,
        p.product_name,
        DATE_TRUNC('month', o.order_date)
),
monthly_category_rank AS (
    SELECT
        category_name,
        product_name,
        order_month,
        monthly_revenue,
        DENSE_RANK() OVER (
            PARTITION BY category_name, order_month
            ORDER BY monthly_revenue DESC
        ) AS category_rank
    FROM monthly_product_revenue
)

SELECT category_name, product_name, COUNT(*) AS months_with_sales,
       SUM(CASE WHEN category_rank <= 3 THEN 1 ELSE 0 END) AS months_in_top_3,
       100 * SUM(CASE WHEN category_rank <= 3 THEN 1 ELSE 0 END) / COUNT(*) AS pct_months_in_top_3,
       MIN(category_rank) AS best_rank,
       AVG(category_rank) AS avg_rank
FROM monthly_category_rank
GROUP BY category_name, product_name
ORDER BY months_in_top_3 DESC, pct_months_in_top_3 DESC;