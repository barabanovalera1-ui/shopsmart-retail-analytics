
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