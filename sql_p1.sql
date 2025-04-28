--CREATE DATABASE sql_project_p2;


--create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY, 
				sale_date DATE, 
				sale_time TIME, 
				customer_id INT, 
				gender VARCHAR (15) ,
				age INT, 
				category VARCHAR (15) ,
				quantiy INT, 
				price_per_unit FLOAT, 
				cogs FLOAT,
				total_sale FLOAT
			) ;

select count(*) from retail_sales;

--Data Cleaning

select * from retail_sales
where transactions_id is null
		or
		sale_date is null
		or
		sale_time is null
		or
		customer_id is null
		or 
		gender is null
		or 
		category is null
		or
		quantiy is null
		or
		price_per_unit is null
		or
		cogs is null
		or 
		total_sale is null;

delete from retail_sales
where transactions_id is null
		or
		sale_date is null
		or
		sale_time is null
		or
		customer_id is null
		or 
		gender is null
		or 
		category is null
		or
		quantiy is null
		or
		price_per_unit is null
		or
		cogs is null
		or 
		total_sale is null;

--Data Exploration

--How many sales we have?

select count(*) as total_sale from retail_sales;

--How many unique customers we have?

select count(distinct customer_id) as total_customers from retail_sales;

--what are the unique customers we have?

select distinct category from retail_sales;

--Data Anaysis & Business Key Problems and Answers

--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE
sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

select * from retail_sales where category = 'Clothing'  and TO_CHAR(sale_date, 'YYYY_MM') = '2022-11' and quantiy >=4;

--write a sql query to calculate the avg sale for each month. Find out the best selling month in each year.

select  
	year, 
	month, 
	avg_sales 
	from 
	( 
		select 
		extract(year from sale_date) as year, 
		extract(month from sale_date) as month,
		avg(total_sale) as avg_sales,
		rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc)
		from retail_sales
		group by 1, 2
	) as sub
where rank = 1;

--write a sql query to find the top 5 customers based on the highest total sales.

select 
	customer_id,
	sum(total_sale) as high_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

--write a sql query to find the number of unique customers who purchased items from each category.

select 
	category,
	count(distinct customer_id) as customer_cnt
from retail_sales
group by 1

--write a sql query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening >17)
with cte as 
	(
		select
			*,
			case
				when extract(hour from sale_time) < 12 then 'Morning'
				when extract(hour from sale_time) between  12 and 17 then 'Afternoon' 
				else 'Evening' 
			end as shift
		from retail_sales
	)
	
select 	
	shift, 
	count(*) as order_num 
from cte 
group by shift;

--End of Project