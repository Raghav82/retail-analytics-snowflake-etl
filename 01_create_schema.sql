-- SCHEMA CREATION: STAR SCHEMA STRUCTURE
-- Switch to the correct role, database, and schema
USE ROLE ACCOUNTADMIN;
USE DATABASE RETAIL_ANALYTICS_DB;
USE SCHEMA PUBLIC;

-- DIMENSION TABLES
-- Create Customer Dimension
-- Stores customer details from both Retail and Superstore datasets
CREATE OR REPLACE TABLE dim_customer (
    customer_sk INT AUTOINCREMENT,      -- Surrogate key for customer
    customer_id VARCHAR,                -- Retail customer ID
    age INT,                            -- Age from Retail data
    gender VARCHAR,                     -- Gender from Retail data
    region VARCHAR,                     -- Region from Superstore data
    segment VARCHAR                     -- Segment from Superstore data
);

-- Create Product Dimension
-- Stores product categories and subcategories
CREATE OR REPLACE TABLE dim_product (
    product_sk INT AUTOINCREMENT,       -- Surrogate key for product
    category VARCHAR,                   -- Product category
    sub_category VARCHAR                -- Product sub-category
);

-- Create Date Dimension
-- Stores date breakdown for time-based analysis
CREATE OR REPLACE TABLE dim_date (
    date_sk INT AUTOINCREMENT,          -- Surrogate key for date
    date DATE,                          -- Full date
    day INT,                            -- Day of month
    month INT,                          -- Month number
    year INT,                           -- Year
    quarter INT                         -- Quarter number
);

-- Create Store Dimension
-- Stores store location details from Superstore data
CREATE OR REPLACE TABLE dim_store (
    store_sk INT AUTOINCREMENT,         -- Surrogate key for store
    city VARCHAR,                       -- City
    state VARCHAR,                      -- State
    country VARCHAR,                    -- Country
    postal_code VARCHAR                 -- Postal code
);

-- Create Fact Table
-- Stores transactional data linked to dimensions
CREATE OR REPLACE TABLE fact_sales (
    sales_sk INT AUTOINCREMENT,         -- Surrogate key for fact table
    date_sk INT,                        -- Foreign key to dim_date
    customer_sk INT,                    -- Foreign key to dim_customer
    product_sk INT,                     -- Foreign key to dim_product
    store_sk INT,                       -- Foreign key to dim_store
    quantity INT,                       -- Quantity sold
    price_per_unit FLOAT,               -- Price per unit
    total_amount FLOAT,                 -- Total transaction amount
    discount FLOAT,                     -- Discount applied
    profit FLOAT,                       -- Profit from Superstore data
    profit_margin FLOAT                 -- Profit margin from Superstore data
);
