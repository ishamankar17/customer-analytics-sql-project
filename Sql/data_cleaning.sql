SELECT COUNT(*) AS total_rows
FROM online_retail;

CREATE TABLE online_retail_raw AS
SELECT *
FROM online_retail;

SELECT COUNT(*) AS total_rows
FROM online_retail_raw;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE invoice IS NULL) AS missing_invoice,
    COUNT(*) FILTER (WHERE stockcode IS NULL) AS missing_stockcode,
    COUNT(*) FILTER (WHERE description IS NULL) AS missing_description,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS missing_quantity,
    COUNT(*) FILTER (WHERE invoicedate IS NULL) AS missing_date,
    COUNT(*) FILTER (WHERE price IS NULL) AS missing_price,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer,
    COUNT(*) FILTER (WHERE country IS NULL) AS missing_country
FROM online_retail_raw;


SELECT
    COUNT(*) AS cancelled_rows
FROM online_retail_raw
WHERE invoice LIKE 'C%';

SELECT
    COUNT(*) AS negative_quantity_rows
FROM online_retail_raw
WHERE quantity < 0;

SELECT
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM online_retail_raw;

SELECT *
FROM online_retail_raw
WHERE price < 0
ORDER BY price
LIMIT 20;

SELECT
    COUNT(*) AS zero_price_rows
FROM online_retail_raw
WHERE price = 0;

SELECT
    stockcode,
    description,
    COUNT(*) AS occurrences
FROM online_retail_raw
WHERE price = 0
GROUP BY stockcode, description
ORDER BY occurrences DESC
LIMIT 20;


DROP TABLE IF EXISTS online_retail_clean;

CREATE TABLE online_retail_clean AS
SELECT
    invoice,
    stockcode,
    COALESCE(description, 'Unknown Product') AS description,
    quantity,
    invoicedate,
    price,
    customer_id,
    country,

    CASE
        WHEN invoice LIKE 'C%' OR quantity < 0 THEN 1
        ELSE 0
    END AS is_return,

    CASE
        WHEN invoice LIKE 'C%' THEN 1
        ELSE 0
    END AS is_cancelled,

    CASE
        WHEN price > 0 AND quantity > 0
        THEN quantity * price
        ELSE 0
    END AS revenue

FROM online_retail_raw;

SELECT COUNT(*) AS total_rows
FROM online_retail_clean;

SELECT *
FROM online_retail_clean
LIMIT 10;



SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (
        WHERE is_return = 1
    ) AS return_rows,

    COUNT(*) FILTER (
        WHERE is_cancelled = 1
    ) AS cancelled_rows,

    COUNT(*) FILTER (
        WHERE price > 0 AND quantity > 0
    ) AS valid_sales_rows,

    COUNT(*) FILTER (
        WHERE price = 0
    ) AS zero_price_rows,

    COUNT(*) FILTER (
        WHERE price < 0
    ) AS negative_price_rows,

    ROUND(SUM(revenue)::numeric, 2) AS total_revenue

FROM online_retail_clean;

SELECT
    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue,
    ROUND(AVG(revenue)::numeric, 2) AS avg_revenue
FROM online_retail_clean;

SELECT
    invoice,
    stockcode,
    description,
    quantity,
    invoicedate,
    price,
    customer_id,
    country,
    COUNT(*) AS duplicate_count
FROM online_retail_raw
GROUP BY
    invoice,
    stockcode,
    description,
    quantity,
    invoicedate,
    price,
    customer_id,
    country
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC
LIMIT 20;


SELECT
    COUNT(*) AS duplicate_groups,
    SUM(duplicate_count - 1) AS extra_duplicate_rows
FROM (
    SELECT
        invoice,
        stockcode,
        description,
        quantity,
        invoicedate,
        price,
        customer_id,
        country,
        COUNT(*) AS duplicate_count
    FROM online_retail_raw
    GROUP BY
        invoice,
        stockcode,
        description,
        quantity,
        invoicedate,
        price,
        customer_id,
        country
    HAVING COUNT(*) > 1
) d;

SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS rows_with_customer_id,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM online_retail_raw;

SELECT
    country,
    COUNT(*) AS transaction_rows,
    COUNT(DISTINCT invoice) AS orders,
    ROUND(SUM(
        CASE
            WHEN price > 0 AND quantity > 0
            THEN quantity * price
            ELSE 0
        END
    )::numeric, 2) AS revenue
FROM online_retail_raw
GROUP BY country
ORDER BY revenue DESC;


DROP TABLE IF EXISTS online_retail_clean;

CREATE TABLE online_retail_clean AS

SELECT DISTINCT
    invoice,
    stockcode,
    COALESCE(description, 'Unknown Product') AS description,
    quantity,
    invoicedate,
    price,
    customer_id,
    country,

    -- Return flag
    CASE
        WHEN quantity < 0 THEN 1
        ELSE 0
    END AS is_return,

    -- Cancellation flag
    CASE
        WHEN invoice LIKE 'C%' THEN 1
        ELSE 0
    END AS is_cancelled,

    -- Valid sales revenue
    CASE
        WHEN quantity > 0 AND price > 0
        THEN quantity * price
        ELSE 0
    END AS revenue

FROM online_retail_raw;


SELECT COUNT(*) AS clean_rows
FROM online_retail_clean;



SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE is_return = 1) AS return_rows,
    COUNT(*) FILTER (WHERE is_cancelled = 1) AS cancelled_rows,
    COUNT(*) FILTER (
        WHERE quantity > 0 AND price > 0
    ) AS valid_sales_rows,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM online_retail_clean;

CREATE INDEX idx_retail_customer
ON online_retail_clean(customer_id);

CREATE INDEX idx_retail_invoice
ON online_retail_clean(invoice);

CREATE INDEX idx_retail_date
ON online_retail_clean(invoicedate);

CREATE INDEX idx_retail_stockcode
ON online_retail_clean(stockcode);




