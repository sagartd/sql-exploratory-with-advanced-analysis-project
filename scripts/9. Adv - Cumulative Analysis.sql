use DataWarehouseAnalytics;

/*
  Cumulative Analysis -  Aggregate the data progressively over time.
  Help to understand weather our business is growing or declining.
*/

-- Task : Calculate total sales per month
--        and running total of sales over time

SELECT 
 *
FROM gold.fact_sales;

SELECT 
  DATETRUNC(MONTH,order_date) as months,
  SUM(sales_amount) as total_sales_year
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
order by months;

--------------------------------------------------------------------------------------------------------
--        and running total of sales over time
SELECT
 *,
  SUM(total_sales) OVER(order by months) as running_total_sales_months  -- Default Window Frame
FROM
(
SELECT 
  DATETRUNC(MONTH,order_date) as months,
  SUM(sales_amount) as total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
) AS d

--------------------------------------------------------------------------------------------------------

--        and running total of sales over time in years by months
SELECT
  *,
  SUM(total_sales) OVER(partition by months order by months) as running_total_sales_months  -- Default Window Frame, reset the frame every year.
FROM
(
SELECT 
  DATETRUNC(MONTH,order_date) as months,
  SUM(sales_amount) as total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
) AS d

--------------------------------------------------------------------------------------------------------
--        and running total of sales over time in only each years

SELECT
  *,
  SUM(total_sales) OVER(order by years) as running_total_sales_year  -- Default Window Frame..
FROM
(
SELECT 
  DATETRUNC(year,order_date) as years,
  SUM(sales_amount) as total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year,order_date)
) AS d
--------------------------------------------------------------------------------------------------------
-- lets find moving average

SELECT
  *,
  SUM(total_sales) OVER(order by years) as running_total_sales_year,  -- Default Window Frame.
  AVG(average_sales) OVER(order by years) as moving_average_sales_year
FROM
(
SELECT 
  DATETRUNC(year,order_date) as years,
  SUM(sales_amount) as total_sales,
  AVG(sales_amount) as average_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year,order_date)
) AS d
--------------------------------------------------------------------------------------------------------