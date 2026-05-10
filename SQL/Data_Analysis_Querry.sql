CREATE DATABASE Sales_Data
USE Sales_Data

SELECT *
FROM Company_Sales_Data

SELECT TOP 10 *
FROM Company_Sales_Data

--(1) TOTAL REVENUE
--(To Know Sales)

SELECT ROUND(SUM(Sales),2) AS TOTAL_REVENUE
FROM Company_Sales_Data

--(2) TOTAL ORDERS
--(To know total orders received)

SELECT COUNT(DISTINCT Order_ID) AS Total_Orders
FROM Company_Sales_Data

--(3) AVERAGE ORDER VALUE
--( To understand average spending)

SELECT ROUND(AVG(Sales),2) AS AOV
FROM Company_Sales_Data

--(4) PROFIT Margin AND NET PROFIT
--(To Understand Profit Margin)

SELECT ROUND((SUM(Profit)/SUM(Sales))*100,2) AS PROFIT_MARGIN
FROM Company_Sales_Data

SELECT ROUND(SUM(Profit),2) AS NET_PROFIT
FROM Company_Sales_Data

--(5) TOTAL REVENUE BY CITY
--(To understand city wise performance)

SELECT City, ROUND(SUM(Sales),2) AS TOTAL_REVENUE
FROM Company_Sales_Data
GROUP BY City
ORDER BY TOTAL_REVENUE DESC

--(6) TOP 5 REVENUE GENERATING PRODUCTS
--(To know products which are performing well)

SELECT TOP 5 Product_Name, ROUND(SUM(Sales),2) AS TOTAL_REVENUE
FROM Company_Sales_Data
GROUP BY Product_Name
ORDER BY TOTAL_REVENUE DESC ;


--(7) COUNT OF ORDERS DAY OR WEEK WISE
--(To know peak days in a week)

SELECT FORMAT(Order_date,'dddd') AS Day_Name,COUNT(Distinct Order_ID) AS OrderCount
FROM Company_Sales_Data
GROUP BY FORMAT(Order_date,'dddd')
ORDER BY OrderCount DESC

--(8) REVENUE AND AVERAGE DISCOUNT BY CATEGORY
--(To Understand the discount influence in revenue)

SELECT Category, ROUND(SUM(Sales),2) AS TOTAL_REVENUE, ROUND(AVG(Discount),2) AS AVG_DISCOUNT
FROM Company_Sales_Data
GROUP BY Category
ORDER BY TOTAL_REVENUE DESC ;

--(9) YEAR AND MONTH WISE REVENUE AND PROFIT TREND WITH DISCOUNT
--(This will help to understand revenue and profit trend and discount role in it)

SELECT YEAR(Order_Date) AS ORDER_YEAR,
MONTH(Order_date) AS Month_Number, 
FORMAT(Order_date,'MMMM') AS Month_Name, 
ROUND(SUM(Sales),2) AS Total_Reveue,
ROUND(SUM(profit),2) as TOTAL_PROFIT,
ROUND(AVG(Discount),2) AS AVG_DISCOUNT
FROM Company_Sales_Data
GROUP BY YEAR(Order_Date), FORMAT(Order_date,'MMMM'), MONTH(Order_date)
ORDER BY Month_Number,Total_Reveue DESC

--(10) CITY WISE TOTAL QUANTITY
--To know the total orders city wise

SELECT City, SUM(Quantity) AS Total_Quantity
FROM Company_Sales_Data
GROUP BY City
ORDER BY Total_Quantity DESC

--(11) TOTAL REVENUE BY CUSTOMERS
--(To know customers who are willing to spend more)

SELECT TOP 10 Customer_Name, ROUND(SUM(Sales),2) AS TOTAL_REVENUE
FROM Company_Sales_Data
GROUP BY Customer_Name
ORDER BY TOTAL_REVENUE DESC

--(12) YOY GROWTH RATE
--(It helps find yoy sales growth)

SELECT YEAR(Order_Date)AS Sales_Year, ROUND(SUM(Sales),2) AS Total_Revenue,
COALESCE(ROUND(((SUM(Sales) - LAG(SUM(Sales))OVER(ORDER BY YEAR(Order_Date)))/LAG(SUM(Sales))OVER(ORDER BY YEAR(Order_Date)))*100,2),0) AS YOY_Growth_Rate
FROM Company_Sales_Data
GROUP BY YEAR(Order_Date)

--(13) NET PROFIT AND AVG DISCOUNT BY CATEGORY
--(It shows which category successed in converting Revenue into profit and can discount will help to uplift net profit)

SELECT Category,ROUND((SUM(Profit)/SUM(Sales))*100,2) AS Net_profit, ROUND(AVG(Discount),2) AS Avg_Discount
FROM Company_Sales_Data
GROUP BY Category 
ORDER BY Net_profit DESC ;

--(14) TOP 10 TOTAL PROFIT BY PRODUCT
--(It will help to find top profit generating products)

SELECT TOP 10 Product_Name, ROUND(SUM(Profit),2) AS TOTAL_PROFIT
FROM Company_Sales_Data
GROUP BY Product_Name
ORDER BY TOTAL_PROFIT DESC ;

--(15) BOTTOM 10 PROFIT GENERATING PRODUCTS
--(It will help to find low performing products)

SELECT TOP 10 Product_Name, ROUND(SUM(Profit),2) AS TOTAL_PROFIT
FROM Company_Sales_Data
GROUP BY Product_Name
ORDER BY TOTAL_PROFIT ;

--(16) INSERTING COLUMN PROFIT LEVEL 
--(It help to find the products which effecting profit by negative sales)

ALTER TABLE Company_Sales_Data
ADD Profit_Level VARCHAR(100) ;

UPDATE Company_Sales_Data
SET Profit_Level = (
       CASE 
	   WHEN Profit < 0
	   THEN 'Negative'
	   ELSE 'Positive'
	   END)

SELECT *
FROM Company_Sales_Data

--(17) DIFFERENT BETWEEN PROFIT WHICH ARE NEGATIVE AND POSITIVE
--(Helps to find products which are affecting profit by doing loss)  

SELECT  COUNT(CASE WHEN Profit_Level = 'Positive' THEN 1 END)AS POSITIVE, 
COUNT(CASE WHEN Profit_Level = 'Negative' THEN 1 END)AS NEGATIVE
FROM Company_Sales_Data

--(18) COUNT PRODUCTS MAKING NEGATIVE SALES 
--(This help to find how many products are affecting profit)

SELECT COUNT(DISTINCT Product_Name)
FROM Company_Sales_Data
WHERE Profit_Level = 'Negative'

--(19) CATEGORY WISE COUNT OF PRODUCTS MAKING NEGATIVE SALES 
--(This help to find how many products are affecting profit) 

SELECT Category, COUNT(DISTINCT Product_Name) AS TOTAL_PRODUCTS
FROM Company_Sales_Data
WHERE Profit_Level = 'Negative'
GROUP BY Category 
ORDER BY TOTAL_PRODUCTS DESC ;

--(20) TOTAL SALES, DISCOUNT AND PROFIT BY PRODUCT
--(This will help to find negative sales or profit making products)

SELECT Product_Name, ROUND(SUM(Sales),2) AS TOTAL_REVENUE, ROUND(SUM(Discount),2) AS TOTAL_DISCOUNT, ROUND(SUM(Profit),2) AS TOTAL_PROFIT
FROM Company_Sales_Data
WHERE Profit_Level = 'Negative'
GROUP BY Product_Name ; 

--(21) TOP 10 CUSTOMERS BY TOTAL PROFIT
--(To Understand top profit generating customers to business)

SELECT TOP 10 Customer_Name, ROUND(SUM(Profit),2) AS Total_Profit
FROM Company_Sales_Data
GROUP BY Customer_Name
ORDER BY Total_Profit DESC ;

--(22) CUSTOMERS SPENDING ABOVE AVERAGE SPENDING
--(Help to know customers who are spending above average)

SELECT Customer_Name, ROUND(SUM(Sales),2) AS Total_Profit
FROM Company_Sales_Data
GROUP BY Customer_Name
HAVING SUM(Sales) > (
                        SELECT AVG(Sales)
						FROM Company_Sales_Data
						)

--(23) SEGMENT WISE TOTAL SALES, TOTAL PROFIT, TOTAL QUANTITY
--(It will help to understand the segment which are performing well)

SELECT Segment, ROUND(SUM(Sales),2) AS TOTAL_REVENUE, ROUND(SUM(Profit),2) AS TOTAL_PROFIT, SUM(Quantity) AS TOTAL_QTY_SOLD, 
ROUND(AVG(Discount),2) AS AVG_DISCOUNT
FROM Company_Sales_Data
GROUP BY Segment
ORDER BY TOTAL_REVENUE DESC ;

--(23) SEGMENT AND CATEGORY WISE ORDER DATE TO SHIP DATE DIFFERENCE
--(It helps to understand segment and category wise gap in inventory supply )

SELECT Segment, AVG(DATEDIFF(DAY,Order_Date,Ship_Date)) AS DAYS_COUNT
FROM Company_Sales_Data
Group by Segment

SELECT Category, AVG(DATEDIFF(DAY,Order_Date,Ship_Date)) AS DAYS_COUNT
FROM Company_Sales_Data
Group by Category


--(24) DAYS DIFFERENCE BETWEEN ORDER DATE AND SHIP DATE
--( Can help to improve business operations)

SELECT COUNT(DISTINCT Order_ID) AS TOTAL_ORDERS
FROM Company_Sales_Data
WHERE DATEDIFF(DAY,Order_Date,Ship_Date) >= 6 ;

--(25) CATEGORY WISE DAYS DIFFERENCE IN ORDER DATE AND SHIP DATE
--(This will help to find the category with slow processing of orders)

SELECT Category, COUNT(DISTINCT Order_ID) AS TOTAL_ORDERS
FROM Company_Sales_Data
WHERE DATEDIFF(DAY,Order_Date,Ship_Date) >= 6 
GROUP BY Category
ORDER BY TOTAL_ORDERS DESC ;

--(26) MONTH ON MONTH RUNNING TOTAL OF REVENUE AND PROFIT
--(It helps to know the revenue growth over time )

SELECT YEAR(Order_Date) AS ORDER_YEAR,
MONTH(Order_date) AS Month_Number, 
FORMAT(Order_date,'MMMM') AS Month_Name,
ROUND(SUM(Sales),2) AS Total_Reveue, 
COALESCE(ROUND(SUM(Sales) + LAG(SUM(Sales))OVER(PARTITION BY YEAR(Order_Date) ORDER BY  MONTH(Order_Date)),2),0)AS RUNNING_TOTAL_OF_REVENUE,
ROUND(SUM(profit),2) AS TOTAL_PROFIT,
COALESCE(ROUND(SUM(profit) + LAG(SUM(Profit))OVER(PARTITION BY YEAR(Order_Date) ORDER BY  MONTH(Order_Date)),2),0)  AS RUNNING_TOTAL_OF_PROFIT
FROM Company_Sales_Data
GROUP BY YEAR(Order_Date), FORMAT(Order_date,'MMMM'), MONTH(Order_date)
ORDER BY Month_Number

--(27) TOP PERFORMING PRODUCT IN CATEGORY 

WITH TOP_PERFORMANCE AS (
                          SELECT Category,
						         Product_Name,
						         ROUND(SUM(Profit),2) AS TOTAL_PROFIT,
						         RANK()OVER(PARTITION BY Category ORDER BY SUM(Profit) DESC) AS Product_Rank
								 FROM Company_Sales_Data
								 GROUP BY Category, Product_Name
						)

SELECT *
FROM TOP_PERFORMANCE
WHERE Product_Rank <= 5 ;



SELECT *
FROM Company_Sales_Data

