-- Set Password & create master key

CREATE MASTER KEY ENCRYPTION BY PASSWORD ='Olist1234Olist' -- to access the external location


/* Create Database Scoped Credential Managed Identity
- to authentic & allow Synapse to interact with other azure services */

CREATE DATABASE SCOPED CREDENTIAL cr_olist
WITH
    IDENTITY = 'Managed Identity';


-- 3) Create External Data Source - conn. between synapse and ADLS - 2 datasource - silver, gold
CREATE EXTERNAL DATA SOURCE silver_layer
WITH
(
    LOCATION = 'https://handsonproject1.blob.core.windows.net/silver',
    CREDENTIAL = cr_olist
)

CREATE EXTERNAL DATA SOURCE gold_layer
WITH
(
    LOCATION = 'https://handsonproject1.blob.core.windows.net/gold',
    CREDENTIAL = cr_olist
)

-- 4) Create External File Format
CREATE EXTERNAL FILE FORMAT parquet_format
WITH
(
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)

-- 5) Create External Tables
--customers:
CREATE EXTERNAL TABLE GOLD.ext_customers
WITH
(
    LOCATION = 'ext_customers',
    DATA_SOURCE = gold_layer,
    FILE_FORMAT = parquet_format
) AS SELECT * FROM GOLD.customers

SELECT * FROM GOLD.ext_customers;

--sellers
CREATE EXTERNAL TABLE GOLD.ext_sellers
WITH
(
    LOCATION = 'ext_sellers',
    DATA_SOURCE = gold_layer,
    FILE_FORMAT = parquet_format
) AS SELECT * FROM GOLD.sellers

SELECT * FROM GOLD.ext_sellers;

--products
CREATE EXTERNAL TABLE GOLD.ext_products
WITH
(
    LOCATION = 'ext_products',
    DATA_SOURCE = gold_layer,
    FILE_FORMAT = parquet_format
) AS SELECT * FROM GOLD.products

SELECT * FROM GOLD.ext_products;

--order_items
CREATE EXTERNAL TABLE GOLD.ext_order_items
WITH
(
    LOCATION = 'ext_order_items',
    DATA_SOURCE = gold_layer,
    FILE_FORMAT = parquet_format
) AS SELECT * FROM GOLD.order_items

SELECT * FROM GOLD.ext_order_items;

--order_payments
CREATE EXTERNAL TABLE GOLD.ext_order_payments
WITH
(
    LOCATION = 'ext_order_payments',
    DATA_SOURCE = gold_layer,
    FILE_FORMAT = parquet_format
) AS SELECT * FROM GOLD.order_payments

SELECT * FROM GOLD.ext_order_payments;

--order_reviews
CREATE EXTERNAL TABLE GOLD.ext_order_reviews
WITH
(
    LOCATION = 'ext_order_reviews',
    DATA_SOURCE = gold_layer,
    FILE_FORMAT = parquet_format
) AS SELECT * FROM GOLD.order_reviews

SELECT * FROM GOLD.ext_order_reviews;

--orders
CREATE EXTERNAL TABLE GOLD.ext_orders
WITH
(
    LOCATION = 'ext_orders',
    DATA_SOURCE = gold_layer,
    FILE_FORMAT = parquet_format
) AS SELECT * FROM GOLD.orders

SELECT * FROM GOLD.ext_orders;
