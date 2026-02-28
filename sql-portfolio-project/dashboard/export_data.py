"""
Export SQL query results to a JavaScript data file for the dashboard.
"""
import sqlite3
import json
import os

DB_PATH = os.path.join(os.path.dirname(__file__), '..', 'database', 'shop_smart.db')
OUTPUT_PATH = os.path.join(os.path.dirname(__file__), 'data.js')

def query(conn, sql):
    cur = conn.execute(sql)
    cols = [d[0] for d in cur.description]
    return [dict(zip(cols, row)) for row in cur.fetchall()]

def main():
    conn = sqlite3.connect(DB_PATH)
    data = {}

    # KPI summary
    data['kpis'] = query(conn, """
        SELECT 
            (SELECT COUNT(*) FROM orders WHERE status='Completed') AS total_orders,
            (SELECT COUNT(DISTINCT customer_id) FROM orders) AS total_customers,
            (SELECT COUNT(*) FROM products) AS total_products,
            (SELECT ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2)
             FROM order_items oi JOIN orders o ON oi.order_id = o.order_id WHERE o.status='Completed') AS total_revenue
    """)[0]
    rev = data['kpis']['total_revenue'] or 0
    ords = data['kpis']['total_orders'] or 1
    data['kpis']['avg_order_value'] = round(rev / ords, 2)

    # Monthly revenue trend
    data['monthlyRevenue'] = query(conn, """
        SELECT strftime('%Y-%m', o.order_date) AS month,
               ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS revenue,
               COUNT(DISTINCT o.order_id) AS orders
        FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
        WHERE o.status = 'Completed'
        GROUP BY month ORDER BY month
    """)

    # Category revenue
    data['categoryRevenue'] = query(conn, """
        SELECT p.category,
               ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS revenue,
               SUM(oi.quantity) AS units_sold
        FROM order_items oi
        JOIN products p ON oi.product_id = p.product_id
        JOIN orders o ON oi.order_id = o.order_id
        WHERE o.status = 'Completed'
        GROUP BY p.category ORDER BY revenue DESC
    """)

    # Top 10 customers
    data['topCustomers'] = query(conn, """
        SELECT c.first_name || ' ' || c.last_name AS name,
               c.city,
               ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS total_spent,
               COUNT(DISTINCT o.order_id) AS orders
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        JOIN order_items oi ON o.order_id = oi.order_id
        WHERE o.status = 'Completed'
        GROUP BY c.customer_id ORDER BY total_spent DESC LIMIT 10
    """)

    # Regional revenue
    data['regionRevenue'] = query(conn, """
        SELECT r.region,
               ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS revenue,
               COUNT(DISTINCT o.order_id) AS orders
        FROM orders o
        JOIN customers c ON o.customer_id = c.customer_id
        JOIN regions r ON c.state = r.state
        JOIN order_items oi ON o.order_id = oi.order_id
        WHERE o.status = 'Completed'
        GROUP BY r.region ORDER BY revenue DESC
    """)

    # Order status distribution
    data['orderStatus'] = query(conn, """
        SELECT status, COUNT(*) AS count FROM orders GROUP BY status ORDER BY count DESC
    """)

    # Payment method distribution
    data['paymentMethods'] = query(conn, """
        SELECT payment_method, COUNT(*) AS count FROM orders GROUP BY payment_method ORDER BY count DESC
    """)

    # Top products
    data['topProducts'] = query(conn, """
        SELECT p.product_name AS name, p.category,
               SUM(oi.quantity) AS qty_sold,
               ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS revenue
        FROM order_items oi
        JOIN products p ON oi.product_id = p.product_id
        JOIN orders o ON oi.order_id = o.order_id
        WHERE o.status = 'Completed'
        GROUP BY p.product_id ORDER BY revenue DESC LIMIT 10
    """)

    # Customer segments
    data['customerSegments'] = query(conn, """
        WITH cs AS (
            SELECT c.customer_id,
                   ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100.0)), 2) AS total_spent,
                   COUNT(DISTINCT o.order_id) AS order_count
            FROM customers c
            JOIN orders o ON c.customer_id = o.customer_id
            JOIN order_items oi ON o.order_id = oi.order_id
            WHERE o.status = 'Completed'
            GROUP BY c.customer_id
        )
        SELECT 
            CASE 
                WHEN total_spent > 15000 AND order_count > 10 THEN 'VIP'
                WHEN total_spent > 8000 THEN 'High Value'
                WHEN total_spent > 3000 THEN 'Mid Value'
                ELSE 'Low Value'
            END AS segment,
            COUNT(*) AS count
        FROM cs GROUP BY segment
    """)

    conn.close()

    with open(OUTPUT_PATH, 'w') as f:
        f.write('// Auto-generated dashboard data from SQL queries\n')
        f.write(f'const DASHBOARD_DATA = {json.dumps(data, indent=2)};\n')

    print(f"[SUCCESS] Data exported to {OUTPUT_PATH}")

if __name__ == '__main__':
    main()
