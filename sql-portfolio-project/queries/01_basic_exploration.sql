-- ============================================================
-- 01: BASIC EXPLORATION QUERIES
-- Skill Level: Beginner
-- Concepts: SELECT, WHERE, ORDER BY, COUNT, DISTINCT, LIMIT
-- ============================================================

-- Q1: How many total orders do we have?
SELECT COUNT(*) AS total_orders FROM orders;

-- Q2: How many unique customers have placed orders?
SELECT COUNT(DISTINCT customer_id) AS active_customers FROM orders;

-- Q3: What are the different order statuses and their counts?
SELECT 
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- Q4: List all product categories with number of products
SELECT 
    category,
    COUNT(*) AS num_products,
    ROUND(AVG(price), 2) AS avg_price,
    MIN(price) AS cheapest,
    MAX(price) AS most_expensive
FROM products
GROUP BY category
ORDER BY num_products DESC;

-- Q5: Top 10 most expensive products
SELECT 
    product_name,
    category,
    price,
    cost_price,
    ROUND(price - cost_price, 2) AS profit_margin
FROM products
ORDER BY price DESC
LIMIT 10;

-- Q6: How many customers joined each year?
SELECT 
    strftime('%Y', join_date) AS join_year,
    COUNT(*) AS new_customers
FROM customers
GROUP BY join_year
ORDER BY join_year;

-- Q7: List all orders from January 2025
SELECT 
    order_id,
    customer_id,
    order_date,
    status,
    payment_method
FROM orders
WHERE order_date BETWEEN '2025-01-01' AND '2025-01-31'
ORDER BY order_date;

-- Q8: What payment methods are most popular?
SELECT 
    payment_method,
    COUNT(*) AS usage_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 1) AS percentage
FROM orders
GROUP BY payment_method
ORDER BY usage_count DESC;

-- Q9: Which cities have the most customers?
SELECT 
    city,
    state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city, state
ORDER BY customer_count DESC
LIMIT 10;

-- Q10: What is the total revenue (before discounts)?
SELECT 
    ROUND(SUM(quantity * unit_price), 2) AS gross_revenue,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS net_revenue,
    ROUND(SUM(quantity * unit_price * discount / 100.0), 2) AS total_discounts
FROM order_items;
