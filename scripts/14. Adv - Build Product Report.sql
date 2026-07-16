use DataWarehouseAnalytics;

/*
  Build Product Report -  
*/

/*
==============================================================================
Product Report
==============================================================================

Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
        - total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - avg selling price
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last sale)
        - average order revenue (AOR)
        - average monthly revenue

==============================================================================
*/

*/
-- TASK : Retrive the core column from the tables

-- Step 1 :
WITH base_query AS 
(
SELECT
  a.product_key,
  a.customer_key,
  a.order_number,
  a.order_date,
  a.sales_amount,
  a.quantity,
  b.product_name,
  b.category,
  b.subcategory,
  b.cost
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_products AS b
ON a.product_key = b.product_key
)
,
-- Step 2: Aggregates product-level metrics
products_aggregates AS
(
SELECT
   product_key,
   product_name,
   category,
   subcategory,
   cost,
   COUNT(DISTINCT order_number) AS total_orders,
   SUM(sales_amount) AS total_sales,
   SUM(quantity) AS item_sold,
   COUNT(DISTINCT customer_key) AS total_customer,
   DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
   MAX(order_date) AS last_order,
   ROUND(AVG(CAST(sales_amount AS FLOAT)/ NULLIF(quantity,0)),1) AS avg_selling_price
FROM base_query
GROUP BY product_key,
         product_name,
         category,
         subcategory,
         cost
)
-- Step 3 : Segments products by revenue : to identify High-Performers, Mid-Range, or Low-Performers.

SELECT
   *,
   CASE 
      WHEN total_sales BETWEEN 1 AND 100000 THEN 'Low-Performer'
      WHEN total_sales BETWEEN 100001 AND 700001 THEN 'Mid-Performer'
      ELSE 'High-Performers'
   END as product_segement,
   -- Step 4 : Calculates valuable KPI
   DATEDIFF(MONTH, last_order, GETDATE()) as recency,
   CASE WHEN total_orders = 0 THEN 0
        ELSE total_sales/total_orders
   END as avg_sales_perOrder,
   CASE WHEN lifespan < 1 THEN total_sales
        ELSE total_sales/lifespan
   END as avg_monthly_sales
FROM products_aggregates;

-----------------------------------------------------------------------------------------------------------
-- CREATE VIEW
go
CREATE VIEW gold.report_products AS
WITH base_query AS 
(
SELECT
  a.product_key,
  a.customer_key,
  a.order_number,
  a.order_date,
  a.sales_amount,
  a.quantity,
  b.product_name,
  b.category,
  b.subcategory,
  b.cost
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_products AS b
ON a.product_key = b.product_key
)
,
-- Step 2: Aggregates product-level metrics
products_aggregates AS
(
SELECT
   product_key,
   product_name,
   category,
   subcategory,
   cost,
   COUNT(DISTINCT order_number) AS total_orders,
   SUM(sales_amount) AS total_sales,
   SUM(quantity) AS item_sold,
   COUNT(DISTINCT customer_key) AS total_customer,
   DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
   MAX(order_date) AS last_order,
   ROUND(AVG(CAST(sales_amount AS FLOAT)/ NULLIF(quantity,0)),1) AS avg_selling_price
FROM base_query
GROUP BY product_key,
         product_name,
         category,
         subcategory,
         cost
)
-- Step 3 : Segments products by revenue : to identify High-Performers, Mid-Range, or Low-Performers.

SELECT
   *,
   CASE 
      WHEN total_sales BETWEEN 1 AND 100000 THEN 'Low-Performer'
      WHEN total_sales BETWEEN 100001 AND 700001 THEN 'Mid-Performer'
      ELSE 'High-Performers'
   END as product_segement,
   -- Step 4 : Calculates valuable KPI
   DATEDIFF(MONTH, last_order, GETDATE()) as recency,
   CASE WHEN total_orders = 0 THEN 0
        ELSE total_sales/total_orders
   END as avg_sales_perOrder,
   CASE WHEN lifespan < 1 THEN total_sales
        ELSE total_sales/lifespan
   END as avg_monthly_sales
FROM products_aggregates;
go
-----------------------------------------------------------------------------------------------------------

SELECT
*
FROM gold.report_products;
-----------------------------------------------------------------------------------------------------------