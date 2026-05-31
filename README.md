#  ShopSmart Israel — Retail Analytics Project

##  Project Overview
End-to-end data analytics project simulating real work as a Junior Data Analyst 
at a fictional Israeli e-commerce company "ShopSmart Israel".

##  Business Problem
The company's revenue is growing but profitability is declining. 
Management needs to understand:
- Who are our most valuable customers?
- Which product categories drive the most revenue?
- Why are customers returning products?
- What are the seasonal trends in sales?

##  Tools Used
| Tool | Purpose |
|---|---|
| Python (pandas) | Dataset generation & EDA |
| SQL Server (SSMS) | Data analysis & KPI queries |
| Power Query | ETL & data transformation |
| Power BI | Interactive dashboard |
| Excel | Initial data exploration |
| GitHub | Version control & portfolio |
| matplotlib / seaborn | Data visualization |

##  Dataset
Realistic synthetic dataset generated with Python:
- **orders** — 8,000 rows
- **customers** — 1,000 rows  
- **returns** — 640 rows
- **Date range:** 2023–2024
- **Total Revenue:** ₪3,065,651

##  Key Insights
-  **Electronics** is the top category generating 49% of total revenue
-  **South region** leads all regions with ₪718,397 in revenue
-  **November** is the peak month (Black Friday effect)
-  **Age group 36-50** generates the highest revenue
-  **Return rate is 8%** — Damaged items are the top return reason
-  **Average Order Value: ₪383**

##  Dashboard Screenshots

![Executive Overview](page1_executive.png.png)
![Customer Analysis](page2_customers.png.png)
![Product & Returns](page3_products.png.png)

## 📈 Python EDA Visualizations

### Revenue by Category
![Revenue by Category](chart1_revenue_by_category.png)

### Monthly Revenue Trend
![Monthly Trend](chart2_monthly_trend.png)

### Return Rate Analysis
![Return Analysis](chart3_return_analysis.png)

### Customer Segmentation
![Customer Segmentation](chart4_customer_segmentation.png)

##  Project Structure
shopsmart-retail-analytics/
├── generate_dataset.py           # Python dataset generator
├── shopsmart_eda_analysis.ipynb  # Python EDA + visualizations
├── shopsmart_sql_analysis.sql    # 16 SQL analytical queries
├── chart1_revenue_by_category.png
├── chart2_monthly_trend.png
├── chart3_return_analysis.png
├── chart4_customer_segmentation.png
├── page1_executive.png.png       # Power BI dashboard
├── page2_customers.png.png
└── page3_products.png.png
