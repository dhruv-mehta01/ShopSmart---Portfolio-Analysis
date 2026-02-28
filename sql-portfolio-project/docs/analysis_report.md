# ShopSmart Analytics — Analysis Report

## Executive Summary

This report presents the findings from analyzing ShopSmart's e-commerce dataset spanning **500 orders** across **50 customers**, **30 products**, and **4 geographical regions** in India from January 2024 to February 2026. The analysis uncovers revenue trends, customer behavior patterns, product performance, and regional insights to drive data-informed business decisions.

---

## 1. Revenue Overview

### Total Performance
- **Total Revenue (Net):** Generated from 500 orders with an average order value reflecting healthy basket sizes
- **Growth Trajectory:** Monthly revenue shows consistent activity across the analysis period
- **Profit Margins:** Electronics products command the highest absolute revenue while Books offer consistent volume

### Monthly Trends
Revenue follows typical e-commerce patterns with variations across months. The trend line reveals:
- Seasonal peaks during festival months
- Steady baseline revenue indicating a loyal customer base
- No significant revenue dips suggesting stable demand

---

## 2. Product Analysis

### Category Performance
Products are distributed across 5 categories:

| Category | Characteristics |
|----------|----------------|
| **Electronics** | Highest revenue per item, strong margins |
| **Clothing** | High volume, moderate margins |
| **Home** | Steady demand, good repeat purchase potential |
| **Books** | Lowest price point, highest unit volume |
| **Sports** | Niche but growing category |

### Key Product Findings
1. Premium electronics (Mechanical Keyboard, Laptop Stand) drive the highest per-unit revenue
2. Books have the lowest average price but contribute meaningfully through volume
3. Discount utilization varies — most orders (50%) have zero discount, suggesting strong pricing power

---

## 3. Customer Analysis

### Customer Segmentation (RFM-Inspired)
Using total spend and order frequency, customers fall into four segments:

| Segment | Criteria | Implication |
|---------|----------|-------------|
| **VIP** | >₹15K spend + >10 orders | Nurture with exclusive benefits |
| **High Value** | >₹8K spend | Upsell and cross-sell opportunities |
| **Mid Value** | >₹3K spend | Grow through targeted campaigns |
| **Low Value** | <₹3K spend | Re-engage or accept natural churn |

### Customer Insights
- Top 10 customers contribute a significant share of total revenue (Pareto principle)
- Customer acquisition is spread across Indian metros, with concentration in West and South
- Some customers have never placed an order — opportunity for activation campaigns

---

## 4. Regional Analysis

### Revenue by Region
| Region | Key Cities | Performance |
|--------|------------|-------------|
| **West** | Mumbai, Pune, Ahmedabad, Jaipur | Highest revenue — largest customer base |
| **South** | Bangalore, Chennai, Hyderabad | Strong second — tech-savvy customers |
| **North** | Delhi, Lucknow, Chandigarh | Growing market |
| **East** | Kolkata, Bhubaneswar, Patna | Emerging — room for growth |

---

## 5. Payment & Order Patterns

### Payment Methods
- **UPI dominates** at ~40%, reflecting India's digital payment revolution
- Credit and Debit cards together account for ~35%
- Cash on Delivery (COD) at ~15% shows declining but still relevant demand
- Net Banking at ~10% is the least preferred method

### Order Status
- **75% Completed** — healthy fulfillment rate
- **10% Pending** — opportunity to improve processing speed
- **10% Cancelled** — investigate friction points in the checkout flow
- **5% Returned** — acceptable return rate for e-commerce

---

## 6. Business Recommendations

1. **Double down on Electronics** — highest revenue category with strong margins; expand the catalog
2. **Launch a loyalty program** — reward VIP and High Value customers to increase retention
3. **Target East region** — lowest revenue but growing; invest in marketing and logistics
4. **Optimize UPI checkout** — since it's the most popular payment method, ensure seamless UPI experience
5. **Reduce cancellations** — investigate why 10% of orders are cancelled; consider better delivery estimates
6. **Bundle strategies** — cross-sell Books/Sports with Electronics to increase basket size

---

## 7. SQL Techniques Applied

This analysis was performed using progressively complex SQL queries:

- **Basic:** Data exploration, counting, filtering, sorting
- **Intermediate:** Multi-table JOINs, aggregations, date-based grouping
- **Advanced:** CTEs for readability, window functions for rankings and growth calculations
- **Expert:** Cohort analysis for retention, CASE-based segmentation, correlated subqueries

---

## Conclusion

ShopSmart's e-commerce data reveals a healthy business with strong product-market fit, particularly in Electronics and the Western region. The customer base shows clear segmentation patterns that can be leveraged for targeted marketing. Key areas for improvement include reducing cancellations, growing the Eastern market, and implementing a loyalty program for high-value customers.

*Analysis performed as part of SQL Data Analyst Portfolio Project — February 2026*
