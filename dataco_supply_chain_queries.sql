/*
----------------------------------------------------------------------
PROJECT: DataCo Supply Chain Analytics using SQL

DESCRIPTION:
This SQL project analyzes a real-world supply chain dataset
to extract business insights related to customer behavior,
product performance, profitability, shipping efficiency,
and overall business performance.

TOOLS USED:
• MySQL
• Aggregate Functions
• CASE Statements
• CTEs
• Window Functions (DENSE_RANK)
• Date Functions
• Business KPI Reporting
----------------------------------------------------------------------
*/
-- Requires table 'dataco_cleaned' loaded from DataCo_Cleaned.csv (see README for load steps)
USE dataco;
# Query 1:
#Business Objective
-- Identify the highest revenue-generating customers to support customer relationship management, targeted marketing campaigns, and VIP customer retention strategies.
SELECT
`Customer Id`,
SUM(Sales) as total_revenue from dataco_cleaned
group by `Customer Id`
order by total_revenue desc
limit 10;
#Key Insights
-- The report highlights customers who contribute the largest share of total revenue. These high-value customers can be prioritized for loyalty programs and personalized marketing initiatives to maximize long-term profitability.

# Query 2:
#Business Objective
-- Determine which customers contribute the highest profits rather than just high sales revenue.
SELECT 
`Customer Id`,
SUM(`Order Profit Per Order`) as total_profit from dataco_cleaned
group by `Customer Id`
order by total_profit desc
limit 10;
#Key Insights
-- High revenue does not always translate into high profitability. This analysis helps identify customers who generate the greatest financial returns and supports more profitable customer acquisition and retention decisions.

# Query 3:
#Business Objective
-- Evaluate profitability across countries by comparing profit generated relative to sales revenue.
SELECT
    `Order Country`,
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`),2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`) * 100 / SUM(Sales),
        2
    ) AS profit_margin
FROM dataco_cleaned
GROUP BY `Order Country`
HAVING SUM(Sales) > 100000
ORDER BY profit_margin DESC
limit 15;
#Key Insight
-- Countries with the highest sales are not always the most profitable. Profit margin analysis helps identify markets with stronger financial performance and supports decisions related to pricing, expansion, and resource allocation.

# Query 4:
#Business Objective
-- Compare the contribution of different customer segments in terms of sales, profit, order volume, and average order value.
SELECT
    `Customer Segment`,
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`),2) AS total_profit,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(AVG(Sales),2) AS avg_order_value
FROM dataco_cleaned
GROUP BY `Customer Segment`
ORDER BY total_sales DESC;
#Key Insight
-- The analysis identifies the most valuable customer segment, enabling businesses to focus marketing efforts, optimize product offerings, and allocate resources more effectively.

# Query 5:
#Business Objective
-- Assess the efficiency and profitability of different shipping modes by comparing delivery times, delays, and profit generated.
SELECT
    `Shipping Mode`,
    COUNT(*) AS total_orders,
    ROUND(AVG(`Days for shipping (real)`),2) AS avg_actual_days,
    ROUND(AVG(`Days for shipment (scheduled)`),2) AS avg_scheduled_days,
    ROUND(AVG(`Days for shipping (real)` - `Days for shipment (scheduled)`),2) AS avg_delay,
    ROUND(SUM(Late_delivery_risk) * 100.0 / COUNT(*), 2) AS pct_late_orders,
    ROUND(SUM(`Order Profit Per Order`),2) AS total_profit
FROM dataco_cleaned
GROUP BY `Shipping Mode`
ORDER BY total_profit DESC;
#Key Insight
-- Shipping modes with shorter delivery times and higher profitability provide better operational performance. The analysis helps optimize logistics strategies and improve customer satisfaction.

# Query 6:
#Business Objective
-- Analyze monthly business performance by tracking sales, profit, and order volume over time.
SELECT
    YEAR(`order date (DateOrders)`) AS order_year,
    MONTH(`order date (DateOrders)`) AS month_no,
    MONTHNAME(`order date (DateOrders)`) AS month_name,
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`),2) AS total_profit,
    COUNT(DISTINCT `Order Id`) AS total_orders
FROM dataco_cleaned
WHERE `order date (DateOrders)` < '2017-10-01'
GROUP BY
    YEAR(`order date (DateOrders)`),
    MONTH(`order date (DateOrders)`),
    MONTHNAME(`order date (DateOrders)`)
ORDER BY order_year, month_no;
#Key Insight
-- Monthly performance trends reveal seasonal patterns and business stability. Incomplete months were excluded to ensure that trend analysis reflects actual business performance rather than partial data.

# Query 7:
#Business Objective
-- Identify the highest-performing products within each product category using category-wise ranking.
WITH ranked_products AS
(
    SELECT
        `Category Name`,
        `Product Name`,
        ROUND(SUM(Sales),2) AS total_sales,
        ROUND(SUM(`Order Profit Per Order`),2) AS total_profit,
	DENSE_RANK() OVER(
	PARTITION BY `Category Name`
	ORDER BY SUM(Sales) DESC
	) AS product_rank

    FROM dataco_cleaned
    GROUP BY
        `Category Name`,
        `Product Name`
)
SELECT
    `Category Name`,
    product_rank,
    `Product Name`,
    total_sales,
    total_profit
FROM ranked_products
WHERE product_rank <= 5
ORDER BY
    `Category Name`,
    product_rank;
#Key Insight
-- Ranking products within each category enables managers to identify best-selling items, optimize inventory levels, and make informed merchandising decisions. The use of window functions allows fair ranking within each category independently.


# Query 8:
#Business Objective
-- Classify customers into One-time, Repeat, and Loyal categories based on their purchase frequency.
WITH customer_orders AS
(    SELECT
        `Customer Id`,
        COUNT(DISTINCT `Order Id`) AS total_orders
    FROM dataco_cleaned
    GROUP BY `Customer Id`
)SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-time'
        WHEN total_orders BETWEEN 2 AND 5 THEN 'Repeat'
        ELSE 'Loyal'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM customer_orders
GROUP BY customer_type
ORDER BY total_customers DESC;
#Key Insight
-- Customer segmentation provides valuable insights into retention and purchasing behavior. Businesses can design targeted loyalty programs for repeat customers while developing strategies to convert one-time buyers into long-term customers.

# Query 9:
#Business Objective
-- Identify the highest revenue-generating product within every geographical region.
WITH regional_sales AS
(    SELECT
        `Order Region`,
        `Product Name`,
        ROUND(SUM(Sales),2) AS total_sales,
        DENSE_RANK() OVER(
            PARTITION BY `Order Region`
            ORDER BY SUM(Sales) DESC
        ) AS product_rank
    FROM dataco_cleaned
    GROUP BY `Order Region`, `Product Name`
)SELECT
    `Order Region`,
    `Product Name`,
    total_sales
FROM regional_sales
WHERE product_rank = 1
ORDER BY `Order Region`;
#Key Insight
-- Different regions often exhibit different purchasing preferences. This analysis helps regional managers optimize inventory planning, regional promotions, and product availability based on local demand.


# Query 10:
#Business Objective
-- Provide a consolidated overview of key business performance indicators for executive decision-making.
WITH business_kpi AS
(
SELECT
    SUM(Sales) AS total_sales,
    SUM(`Order Profit Per Order`) AS total_profit,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    COUNT(DISTINCT `Customer Id`) AS total_customers,
    AVG(Sales) AS avg_order_value
FROM dataco_cleaned
)
SELECT
    ROUND(total_sales,2) AS total_sales,
    ROUND(total_profit,2) AS total_profit,
    total_orders,
    total_customers,
    ROUND(avg_order_value,2) AS avg_order_value
FROM business_kpi;
#Key Insight
-- The summary presents essential business metrics—including total sales, total profit, total customers, total orders, and average order value—in a single report, enabling quick performance evaluation and strategic planning.
