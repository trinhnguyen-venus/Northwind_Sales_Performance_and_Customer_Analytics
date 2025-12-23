-- 02_data_cleaning.sql
-- Purpose: Prepare clean, reporting-ready datasets without altering raw data

USE Northwind;
GO

/* NOTE:
   - This script does NOT modify or delete raw tables.
   - Cleaning is done via derived tables / views for reporting purposes only. 
*/

-- Clean Orders for reporting
-- Order-level dataset with shipment status and time attributes
CREATE OR ALTER VIEW vw_orders_clean AS
SELECT OrderID,
	CustomerID,
	EmployeeID,
	OrderDate,
	YEAR(OrderDate) AS order_year,
	MONTH(OrderDate) AS order_year,
	ShippedDate,
	CASE WHEN ShippedDate IS NULL THEN 0
		ELSE 1
		END AS is_shipped,
	ShipCountry,
	Freight
FROM Orders;

-- Clean Order Details for reporting
-- Line-level revenue calculation
CREATE OR ALTER VIEW vw_order_details_clean  AS
SELECT OrderID,
	ProductID,
	UnitPrice,
	Quantity,
	Discount,
	UnitPrice * Quantity * (1 - Discount) AS line_revenue
FROM [Order Details];

-- Clean Products for reporting
-- Product master enriched with category
CREATE OR ALTER VIEW vw_products_clean AS
SELECT ProductID,
	ProductName,
	CategoryName,
	UnitPrice,
	Discontinued
FROM Products AS P
LEFT JOIN Categories AS C ON P.CategoryID = C.CategoryID;

-- Validate cleaned views
SELECT COUNT(*) FROM vw_orders_clean;
SELECT COUNT(*) FROM vw_order_details_clean;
SELECT COUNT(*) FROM vw_products_clean;
