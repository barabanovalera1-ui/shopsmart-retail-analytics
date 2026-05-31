
-- ShopSmart Israel | SQL Analysis
-- Analyst: Valeria Barabanova
-- Date: 2024
-- Tools: SQL Server (SSMS)


USE ShopSmart;


-- 1. REVENUE BY CATEGORY
-- Business question: Which category generates the most revenue?

SELECT 
    category,
    COUNT(order_id)        AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM orders
GROUP BY category
ORDER BY total_revenue DESC;


-- 2. REVENUE BY REGION
-- Business question: Which region leads in sales?

SELECT 
    region,
    COUNT(order_id)        AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_order_value
FROM orders
GROUP BY region
ORDER BY total_revenue DESC;


-- 3. MONTHLY REVENUE TREND
-- Business question: How does revenue change over time?

SELECT 
    YEAR(order_date)  AS year,
    MONTH(order_date) AS month,
    COUNT(order_id)   AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);


-- 4. TOP 10 CUSTOMERS BY REVENUE
-- Business question: Who are our most valuable customers?

SELECT TOP 10
    o.customer_id,
    c.loyalty_tier,
    c.region,
    COUNT(o.order_id)      AS total_orders,
    ROUND(SUM(o.revenue), 2) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.loyalty_tier, c.region
ORDER BY total_revenue DESC;


-- 5. CUSTOMER ORDER FREQUENCY
-- Business question: How often do customers purchase?

SELECT 
    customer_id,
    COUNT(order_id)        AS total_orders,
    ROUND(AVG(revenue), 2) AS avg_order_value,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;


-- 6. REVENUE PRICE RANGE BY CATEGORY
-- Business question: What is the min and max order value per category?

SELECT 
    category,
    ROUND(MIN(revenue), 2) AS min_revenue,
    ROUND(MAX(revenue), 2) AS max_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue
FROM orders
GROUP BY category
ORDER BY avg_revenue DESC;


-- 7. RETURNS BY CATEGORY
-- Business question: Which category has the most returns?

SELECT 
    o.category,
    COUNT(r.return_id)        AS total_returns,
    ROUND(SUM(r.return_amount), 2) AS total_return_amount
FROM orders o
JOIN returns r ON o.order_id = r.order_id
GROUP BY o.category
ORDER BY total_returns DESC;


-- 8. RETURN RATE BY CATEGORY
-- Business question: What percentage of orders are returned per category?

SELECT 
    o.category,
    COUNT(o.order_id)  AS total_orders,
    COUNT(r.return_id) AS total_returns,
    ROUND(COUNT(r.return_id) * 100.0 / COUNT(o.order_id), 2) AS return_rate_pct
FROM orders o
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY o.category
ORDER BY return_rate_pct DESC;


-- 9. REVENUE BY CHANNEL
-- Business question: Which sales channel performs best?

SELECT 
    channel,
    COUNT(order_id)        AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_order_value
FROM orders
GROUP BY channel
ORDER BY total_revenue DESC;


-- 10. CUSTOMER SEGMENTATION BY ORDER VALUE
-- Business question: How can we classify orders by size?

SELECT 
    order_id,
    revenue,
    CASE 
        WHEN revenue > 500 THEN 'High Value'
        WHEN revenue > 200 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_segment
FROM orders
ORDER BY revenue DESC;
-- 11. TOP 3 CUSTOMERS PER REGION
-- Business question: Who are the top 3 most valuable customers in each region?
-- Technique: CTE + Window Function (ROW_NUMBER + PARTITION BY)
WITH customer_revenue AS (
    -- Step 1: Calculate total revenue per customer
    SELECT 
        o.customer_id,
        c.region,
        ROUND(SUM(o.revenue), 2) AS total_revenue
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.region
),
ranked_customers AS (
    -- Step 2: Rank customers within each region
    SELECT 
        customer_id,
        region,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY region       -- restart ranking for each region
            ORDER BY total_revenue DESC
        ) AS rank_in_region
    FROM customer_revenue
)
-- Step 3: Show only top 3 per region
SELECT 
    region,
    customer_id,
    total_revenue,
    rank_in_region
FROM ranked_customers
WHERE rank_in_region <= 3
ORDER BY region, rank_in_region;


-- 12. MONTH OVER MONTH REVENUE GROWTH
-- Business question: How is revenue growing or declining each month?
-- Technique: CTE + Window Function (LAG)
WITH monthly_revenue AS (
    -- Step 1: Calculate total revenue per month
    SELECT 
        YEAR(order_date)       AS year,
        MONTH(order_date)      AS month,
        ROUND(SUM(revenue), 2) AS total_revenue
    FROM orders
    GROUP BY YEAR(order_date), MONTH(order_date)
)
-- Step 2: Compare each month to previous month using LAG
SELECT 
    year,
    month,
    total_revenue,
    LAG(total_revenue) OVER (
        ORDER BY year, month   -- look at previous month
    ) AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year, month))
        * 100.0 /
        LAG(total_revenue) OVER (ORDER BY year, month),
    2) AS mom_growth_pct       -- Month over Month growth %
FROM monthly_revenue
ORDER BY year, month;


-- 13. RUNNING TOTAL REVENUE
-- Business question: What is our cumulative revenue over time?
-- Technique: Window Function (SUM OVER)
WITH monthly_revenue AS (
    -- Step 1: Calculate revenue per month
    SELECT 
        YEAR(order_date)       AS year,
        MONTH(order_date)      AS month,
        ROUND(SUM(revenue), 2) AS total_revenue
    FROM orders
    GROUP BY YEAR(order_date), MONTH(order_date)
)
-- Step 2: Add running total column
SELECT 
    year,
    month,
    total_revenue,
    ROUND(SUM(total_revenue) OVER (
        ORDER BY year, month   -- accumulate month by month
    ), 2) AS running_total
FROM monthly_revenue
ORDER BY year, month;


-- 14. CUSTOMER ORDER RANKING
-- Business question: What is the rank of each customer by total revenue?
-- Technique: Window Function (RANK)
SELECT 
    customer_id,
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(order_id)        AS total_orders,
    RANK() OVER (
        ORDER BY SUM(revenue) DESC   -- rank 1 = highest revenue customer
    ) AS customer_rank
FROM orders
GROUP BY customer_id
ORDER BY customer_rank;


-- 15. COHORT ANALYSIS — FIRST PURCHASE MONTH
-- Business question: Do customers who joined in certain months spend more?
-- Technique: CTE + Window Function (MIN OVER)
WITH customer_first_order AS (
    -- Step 1: Find each customer's first purchase month
    SELECT 
        customer_id,
        MIN(order_date)                    AS first_order_date,
        YEAR(MIN(order_date))              AS cohort_year,
        MONTH(MIN(order_date))             AS cohort_month
    FROM orders
    GROUP BY customer_id
),
cohort_data AS (
    -- Step 2: Join orders with cohort info
    SELECT 
        o.customer_id,
        o.order_date,
        o.revenue,
        c.cohort_year,
        c.cohort_month
    FROM orders o
    JOIN customer_first_order c ON o.customer_id = c.customer_id
)
-- Step 3: Aggregate by cohort
SELECT 
    cohort_year,
    cohort_month,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(revenue), 2)      AS total_revenue,
    ROUND(AVG(revenue), 2)      AS avg_revenue_per_order
FROM cohort_data
GROUP BY cohort_year, cohort_month
ORDER BY cohort_year, cohort_month;


-- 16. RFM SEGMENTATION
-- Business question: Who are our best, at-risk, and lost customers?
-- Technique: CTE + CASE WHEN segmentation
-- RFM = Recency (last purchase), Frequency (order count), Monetary (total spend)
WITH rfm_base AS (
    -- Step 1: Calculate RFM metrics per customer
    SELECT 
        customer_id,
        DATEDIFF(day, MAX(order_date), '2024-12-31') AS recency_days,  -- days since last order
        COUNT(order_id)                               AS frequency,      -- number of orders
        ROUND(SUM(revenue), 2)                        AS monetary        -- total spend
    FROM orders
    GROUP BY customer_id
),
rfm_scored AS (
    -- Step 2: Score each metric 1-3
    SELECT 
        customer_id,
        recency_days,
        frequency,
        monetary,
        CASE 
            WHEN recency_days <= 90  THEN 3   -- recent buyer
            WHEN recency_days <= 180 THEN 2   -- moderate
            ELSE 1                            -- inactive
        END AS recency_score,
        CASE 
            WHEN frequency >= 10 THEN 3       -- frequent buyer
            WHEN frequency >= 5  THEN 2       -- moderate
            ELSE 1                            -- rare
        END AS frequency_score,
        CASE 
            WHEN monetary >= 5000 THEN 3      -- high spender
            WHEN monetary >= 2000 THEN 2      -- moderate
            ELSE 1                            -- low spender
        END AS monetary_score
    FROM rfm_base
)
-- Step 3: Classify customers into segments
SELECT 
    customer_id,
    recency_days,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    recency_score + frequency_score + monetary_score AS rfm_total,
    CASE 
        WHEN recency_score + frequency_score + monetary_score >= 8 THEN 'Champion'
        WHEN recency_score + frequency_score + monetary_score >= 6 THEN 'Loyal Customer'
        WHEN recency_score + frequency_score + monetary_score >= 4 THEN 'At Risk'
        ELSE 'Lost Customer'
    END AS customer_segment
FROM rfm_scored
ORDER BY rfm_total DESC;
