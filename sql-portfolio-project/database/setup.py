"""
ShopSmart Analytics — Database Setup Script
Creates the SQLite database, schema, and generates realistic seed data.
"""
import sqlite3
import random
import os
from datetime import datetime, timedelta

DB_PATH = os.path.join(os.path.dirname(__file__), 'shop_smart.db')
SCHEMA_PATH = os.path.join(os.path.dirname(__file__), 'schema.sql')

# --- Seed Data Definitions ---
REGIONS = {
    'Maharashtra': 'West', 'Gujarat': 'West', 'Rajasthan': 'West', 'Goa': 'West',
    'Karnataka': 'South', 'Tamil Nadu': 'South', 'Kerala': 'South', 'Andhra Pradesh': 'South', 'Telangana': 'South',
    'Delhi': 'North', 'Uttar Pradesh': 'North', 'Punjab': 'North', 'Haryana': 'North', 'Himachal Pradesh': 'North',
    'West Bengal': 'East', 'Odisha': 'East', 'Bihar': 'East', 'Jharkhand': 'East', 'Assam': 'East',
    'Madhya Pradesh': 'West', 'Chhattisgarh': 'East'
}

CITIES = {
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'], 'Gujarat': ['Ahmedabad', 'Surat'],
    'Rajasthan': ['Jaipur', 'Udaipur'], 'Goa': ['Panaji'], 'Karnataka': ['Bangalore', 'Mysore'],
    'Tamil Nadu': ['Chennai', 'Coimbatore'], 'Kerala': ['Kochi', 'Thiruvananthapuram'],
    'Andhra Pradesh': ['Visakhapatnam', 'Vijayawada'], 'Telangana': ['Hyderabad'],
    'Delhi': ['New Delhi'], 'Uttar Pradesh': ['Lucknow', 'Noida', 'Varanasi'],
    'Punjab': ['Chandigarh', 'Amritsar'], 'Haryana': ['Gurugram', 'Faridabad'],
    'Himachal Pradesh': ['Shimla'], 'West Bengal': ['Kolkata', 'Siliguri'],
    'Odisha': ['Bhubaneswar'], 'Bihar': ['Patna'], 'Jharkhand': ['Ranchi'],
    'Assam': ['Guwahati'], 'Madhya Pradesh': ['Bhopal', 'Indore'], 'Chhattisgarh': ['Raipur']
}

FIRST_NAMES = ['Aarav','Vivaan','Aditya','Vihaan','Arjun','Sai','Reyansh','Ayaan','Krishna','Ishaan',
               'Ananya','Diya','Myra','Sara','Aanya','Aadhya','Isha','Pari','Riya','Kiara',
               'Rohan','Priya','Neha','Amit','Sneha','Rahul','Pooja','Vikram','Meera','Karan',
               'Nisha','Raj','Divya','Aryan','Tanvi','Sahil','Shreya','Dev','Kavya','Manish',
               'Ritika','Akash','Simran','Gaurav','Aarohi','Harsh','Tanya','Nikhil','Avni','Varun']

LAST_NAMES = ['Sharma','Patel','Singh','Kumar','Gupta','Reddy','Joshi','Mehta','Shah','Nair',
              'Iyer','Rao','Das','Bose','Pillai','Verma','Yadav','Mishra','Chauhan','Agarwal',
              'Jain','Kapoor','Malhotra','Banerjee','Mukherjee']

PRODUCTS = [
    ('Wireless Bluetooth Earbuds', 'Electronics', 1499, 800), ('Smartphone Case (Premium)', 'Electronics', 799, 300),
    ('USB-C Fast Charger', 'Electronics', 999, 450), ('Portable Power Bank 10000mAh', 'Electronics', 1299, 650),
    ('Wireless Mouse', 'Electronics', 599, 250), ('Laptop Stand Adjustable', 'Electronics', 1899, 900),
    ('LED Desk Lamp', 'Electronics', 1199, 550), ('Mechanical Keyboard', 'Electronics', 2999, 1500),
    ('Cotton T-Shirt (Round Neck)', 'Clothing', 499, 180), ('Denim Jeans (Slim Fit)', 'Clothing', 1299, 500),
    ('Casual Sneakers', 'Clothing', 1999, 850), ('Hooded Sweatshirt', 'Clothing', 899, 350),
    ('Formal Shirt (Cotton)', 'Clothing', 799, 310), ('Track Pants', 'Clothing', 599, 220),
    ('Stainless Steel Water Bottle', 'Home', 399, 150), ('Scented Candle Set (3-Pack)', 'Home', 699, 250),
    ('Bamboo Cutting Board', 'Home', 549, 200), ('Ceramic Coffee Mug Set', 'Home', 899, 350),
    ('Bedsheet Set (King Size)', 'Home', 1499, 600), ('Wall Clock (Modern Design)', 'Home', 799, 300),
    ('The Psychology of Money', 'Books', 349, 150), ('Atomic Habits', 'Books', 399, 170),
    ('Sapiens: A Brief History', 'Books', 499, 220), ('Rich Dad Poor Dad', 'Books', 299, 120),
    ('The Alchemist', 'Books', 250, 100), ('Deep Work', 'Books', 350, 140),
    ('Yoga Mat (6mm Premium)', 'Sports', 799, 300), ('Resistance Bands Set', 'Sports', 499, 180),
    ('Skipping Rope (Adjustable)', 'Sports', 299, 100), ('Cricket Tennis Ball (Pack of 6)', 'Sports', 199, 70)
]

STATUSES = ['Completed'] * 75 + ['Pending'] * 10 + ['Cancelled'] * 10 + ['Returned'] * 5
PAYMENT_METHODS = ['UPI'] * 40 + ['Credit Card'] * 20 + ['Debit Card'] * 15 + ['COD'] * 15 + ['Net Banking'] * 10

def random_date(start_str, end_str):
    start = datetime.strptime(start_str, '%Y-%m-%d')
    end = datetime.strptime(end_str, '%Y-%m-%d')
    return start + timedelta(days=random.randint(0, (end - start).days))

def setup_database():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
    
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()

    # Execute schema
    with open(SCHEMA_PATH, 'r') as f:
        cur.executescript(f.read())

    # Insert regions
    for state, region in REGIONS.items():
        cur.execute("INSERT INTO regions (state, region) VALUES (?, ?)", (state, region))

    # Insert customers (50)
    random.seed(42)
    states = list(CITIES.keys())
    used_emails = set()
    for i in range(50):
        fn = FIRST_NAMES[i]
        ln = random.choice(LAST_NAMES)
        email = f"{fn.lower()}.{ln.lower()}{random.randint(1,99)}@{'gmail.com' if random.random() > 0.3 else 'yahoo.com'}"
        while email in used_emails:
            email = f"{fn.lower()}.{ln.lower()}{random.randint(1,999)}@gmail.com"
        used_emails.add(email)
        state = random.choice(states)
        city = random.choice(CITIES[state])
        phone = f"+91-{random.randint(70000,99999)}{random.randint(10000,99999)}"
        join_date = random_date('2023-06-01', '2025-12-31').strftime('%Y-%m-%d')
        cur.execute("INSERT INTO customers (first_name,last_name,email,phone,city,state,join_date) VALUES (?,?,?,?,?,?,?)",
                    (fn, ln, email, phone, city, state, join_date))

    # Insert products (30)
    for name, cat, price, cost in PRODUCTS:
        stock = random.randint(20, 500)
        cur.execute("INSERT INTO products (product_name,category,price,cost_price,stock_quantity) VALUES (?,?,?,?,?)",
                    (name, cat, price, cost, stock))

    # Insert orders (500) and order_items (~1200)
    for _ in range(500):
        cust_id = random.randint(1, 50)
        order_date = random_date('2024-01-01', '2026-02-28').strftime('%Y-%m-%d')
        status = random.choice(STATUSES)
        shipping = round(random.choice([0, 0, 0, 49, 79, 99, 149]), 2)
        payment = random.choice(PAYMENT_METHODS)
        cur.execute("INSERT INTO orders (customer_id,order_date,status,shipping_cost,payment_method) VALUES (?,?,?,?,?)",
                    (cust_id, order_date, status, shipping, payment))
        order_id = cur.lastrowid

        num_items = random.choices([1, 2, 3, 4], weights=[50, 30, 15, 5])[0]
        chosen_products = random.sample(range(1, 31), num_items)
        for pid in chosen_products:
            qty = random.choices([1, 2, 3], weights=[60, 30, 10])[0]
            base_price = PRODUCTS[pid - 1][2]
            discount = random.choices([0, 5, 10, 15, 20], weights=[50, 20, 15, 10, 5])[0]
            cur.execute("INSERT INTO order_items (order_id,product_id,quantity,unit_price,discount) VALUES (?,?,?,?,?)",
                        (order_id, pid, qty, base_price, discount))

    conn.commit()
    
    # Print summary
    for table in ['regions', 'customers', 'products', 'orders', 'order_items']:
        count = cur.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
        print(f"  [OK] {table}: {count} rows")
    
    conn.close()
    print(f"\n[SUCCESS] Database created at: {DB_PATH}")

if __name__ == '__main__':
    print("[*] Setting up ShopSmart Analytics Database...\n")
    setup_database()
