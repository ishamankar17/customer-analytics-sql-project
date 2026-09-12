CREATE OR REPLACE VIEW customer_rfm AS
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
GROUP BY customer_id;

SELECT * FROM customer_rfm LIMIT 10;

-----Champions
SELECT * FROM customer_rfm
WHERE recency <= 30 AND frequency >= 10 AND monetary >= 1000;

-----Loyal Customers
SELECT * FROM customer_rfm
WHERE recency <= 90 AND frequency >= 5

----Potential Loyalists
SELECT * FROM customer_rfm
WHERE recency <= 60 AND frequency BETWEEN 2 AND 4;

----At Risk
SELECT * FROM customer_rfm
WHERE recency BETWEEN 90 AND 180
  AND frequency >= 3;

---Lost Customers
SELECT * FROM customer_rfm
WHERE recency > 180 AND frequency <= 2;
