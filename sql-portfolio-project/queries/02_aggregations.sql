-- ============================================================
-- 02: AGGREGATION & GROUPING QUERIES
-- Skill Level: Intermediate
-- Concepts: GROUP BY, HAVING, SUM, AVG, date functions
-- ============================================================

-- Q1: Monthly revenue trend (net of discounts)
SELECT 
    strftime('%Y-%m', o.order_date) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS net_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY month
ORDER BY month;

-- Q2: Revenue by product category
SELECT 
    p.category,
    COUNT(DISTINCT oi.order_id) AS num_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS net_revenue,
    ROUND(SUM(oi.quantity * (oi.unit_price - p.cost_price)), 2) AS gross_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY net_revenue DESC;

-- Q3: Average order value (AOV) by month
SELECT 
    strftime('%Y-%m', o.order_date) AS month,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)) / COUNT(DISTINCT o.order_id), 2) AS aov
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY month
ORDER BY month;

-- Q4: Top 10 customers by total spend
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Q5: Revenue by region
SELECT 
    r.region,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS net_revenue,
    ROUND(AVG(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS avg_item_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN regions r ON c.state = r.state
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY r.region
ORDER BY net_revenue DESC;

-- Q6: Best-selling products (by quantity)
SELECT 
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_qty_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id
ORDER BY total_qty_sold DESC
LIMIT 10;

-- Q7: Categories with more than 5000 in revenue (HAVING clause)
SELECT 
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS net_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
HAVING net_revenue > 5000
ORDER BY net_revenue DESC;

-- Q8: Quarterly performance summary
SELECT 
    strftime('%Y', o.order_date) AS year,
    'Q' || ((CAST(strftime('%m', o.order_date) AS INTEGER) - 1) / 3 + 1) AS quarter,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY year, quarter
ORDER BY year, quarter;
