SELECT *
FROM DairySales

/*What are the top-selling dairy products based on the quantity sold and total revenue generated?*/

SELECT Product_Name,SUM(Quantity_Sold_liters_kg) AS QUANTITY_SOLD,SUM(Approx_Total_Revenue_INR) AS TOTAL_REVENUE
FROM DairySales
GROUP BY Product_Name
ORDER BY QUANTITY_SOLD DESC

/*Which brands have the highest sales volume and revenue?*/
SELECT BRAND,SUM(Price_per_Unit_sold) AS SALES,SUM(Approx_Total_Revenue_INR) AS TOTAL_REVENUE
FROM DairySales
GROUP BY Brand
ORDER BY SALES DESC

/*What is the overall sales trend over time? Are there any noticeable seasonal patterns?*/

SELECT YEAR(DATE) AS YEARS,SUM(Price_per_Unit_sold) AS SALES
FROM DairySales
GROUP BY YEAR(DATE)
ORDER BY YEARS

/*Which dairy products are currently below the minimum stock threshold?*/

SELECT Brand,Quantity_in_Stock_liters_kg,Minimum_Stock_Threshold_liters_kg
FROM DairySales
WHERE Quantity_in_Stock_liters_kg < Minimum_Stock_Threshold_liters_kg

/*What is the remaining quantity in stock for each dairy product?*/

SELECT Brand,SUM(Quantity_in_Stock_liters_kg) AS REMAINING_QUANTITY
FROM DairySales
GROUP BY Brand
ORDER BY REMAINING_QUANTITY ASC

/*What is the recommended reorder quantity for each product based on historical sales and minimum stock threshold?*/
SELECT Product_Name,SUM(Reorder_Quantity_liters_kg) AS REORDER_QUANTITY,SUM(Price_per_Unit_sold) AS SALES,
SUM(Quantity_in_Stock_liters_kg) AS STOCK,
MIN(Minimum_Stock_Threshold_liters_kg) AS MINIMUM_STOCK_THRESHOLD
FROM DairySales
GROUP BY Product_Name
HAVING SUM(Quantity_in_Stock_liters_kg) >MIN(Minimum_Stock_Threshold_liters_kg)
ORDER BY REORDER_QUANTITY


/*What is the average shelf life of the dairy products? Are there any products nearing or past their expiration dates?*/

SELECT AVG(SHELF_LIFE_DAYS) AS SHELF_LIFE,COUNT(*) AS TOTAL_PRODUCTS,
       SUM(CASE WHEN EXPIRATION_DATE<=DATE THEN 1 ELSE 0 END) AS EXPIRED_PRODUCTS,
       SUM(CASE WHEN EXPIRATION_DATE> DATE THEN 1 ELSE 0 END) AS NOT_EXPIRED
FROM DAIRYSALES

/*What is the average time it takes to sell each product?*/

SELECT *
FROM DairySales

SELECT  PRODUCT_NAME,AVG(DATEDIFF(DAY,PRODUCTION_DATE,DATE)) AS TIME_TAKEN
FROM DairySales
GROUP BY Product_Name

/*Which products have the highest and lowest sales growth rates?*/
SELECT X.Product_Name ,(X.HIGHEST_SALES-X.LOWEST_SALES) AS GROWTH_RATE
FROM (
        SELECT PRODUCT_NAME, MAX(Approx_Total_Revenue_INR) AS HIGHEST_SALES,MIN(Approx_Total_Revenue_INR) AS LOWEST_SALES
        FROM DairySales
        GROUP BY PRODUCT_NAME) X
ORDER BY GROWTH_RATE DESC

/*What are the top customer locations based on the quantity purchased and total revenue generated?*/


SELECT LOCATION,SUM(Quantity_Sold_liters_kg) AS	QUANTITY_PURCHASED,SUM(APPROX_TOTAL_REVENUE_INR) AS TOTAL_REVENUE
FROM DairySales
GROUP BY Location
ORDER BY QUANTITY_PURCHASED DESC

	
/*How does the sales performance vary across different customer locations*/

SELECT Customer_Location, SUM(Approx_Total_Revenue_INR) AS Total_Sales,
ROUND(PERCENT_RANK() OVER(ORDER BY SUM(Approx_Total_Revenue_INR) DESC) *100,2) AS Performance_Rank
FROM DairySales
GROUP BY Customer_Location
ORDER BY Performance_Rank DESC;

/*Are there any regions or areas with significant sales growth potential?*/

SELECT Z.Location,Z.MAXIMUM_SALES,Z.MINIMUM_SALES,(Z.MAXIMUM_SALES-Z.MINIMUM_SALES) AS SALES_GROWTH
FROM
(
   SELECT Location,MAX(APPROX_TOTAL_REVENUE_INR) AS MAXIMUM_SALES,MIN(APPROX_TOTAL_REVENUE_INR) AS MINIMUM_SALES
   FROM DairySales
   GROUP BY Location) Z
ORDER BY SALES_GROWTH DESC

/*Are there opportunities for market expansion or targeted marketing campaigns based on customer locations?*/

SELECT Customer_Location,COUNT(*) AS TOTAL_CUSTOMERS,SUM(Approx_Total_Revenue_INR) AS TOTAL_REVENUE
FROM DairySales
GROUP BY Customer_Location
ORDER BY TOTAL_CUSTOMERS DESC

/*What is the average price per unit for each dairy product?*/

SELECT  Product_Name,AVG(Price_per_Unit) AS AVERAGE_PRICE_PER_UNIT
FROM DairySales
GROUP BY Product_Name
ORDER BY AVERAGE_PRICE_PER_UNIT DESC

/*Are there any significant price variations across different products or brands?*/

SELECT Product_Name,MIN(Price_per_Unit) AS MINIMUM_PRICE,MAX(Price_per_Unit) MAXIMUM_PRICE,
MAX(Price_per_Unit)  -MIN(Price_per_Unit) PRICE_VARIATIONS
FROM DairySales
GROUP BY Product_Name
ORDER BY PRICE_VARIATIONS DESC

/*How does price impact sales volume and revenue?*/

SELECT
CASE 
WHEN Price_per_Unit_sold<= 30 THEN 'LOW_PRICE_RANGE'
WHEN Price_per_Unit_sold>=30 AND Price_per_Unit_sold<=60 THEN 'MID_RANGE_PRICE'
WHEN PRICE_PER_UNIT_sold>60 then 'High_price_range'
END AS PRICE_RANGE,
SUM(Quantity_Sold_liters_kg) AS SALES_VOLUME, 
SUM(Approx_Total_Revenue_INR) AS REVENUE
FROM DairySales
GROUP BY PRICE_RANGE

SELECT X.Price_Range,  AVG(Quantity_Sold_liters_kg) AS Average_Sales_Volume,SUM(Approx_Total_Revenue_INR) AS Total_Revenue
FROM
(SELECT 
  CASE
    WHEN Price_per_Unit_sold < 50 THEN 'Low Price Range'
    WHEN Price_per_Unit_sold >= 50 AND Price_per_Unit_sold < 100 THEN 'Medium Price Range'
    ELSE 'High Price Range'
  END AS Price_Range,
  Quantity_Sold_liters_kg,Approx_Total_Revenue_INR
FROM DairySales) X
GROUP BY X.Price_Range
ORDER BY Total_Revenue ASC

---------------------------------------------------------------------------------------------------------------------------



  

