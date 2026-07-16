use DataWarehouseAnalytics;

/*
  Change ovet Time - Analyze how measure evolves over time.
     Helps track trends and identify seasonability in you data
*/

-- Task Analyze sales performence over time
-- Target is fact table here

SELECT 
 *
FROM gold.fact_sales;

SELECT 
  YEAR(order_date) as years,
  SUM(sales_amount) as total_sales_year,
  ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS ranking_by_sales,
  COUNT(DISTINCT customer_key) AS total_customer,
  SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
order by years;

----------------------------------------------------------------------------------------------------
-- Change ovet years - A high level overview insights that helps with strategic decision-making.
----------------------------------------------------------------------------------------------------
-- Now lets try for each Months data

SELECT 
  MONTH(order_date) as months,
  SUM(sales_amount) as total_sales_year,
  ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS ranking_by_sales,
  COUNT(DISTINCT customer_key) AS total_customer,
  SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
order by months;
----------------------------------------------------------------------------------------------------
-- Change ovet months - Detailed insight to discover seasonality in your data.
----------------------------------------------------------------------------------------------------
-- we can also check data by each year and its months

SELECT 
  YEAR(order_date) as years,
  MONTH(order_date) as months,
  SUM(sales_amount) as total_sales_year,
  ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS ranking_by_sales,
  COUNT(DISTINCT customer_key) AS total_customer,
  SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
order by years, months;
----------------------------------------------------------------------------------------------------
-- instead of this we can use DATETRUNC function 

SELECT 
  DATETRUNC (MONTH,order_date) as months,  -- Start date will be 1st day of each month
  SUM(sales_amount) as total_sales_year,
  ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS ranking_by_sales,
  COUNT(DISTINCT customer_key) AS total_customer,
  SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC (MONTH,order_date)
order by months;

----------------------------------------------------------------------------------------------------
-- while using order by it will sort by the datatype of function we use 
--       e.g. DATETRUNC is Date type
--            FORMAT make a string type
--            YEAR or MONTH make integer type, 
----------------------------------------------------------------------------------------------------