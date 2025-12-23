USE Northwind;
GO

/*
============================================================================================================
                                        SALES SUMMARY REPORT
============================================================================================================
 This report provides a high-level summary of sales performance.
 Highlights:
    1. Tracks revenue and order volume over time.
    2. Analyzes shipment status impact on revenue.
    3. Summarizes market contribution by country.
============================================================================================================
*/

-- CREATE OR ALTER VIEW dbo.report_sales_summary AS

/*----------------------------------------------------------------------------------------------------------
1. Revenue & order volume by year
----------------------------------------------------------------------------------------------------------*/
WITH revenue_by_year AS (
	SELECT year,
		COUNT(DISTINCT O.OrderID) AS total_orders,
		ROUND(SUM(line_revenue), 2) AS total_revenue
	FROM vw_orders_clean AS O
	JOIN vw_order_details_clean AS OD ON OD.OrderID = O.OrderID
	GROUP BY year),

/*----------------------------------------------------------------------------------------------------------
2. Revenue by shipment status
----------------------------------------------------------------------------------------------------------*/
shipment_summary AS (
	SELECT is_shipped,
		COUNT(DISTINCT O.OrderID) AS total_orders,
		ROUND(SUM(line_revenue), 2) AS total_revenue
	FROM vw_orders_clean AS O
	JOIN vw_order_details_clean AS OD ON O.OrderID = OD.OrderID
	GROUP BY is_shipped),

/*----------------------------------------------------------------------------------------------------------
3. Revenue by customer country
----------------------------------------------------------------------------------------------------------*/
country_summary AS (
	SELECT Country,
		COUNT(DISTINCT O.OrderID) AS total_orders,
		ROUND(SUM(line_revenue), 2) AS total_revenue
	FROM vw_orders_clean O
	JOIN vw_order_details_clean OD ON OD.OrderID = O.OrderID
	JOIN Customers AS C ON C.CustomerID = O.CustomerID
	GROUP BY Country)

/*----------------------------------------------------------------------------------------------------------
4. Final sales summary (flattened)
----------------------------------------------------------------------------------------------------------*/
SELECT 'Yearly Performance' AS summary_type,
	CAST(year AS VARCHAR(20)) AS dimension,
	total_orders,
	total_revenue
FROM revenue_by_year

UNION ALL

SELECT 'shipment_summary' AS summary_type,
	CASE WHEN is_shipped = 1 THEN 'Shipped'
		ELSE 'Not Shipped'
		END AS dimension,
	total_orders,
	total_revenue
FROM shipment_summary

UNION ALL

SELECT 'Country Contribution' AS summary_type,
	Country AS dimension,
	total_orders,
	total_revenue
FROM country_summary;