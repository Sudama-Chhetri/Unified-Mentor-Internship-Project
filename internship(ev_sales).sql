-- Create Database and Table
-- Step 1: Create a new database
CREATE DATABASE ev_sales_india;

-- Step 2: Use the database
USE ev_sales_india;

-- View a few rows
SELECT * FROM ev_sales LIMIT 10;

-- Basic Data Check
-- Check how many records
SELECT COUNT(*) AS Total_Rows FROM ev_sales;

-- Distinct states and years
SELECT DISTINCT State FROM ev_sales;
SELECT DISTINCT Year FROM ev_sales;

-- Total years of data
SELECT MIN(Year) AS Start_Year, MAX(Year) AS End_Year FROM ev_sales;

-- Total EV Sales Over the Years
-- Total sales by year
SELECT 
    Year, 
    SUM(EV_Sales_Quantity) AS Total_EV_Sales
FROM 
    ev_sales
GROUP BY 
    Year
ORDER BY 
    Year;
    

-- Top 10 States by Total EV Sales
SELECT 
    State,
    SUM(EV_Sales_Quantity) AS Total_EV_Sales
FROM 
    ev_sales
GROUP BY 
    State
ORDER BY 
    Total_EV_Sales DESC
LIMIT 10;

-- Find Top 5 states first
SELECT 
    State,
    SUM(EV_Sales_Quantity) AS Total_Sales
FROM 
    ev_sales
GROUP BY 
    State
ORDER BY 
    Total_Sales DESC
LIMIT 5;

-- Year-wise sales for those states
SELECT 
    Year,
    State,
    SUM(EV_Sales_Quantity) AS Yearly_Sales
FROM 
    ev_sales
WHERE 
    State IN ('Delhi', 'Maharashtra', 'Karnataka', 'Tamil Nadu', 'Uttar Pradesh')
GROUP BY 
    Year, State
ORDER BY 
    Year, Yearly_Sales DESC;
    
-- Step 1: Create a temp table with previous year’s sales
CREATE TEMPORARY TABLE ev_with_prev_year AS
SELECT 
    a.State,
    a.Year,
    a.EV_Sales_Quantity AS Current_Year_Sales,
    b.EV_Sales_Quantity AS Previous_Year_Sales
FROM 
    ev_sales a
LEFT JOIN 
    ev_sales b 
    ON a.State = b.State AND a.Year = b.Year + 1;

-- Step 2: Calculate YoY Growth %
SELECT 
    State,
    Year,
    Current_Year_Sales,
    Previous_Year_Sales,
    ROUND(((Current_Year_Sales - Previous_Year_Sales) / Previous_Year_Sales) * 100, 2) AS YoY_Growth_Percent
FROM 
    ev_with_prev_year
WHERE 
    Previous_Year_Sales IS NOT NULL
ORDER BY 
    State, Year;
    
--  Identify Consistently Growing States
-- States with average positive YoY growth
SELECT 
    State,
    ROUND(AVG((Current_Year_Sales - Previous_Year_Sales) / Previous_Year_Sales) * 100, 2) AS Avg_YoY_Growth
FROM 
    ev_with_prev_year
WHERE 
    Previous_Year_Sales > 0
GROUP BY 
    State
HAVING 
    Avg_YoY_Growth > 0
ORDER BY 
    Avg_YoY_Growth DESC
LIMIT 10;

-- Least Performing States
-- Bottom 5 states by total sales
SELECT 
    State,
    SUM(EV_Sales_Quantity) AS Total_EV_Sales
FROM 
    ev_sales
GROUP BY 
    State
ORDER BY 
    Total_EV_Sales ASC
LIMIT 5;

-- State vs Year Pivot View (for Visualization)
-- Pivot-style output (manual)
SELECT 
    State,
    SUM(CASE WHEN Year = 2017 THEN EV_Sales_Quantity ELSE 0 END) AS '2017',
    SUM(CASE WHEN Year = 2018 THEN EV_Sales_Quantity ELSE 0 END) AS '2018',
    SUM(CASE WHEN Year = 2019 THEN EV_Sales_Quantity ELSE 0 END) AS '2019',
    SUM(CASE WHEN Year = 2020 THEN EV_Sales_Quantity ELSE 0 END) AS '2020',
    SUM(CASE WHEN Year = 2021 THEN EV_Sales_Quantity ELSE 0 END) AS '2021',
    SUM(CASE WHEN Year = 2022 THEN EV_Sales_Quantity ELSE 0 END) AS '2022'
FROM 
    ev_sales
GROUP BY 
    State;


-- MySQL helped uncover trends in electric vehicle adoption across Indian states.
-- Year-over-year growth and regional differences were analyzed in detail.
-- Using SQL queries, we extracted top-performing and underperforming states, calculated growth rates, and prepared data for visualizations.
-- This analysis enhanced my SQL skills in real-world data processing and reporting.








