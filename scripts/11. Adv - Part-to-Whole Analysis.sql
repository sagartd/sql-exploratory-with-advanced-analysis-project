use DataWarehouseAnalytics;

/*
  Part-to-Whole Analysis -  Proportional Analysis
                       Analyze how an individual part is performing to the overall,
                       allowing us to understand which category has the greatest impact on the business.
*/

-- Task : Which category contribute the most to over all sales.


WITH sale_bycategory AS
(
SELECT
  b.category,
  SUM(a.sales_amount) as total_sale
FROM gold.fact_sales AS a
LEFT JOIN gold.dim_products AS b
ON a.product_key = b.product_key
GROUP BY b.category
) 

SELECT 
 *,
 SUM(total_sale) OVER() AS all_cat_sale, 
 CONCAT(
      CAST(
            (total_sale * 100.0) / SUM(total_sale) OVER() 
            AS DECIMAL(10,2)
           ),
      ' %'
       ) AS sale_percentage
FROM sale_bycategory
ORDER BY total_sale DESC

----------------------------------------------------------------------------------------------------------------
