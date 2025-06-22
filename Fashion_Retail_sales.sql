CREATE DATABASE fashion_retail;
USE fashion_retail;

CREATE TABLE fashion_sales (
    Customer_ID VARCHAR(50),
    Item_Purchased VARCHAR(100),
    Purchase_Amount DECIMAL(10,2),
    Date_Purchase DATE,
    Review_Rating FLOAT,
    Payment_Method VARCHAR(50)
);

SELECT * FROM fashion_sales LIMIT 10;


SELECT SUM(Purchase_Amount) AS Total_Revenue FROM fashion_sales;


### Average Rating per Item
SELECT Item_Purchased, COUNT(*) AS Purchase_Count
FROM fashion_sales
GROUP BY Item_Purchased
ORDER BY Purchase_Count DESC;

### Sales by Payment Method
SELECT Item_Purchased, ROUND(AVG(Review_Rating), 2) AS Avg_Rating
FROM fashion_sales
GROUP BY Item_Purchased
ORDER BY Avg_Rating DESC;

### Categorize Purchases by Rating

SELECT *,
  CASE
    WHEN Review_Rating >= 4.5 THEN 'Excellent'
    WHEN Review_Rating >= 3 THEN 'Good'
    ELSE 'Poor'
  END AS Rating_Category
FROM fashion_sales;

### Identify High-Value Customers
SELECT Customer_ID, SUM(Purchase_Amount) AS Total_Spent
FROM fashion_sales
GROUP BY Customer_ID
HAVING Total_Spent > 500
ORDER BY Total_Spent DESC;


### Running Total of Purchases per Customer
SELECT
  Customer_ID,
  Date_Purchase,
  Purchase_Amount,
  SUM(Purchase_Amount) OVER (PARTITION BY Customer_ID ORDER BY Date_Purchase) AS Running_Total
FROM fashion_sales;

### Rank Items by Revenue Using Window Function
SELECT
  Item_Purchased,
  SUM(Purchase_Amount) AS Total_Revenue,
  DENSE_RANK() OVER (ORDER BY SUM(Purchase_Amount) DESC) AS Revenue_Rank
FROM fashion_sales
GROUP BY Item_Purchased;



### Find Monthly Sales Trends
SELECT
  DATE_FORMAT(Date_Purchase, '%Y-%m') AS Month,
  SUM(Purchase_Amount) AS Monthly_Revenue
FROM fashion_sales
GROUP BY Month
ORDER BY Month;


### Moving Average of Purchases Over Time
SELECT
  Date_Purchase,
  Purchase_Amount,
  AVG(Purchase_Amount) OVER (ORDER BY Date_Purchase ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Moving_Avg
FROM fashion_sales;


### Compare Review Ratings Using LAG
SELECT
  Customer_ID,
  Date_Purchase,
  Review_Rating,
  Review_Rating - LAG(Review_Rating) OVER (PARTITION BY Customer_ID ORDER BY Date_Purchase) AS Rating_Change
FROM fashion_sales;

### Top Customers by Payment Method
SELECT
  Payment_Method,
  Customer_ID,
  SUM(Purchase_Amount) AS Total_Spent,
  DENSE_RANK() OVER (PARTITION BY Payment_Method ORDER BY SUM(Purchase_Amount) DESC) AS Rank_in_Method
FROM fashion_sales
GROUP BY Payment_Method, Customer_ID;






### Create Views for Reusability
CREATE VIEW Top_5_Items AS
SELECT Item_Purchased, COUNT(*) AS Purchase_Count
FROM fashion_sales
GROUP BY Item_Purchased
ORDER BY Purchase_Count DESC
LIMIT 5;


