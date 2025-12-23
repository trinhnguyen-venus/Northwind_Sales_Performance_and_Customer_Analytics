USE Northwind;
GO

/*
============================================================================================================
                                            CUSTOMER REPORT
============================================================================================================
 This report consolidates key customer-level metrics and purchasing behavior.
 Highlights:
    1. Builds customer-level sales history from order and order detail data.
    2. Aggregates key metrics:
        - total orders
        - total revenue
        - total quantity purchased
        - total distinct products purchased
        - customer lifespan (in months)
    3. Calculates important KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend
    4. Segments customers based on lifecycle and revenue contribution.
============================================================================================================
*/


/*----------------------------------------------------------------------------------------------------------
1. Base query: Retrieve transaction-level customer data
----------------------------------------------------------------------------------------------------------*/
WITH base_query AS (
	SELECT O.OrderID,
		OrderDate,
		C.CustomerID,
		CompanyName AS customer_name,
		ProductID,
		Quantity,
		line_revenue
	FROM vw_orders_clean AS O
	JOIN vw_order_details_clean AS OD ON OD.OrderID = O.OrderID
	JOIN Customers AS C ON C.CustomerID = O.CustomerID),

/*----------------------------------------------------------------------------------------------------------
2. Customer aggregation: Aggregate metrics at customer level
----------------------------------------------------------------------------------------------------------*/
customer_aggregation AS (
	SELECT CustomerID,
		customer_name,
		COUNT(DISTINCT OrderID) AS total_orders,
		SUM(line_revenue) AS total_revenue,
		SUM(Quantity) AS total_quantity,
		COUNT(DISTINCT ProductID) AS total_products,
		MIN(OrderDate) AS first_order_date,
		MAX(OrderDate) AS last_order_date,
		DATEDIFF(MONTH, MIN(OrderDate), MAX(OrderDate)) AS lifespan
	FROM base_query
	GROUP BY CustomerID, customer_name)

/*----------------------------------------------------------------------------------------------------------
3. Final customer report with KPIs and segmentation
----------------------------------------------------------------------------------------------------------*/
SELECT CustomerID,
	customer_name,
	total_orders,
	total_products,
	total_quantity,
	ROUND(total_revenue, 2) AS total_revenue,
	first_order_date,
	last_order_date,
	lifespan,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_in_months,
	-- Average Order Value
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE ROUND(total_revenue / total_orders, 2)
		END AS avg_order_value,
	-- Average Monthly Spend
	CASE 
		WHEN lifespan = 0 THEN ROUND(total_revenue, 2)
		ELSE ROUND(total_revenue / lifespan, 2)
		END AS avg_monthly_spend,
	-- Customer Segmentation
	CASE 
		WHEN lifespan >= 12 AND total_revenue >= 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_revenue < 5000 THEN 'Regular'
		ELSE 'New'
		END AS customer_segment
FROM customer_aggregation;

