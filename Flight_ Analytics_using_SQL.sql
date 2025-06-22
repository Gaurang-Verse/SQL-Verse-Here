# Flight Analytics
**Created by:** Gaurang Kumbhar  
**Email:** gaurang.kumbhar1332003@gmail.com  
## Overview
This project focuses on performing in-depth analysis of flight data using SQL. It demonstrates the application of advanced SQL techniques, including:
- **Window Functions**  
- **Aggregate Functions**  
- **CASE Statements**
These concepts are used to extract meaningful insights, rank and compare flight performance, and segment data based on various conditions.
## Purpose
This repository serves as a reference for understanding and applying complex SQL queries in real-world data scenarios, especially in the context of aviation and flight datasets.





CREATE DATABASE flight_analytics;
USE flight_analytics;


SELECT * FROM Flights;

#Calculate Total Profit for a Specific Route
SELECT SUM(Profitability) AS TotalProfit
FROM Flights
WHERE Route = 'BNE-SYD';

#Observe Flights with Frequent Flyer Status
SELECT * FROM Flights
WHERE `Frequent Flyer Status` = 'Gold';


#Find the Customers with the Highest Total Ticket Prices 
SELECT `Customer ID`, Name, SUM(`Ticket Price`) AS TotalSpent
FROM Flights
GROUP BY `Customer ID`, Name
ORDER BY TotalSpent DESC
LIMIT 50;


#Find Flights with Ticket Price Higher than Competitor Price
SELECT * FROM Flights
WHERE `Ticket Price` > `Competitor Price`;


SELECT
    Route,
    `Ticket Price`,
    `Competitor Price`,
    CASE
        WHEN `Ticket Price` > `Competitor Price` THEN 'Higher'
        WHEN `Ticket Price` < `Competitor Price` THEN 'Lower'
        ELSE 'Equal'
    END AS PriceComparison
FROM Flights;

SELECT Route, MAX(Profitability) AS MaxProfit
FROM Flights
GROUP BY Route ORDER BY MaxProfit DESC
LIMIT 1;

SELECT `Departure City`, SUM(`Ticket Price`) AS TotalRevenue
FROM Flights
GROUP BY `Departure City`;

SELECT
    Route,
    `Departure Date`,
    `Ticket Price`,
    SUM(`Ticket Price`) OVER (PARTITION BY Route ORDER BY `Departure Date`) AS RunningTotal
FROM Flights
ORDER BY Route, `Departure Date`;

SELECT * FROM Flights
WHERE Demand > 1.9 order by Demand desc;


SELECT
    `Departure Date`,
    `Delay Minutes`,
    AVG(`Delay Minutes`) OVER (ORDER BY `Departure Date` ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS AvgDelay
FROM Flights
ORDER BY `Departure Date`;

SELECT
    Route,
    `Departure Date`,
    `Ticket Price`,
    `Ticket Price` - LAG(`Ticket Price`) OVER (PARTITION BY Route ORDER BY `Departure Date`) AS PriceDifference
FROM Flights
ORDER BY Route, `Departure Date`;


WITH CustomerSpending AS (
    SELECT
        `Departure Date`,
        `Customer ID`,
        SUM(`Ticket Price`) AS TotalSpent
    FROM Flights
    GROUP BY `Departure Date`, `Customer ID`)
SELECT
    `Departure Date`,
    `Customer ID`,
    TotalSpent,
    DENSE_RANK() OVER (PARTITION BY `Departure Date` ORDER BY TotalSpent DESC) AS DenseCustomerRank
FROM CustomerSpending
ORDER BY `Departure Date`, DenseCustomerRank

SELECT
    `Departure City`,
    `Arrival City`,
    CASE
        WHEN `Delay Minutes` <= 20 THEN 'Reasonable Lated'
        ELSE 'Delayed'
    END AS FlightStatus
FROM Flights;

