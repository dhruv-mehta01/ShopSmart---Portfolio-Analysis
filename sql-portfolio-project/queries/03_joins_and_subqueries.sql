-- ============================================================
-- 03: JOINS & SUBQUERIES
-- Skill Level: Intermediate-Advanced
-- Concepts: INNER JOIN, LEFT JOIN, subqueries, correlated subqueries
-- ============================================================

-- Q1: Full order details with customer and product info (multi-table JOIN)
SELECT 
    o.order_id,
    o.order_date,
    c.first_name || ' ' || c.last_name AS customer,
    c.city || ', ' || c.state AS location,
    p.product_name,
    p.category,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    ROUND(oi.quantity * oi.unit_price * (1 - oi.discount/100.0), 2) AS line_total,
    o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_date DESC
LIMIT 20;

-- Q2: Customers who have NEVER placed an order (LEFT JOIN)
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    c.city,
    c.join_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q3: Products that have never been ordered (LEFT JOIN)
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.item_id IS NULL;

-- Q4: Products priced above the average price (subquery)
SELECT 
    product_name,
    category,
    price,
    ROUND(price - (SELECT AVG(price) FROM products), 2) AS above_avg_by
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- Q5: Customers who spent more than the average customer (subquery with HAVING)
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id
HAVING total_spent > (
    SELECT AVG(customer_total) FROM (
        SELECT SUM(oi2.quantity * oi2.unit_price * (1 - oi2.discount/100.0)) AS customer_total
        FROM orders o2
        JOIN order_items oi2 ON o2.order_id = oi2.order_id
        WHERE o2.status = 'Completed'
        GROUP BY o2.customer_id
    )
)
ORDER BY total_spent DESC;

-- Q6: Best-selling product per category (correlated subquery)
SELECT 
    p.category,
    p.product_name,
    SUM(oi.quantity) AS qty_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id
HAVING SUM(oi.quantity) = (
    SELECT MAX(cat_qty) FROM (
        SELECT SUM(oi2.quantity) AS cat_qty
        FROM products p2
        JOIN order_items oi2 ON p2.product_id = oi2.product_id
        JOIN orders o2 ON oi2.order_id = o2.order_id
        WHERE o2.status = 'Completed' AND p2.category = p.category
        GROUP BY p2.product_id
    )
)
ORDER BY p.category;

-- Q7: Customer orders with region information
SELECT 
    r.region,
    c.first_name || ' ' || c.last_name AS customer,
    c.city,
    c.state,
    COUNT(o.order_id) AS num_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN regions r ON c.state = r.state
WHERE o.status = 'Completed'
GROUP BY c.customer_id
ORDER BY r.region, total_spent DESC;

-- Q8: Orders that contain products from multiple categories
SELECT 
    o.order_id,
    o.order_date,
    COUNT(DISTINCT p.category) AS categories_in_order,
    GROUP_CONCAT(DISTINCT p.category) AS category_list,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS order_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.order_id
HAVING categories_in_order > 1
ORDER BY categories_in_order DESC, order_total DESC
LIMIT 15;
