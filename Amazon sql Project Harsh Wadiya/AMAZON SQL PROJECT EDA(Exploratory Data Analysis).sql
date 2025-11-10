

-------------------------------------------------------------------------------------				
					
						/* DataBase Exploration */

-------------------------------------------------------------------------------------

--Explore all Objects in the database
select * from INFORMATION_SCHEMA.tables;

--Explore all columns from all the tables of the database.
Select * from INFORMATION_SCHEMA.COLUMNS;

-- Explore all columns from particular tables of the database.
Select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Customers';

select * from customers
select * from inventory
select * from order_items
select * from orders
Select * from payments
select * from products
select * from sellers
select * from shippings

-----------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------				
					
						/* Dimensions Exploration */

-------------------------------------------------------------------------------------
--Explore all States our customers come from.
Select Distinct State from customers

--Explore the number of Customers By State
select state,count(customer_id) as Customers_by_country from customers
group by state
order by state asc

-- Explore the distinct products from the proucts sections
select distinct product_name from products

-- Explore all origin our sellers sell from.
select distinct origin from sellers

---------------------------------------------------------------------------

-------------------------------------------------------------------------------------				
					
						/* Date Exploration */

-------------------------------------------------------------------------------------

-- Find the First and last Order date and check how many months of sales data is available.
select 
MIN(order_date) as first_order_date,
MAX(Order_date) as last_order_date,
DATEDIFF(Month,min(order_date),max(Order_date)) as order_range_months
from orders;

-- Find the No of days between next order date

WITH cte1 AS (
    SELECT order_date 
    FROM orders 
    GROUP BY order_date
)
SELECT *,
    DATEDIFF(day, order_date, next_order_date) AS diff_in_days
FROM (
    SELECT 
        order_date,
        LEAD(order_date, 1, NULL) OVER (ORDER BY order_date) AS next_order_date
    FROM cte1
) t;

-- Find distinct categories 
select distinct category_name from category;



-------------------------------------------------------------------------------------				
					
							/* Measures Exploration */


				/* calculate the KPI of the data and Show highest 
		as well as lowest level of aggregations and then generate a report.*/

-------------------------------------------------------------------------------------

--Find the Total Sales
with totalsalestable as (
select*, (quantity*price_per_unit) as total_sales from order_items
)
select round(sum(total_sales),2) Total_sales_aggr from totalsalestable;

--Find How many items are sold
select sum(quantity) Total_Quantity from order_items

-- Find the average selling price of the products
select ROUND(avg(price_per_unit),2) as Avg_selling_price from order_items

-- Find the total number of orders
select count(distinct order_id) as Total_orders from Orders

--Find the total number of customers
select count(distinct customer_id) as Total_Customers from customers

--Find the total number of Products
select count(distinct product_id) as Total_Products from products;

-- Find the Count Products which are not returned
select count(distinct shipping_id) NOT_Returned from Shippings
where return_date is  null

-------------------------------------------------------------------------------------				
					
				                     /* Report */

-------------------------------------------------------------------------------------


WITH totalsalestable AS (
    SELECT *, (quantity * price_per_unit) AS total_sales
    FROM order_items
)
SELECT 
    'Total Sales' AS Measure_name,
    ROUND(SUM(total_sales), 2) AS Measure_value
FROM totalsalestable

UNION ALL

SELECT 
    'Total Quantity Sold' AS Measure_name,
    SUM(quantity) AS Measure_value
FROM order_items

UNION ALL

SELECT 
    'Average Selling Price' AS Measure_name,
    ROUND(AVG(price_per_unit), 2) AS Measure_value
FROM order_items

UNION ALL

SELECT 
    'Total Orders' AS Measure_name,
    COUNT(DISTINCT order_id) AS Measure_value
FROM orders

UNION ALL

SELECT 
    'Total Customers' AS Measure_name,
    COUNT(DISTINCT customer_id) AS Measure_value
FROM customers

UNION ALL

SELECT 
    'Total Products' AS Measure_name,
    COUNT(DISTINCT product_id) AS Measure_value
FROM products;

---------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------				
					
				               /* Magnitude Analysis */

-------------------------------------------------------------------------------------


-- Find the Total Sales by State


with salesbystate as (
select c.first_name,c.last_name,state,
oi.quantity,oi.price_per_unit, (quantity*price_per_unit) as total_sales
from order_items as oi
left join orders as o
on o.order_id = oi.order_id
left join customers as c
on c.customer_id = o.customer_id
)

select state,Round(sum(total_sales),2) Sales_By_State from salesbystate
group by state
order by state asc;

--Find the Total Quantity By category

select p.category_id,ca.category_name,count(oi.quantity) as TotalQuantitybycategory from order_items as oi
left join products as p
on oi.product_id = p.product_id
left join category as ca
on p.category_id = ca.category_id
group by p.category_id,ca.category_name;

--Find the Average Price by Products

select product_name,avg((quantity*price_per_unit)) as sales from order_items as oi 
left join products as p
on p.product_id = oi.product_id
group by product_name;


--------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------				
					
				                    /* Ranking */

-------------------------------------------------------------------------------------

-- Find the TOP 5 states by there Total Sales 


with salesbystate as (
select c.first_name,c.last_name,state,
oi.quantity,oi.price_per_unit, (quantity*price_per_unit) as total_sales
from order_items as oi
left join orders as o
on o.order_id = oi.order_id
left join customers as c
on c.customer_id = o.customer_id
)

select TOP 5 state,Round(sum(total_sales),2) Sales_By_State from salesbystate
group by state
order by Sales_By_State desc;

-- Find the Bottom 5 states by there Total Sales 


with salesbystate as (
select c.first_name,c.last_name,state,
oi.quantity,oi.price_per_unit, (quantity*price_per_unit) as total_sales
from order_items as oi
left join orders as o
on o.order_id = oi.order_id
left join customers as c
on c.customer_id = o.customer_id
)

select TOP 5 state,Round(sum(total_sales),2) Sales_By_State from salesbystate
group by state
order by Sales_By_State asc;


--Find the Top 2 products by their quantity

select TOP 2 p.category_id,ca.category_name,count(oi.quantity) as TotalQuantitybycategory from order_items as oi
left join products as p
on oi.product_id = p.product_id
left join category as ca
on p.category_id = ca.category_id
group by p.category_id,ca.category_name
order by TotalQuantitybycategory desc;

--Find the Bottom 2 products by their quantity

select TOP 2 p.category_id,ca.category_name,count(oi.quantity) as TotalQuantitybycategory from order_items as oi
left join products as p
on oi.product_id = p.product_id
left join category as ca
on p.category_id = ca.category_id
group by p.category_id,ca.category_name
order by TotalQuantitybycategory asc;


/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*/