## Brazilian E-Commerce 
## Project Objective
Analyze Brazilian E-Commerce sales, logistics, and customer satisfaction across a 3-page interactive dashboard. 
## Tools & Concepts Used
-	Data Model: Star Schema (Fact_Order_Items + 5 Dimensions: Customer, Product, Sellers, Payment, Date).
-	Power Query ETL: Merged queries, fixed missing postal codes (NULL to 00000), split date fields, and set Geo Data Categories. 
-	DAX Metrics: CALCULATE, FILTER, SAMEPERIODLASTYEAR, DIVIDE, DISTINCTCOUNT, SUM, AVERAGE.
## Key Features & Visual Previews
-	Overall Performance: $13.59M revenue, 99K orders, YoY growth, top products/sellers, payment types. 
-	Delivery & Logistics: $2.25M freight cost, regional density, state shipping map. 
-	Customer Satisfaction: 57K 5-star ratings, 6.5K delayed orders, review score vs. lead time. 
## Key Business Insights & Recommendations
-	Credit card is the top payment method; sales center in Sao Paulo & Rio. 
-	Achieved 93% on-time delivery with 12.41 average delivery days. 
-	Delivery delay directly reduces review scores; speed up logistics to boost ratings. 
## How to Run / Files
Open the `e commerce.pbix` file in Power BI Desktop and navigate using the sidebar menu. 
