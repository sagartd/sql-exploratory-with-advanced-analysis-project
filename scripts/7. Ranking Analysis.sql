use DataWarehouseAnalytics
/*
  Ranking Analysis : Order the values of Dimension by the measure.
                     TOP N PERFORMERS || BOTTOM N PERFORMERS
*/

-- Task : Which 5 product generates highest revenue.

SELECT TOP 5
  b.product_name,
  SUM(a.sales_amount) AS sold_amount
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_products AS b
ON a.product_key = b.product_key
GROUP BY b.product_name
ORDER BY sold_amount DESC;

-----------------------------------------------------------------------------------------------------------------

-- Task : What are 5 worse-performing product in terms of sell

SELECT TOP 5
  b.product_name,
  SUM(a.sales_amount) AS sold_amount
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_products AS b
ON a.product_key = b.product_key
GROUP BY b.product_name
ORDER BY sold_amount;

-----------------------------------------------------------------------------------------------------------------
-- Task : Which 5 product generates highest revenue.
-- With dimension is subcategory
SELECT TOP 5
  b.subcategory,
  SUM(a.sales_amount) AS sold_amount
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_products AS b
ON a.product_key = b.product_key
GROUP BY b.subcategory
ORDER BY sold_amount DESC;

-----------------------------------------------------------------------------------------------------------------
-- Task : What are 5 worse-performing product in terms of sell
-- With dimension is subcategory
SELECT TOP 5
  b.subcategory,
  SUM(a.sales_amount) AS sold_amount
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_products AS b
ON a.product_key = b.product_key
GROUP BY b.subcategory
ORDER BY sold_amount;
-----------------------------------------------------------------------------------------------------------------
-- Now lets use Window Function - for more flexible and complex queries with extra details.

SELECT TOP 5
  b.product_name,
  SUM(a.sales_amount) AS sold_amount,
  ROW_NUMBER() OVER(order by SUM(a.sales_amount) desc) AS top_sold
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_products AS b
ON a.product_key = b.product_key
GROUP BY b.product_name
-----------------------------------------------------------------------------------------------------------------
-- Task : Find the top 10 customers who have generated the highest revenue. 3 customer fewest order placed

SELECT TOP 10
  b.customer_key,
  b.first_name, b.last_name,
  SUM(a.sales_amount) as customer_revenue
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_customers AS b
ON a.customer_key = b.customer_key
GROUP BY b.customer_key, b.first_name, b.last_name
ORDER BY customer_revenue DESC;


-----------------------------------------------------------------------------------------------------------------
-- Task : Find the top 3 customer fewest order placed

SELECT TOP 3
  b.first_name,
  b.last_name,
  a.customer_key,
  COUNT(DISTINCT a.order_number) AS order_count
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_customers AS b
ON a.customer_key = b.customer_key
GROUP BY a.customer_key,  b.first_name,b.last_name
ORDER BY order_count;

-----------------------------------------------------------------------------------------------------------------