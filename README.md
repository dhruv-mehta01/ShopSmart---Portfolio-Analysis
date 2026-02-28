🛒 ShopSmart Analytics – SQL Data Analyst Portfolio Project

ShopSmart Analytics is an **end-to-end SQL Data Analytics project** built using a realistic **Indian e-commerce dataset**. The project demonstrates practical skills in **data exploration, SQL analytics, business insight generation, and data visualization**.

The analysis is performed using **SQLite and Python**, and the insights are presented through an **interactive Chart.js dashboard**. The dataset contains **500+ orders, 50 customers across 20+ Indian cities, and 30 products** across multiple categories.

This project was developed as part of a **B.Tech Computer Science (4th Semester) Data Analytics portfolio / internship preparation**.

---

📊 Project Overview

The dataset represents a simplified Indian e-commerce platform containing:

* **500+ orders**
* **50 customers**
* **30 products**
* **20+ cities across India**
* **5 product categories**

  * Electronics
  * Clothing
  * Home
  * Books
  * Sports

The goal of this project is to **analyze business performance using SQL** and convert raw transactional data into meaningful insights.

---

🗂 Database Schema
The project uses a **normalized relational schema with five tables**:

1. **Customers**
2. **Orders**
3. **Order_Items**
4. **Products**
5. **Payments**

This structure enables efficient joins and realistic business analysis.

---

🧠 SQL Analysis Structure

The SQL analysis is divided into **four progressive stages**.

1️⃣ Basic SQL Analysis

Focus on understanding the dataset.

Concepts used:

* `SELECT`
* `WHERE`
* `ORDER BY`
* `COUNT`
* `SUM`
* `AVG`

Examples:

* Total number of orders
* Total revenue generated
* Orders by city
* Most expensive products

---

2️⃣ Intermediate SQL Analysis

Concepts used:

* `GROUP BY`
* `HAVING`
* `INNER JOIN`
* `LEFT JOIN`

Examples:

* Revenue by category
* Top customers by spending
* Order distribution by city
* Category performance analysis

---

3️⃣ Advanced SQL Analysis

Concepts used:

* **Common Table Expressions (CTE)**
* **Window Functions**

  * `RANK()`
  * `DENSE_RANK()`
  * `LAG()`
  * `LEAD()`
* **Running totals**

Examples:

* Top products by revenue
* Monthly sales trend
* Customer purchase ranking
* Growth analysis

---

4️⃣ Business Intelligence Queries

Advanced analytics using SQL.

Concepts used:

* `CASE` statements
* Customer segmentation
* Cohort analysis
* Year-over-year growth

Customers are segmented into:

* **VIP Customers**
* **High Value**
* **Mid Value**
* **Low Value**

---

📈 Interactive Dashboard

All insights are visualized using a **dark-theme Chart.js dashboard**.

The dashboard contains **8 visualizations**:

1. Monthly Revenue Trend
2. Category Revenue Distribution
3. Top 10 Customers by Spending
4. Regional Revenue Distribution (North, South, East, West)
5. Order Status Distribution
6. Payment Method Analysis
7. Customer Segmentation Chart
8. Top Products (Revenue vs Quantity Sold)

---

🔍 Key Business Insights

The analysis revealed several important insights:

* **Electronics** is the highest revenue-generating category.
* **UPI accounts for ~40% of all payments**, showing strong adoption of digital payments in India.
* **West and South India generate the highest revenue**, mainly due to metro cities.
* **75% of orders are successfully completed**, with only **10% cancellations**.
* A **small VIP customer segment contributes a large portion of total revenue**, demonstrating the **Pareto Principle (80/20 rule)**.

---

💡 Business Recommendations

Based on the analysis:

* Expand the **Electronics product catalog**
* Introduce **loyalty programs for high-value customers**
* Improve **marketing efforts in the East region**
* Optimize inventory for **top-selling products**

---

🛠 Technologies Used

* **SQL (SQLite)**
* **Python**
* **Chart.js**
* **HTML / CSS / JavaScript**

---

📂 Project Structure

```
ShopSmart-Analytics
│
├── database
│   └── shopsmart.db
│
├── sql_queries
│   ├── 01_basic_analysis.sql
│   ├── 02_intermediate_analysis.sql
│   ├── 03_advanced_analysis.sql
│   └── 04_business_insights.sql
│
├── dashboard
│   ├── index.html
│   ├── style.css
│   └── charts.js
│
└── README.md
```

---

🎯 Skills Demonstrated

This project demonstrates proficiency in:

* SQL Query Writing
* Relational Database Design
* Data Cleaning & Exploration
* Business Data Analysis
* Window Functions
* Data Visualization
* Dashboard Development
* Data Storytelling

---

🚀 Future Improvements

Potential improvements for this project:

* Add **Power BI / Tableau dashboard**
* Deploy dashboard using **Streamlit**
* Expand dataset with **thousands of records**
* Add **predictive analytics (sales forecasting)**

---

👨‍💻 Author
DHRUV MEHTA
Computer Science Student, 
ICT-Ganpat university,Mehsana

---

