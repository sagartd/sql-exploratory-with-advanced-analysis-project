use DataWarehouse;

/*
  Data Exploration :-
    Indentify the earliest and latest dates (boundaries).
    Understand the scope of data and the timespan.
*/

SELECT 
*
FROM gold.fact_sales;

-- Task : Find the date of first and last orders

SELECT 
  min(order_date) as first_order_date,
  max(order_date) as last_order_date
FROM gold.fact_sales;
---------------------------------------------------------------------------------
-- Task : How many years sales are availble

SELECT 
  DATEDIFF(YEAR, min(order_date),max(order_date)) AS order_range
FROM gold.fact_sales;
---------------------------------------------------------------------------------
-- Task : Find younghest and oldest customer

SELECT 
*
FROM gold.dim_customers;

SELECT 
  min(birthdate) as oldest_customer,
  DATEDIFF(YEAR, min(birthdate), GETDATE()) as oldest_customer_age,
  max(birthdate) as younghest_customer,
  DATEDIFF(YEAR, max(birthdate), GETDATE()) as younghest_customer_age
FROM gold.dim_customers;

---------------------------------------------------------------------------------