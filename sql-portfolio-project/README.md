# ShopSmart Analytics — SQL Data Analyst Portfolio Project

> A comprehensive e-commerce sales analysis project demonstrating beginner-to-advanced SQL skills, built with SQLite and an interactive Chart.js dashboard.

![SQL](https://img.shields.io/badge/SQL-SQLite-blue?style=flat-square&logo=sqlite)
![Python](https://img.shields.io/badge/Python-3.x-green?style=flat-square&logo=python)
![Chart.js](https://img.shields.io/badge/Charts-Chart.js-ff6384?style=flat-square)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat-square)

---

## About

This project analyzes a **realistic e-commerce dataset** (ShopSmart) spanning customers, products, orders, and regions across India. It demonstrates SQL proficiency from basic `SELECT` statements to advanced window functions and cohort analysis, with all results visualized in a stunning interactive dashboard.

**Built as a portfolio project for a CSE internship (4th Semester).**

---

## Tech Stack

| Technology | Purpose |
|-----------|---------|
| **SQLite** | Relational database |
| **Python 3** | Data generation & export |
| **HTML/CSS/JS** | Interactive dashboard |
| **Chart.js** | Data visualizations |

---

## Project Structure

```
sql-portfolio-project/
├── database/
│   ├── schema.sql          # Table definitions (5 tables)
│   ├── setup.py            # Creates DB + generates seed data
│   └── shop_smart.db       # SQLite database (auto-generated)
├── queries/
│   ├── 01_basic_exploration.sql    # SELECT, WHERE, ORDER BY
│   ├── 02_aggregations.sql         # GROUP BY, HAVING, date functions
│   ├── 03_joins_and_subqueries.sql # JOINs, LEFT JOINs, subqueries
│   └── 04_advanced_analytics.sql   # CTEs, Window Functions, Cohort
├── dashboard/
│   ├── index.html          # Main dashboard page
│   ├── styles.css          # Dark-theme glassmorphism design
│   ├── app.js              # Chart.js visualizations
│   ├── data.js             # Pre-computed query results
│   └── export_data.py      # Exports SQL results → JS
├── docs/
│   └── analysis_report.md  # Detailed findings & recommendations
└── README.md
```

---

## Database Schema

```
regions ──────── customers ──────── orders ──────── order_items ──────── products
(state, region)  (id, name,        (id, customer,  (id, order,         (id, name,
                  email, city,      date, status,   product, qty,       category,
                  state, join_date) payment)        price, discount)    price, cost)
```

**Data Summary:**
- **21** Indian states/regions
- **50** customers across major cities
- **30** products in 5 categories
- **500** orders (Jan 2024 – Feb 2026)
- **860+** order line items

---

## SQL Skills Demonstrated

| Level | Concepts |
|-------|----------|
| **Beginner** | SELECT, WHERE, ORDER BY, LIMIT, DISTINCT, COUNT |
| **Intermediate** | GROUP BY, HAVING, SUM, AVG, Date functions, Multi-table JOINs |
| **Advanced** | LEFT JOIN, Subqueries, Correlated subqueries |
| **Expert** | CTEs (WITH), Window Functions (RANK, LAG/LEAD), Running Totals, CASE segmentation, Cohort Analysis, PARTITION BY |

---

## Key Insights Discovered

1. **Electronics** is the highest revenue category, driven by premium products like keyboards and laptop stands
2. **UPI** is the dominant payment method (~40% of orders), reflecting India's digital payment adoption
3. **West and South** regions generate the highest revenue, aligned with metro city customer concentration
4. **~75%** of orders are completed successfully, with only 10% cancellation rate
5. **Customer segmentation** reveals a small VIP segment driving disproportionate revenue

---

## How to Run

### 1. Set up the database
```bash
python database/setup.py
```

### 2. Run SQL queries (optional — explore interactively)
```bash
sqlite3 database/shop_smart.db < queries/01_basic_exploration.sql
```

### 3. Export data for dashboard
```bash
python dashboard/export_data.py
```

### 4. Open the dashboard
Open `dashboard/index.html` in any web browser.

---

## Dashboard Features

- **4 KPI Cards** — Total Revenue, Orders, Customers, Avg Order Value
- **Monthly Revenue Trend** — Line chart with gradient fill
- **Category Breakdown** — Doughnut chart
- **Top 10 Customers** — Horizontal bar chart
- **Regional Revenue** — Polar area chart
- **Order Status & Payment Methods** — Distribution charts
- **Customer Segments** — Pie chart (VIP/High/Mid/Low value)
- **Top Products** — Dual-axis bar chart (Revenue + Quantity)

---

## Author

**Dhruv** — B.Tech CSE, 4th Semester  
SQL Data Analyst Portfolio Project | 2026
