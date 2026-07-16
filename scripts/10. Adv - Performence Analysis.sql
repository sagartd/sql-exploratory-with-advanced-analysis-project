use DataWarehouseAnalytics;

/*
  Performence Analysis -  
         Comparing the current value to a target value.
         Helps to mesures success and campare performance.
*/

-- Task : Analyze the yearly performence of the product by comapring each product sales
--        to both its average sale performance and the previous year sale.

SELECT
  YEAR( a.order_date) as per_year,
  b.product_name,
  SUM(a.sales_amount) as Total_sale
FROM gold.fact_sales as a
LEFT JOIN gold.dim_products as b
ON a.product_key = b. product_key
WHERE  a.order_date IS NOT NULL
GROUP BY YEAR( a.order_date), b.product_name
order by Total_sale desc;

------------------------------------------------------------------------------------------------------------------------


-- using CTE - Analyse by Year

WITH yearly_product_sales AS
(
SELECT
  YEAR( a.order_date) as per_year,
  b.product_name,
  SUM(a.sales_amount) as Total_sale
FROM gold.fact_sales as a
LEFT JOIN gold.dim_products as b
ON a.product_key = b. product_key
WHERE  a.order_date IS NOT NULL
GROUP BY YEAR( a.order_date), b.product_name
) 
-- Year-over-Year Long term Analysis
SELECT
 *,
 AVG(Total_sale) OVER(PARTITION BY product_name) as avg_sale,
 Total_sale - AVG(Total_sale) OVER(PARTITION BY product_name) as avg_diff,
 CASE
    WHEN Total_sale - AVG(Total_sale) OVER(PARTITION BY product_name) < 0
    THEN 'demand is low'
     WHEN Total_sale - AVG(Total_sale) OVER(PARTITION BY product_name) > 0
    THEN 'demand is high'
    ELSE 'avg'
 END AS product_demand,
 LAG(Total_sale) OVER(PARTITION BY product_name ORDER BY  per_year) as prev_yr_sale,
  CASE
    WHEN Total_sale - LAG(Total_sale) OVER(PARTITION BY product_name ORDER BY  per_year) < 0
    THEN 'low from last year'
     WHEN Total_sale - LAG(Total_sale) OVER(PARTITION BY product_name ORDER BY  per_year) > 0
    THEN 'high from last year'
    ELSE 'no change'
 END AS curr_year_demand
FROM yearly_product_sales
ORDER BY product_name, per_year;

------------------------------------------------------------------------------------------------------------------------
-- using CTE - Analyse by Month

WITH yearly_product_sales AS
(
SELECT
  Month( a.order_date) as per_month,
  b.product_name,
  SUM(a.sales_amount) as Total_sale
FROM gold.fact_sales as a
LEFT JOIN gold.dim_products as b
ON a.product_key = b. product_key
WHERE  a.order_date IS NOT NULL
GROUP BY Month( a.order_date), b.product_name
) 
-- Month-over-Month Short term Analysis
SELECT
 *,
 AVG(Total_sale) OVER(PARTITION BY product_name) as avg_sale,
 Total_sale - AVG(Total_sale) OVER(PARTITION BY product_name) as avg_diff,
 CASE
    WHEN Total_sale - AVG(Total_sale) OVER(PARTITION BY product_name) < 0
    THEN 'demand is low'
     WHEN Total_sale - AVG(Total_sale) OVER(PARTITION BY product_name) > 0
    THEN 'demand is high'
    ELSE 'avg'
 END AS product_demand,
 LAG(Total_sale) OVER(PARTITION BY product_name ORDER BY  per_month) as prev_month_sale,
  CASE
    WHEN Total_sale - LAG(Total_sale) OVER(PARTITION BY product_name ORDER BY  per_month) < 0
    THEN 'low from last month'
     WHEN Total_sale - LAG(Total_sale) OVER(PARTITION BY product_name ORDER BY  per_month) > 0
    THEN 'high from last month'
    ELSE 'no change'
 END AS curr_month_demand
FROM yearly_product_sales
ORDER BY product_name, per_month;
------------------------------------------------------------------------------------------------------------------------