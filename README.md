# Customer Analytics & Segmentation using SQL and Power BI

##  Project Overview
This project analyzes customer purchasing behavior for an online retail business using **PostgreSQL** and **Power BI**. Raw transaction data was cleaned and modeled in SQL, then transformed into an interactive 3-page Power BI dashboard covering sales performance, customer segmentation, and retention.

##  What I Did

**SQL (PostgreSQL)**
- Cleaned raw transaction data (duplicates, missing values, cancellations, returns)
- Built customer-level metrics: Recency, Frequency, Monetary (RFM)
- Used window functions (`RANK`, `DENSE_RANK`, `ROW_NUMBER`, `LAG`, `LEAD`, `NTILE`) for ranking and purchase-sequence analysis
- Performed cohort analysis to track retention by first-purchase month
- Created reusable views: `sales_summary`, `customer_rfm`, `product_performance`, `monthly_sales`

**Power BI**
- Built a star-schema data model with one fact table and four dimension tables
- Wrote DAX measures for KPIs (Revenue, AOV, Return Rate, etc.)
- Designed 3 interactive dashboard pages with slicers and cross-filtering

##  Dataset
**Online Retail II** — ~1M transaction records (invoice, product, quantity, price, customer, country) from a UK-based online retailer, covering 2009–2011.

##  Data Model
A star schema with `FactSales` at the center, linked to `DimDate`, `DimProduct`, `DimCustomer`, and `DimCountry`.

![Data Model](<img width="1226" height="640" alt="image" src="https://github.com/user-attachments/assets/23bfe1b8-1fdc-41b2-8587-4c36646b65e9" />

)

##  Dashboards

**1. Sales & Business Overview**
Tracks overall performance — revenue trend, orders, top countries, and top products.
![Sales Overview](images/sales_overview.png)

**2. Customer Analytics & Segmentation**
Segments customers into High/Medium/Low value groups using RFM, and visualizes purchase frequency and recency patterns.
![Customer Segmentation](images/customer_segmentation.png)

**3. Customer Retention & Cohort Analysis**
Shows how customer retention decays over time using a cohort retention heatmap.
![Retention & Cohorts](images/retention_cohorts.png)

##  Key Business Insights
- 5,878 customers generated **£20.48M** in revenue across 40K orders.
- **70% repeat customer rate**, but retention drops sharply after month 1 (from 100% to ~20–35%).
- A small **High Value** segment drives a disproportionate share of revenue, while **Low Value** customers make up the largest count.
- UK dominates revenue contribution, followed by a long tail of European countries.

##  Tech Stack
`PostgreSQL` · `SQL (CTEs, Window Functions, Views)` · `Power BI` · `DAX` · `Star Schema Modeling`

## 🔗 Links
- SQL Scripts: [Add link]
- Power BI File (.pbix): [Add link]


