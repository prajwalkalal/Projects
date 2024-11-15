create database salesDataWalmart;
use salesDataWalmart;

create table sales( 
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float (6,4) not null,
total decimal(12,5) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,9),
gross_income decimal(12,4) not null,
rating float(2,1)
);

-- ------------------- --
-- FEATURE ENGINEERING --
-- ------------------- --

-- TIME OF DAY --

SELECT 
    time,
    (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM
    sales;

alter table sales add column time_of_day varchar(20);

UPDATE sales 
SET 
    time_of_day = (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);
    
-- DAY NAME --    

SELECT 
    date, DAYNAME(date)
FROM
    sales;

alter table sales add column day_name varchar(10);

UPDATE sales 
SET 
    day_name = DAYNAME(date);

-- MONTH NAME --

SELECT 
    DATE, MONTHNAME(DATE)
FROM
    SALES;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE SALES 
SET 
    month_name = MONTHNAME(DATE);

-- ------- --
-- GENERIC --
-- ------- --

-- 1. How many unique cities does data have ?

SELECT DISTINCT
    city
FROM
    sales;

-- 2. In which city is each branch ?

SELECT DISTINCT
    branch
FROM
    sales;

SELECT DISTINCT
    city, branch
FROM
    sales;

-- ----------
-- PRODUCT --
-- ------- --

-- 1. How many unique product lines does the data have ?

SELECT 
    COUNT(DISTINCT product_line)
FROM
    sales;

-- 2. What is the most common payment method ?

SELECT 
    payment_method, COUNT(payment_method) AS cnt
FROM
    sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- 3. What is the most selling product line ?

SELECT 
    product_line, COUNT(product_line) AS cnt
FROM
    sales
GROUP BY product_line
ORDER BY cnt DESC;

-- 4. What is the total revenue by month ?

SELECT 
    month_name AS month, SUM(total) AS total_revenue
FROM
    sales
GROUP BY month
ORDER BY total_revenue DESC;

-- 5. What month had the largest COGS?

SELECT 
    month_name AS month, SUM(cogs) AS cogs
FROM
    sales
GROUP BY month_name
ORDER BY cogs desc;

-- 6. What product line had the largest revenue?

SELECT 
    product_line, SUM(total) AS total_revenue
FROM
    sales
GROUP BY product_line
ORDER BY total_revenue DESC;  

-- 7. What is the city with the largest revenue?

SELECT 
    branch, city, SUM(total) AS total_revenue
FROM
    sales
GROUP BY city,branch
ORDER BY total_revenue DESC;

-- 8. What product line had the largest VAT?

SELECT 
    product_line, AVG(VAT) AS avg_tax
FROM
    sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- 10. Which branch sold more products than average product sold?

SELECT 
    branch, SUM(quantity) AS qty
FROM
    sales
GROUP BY branch
having sum(quantity) > (select avg(quantity) from sales);

-- 11. What is the most common product line by gender ?

SELECT 
    gender, product_line, COUNT(gender) AS total_cnt
FROM
    sales
GROUP BY gender , product_line
ORDER BY total_cnt DESC; 

-- 12. What is the average rating of each product line?

SELECT 
    product_line, ROUND(AVG(rating), 2) AS avg_rating
FROM
    sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- ----- --
-- SALES --
-- ----- --

-- 1. Number of sales made in each time of the day per weekday

SELECT 
    time_of_day, COUNT(*), day_name AS total_sales
FROM
    sales
GROUP BY time_of_day , day_name
ORDER BY day_name DESC;

-- 2. Which of the customer types brings the most revenue?

SELECT 
    customer_type, SUM(total) AS total_revenue
FROM
    sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?

SELECT 
    city, AVG(VAT) as VAT
FROM
    sales
GROUP BY city
order by VAT desc;

-- 4. Which customer type pays the most in VAT?

select customer_type, avg(VAT) as VAT from sales group by customer_type order by VAT desc;

-- --------- --
-- CUSTOMERS --
-- --------- --

-- 1. How many unique customer types does the data have?

SELECT DISTINCT
    customer_type
FROM
    sales;

-- 2. How many unique payment methods does the data have?

SELECT DISTINCT
    payment_method
FROM
    sales;

-- 3. What is the most common customer type?

SELECT 
    customer_type,(customer_type)
FROM
    sales
GROUP BY customer_type;

-- 4. Which customer type buys the most?

SELECT 
    customer_type, COUNT(*) AS cstm_cnt
FROM
    sales
GROUP BY customer_type;

-- 5. What is the gender of most of the customers?

SELECT 
    gender, COUNT(gender) AS gender_count
FROM
    sales
GROUP BY gender
ORDER BY gender DESC;

-- 6. What is the gender distribution per branch?

SELECT 
    branch, gender, COUNT(gender) AS cnt_branch_gender
FROM
    sales
GROUP BY branch , gender
ORDER BY branch , cnt_branch_gender DESC;

-- 7. Which time of the day do customers give most ratings?

SELECT 
    time_of_day, AVG(rating) AS count
FROM
    sales
GROUP BY time_of_day
ORDER BY count DESC;

-- 8. Which time of the day do customers give most ratings per branch?

SELECT 
    branch, time_of_day, AVG(rating) AS count
FROM
    sales
GROUP BY time_of_day, branch
ORDER BY branch, count DESC;

-- 9. Which day fo the week has the best avg ratings?

SELECT 
    day_name, AVG(rating) AS best_rating
FROM
    sales
GROUP BY day_name
ORDER BY best_rating DESC; 

-- 10. Which day of the week has the best average ratings per branch?

SELECT 
    branch, day_name, AVG(rating) AS best_rating
FROM
    sales
GROUP BY day_name, branch
ORDER BY best_rating DESC limit 3; 

