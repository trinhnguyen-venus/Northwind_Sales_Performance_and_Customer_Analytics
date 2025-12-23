/* 01_data_exploration.sql
Purpose: Understand dataset structure, coverage, and basic data characteristics */

USE Northwind;
GO

-- List all base tables
SELECT 
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- Row count per key table
SELECT 'Customers' AS table_name, COUNT(*) AS row_count FROM Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Order Details', COUNT(*) FROM [Order Details]
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'Suppliers', COUNT(*) FROM Suppliers;

-- Order date range
SELECT MIN(OrderDate) AS first_order_date,
	MAX(OrderDate) AS last_order_date,
	COUNT(DISTINCT YEAR(OrderDate)) AS number_of_years
FROM Orders

-- Customers distribution by country
SELECT Country,
	COUNT(*) AS customer_count
FROM Customers
GROUP BY Country
ORDER BY customer_count DESC;

-- Orders volume by year
SELECT YEAR(OrderDate) AS year,
	COUNT(*) AS number_of_order
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate)

-- Orders without customer reference
SELECT COUNT(*) orders_without_customer
FROM Orders
WHERE CustomerID IS NULL

-- Orders not yet shipped
SELECT COUNT(*) AS unshipped_orders
FROM Orders
WHERE ShippedDate IS NULL
