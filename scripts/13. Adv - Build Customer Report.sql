use DataWarehouseAnalytics;

/*
  Build Customer Report -  

*/

/*
==============================================================================
Customer Report
==============================================================================

Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend

==============================================================================
*/
-- TASK : Retrive the core column from the tables

 -- step 1 :
WITH base_query AS 
(
SELECT
  a.customer_key,
  a.product_key,
  b.first_name + ' ' + b.last_name AS customer_name,
  DATEDIFF(YEAR,b.birthdate, GETDATE()) AS customer_age,
  b.customer_number,
  a.order_number,
  a.order_date,
  a.sales_amount,
  a.quantity
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_customers AS b
ON a.customer_key = b.customer_key

WHERE a.order_date IS NOT NULL
) -- end CTE 1st
, -- step 2 : Aggregates customer-level metrics
customer_aggregation AS
( 
SELECT
   customer_key,
   customer_number,
   customer_name,
   customer_age,
   COUNT(DISTINCT order_number) as Total_orders,
   SUM(sales_amount) as Total_amount,
   SUM(quantity) AS Total_quantity,
   COUNT(DISTINCT product_key) as number_ofProducts,
   MAX(order_date) as last_order,
   DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) as customer_lifespan
FROM base_query
GROUP BY customer_key,
         customer_number,
         customer_name,
         customer_age
)
SELECT
  *,
  -- step 3: Segments customers
  CASE 
     WHEN customer_age BETWEEN 18 AND 35 THEN 'Younger-age'
     WHEN customer_age BETWEEN 36 AND 50 THEN 'Middle-age'
     ELSE 'Older-age'
  END as age_group,
  CASE
     WHEN customer_lifespan >= 12 AND Total_amount > 5000 THEN 'VIP'
     WHEN customer_lifespan >= 12 AND Total_amount <= 5000 THEN 'Regular'
     ELSE 'New'
  END as customer_type,
  -- step 4 : Calculates valuable KPIs
  DATEDIFF(MONTH, last_order, GETDATE()) AS check_recensy,
  CASE 
     WHEN Total_orders = 0 THEN 0
     ELSE Total_amount/Total_orders
  END as avg_order_spend,
  CASE
     WHEN customer_lifespan = 0 THEN 0
     ELSE Total_amount/customer_lifespan 
  END as avg_month_spend
FROM customer_aggregation
WHERE customer_age IS NOT NULL

-----------------------------------------------------------------------------------------------------------
-- CREATE VIEW
go
CREATE VIEW gold.report_customer AS
WITH base_query AS 
(
SELECT
  a.customer_key,
  a.product_key,
  b.first_name + ' ' + b.last_name AS customer_name,
  DATEDIFF(YEAR,b.birthdate, GETDATE()) AS customer_age,
  b.customer_number,
  a.order_number,
  a.order_date,
  a.sales_amount,
  a.quantity
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_customers AS b
ON a.customer_key = b.customer_key
WHERE a.order_date IS NOT NULL
) -- end CTE 1st
, -- step 2 : Aggregates customer-level metrics
customer_aggregation AS
( 
SELECT
   customer_key,
   customer_number,
   customer_name,
   customer_age,
   COUNT(DISTINCT order_number) as Total_orders,
   SUM(sales_amount) as Total_amount,
   SUM(quantity) AS Total_quantity,
   COUNT(DISTINCT product_key) as number_ofProducts,
   MAX(order_date) as last_order,
   DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) as customer_lifespan
FROM base_query
GROUP BY customer_key,
         customer_number,
         customer_name,
         customer_age
)
SELECT
  *,
  -- step 3: Segments customers
  CASE 
     WHEN customer_age BETWEEN 18 AND 35 THEN 'Younger-age'
     WHEN customer_age BETWEEN 36 AND 50 THEN 'Middle-age'
     ELSE 'Older-age'
  END as age_group,
  CASE
     WHEN customer_lifespan >= 12 AND Total_amount > 5000 THEN 'VIP'
     WHEN customer_lifespan >= 12 AND Total_amount <= 5000 THEN 'Regular'
     ELSE 'New'
  END as customer_type,
  -- step 4 : Calculates valuable KPIs
  DATEDIFF(MONTH, last_order, GETDATE()) AS check_recensy,
  CASE 
     WHEN Total_orders = 0 THEN 0
     ELSE Total_amount/Total_orders
  END as avg_order_spend,
  CASE
     WHEN customer_lifespan = 0 THEN 0
     ELSE Total_amount/customer_lifespan 
  END as avg_month_spend
FROM customer_aggregation
WHERE customer_age IS NOT NULL
go
-----------------------------------------------------------------------------------------------------------

SELECT
*
FROM gold.report_customer;
-----------------------------------------------------------------------------------------------------------
-- Now easy to make analysis
SELECT
 age_group,
 COUNT(customer_key)
FROM gold.report_customer
GROUP BY age_group;
---------------------------------------
SELECT
 customer_type,
 SUM(Total_amount) ,
 COUNT(customer_key) as number_ofCustomer
FROM gold.report_customer
GROUP BY customer_type;
-----------------------------------------------------------------------------------------------------------