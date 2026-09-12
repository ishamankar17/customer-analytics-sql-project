--- Total Sales KPIs

SELECT
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue,

    COUNT(DISTINCT invoice) FILTER (
        WHERE is_cancelled = 0
          AND quantity > 0
          AND price > 0
    ) AS total_orders,

    COUNT(DISTINCT stockcode) FILTER (
        WHERE quantity > 0
          AND price > 0
    ) AS total_products,

    COUNT(DISTINCT customer_id) FILTER (
        WHERE customer_id IS NOT NULL
          AND quantity > 0
          AND price > 0
    ) AS total_customers,

    ROUND(
        (SUM(revenue) /
        NULLIF(
            COUNT(DISTINCT invoice) FILTER (
                WHERE is_cancelled = 0
                  AND quantity > 0
                  AND price > 0
            ), 0
        ))::numeric,
        2
    ) AS average_order_value

FROM online_retail_clean;


---Monthly Revenue Trend
SELECT
    DATE_TRUNC('month', invoicedate)::date AS month,
    ROUND(SUM(revenue)::numeric, 2) AS revenue,
    COUNT(DISTINCT invoice) FILTER (
        WHERE is_cancelled = 0
          AND quantity > 0
          AND price > 0
    ) AS orders
FROM online_retail_clean
GROUP BY DATE_TRUNC('month', invoicedate)
ORDER BY month;


----Yearly Revenue

SELECT
    EXTRACT(YEAR FROM invoicedate)::int AS year,
    ROUND(SUM(revenue)::numeric, 2) AS revenue,
    COUNT(DISTINCT invoice) FILTER (
        WHERE is_cancelled = 0
          AND quantity > 0
          AND price > 0
    ) AS orders
FROM online_retail_clean
GROUP BY EXTRACT(YEAR FROM invoicedate)
ORDER BY year;

-----Top 10 Products by Revenue

SELECT
    stockcode,
    description,
    SUM(quantity) AS units_sold,
    ROUND(SUM(revenue)::numeric, 2) AS revenue,
    COUNT(DISTINCT invoice) AS orders
FROM online_retail_clean
WHERE quantity > 0
  AND price > 0
  AND is_cancelled = 0
GROUP BY stockcode, description
ORDER BY revenue DESC
LIMIT 10;



--------Top 10 Countries by Revenue
SELECT
    country,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(quantity) AS units_sold,
    ROUND(SUM(revenue)::numeric, 2) AS revenue
FROM online_retail_clean
WHERE quantity > 0
  AND price > 0
  AND is_cancelled = 0
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;

------Return & Cancellation Analysis
SELECT
    SUM(CASE WHEN is_return = 1 THEN 1 ELSE 0 END) AS return_rows,
    SUM(CASE WHEN is_cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_rows,

    SUM(CASE
        WHEN is_return = 1 THEN ABS(quantity)
        ELSE 0
    END) AS returned_units,

    ROUND(SUM(CASE
        WHEN is_return = 1 THEN ABS(quantity * price)
        ELSE 0
    END)::numeric, 2) AS returned_value,

    COUNT(DISTINCT invoice) FILTER (
        WHERE is_cancelled = 1
    ) AS cancelled_orders

FROM online_retail_clean;

----return rate
SELECT
    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE is_return = 1)
        / NULLIF(COUNT(*), 0),
        2
    ) AS return_row_rate,

    ROUND(
        100.0 *
        COUNT(DISTINCT invoice) FILTER (WHERE is_cancelled = 1)
        /
        NULLIF(
            COUNT(DISTINCT invoice) FILTER (
                WHERE quantity > 0
                  AND price > 0
            ),
            0
        ),
        2
    ) AS cancellation_rate
FROM online_retail_clean;

