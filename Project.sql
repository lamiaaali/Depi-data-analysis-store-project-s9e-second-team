use sales_data

-- I- KEY METRICS
--  What is the total number of orders, total sales, and number of customers in the dataset?
select count(distinct [Order ID]) as [total orders], 
sum(sales) as [Total Sales], 
count(distinct([customer id])) as [Total number of ustomers] , 
count([Order ID]) as [total number of distinct customers ]
from sales_data


--******************************************************************************************************************
-- II- CUSTOMER INSIGHTS
-- Which customer segment has the most orders?
select segment, count(distinct([order id])) as [number of orders], sum(sales) as [total sales]
from sales_data
group by Segment
order by [number of orders] desc

-- Repeat Customer Rate?
WITH FirstOrder AS (
SELECT [Customer ID], MIN([Order Date]) AS FirstOrderDate
FROM sales_data
GROUP BY [Customer ID]
),
RepeatCustomers AS (
SELECT o.[Customer ID], COUNT(*) AS RepeatOrders
FROM sales_data o
JOIN FirstOrder f ON o.[Customer ID] = f.[Customer ID]
WHERE o.[Order Date] > f.FirstOrderDate
GROUP BY o.[Customer ID]
)
SELECT 
    (SELECT COUNT(*) FROM RepeatCustomers) * 100.0 / (SELECT COUNT(*) FROM FirstOrder) AS CustomerRetentionRate

-- What is the number of products for each customer per order?
select top 10 [Order ID] ,[Customer Name], count([Product Name]) as [order size]
from sales_data
group by [Order ID],[Customer Name]
order by [order size] desc

-- Which customer placed the most orders?
select top 15 [Customer Name],[Customer ID],count(*) as [number of orders], sum(Sales) as [total sales]
from sales_data
group by [Customer Name],[Customer ID]
order by [number of orders] desc

-- What is the total sales generated by each customer?
select [Customer ID], [Customer Name], sum(sales) as [total sales]
from sales_data
group by [Customer ID], [Customer Name]
order by [total sales] desc

-- Which customers purchased the most products overall?
SELECT top 10 [Customer ID],[Customer Name], COUNT([Product Name]) AS [Total Products Purchased]
FROM sales_data
GROUP BY [Customer ID], [Customer Name]
ORDER BY [Total Products Purchased] DESC

--*************************************************************************************************************
-- III- PRODUCT PERFORMANCE
-- Which product category generates the most sales?
select Category, sum(sales) as [total sales]
from sales_data
group by Category
order by [total sales] desc

-- What are the top 10 products by revenue?
select top 10 [Product Name], [Product ID], sum(sales) as [total sales]
from sales_data
group by [Product Name], [Product ID]
order by [total sales] desc


-- Which product category has the highest average sales price?
select Category, round(avg(sales),2) as [average sales]
from sales_data
group by Category
order by [average sales] desc

-- Which product sub-category has the highest sales volume?
select [Sub-Category], sum(sales) as [total sales]
from sales_data
group by [Sub-Category]
order by [total sales] desc

--*****************************************************************************************************************
-- IV- GEOGRAPHIC INSIGHTS
-- What are the top 5 states by sales?
select top 5 State, sum(sales) as [total sales]
from sales_data
group by State
order by [total sales] desc

--  What are the top 10 cities by sales?
SELECT top 10 [City], SUM(Sales) AS [Total sales]
FROM sales_data
GROUP BY [City]
ORDER BY [Total sales] DESC

-- Which city has the highest number of orders?
select top 10 City, count(distinct([Order ID])) as [number of orders]
from sales_data
group by City
order by [number of orders] desc

-- What is the total revenue by region?
select Region, sum(sales) as [total sales]
from sales_data
group by Region
order by [total sales] desc

-- Which state has the highest number of customers?
select State, count(distinct([Customer ID])) as [number of customers] 
from sales_data
group by State
order by [number of customers] desc

-- What is the total number of orders for each region?
select Region, count(distinct([order ID])) as [number of orders]
from sales_data
group by Region
order by [number of orders] desc
-- ***********************************************************************************************************************

-- V- SHIPPING ANALYSIS
-- What is the average shipping time (days between order date and ship date)?
SELECT AVG(DATEDIFF(DAY, [Order Date], [Ship Date])) AS AvgShippingTime
FROM sales_data;

-- What is the most popular shipping mode?
WITH DeliveryTimes AS (
SELECT [Order ID], [Ship Mode], DATEDIFF(day, [Order Date], [Ship Date]) AS Delivery_Days, [Sales]
FROM sales_data
)
SELECT [Ship Mode], COUNT(DISTINCT [Order ID]) AS Number_of_Orders, SUM([Sales]) AS Total_Sales,
AVG(Delivery_Days) AS Avg_Delivery_Time, MIN(Delivery_Days) AS Min_Delivery_Time, MAX(Delivery_Days) AS Max_Delivery_Time
FROM DeliveryTimes
GROUP BY [Ship Mode]
ORDER BY Avg_Delivery_Time desc;
--********************************************************************************************
-- VI- YEARLY SALES OVERVIEW
-- What is the total sales by year?
select year([Order Date]) as year, sum(sales) as [total sales]
from sales_data
group by year([Order Date])
order by year

-- How many orders and what is total sales were placed in each quarter of the years?
SELECT DATEPART(YEAR, [Order Date]) AS [Order Year], DATEPART(QUARTER, [Order Date]) AS [Order Quarter],
COUNT(DISTINCT [Order ID]) AS [Total Orders], SUM(Sales) AS [Total Sales]
FROM sales_data
GROUP BY DATEPART(YEAR, [Order Date]), DATEPART(QUARTER, [Order Date])
ORDER BY [Order Year], [Order Quarter];

-- How many orders were placed each month?
select month([Order Date]) as month, count(distinct([order id])) as [umber of orders]
from sales_data
group by month([Order Date])
order by month

--*************************************************************************************************