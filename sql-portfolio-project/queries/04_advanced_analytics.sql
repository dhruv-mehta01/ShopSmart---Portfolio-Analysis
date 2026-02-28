-- ============================================================
-- 04: ADVANCED ANALYTICS
-- Skill Level: Advanced
-- Concepts: CTEs, Window Functions, RANK, LAG/LEAD, Running Totals,
--           CASE statements, Cohort Analysis
-- ============================================================

-- Q1: Monthly revenue with month-over-month growth (CTE + Window Functions)
WITH monthly_revenue AS (
    SELECT 
        strftime('%Y-%m', o.order_date) AS month,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY month
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 
        / LAG(revenue) OVER (ORDER BY month), 1
    ) AS growth_pct
FROM monthly_revenue
ORDER BY month;

-- Q2: Customer ranking by total spend (RANK & DENSE_RANK)
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.city,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS total_spent,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)) DESC) AS spend_rank,
    DENSE_RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)) DESC) AS dense_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id
ORDER BY spend_rank
LIMIT 15;

-- Q3: Cumulative (running) revenue over time
WITH daily_revenue AS (
    SELECT 
        o.order_date,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS daily_rev
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY o.order_date
)
SELECT 
    order_date,
    daily_rev,
    ROUND(SUM(daily_rev) OVER (ORDER BY order_date), 2) AS cumulative_revenue
FROM daily_revenue
ORDER BY order_date;

-- Q4: Customer segmentation using CASE (RFM-inspired)
WITH customer_stats AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        COUNT(DISTINCT o.order_id) AS order_count,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS total_spent,
        MAX(o.order_date) AS last_order_date,
        JULIANDAY('2026-02-28') - JULIANDAY(MAX(o.order_date)) AS days_since_last_order
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id
)
SELECT 
    customer_name,
    order_count,
    total_spent,
    last_order_date,
    CAST(days_since_last_order AS INTEGER) AS days_inactive,
    CASE 
        WHEN total_spent > 15000 AND order_count > 10 THEN 'VIP'
        WHEN total_spent > 8000 THEN 'High Value'
        WHEN total_spent > 3000 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS customer_segment,
    CASE 
        WHEN days_since_last_order < 60 THEN 'Active'
        WHEN days_since_last_order < 180 THEN 'At Risk'
        ELSE 'Churned'
    END AS activity_status
FROM customer_stats
ORDER BY total_spent DESC;

-- Q5: Product ranking within each category (RANK with PARTITION BY)
SELECT 
    p.category,
    p.product_name,
    SUM(oi.quantity) AS qty_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS revenue,
    RANK() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity) DESC) AS rank_in_category
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id
ORDER BY p.category, rank_in_category;

-- Q6: Cohort analysis — Customer retention by join month
WITH customer_cohort AS (
    SELECT 
        c.customer_id,
        strftime('%Y-%m', c.join_date) AS cohort_month,
        strftime('%Y-%m', o.order_date) AS order_month
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status = 'Completed'
),
cohort_size AS (
    SELECT cohort_month, COUNT(DISTINCT customer_id) AS num_customers
    FROM customer_cohort
    GROUP BY cohort_month
),
cohort_activity AS (
    SELECT 
        cohort_month,
        order_month,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM customer_cohort
    GROUP BY cohort_month, order_month
)
SELECT 
    ca.cohort_month,
    cs.num_customers AS cohort_size,
    ca.order_month AS activity_month,
    ca.active_customers,
    ROUND(ca.active_customers * 100.0 / cs.num_customers, 1) AS retention_pct
FROM cohort_activity ca
JOIN cohort_size cs ON ca.cohort_month = cs.cohort_month
ORDER BY ca.cohort_month, ca.order_month;

-- Q7: Profit margin analysis with profitability ranking
WITH product_profitability AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        p.price,
        p.cost_price,
        ROUND((p.price - p.cost_price) * 100.0 / p.price, 1) AS margin_pct,
        SUM(oi.quantity) AS units_sold,
        ROUND(SUM(oi.quantity * (oi.unit_price * (1 - oi.discount/100.0) - p.cost_price)), 2) AS net_profit
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY p.product_id
)
SELECT 
    *,
    RANK() OVER (ORDER BY net_profit DESC) AS profit_rank,
    ROUND(net_profit * 100.0 / SUM(net_profit) OVER (), 1) AS pct_of_total_profit
FROM product_profitability
ORDER BY profit_rank;

-- Q8: Year-over-year comparison
WITH yearly AS (
    SELECT 
        strftime('%Y', o.order_date) AS year,
        COUNT(DISTINCT o.order_id) AS orders,
        COUNT(DISTINCT o.customer_id) AS customers,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY year
)
SELECT 
    year,
    orders,
    customers,
    revenue,
    LAG(revenue) OVER (ORDER BY year) AS prev_year_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY year)) * 100.0 / LAG(revenue) OVER (ORDER BY year), 1) AS yoy_growth
FROM yearly
ORDER BY year;
