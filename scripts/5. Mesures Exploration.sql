use DataWarehouse;

/*
  Mesures Exploration :-
    Calculate the key metric of the business (Big Numbres)
    Highest Level of aggregation | Lowest level of details:
*/

-- Task : Find the total Sales

SELECT
 SUM(sales_amount) as total_Sales
FROM gold.fact_sales

-----------------------------------------------------------------------------------------------------
-- Task : Find how many items are sold
SELECT
 SUM(quantity) as total_sold
FROM gold.fact_sales
-----------------------------------------------------------------------------------------------------
-- Task : Find the average selling price
SELECT
 AVG(price) as avg_price
FROM gold.fact_sales
-----------------------------------------------------------------------------------------------------
-- Task : Find the total number of orders
SELECT
 COUNT(order_number) as total_orders
FROM gold.fact_sales
-----------------------------------
SELECT
 COUNT(DISTINCT order_number) as total_orders
FROM gold.fact_sales
-----------------------------------------------------------------------------------------------------
-- Task : Find the total number of product
SELECT
 COUNT(product_key) as total_products
FROM gold.dim_product
--------------------------------------
SELECT
 COUNT(DISTINCT product_name) as total_products
FROM gold.dim_product
-----------------------------------------------------------------------------------------------------
-- Task : Find the total number of customers
SELECT
 COUNT(customer_key) as total_customers
FROM gold.dim_customers
-----------------------------------------------------------------------------------------------------
-- Task : Find the total number of customers that has placed an orders
SELECT 
  COUNT(DISTINCT customer_key) as total_customers_who_ordered
FROM gold.fact_sales;

-----------------------------------------------------------------------------------------------------
-- lets put this all analysis in single table

SELECT
  'Total Sales' AS mesure_name,
   SUM(sales_amount) AS mesure_value
FROM gold.fact_sales
UNION ALL

SELECT
  'Total Sold' AS mesure_name,
   SUM(quantity) AS mesure_value
FROM gold.fact_sales
UNION ALL

SELECT
  'Average Price' AS mesure_name, 
   AVG(price) AS mesure_value
FROM gold.fact_sales
UNION ALL

SELECT
  'Total Orders' AS mesure_name, 
   COUNT(DISTINCT order_number) AS mesure_value
FROM gold.fact_sales
UNION ALL

SELECT
  'Total Products' AS mesure_name, 
   COUNT(product_key) AS mesure_value
FROM gold.dim_product
UNION ALL

SELECT
  'Total Customers' AS mesure_name, 
   COUNT(customer_key) AS mesure_value
FROM gold.dim_customers
UNION ALL

SELECT 
  'Total Customers Who Ordered' AS mesure_name, 
   COUNT(DISTINCT customer_key) AS mesure_value
FROM gold.fact_sales;
-----------------------------------------------------------------------------------------------------
-- Uninion : number of columns and datatypes must be matching