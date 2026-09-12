--Rank Customers by Revenue

SELECT
    customer_id,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
GROUP BY customer_id
ORDER BY revenue_rank;

---customers by number of orders DENSE_RANK()
SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS total_orders,
    DENSE_RANK() OVER (
        ORDER BY COUNT(DISTINCT invoice) DESC
    ) AS order_rank
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
GROUP BY customer_id
ORDER BY order_rank;

---customer purchase by previous customer LAG()
SELECT
    customer_id,
    invoicedate,
    revenue,
    LAG(invoicedate) OVER (
        PARTITION BY customer_id
        ORDER BY invoicedate
    ) AS previous_purchase
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
ORDER BY customer_id, invoicedate;

---Days Between Purchases LAG()
SELECT
    customer_id,
    invoicedate,
    LAG(invoicedate) OVER (
        PARTITION BY customer_id
        ORDER BY invoicedate
    ) AS previous_purchase,
    invoicedate -
    LAG(invoicedate) OVER (
        PARTITION BY customer_id
        ORDER BY invoicedate
    ) AS days_between
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
ORDER BY customer_id, invoicedate;

----LEAD(): Next Purchase
SELECT
    customer_id,
    invoicedate,
    LEAD(invoicedate) OVER (
        PARTITION BY customer_id
        ORDER BY invoicedate
    ) AS next_purchase
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
ORDER BY customer_id, invoicedate;

----Running Revenue using SUM() OVER()

SELECT
    customer_id,
    invoicedate,
    revenue,
    SUM(revenue) OVER (
        PARTITION BY customer_id
        ORDER BY invoicedate
    ) AS cumulative_revenue
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
ORDER BY customer_id, invoicedate;

----ROW_NUMBER(): Number Each Customer's Purchases

SELECT
    customer_id,
    invoice,
    invoicedate,
    revenue,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY invoicedate
    ) AS purchase_number
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
ORDER BY customer_id, invoicedate;

----Find each customer's first purchase
WITH purchases AS (
    SELECT
        customer_id,
        invoice,
        invoicedate,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY invoicedate
        ) AS rn
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
      AND quantity > 0
      AND price > 0
      AND is_cancelled = 0
)
SELECT *
FROM purchases
WHERE rn = 1
ORDER BY invoicedate;

----Find each customer's latest purchase
WITH purchases AS (
    SELECT
        customer_id,
        invoice,
        invoicedate,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY invoicedate DESC
        ) AS rn
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
      AND quantity > 0
      AND price > 0
      AND is_cancelled = 0
)
SELECT *
FROM purchases
WHERE rn = 1
ORDER BY invoicedate DESC;

----Divide customers into 5 groups using NTILE()
SELECT
    customer_id,
    SUM(revenue) AS total_revenue,
    NTILE(5) OVER (
        ORDER BY SUM(revenue) DESC
    ) AS revenue_group
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
GROUP BY customer_id
ORDER BY revenue_group, total_revenue DESC;

---Rank customers within each country
SELECT
    country,
    customer_id,
    SUM(revenue) AS total_revenue,
    RANK() OVER (
        PARTITION BY country
        ORDER BY SUM(revenue) DESC
    ) AS country_rank
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
GROUP BY country, customer_id
ORDER BY country, country_rank;

--------Calculate each customer's total revenue and order count
SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS total_orders,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
GROUP BY customer_id
ORDER BY total_revenue DESC;


-----Calculate Recency
SELECT
    customer_id,
    MAX(invoicedate) AS last_purchase,
    CURRENT_DATE - MAX(invoicedate)::date AS recency_days
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
GROUP BY customer_id
ORDER BY recency_days;

-----Calculate Frequency
SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS frequency
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
GROUP BY customer_id
ORDER BY frequency DESC;

---Calculate Monetary Value
SELECT
    customer_id,
    ROUND(SUM(revenue)::numeric, 2) AS monetary
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
GROUP BY customer_id
ORDER BY monetary DESC;

-----Build the complete RFM table
SELECT
    customer_id,
    CURRENT_DATE - MAX(invoicedate)::date AS recency,
    COUNT(DISTINCT invoice) AS frequency,
    ROUND(SUM(revenue)::numeric, 2) AS monetary
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND price > 0
  AND is_cancelled = 0
GROUP BY customer_id
ORDER BY monetary DESC;

----Assign RFM scores
WITH rfm AS (
    SELECT
        customer_id,
        CURRENT_DATE - MAX(invoicedate)::date AS recency,
        COUNT(DISTINCT invoice) AS frequency,
        SUM(revenue) AS monetary
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
      AND quantity > 0
      AND price > 0
      AND is_cancelled = 0
    GROUP BY customer_id
)
SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency) AS f_score,
    NTILE(5) OVER (ORDER BY monetary) AS m_score
FROM rfm;

