# 📊 Northwind Sales Performance & Customer Analytics (SQL)
## 1. Project Overview

This project analyzes historical sales data from the Northwind database to understand how the business generates revenue, which customers and products drive performance, and how sales are distributed across markets.

The analysis is performed entirely in SQL, with reporting logic built directly at the database level.

## 2. Business Questions

- How has sales revenue evolved over time?
- Which customers contribute the most to total revenue?
- How concentrated is revenue across customers and countries?
- Which products and categories contribute most to sales?
- How does shipment status impact realized revenue?

## 3. Key Insights

- The dataset generated approximately $1.26M in total revenue over the observed period, providing a solid basis for performance analysis.
- Revenue grew strongly from 1996 to peak in 1997, before declining in 1998, indicating a potential slowdown in sales momentum.
- Revenue is highly concentrated among a small group of customers, with the top accounts contributing a disproportionately large share of total sales.
- The USA and Germany are the two largest revenue-contributing markets, together accounting for a significant portion of total revenue.
- Nearly all revenue comes from shipped orders, while unshipped orders represent only a minimal share of sales.
- Product performance varies significantly by category, suggesting uneven contribution across the product portfolio.

## 4. Recommendations

- Closely monitor dependency on top customers to reduce concentration risk.
- Investigate the causes behind the revenue decline after 1997, including market demand and operational factors.
- Maintain focus on core markets such as the USA and Germany while assessing growth opportunities in mid-performing countries.
- Review underperforming product categories to identify opportunities for pricing, promotion, or portfolio optimization.
- Continue prioritizing efficient shipment processes, as timely deliveries are critical to revenue realization.

## Files Included

`00_prepare_northwind_data.sql`
`01_data_exploration.sql`
`02_data_cleaning.sql`
`03_reporting_queries.sql`
`04_customer_reporting_views.sql`
`05_product_reporting_views.sql`
`06_final_sales_summary_views.sql`

## Author
**Trinh Nguyen**  

📧 Contact: ng.trinh3023@gmail.com

📍 GitHub: [https://trinhnguyen-venus.github.io/](https://trinhnguyen-venus.github.io/)

