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

<img width="900" height="400" alt="image" src="https://github.com/user-attachments/assets/23bfe1b8-1fdc-41b2-8587-4c36646b65e9" />



##  Dashboards

**1. Sales & Business Overview**
Tracks overall performance — revenue trend, orders, top countries, and top products.

<img width="1321" height="741" alt="image" src="https://github.com/user-attachments/assets/df231590-3474-49bd-8376-ac0f54a6917c" />


**2. Customer Analytics & Segmentation**
Segments customers into High/Medium/Low value groups using RFM, and visualizes purchase frequency and recency patterns.

<img width="1322" height="742" alt="image" src="https://github.com/user-attachments/assets/b3d67384-23e5-4156-87fa-5b9905e0b86e" />


**3. Customer Retention & Cohort Analysis**
Shows how customer retention decays over time using a cohort retention heatmap.

<img width="1325" height="746" alt="image" src="https://github.com/user-attachments/assets/cb03fdce-80d9-40ab-9446-33a2df15755c" />

##  Key Business Insights

**Revenue & Sales**
- 5,878 customers generated **£20.48M** in revenue across ~40K orders, at an average order value of **£510.92**.
- The **UK** contributes the vast majority of revenue, with the remaining ~43 countries forming a long tail.
- Revenue grew steadily through 2011, with a sharp spike in the final months of the year.
- 
**Customer Value**
- Customers split into **High, Medium, and Low Value** segments based on RFM. High Value customers are a small share of the base but account for a disproportionate share of revenue.
- **70% repeat customer rate** — most customers return at least once after their first purchase.
- 
**Retention**
- Retention drops sharply after the first month across every cohort (from 100% down to roughly 20–35% by month 1), then declines more gradually.
- Later cohorts (2011) retain worse than earlier ones (2009), suggesting retention has weakened over time rather than being a one-off dip — worth investigating further.
**So what:** the business should focus retention efforts in the first 30 days after a customer's initial purchase, and prioritize the High Value segment for loyalty/marketing spend since it drives outsized revenue.

##  Tech Stack
`PostgreSQL` · `SQL (CTEs, Window Functions, Views)` · `Power BI` · `DAX` · `Star Schema Modeling`



