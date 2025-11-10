# Advanced-Amazon-Sales-Project-SQL-Server
---

---

## **Project Overview**

This project focuses on analyzing over 20,000 sales records from an Amazon-like e-commerce platform using **PostgreSQL**. The goal was to uncover insights about customer behavior, product performance, and sales trends by applying advanced SQL techniques.

The project involved solving various business challenges such as **revenue analysis**, **customer segmentation**, and **inventory optimization** through structured SQL queries. Additionally, it covered essential data engineering practices such as **data cleaning**, **handling null values**, and **database relationship management**.

An **Entity Relationship Diagram (ERD)** was also designed to visualize the database schema and relationships among the tables.

---
![ER Diagram](images/ERD.png)

---

## **Objective**

The primary objective of this project is to demonstrate proficiency in **advanced SQL concepts** by addressing real-world e-commerce business problems. The analysis focuses on identifying trends, optimizing performance metrics, and improving operational efficiency through SQL-driven exploration.

---

## **SQL Concepts Used**

This project utilizes advanced SQL concepts ranging from basic to complex, including:
- **Joins**  
- **CASE Statements**  
- **Window Functions** (*RANK, DENSE_RANK, LAG, LEAD*)  
- **Aggregate Functions (GROUP BY, HAVING)**  
- **Subqueries**  
- **Date Functions**  
- **Common Table Expressions (CTEs)**  

---

## **Dataset Source**

The project is built using **Amazon demo sales data** sourced from **Kaggle**, providing realistic e-commerce scenarios for analysis and problem-solving.

---

## **Key Insights**

- **High-Value Customers**: The top 10 customers contribute a significant portion of total revenue, emphasizing the importance of retention strategies.  
- **Payment Efficiency**: The payment success rate reflects the reliability and performance of the payment processing system.  
- **Product Performance**: Identifying top-selling products assists in inventory planning and targeted marketing.  
- **Return Rates**: High return rates signal potential product quality or expectation issues.  
- **Seller Contributions**: Recognizing high-performing sellers supports better partnership and commission management.

---

## **Database Setup & Design**

### **Schema Structure**

```sql
-- Amazon Project- Advanced SQL
-- First Create The Parent Tables. Table 1, 2, 3 are the parent tables.
-- category TABLE ( Table 1)

Create Table Category 
(
category_id INT Primary Key,
category_name Varchar (30 )
);

-- Customers Table ( Table 2)

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    state VARCHAR(50),
    -- Address column with a more practical size and standard default syntax
    address VARCHAR(255) DEFAULT 'Not Provided'
);

-- Sellers Table ( Table 3)

Create Table sellers (
seller_id INT Primary Key,
seller_name varchar(25),
origin Varchar (10)
);

-- Products table ( Table 4)
Create table products 
(
product_id INT primary key,
product_name Varchar (100),
price FLOAT,
cogs  FLOAT,
category_id  INT, -- FK
constraint product_fk_Category Foreign Key (category_id) references category (category_id)
);

-- Orders Table ( Table 5)

create table orders
(
order_id INT Primary Key , 
order_date date,
customer_id INT, -- FK
seller_id INT, -- FK
order_status Varchar (50),
constraint orders_fk_customers foreign key (customer_id) references customers  ( customer_id),
Constraint orders_fk_sellers foreign key (seller_id) references sellers ( seller_id)
);


-- Order Items Table ( Table 6)

Create Table order_items 
( 
 order_item_id int Primary Key,
order_id INT, -- FK
product_id INT, -- FK
quantity int,
price_per_unit FLOAT,
constraint order_items_fk_orders Foreign Key (order_id) references orders (order_id),
constraint order_items_fk_products Foreign Key (product_id) references products ( product_id)
);




-- Payment Table ( table 7)
Create Table payments
(
payment_id INT Primary Key,
order_id INT, --FK
payment_date Date,
payment_status Varchar (100),
Constraint payments_fk_orders Foreign Key (order_id) references orders (order_id)
);

-- Shipping Table ( table 8)

Create Table shippings 
(
shipping_id INT Primary Key,
order_id INT , -- FK
shipping_date DATE,
return_date DATE,
shipping_providers Varchar (15),
delivery_status Varchar (15),
Constraint shipping_fk_orders Foreign Key (order_id) references orders (order_id)
);

-- Inventory Table ( table 9)

Create Table inventory
(
inventory_id  int Primary KEY,
product_id INT, --FK
stock INT,
warehouse_id INT,
last_stock_date DATE,
CONSTRAINT inventory_fk_products FOREIGN KEY (product_id) REFERENCES products (product_id)
);

-- END OF SCHEMAS

--'H:\Amazon sql project\Amazon_Data_SQL_Project-main\category.csv'
--bulk insert

BULK INSERT Category
FROM 'H:\Amazon sql project\Amazon_Data_SQL_Project-main\category.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT customers
FROM 'H:\Amazon sql project\Amazon_Data_SQL_Project-main\customers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT sellers
FROM 'H:\Amazon sql project\Amazon_Data_SQL_Project-main\sellers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT products
FROM 'H:\Amazon sql project\Amazon_Data_SQL_Project-main\products.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT orders
FROM 'H:\Amazon sql project\Amazon_Data_SQL_Project-main\orders.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT order_items
FROM 'H:\Amazon sql project\Amazon_Data_SQL_Project-main\order_items.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT payments
FROM 'H:\Amazon sql project\Amazon_Data_SQL_Project-main\payments.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);


BULK INSERT shippings
FROM 'H:\Amazon sql project\Amazon_Data_SQL_Project-main\shipping.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT inventory
FROM 'H:\Amazon sql project\Amazon_Data_SQL_Project-main\inventory.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
```


---

## **Data Cleaning**

During the data cleaning process, several steps were taken to ensure data accuracy and reliability:

- **Removed Duplicates:** Identified and deleted duplicate records from key tables such as `customers` and `orders`.
- **Handled Missing Values:** Filled or replaced null values in critical columns like `address`, `payment_status`, and `order_status` using appropriate defaults.
- **Standardized Data Formats:** Ensured consistent formatting for date fields, state names, and category names.
- **Validated Relationships:** Checked for foreign key integrity across all linked tables to prevent orphan records.

---

## **Handling Null Values**

Null values were treated contextually to preserve data meaning:

- **Customer Addresses:** Replaced missing addresses with a placeholder value `'xxxx'`.
- **Payment Status:** Orders with null payment statuses were categorized as `'Pending'`.
- **Shipping Details:** Null return dates were kept unchanged, as they indicate non-returned shipments.
- **Product or Category Gaps:** Verified that each product had a valid category and cost record to avoid missing join relationships.

---

## **Conclusion**

This SQL project demonstrates the power of **advanced SQL concepts** in solving real-world e-commerce challenges.  
By applying **window functions**, **CTEs**, **subqueries**, and **date functions**, complex business questions were efficiently addressed.  

The analysis provided valuable insights into:
- Sales performance and revenue growth  
- Customer behavior and retention  
- Product demand and return trends  
- Seller performance and inventory optimization  

Overall, this project highlights how structured query logic and data cleaning can transform raw transactional data into meaningful business intelligence.

---
