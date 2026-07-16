use DataWarehouse;

/*
  Diamention Exploration :-
     Identifying the unique values (or categories) in each dimension.
     Recongnizing how data might be grouped or segmented wwhich is useful for later analysis.
     For that we are going to use - 'DISTINCT,' FROM this you can understand,
     that does your dimesion has 3 values or 100 values.
*/

-- Task : Explore all countries customer come from :-

SELECT
  DISTINCT country
FROM gold.dim_customers;

-- Task : Explore all categories 'The major divisions' :-


SELECT
  DISTINCT category
FROM gold.dim_product;

SELECT
  DISTINCT category, subcategory
FROM gold.dim_product;

SELECT
  DISTINCT category, subcategory, product_name
FROM gold.dim_product
order by 1, 2, 3;

/*
1 is First by category. 
2 is If two rows have the same category, then by subcategory.
3 is If both category and subcategory are the same, then by product_name.
*/

