/* 03_reporting_queries.sql
Purpose: Business-focused reporting queries built directly in SQL
*/

USE Northwind;
GO

-- Total revenue
SELECT ROUND(SUM(line_revenue), 2) AS total_revenue
FROM vw_order_details_clean;
/* Insight:
	The dataset generates approximately 1.26M in total revenue, indicating sufficient transaction volume for meaningful business analysis. */


--Revenue by year
SELECT year,
	ROUND(SUM(line_revenue), 2) AS total_revenue
FROM vw_orders_clean AS O
JOIN vw_order_details_clean AS OD ON OD.OrderID = O.OrderID
GROUP BY year
ORDER BY year;
/* Insight:
	- Revenue peaked in 1997, showing strong year-over-year growth before declining in 1998, suggesting a possible slowdown in sales momentum.*/


-- Top customers by revenue
SELECT TOP 10 
	CompanyName,
	ROUND(SUM(line_revenue), 2) AS customer_revenue
FROM vw_orders_clean AS O
JOIN vw_order_details_clean AS OD ON O.OrderID = OD.OrderID
JOIN Customers AS C ON C.CustomerID = O.CustomerID
GROUP BY CompanyName
ORDER BY customer_revenue DESC;
/* Insight:
	- Revenue is highly concentrated among a small number of key customers, highlighting potential dependency risk on top accounts.*/


-- Revenue by country
SELECT Country,
	ROUND(SUM(line_revenue), 2) AS country_revenue
FROM vw_orders_clean AS O
JOIN vw_order_details_clean AS OD ON O.OrderID = OD.OrderID
JOIN Customers AS C ON C.CustomerID = O.CustomerID
GROUP BY Country
ORDER BY country_revenue DESC;
/* Insight:
	- Revenue is primarily driven by customers from the USA and Germany, indicating these markets as core contributors to overall sales performance.*/


-- Revenue by shipment status
SELECT is_shipped,
	CASE WHEN is_shipped = 1 THEN 'Shipped'
		ELSE 'Not Shipped'
		END AS shipment_status,
	ROUND(SUM(line_revenue), 2) AS total_revenue
FROM vw_order_details_clean AS OD
JOIN vw_orders_clean AS O ON O.OrderID = OD.OrderID
GROUP BY is_shipped;
/* Insight:
	- The vast majority of revenue comes from shipped orders, while unshipped orders represent a very small share of total revenue.*/


-- Average order value
SELECT ROUND(AVG(total_revenue), 2) AS avg_order_value
FROM (
	SELECT OD.OrderID,
		SUM(line_revenue) AS total_revenue
	FROM vw_order_details_clean AS OD
	JOIN vw_orders_clean AS O ON O.OrderID = OD.OrderID
	GROUP BY OD.OrderID) T;
/* Insight:
	- The average order value is approximately $1,525, providing a baseline for evaluating customer purchasing behavior.*/