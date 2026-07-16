use DataWarehouseAnalytics;

/*
  Data Sagmentation -  
              Group the data based on the specific range.
              Helps to understand the correlation between two measures
*/

-- Task :  Segment products into cost range and
--         count how many product fall into each segemnt.

-- First just find most high and low cost product, to create range

SELECT 
  MAX(cost) as highest_cost
FROM gold.dim_products;


SELECT 
  MIN(cost) as lowest_cost
FROM gold.dim_products
where cost > 0;

-------------------------------------------------------------------------------------------
-- So lets create 3 range by cost -
--                       upto 750 will be low cost product,
--                       751 to 1500 will be mid-cost
--                       1501 to 2200 will be high cost product.
-- lets apply to all product :-
-------------------------------------------------------------------------------------------

SELECT 
  product_name,
  cost,
  CASE 
       WHEN cost >=1 AND COST <= 750 THEN 'low_cost'
       WHEN cost >=751 AND COST <= 1500 THEN 'mid_cost'
       WHEN cost >=1501 AND COST <= 2200 THEN 'high_cost'
       ELSE 'zero_cost'
  END as cost_range
FROM gold.dim_products;

-------------------------------------------------------------------------------------------
-- now lets just count the number of product in each cost range

WITH product_cost_range AS
(
SELECT 
  product_key,
  product_name,
  cost,
  CASE 
       WHEN cost BETWEEN 1 AND 750 THEN 'low_cost'
       WHEN cost BETWEEN 751 AND 1500 THEN 'mid_cost'
       WHEN cost BETWEEN 1501 AND 2200 THEN 'high_cost'
       ELSE 'zero_cost'
  END as cost_range
FROM gold.dim_products
)

SELECT
 COUNT(product_key) as number_ofProduct,
 cost_range
FROM product_cost_range
GROUP BY cost_range
ORDER BY number_ofProduct DESC;
-------------------------------------------------------------------------------------------
-- TASK : Group customer into thre segments based on their spending bahavior :
--        VIP : Customer with at least 12 months of history and spending more than 5000.
--        Resgular : Customer with at least 12 months of history and spending 5000 or less.
--        New : Customer with lifespan less than 12 months.
--       and find the total number of customer by each group

SELECT
*
FROM gold.dim_customers;
--------------------------------------------------------------------------------------------

WITH customer_spending AS
(
SELECT 
  customer_key,
  SUM(sales_amount) as total_spend,
  DATEDIFF(MONTH,MIN(order_date), MAX(order_date)) as order_months 
FROM gold.fact_sales
GROUP BY customer_key
)
SELECT
 customer_type,
 COUNT(customer_key) AS number_ofCustomer
FROM
(
SELECT 
   customer_key,
   total_spend,
   order_months,
 CASE
     WHEN order_months >= 12 AND total_spend > 5000 THEN 'VIP'
     WHEN order_months >= 12 AND total_spend <= 5000 THEN 'Regular'
     ELSE 'New'
 END as customer_type
FROM customer_spending
) as d
GROUP BY customer_type
ORDER BY number_ofCustomer DESC;
--------------------------------------------------------------------------------------------

