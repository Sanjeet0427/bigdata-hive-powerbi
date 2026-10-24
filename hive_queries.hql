-- ============ BIG DATA ANALYTICS: E-COMMERCE SALES (Hive) ============
-- Dataset: sales_data.csv (200,000 orders, India, 2025)

CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- 1. Raw table (text)
CREATE TABLE IF NOT EXISTS sales_raw (
  order_id INT, order_date STRING, customer_id INT, city STRING,
  category STRING, product STRING, quantity INT, unit_price DOUBLE,
  discount_pct INT, payment_mode STRING, delivery_days INT,
  rating INT, revenue DOUBLE
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

-- Upload to HDFS first:  hdfs dfs -put sales_data.csv /user/hive/data/
LOAD DATA LOCAL INPATH '/tmp/sales_data.csv' INTO TABLE sales_raw;

-- 2. Optimised table (ORC, partitioned by month)
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

CREATE TABLE IF NOT EXISTS sales_orc (
  order_id INT, order_date STRING, customer_id INT, city STRING,
  category STRING, product STRING, quantity INT, unit_price DOUBLE,
  discount_pct INT, payment_mode STRING, delivery_days INT,
  rating INT, revenue DOUBLE
) PARTITIONED BY (order_month STRING)
STORED AS ORC;

INSERT OVERWRITE TABLE sales_orc PARTITION (order_month)
SELECT *, substr(order_date,1,7) FROM sales_raw;

-- ================= ANALYSIS QUERIES =================

-- Q1: Revenue by category
SELECT category, COUNT(*) AS total_orders, ROUND(SUM(revenue),2) AS total_revenue
FROM sales_orc GROUP BY category ORDER BY total_revenue DESC;

-- Q2: Monthly revenue trend
SELECT order_month AS month, COUNT(*) AS total_orders, ROUND(SUM(revenue),2) AS total_revenue
FROM sales_orc GROUP BY order_month ORDER BY order_month;

-- Q3: City performance
SELECT city, COUNT(*) AS total_orders, ROUND(SUM(revenue),2) AS total_revenue,
       ROUND(AVG(delivery_days),2) AS avg_delivery_days, ROUND(AVG(rating),2) AS avg_rating
FROM sales_orc GROUP BY city ORDER BY total_revenue DESC;

-- Q4: Payment mode share
SELECT payment_mode, COUNT(*) AS total_orders, ROUND(SUM(revenue),2) AS total_revenue
FROM sales_orc GROUP BY payment_mode ORDER BY total_orders DESC;

-- Q5: Top 10 products
SELECT category, product, SUM(quantity) AS units_sold, ROUND(SUM(revenue),2) AS total_revenue
FROM sales_orc GROUP BY category, product ORDER BY total_revenue DESC LIMIT 10;

-- Q6: Does discount affect rating?
SELECT discount_pct, COUNT(*) AS total_orders, ROUND(AVG(rating),2) AS avg_rating
FROM sales_orc GROUP BY discount_pct ORDER BY discount_pct;
