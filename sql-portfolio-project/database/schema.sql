-- ============================================================
-- ShopSmart Analytics — Database Schema
-- E-Commerce Sales Analysis Portfolio Project
-- ============================================================

-- Regions table: Maps states to geographical regions
CREATE TABLE IF NOT EXISTS regions (
    state       TEXT PRIMARY KEY,
    region      TEXT NOT NULL  -- North, South, East, West
);

-- Customers table: Stores customer information
CREATE TABLE IF NOT EXISTS customers (
    customer_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT UNIQUE NOT NULL,
    phone           TEXT,
    city            TEXT NOT NULL,
    state           TEXT NOT NULL,
    join_date       DATE NOT NULL,
    FOREIGN KEY (state) REFERENCES regions(state)
);

-- Products table: Stores product catalog
CREATE TABLE IF NOT EXISTS products (
    product_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name    TEXT NOT NULL,
    category        TEXT NOT NULL,  -- Electronics, Clothing, Home, Books, Sports
    price           REAL NOT NULL,  -- Selling price
    cost_price      REAL NOT NULL,  -- Cost price for profit analysis
    stock_quantity  INTEGER NOT NULL DEFAULT 0
);

-- Orders table: Stores order header information
CREATE TABLE IF NOT EXISTS orders (
    order_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id     INTEGER NOT NULL,
    order_date      DATE NOT NULL,
    status          TEXT NOT NULL DEFAULT 'Completed',  -- Completed, Pending, Cancelled, Returned
    shipping_cost   REAL NOT NULL DEFAULT 0,
    payment_method  TEXT NOT NULL DEFAULT 'UPI',  -- UPI, Credit Card, Debit Card, COD, Net Banking
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items table: Stores line items for each order
CREATE TABLE IF NOT EXISTS order_items (
    item_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id        INTEGER NOT NULL,
    product_id      INTEGER NOT NULL,
    quantity        INTEGER NOT NULL DEFAULT 1,
    unit_price      REAL NOT NULL,
    discount        REAL NOT NULL DEFAULT 0,  -- Discount percentage (0-30)
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_customers_state ON customers(state);
