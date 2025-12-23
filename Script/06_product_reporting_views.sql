USE Northwind;
GO
/*
============================================================================================================
                                            PRODUCT REPORT
============================================================================================================
 This report summarizes product-level performance and contribution.
 Highlights:
    1. Aggregates revenue, quantity, and order coverage by product.
    2. Enriches products with category and lifecycle status.
    3. Calculates KPIs:
        - average revenue per order
        - average price per unit
    4. Supports ranking and portfolio analysis.
============================================================================================================
*/

--CREATE OR ALTER VIEW dbo.report_products AS

/*----------------------------------------------------------------------------------------------------------
1. Base query: Retrieve transaction-level product data
----------------------------------------------------------------------------------------------------------*/
WITH basequery AS (
	SELECT OrderID,
		P.ProductID,
		ProductName,
		CategoryName,
		Quantity,
		line_revenue,
		P.UnitPrice,
		Discontinued
	FROM vw_order_details_clean AS O
	JOIN Products AS P ON P.ProductID = O.ProductID
	LEFT JOIN Categories AS CAT ON CAT.CategoryID = P.CategoryID),

/*----------------------------------------------------------------------------------------------------------
2. Product aggregation: Aggregate metrics at product level
----------------------------------------------------------------------------------------------------------*/
product_aggregation AS (
	SELECT ProductID,
		ProductName,
		CategoryName,
		Discontinued,
		COUNT(DISTINCT OrderID) AS total_orders,
		SUM(Quantity) AS total_quantity,
		SUM(line_revenue) AS total_revenue,
		AVG(UnitPrice) AS avg_list_price
	FROM basequery
	GROUP BY ProductID, ProductName, CategoryName, Discontinued)

/*----------------------------------------------------------------------------------------------------------
3. Final product report with KPIs
----------------------------------------------------------------------------------------------------------*/
SELECT ProductID,
	ProductName,
	CategoryName,
	CASE WHEN Discontinued = 1 THEN 'Discontinued'
		ELSE 'Active'
		END AS product_status,
	total_orders,
	total_quantity,
	ROUND(total_revenue, 2) AS total_revenue,
	-- Average revenue per order
	CASE WHEN total_orders = 0 THEN 0
		ELSE ROUND(total_revenue / total_orders, 2)
		END AS avg_revenue_per_order,
	-- Average revenue per unit sold
	CASE WHEN total_revenue = 0 THEN 0
		ELSE ROUND(total_quantity / total_revenue, 2)
		END AS avg_revenue_per_unit,
	ROUND(avg_list_price, 2) AS avg_list_price
FROM product_aggregation;