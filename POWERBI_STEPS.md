# Power BI Dashboard Steps

1. Power BI Desktop -> Get Data -> Text/CSV -> load all q1..q6 CSV files (or sales_data.csv for slicers).
2. Page 1 (Overview):
   - Cards: Total Revenue, Total Orders, Avg Rating (from q3 / sales_data)
   - Clustered bar: q1 category vs total_revenue
   - Line chart: q2 month vs total_revenue
3. Page 2 (Geography & Payments):
   - Map or bar: q3 city vs total_revenue (tooltip: avg_delivery_days)
   - Donut: q4 payment_mode vs total_orders
4. Page 3 (Products & Discounts):
   - Table: q5 top 10 products
   - Column chart: q6 discount_pct vs avg_rating
5. Add slicers (city, category) using sales_data.csv.
6. Live Hive connection (optional): install Hive ODBC driver -> Get Data -> ODBC -> DSN -> select ecommerce.sales_orc.
