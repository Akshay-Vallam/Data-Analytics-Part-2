/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

-- Drop and recreate the 'DataWarehouseAnalytics' database
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM pg_database WHERE datname = 'DataWarehouseAnalytics') THEN
        PERFORM pg_terminate_backend(pid) 
        FROM pg_stat_activity 
        WHERE datname = 'DataWarehouseAnalytics' AND pid <> pg_backend_pid();
        
        EXECUTE 'DROP DATABASE DataWarehouseAnalytics';
    END IF;
END $$;

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE "DataWarehouseAnalytics";

-- Connect to the 'DataWarehouseAnalytics' database manually
-- After running the above statement, connect to the 'DataWarehouseAnalytics' database manually
-- (through psql or your PostgreSQL client)

-- Create Schemas
CREATE SCHEMA gold;

-- Create the tables
CREATE TABLE gold.dim_customers(
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);

CREATE TABLE gold.dim_products(
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);

CREATE TABLE gold.fact_sales(
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity SMALLINT, -- 'tinyint' in MySQL is equivalent to 'smallint' in PostgreSQL
    price INT
);

-- Truncate the tables
TRUNCATE TABLE gold.dim_customers;
TRUNCATE TABLE gold.dim_products;
TRUNCATE TABLE gold.fact_sales;

-- Copy data from CSV files using PostgreSQL's COPY command
-- Adjust the file path to your system's location

COPY gold.dim_customers(customer_key, customer_id, customer_number, first_name, last_name, country, marital_status, gender, birthdate, create_date)
FROM 'E:\SQL\Projects\5. Data Analytics Project\datasets\csv-files\gold.dim_customers.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

COPY gold.dim_products(product_key, product_id, product_number, product_name, category_id, category, subcategory, maintenance, cost, product_line, start_date)
FROM 'E:\SQL\Projects\5. Data Analytics Project\datasets\csv-files\gold.dim_products.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

COPY gold.fact_sales(order_number, product_key, customer_key, order_date, shipping_date, due_date, sales_amount, quantity, price)
FROM 'E:\SQL\Projects\5. Data Analytics Project\datasets\csv-files\gold.fact_sales.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');
