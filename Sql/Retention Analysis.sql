--First purchase month (Cohort)

SELECT
    customer_id,
    DATE_TRUNC('month', MIN(invoicedate)) AS cohort_month
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0 AND price > 0
  AND is_cancelled = 0
GROUP BY customer_id;

-----Customer purchase month
SELECT DISTINCT
    customer_id,
    DATE_TRUNC('month', invoicedate) AS purchase_month
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0 AND price > 0
  AND is_cancelled = 0;

--Cohort + purchase month
SELECT
    customer_id,
    DATE_TRUNC('month', MIN(invoicedate))
        OVER (PARTITION BY customer_id) AS cohort_month,
    DATE_TRUNC('month', invoicedate) AS purchase_month
FROM online_retail_clean
WHERE customer_id IS NOT NULL
  AND quantity > 0 AND price > 0
  AND is_cancelled = 0;

---Retention by cohort
WITH x AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(invoicedate))
            OVER (PARTITION BY customer_id) AS cohort_month,
        DATE_TRUNC('month', invoicedate) AS purchase_month
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
      AND quantity > 0 AND price > 0
      AND is_cancelled = 0
)
SELECT
    cohort_month,
    purchase_month,
    COUNT(DISTINCT customer_id) AS customers
FROM x
GROUP BY cohort_month, purchase_month
ORDER BY cohort_month, purchase_month;

---Retention month number
WITH x AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(invoicedate))
            OVER (PARTITION BY customer_id) AS cohort_month,
        DATE_TRUNC('month', invoicedate) AS purchase_month
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
      AND quantity > 0 AND price > 0
      AND is_cancelled = 0
)
SELECT
    cohort_month,
    purchase_month,
    COUNT(DISTINCT customer_id) AS customers,
    EXTRACT(MONTH FROM AGE(purchase_month, cohort_month))
        + 12 * EXTRACT(YEAR FROM AGE(purchase_month, cohort_month)) AS month_number
FROM x
GROUP BY cohort_month, purchase_month
ORDER BY cohort_month, purchase_month;

