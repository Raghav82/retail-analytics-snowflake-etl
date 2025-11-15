

-- ETL: POPULATE DIMENSIONS AND FACT TABLE
-- Populate Customer Dimension
-- Combines Retail customer details and Superstore region/segment
INSERT INTO dim_customer (customer_id, age, gender, region, segment)
SELECT DISTINCT
    CUSTOMER_ID,
    AGE,
    GENDER,
    NULL AS REGION,    -- Retail data lacks region
    NULL AS SEGMENT    -- Retail data lacks segment
FROM RETAIL_SALES
UNION
SELECT DISTINCT
    NULL AS CUSTOMER_ID,
    NULL AS AGE,
    NULL AS GENDER,
    REGION,
    SEGMENT
FROM SUPERSTORE_SALES;

-- 2. Populate Product Dimension
-- Combines Retail product categories and Superstore categories/subcategories
INSERT INTO dim_product (category, sub_category)
SELECT DISTINCT
    PRODUCT_CATEGORY AS category,
    NULL AS sub_category
FROM RETAIL_SALES
UNION
SELECT DISTINCT
    CATEGORY,
    SUB_CATEGORY
FROM SUPERSTORE_SALES;

-- 3. Populate Date Dimension
-- Extracts date components for time-based analysis
INSERT INTO dim_date (date, day, month, year, quarter)
SELECT DISTINCT
    DATE,
    DATE_PART('DAY', DATE),
    DATE_PART('MONTH', DATE),
    DATE_PART('YEAR', DATE),
    DATE_PART('QUARTER', DATE)
FROM RETAIL_SALES;

-- 4. Populate Store Dimension
-- Extracts store location details from Superstore data
INSERT INTO dim_store (city, state, country, postal_code)
SELECT DISTINCT
    CITY,
    STATE,
    COUNTRY,
    POSTAL_CODE
FROM SUPERSTORE_SALES;

-- 5. Populate Fact Table
-- Combines Retail transaction details with Superstore discount/profit
INSERT INTO fact_sales (
    date_sk,
    customer_sk,
    product_sk,
    store_sk,
    quantity,
    price_per_unit,
    total_amount,
    discount,
    profit,
    profit_margin
)
SELECT
    d.date_sk,                -- Link to dim_date
    c.customer_sk,            -- Link to dim_customer
    p.product_sk,             -- Link to dim_product
    s.store_sk,               -- Link to dim_store
    rs.QUANTITY,              -- Quantity from Retail
    rs.PRICE_PER_UNIT,        -- Price per unit from Retail
    rs.TOTAL_AMOUNT,          -- Total amount from Retail
    ss.DISCOUNT,              -- Discount from Superstore
    ss.PROFIT,                -- Profit from Superstore
    ss.PROFIT_MARGIN          -- Profit margin from Superstore
FROM RETAIL_SALES rs
LEFT JOIN dim_date d ON rs.DATE = d.date
LEFT JOIN dim_customer c ON rs.CUSTOMER_ID = c.customer_id
LEFT JOIN dim_product p ON rs.PRODUCT_CATEGORY = p.category
LEFT JOIN SUPERSTORE_SALES ss ON rs.PRODUCT_CATEGORY = ss.CATEGORY  -- Logical link by product category
LEFT JOIN dim_store s ON ss.POSTAL_CODE = s.postal_code;
