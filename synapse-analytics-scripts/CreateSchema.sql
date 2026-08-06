-- 1) Schema Creation
CREATE SCHEMA GOLD;

-- 2) View Creation - customers
CREATE VIEW GOLD.customers
AS
WITH customer_geo AS (
    SELECT 
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS avg_lat,
        AVG(geolocation_lng) AS avg_lng
    FROM OPENROWSET(
        BULK 'https://handsonproject1.dfs.core.windows.net/silver/geolocation/',
        FORMAT = 'DELTA'
    ) AS geo_query
    GROUP BY geolocation_zip_code_prefix
)
SELECT 
    c.customer_id,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    g.avg_lat,
    g.avg_lng
FROM OPENROWSET(
    BULK 'https://handsonproject1.dfs.core.windows.net/silver/customers/',
    FORMAT = 'DELTA'
) AS c
LEFT JOIN customer_geo g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;

SELECT * FROM GOLD.customers

-- 3) View Creation - sellers
CREATE VIEW GOLD.sellers
AS
WITH seller_geo AS (
    SELECT 
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS avg_lat,
        AVG(geolocation_lng) AS avg_lng
    FROM OPENROWSET(
        BULK 'https://handsonproject1.dfs.core.windows.net/silver/geolocation/',
        FORMAT = 'Delta'
    ) AS geo_query
    GROUP BY geolocation_zip_code_prefix
)
SELECT 
    s.seller_id,
    s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state,
    g.avg_lat,
    g.avg_lng
FROM OPENROWSET(
    BULK 'https://handsonproject1.dfs.core.windows.net/silver/sellers/',
    FORMAT = 'Delta'
) AS s
LEFT JOIN seller_geo g
    ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix;

SELECT * FROM GOLD.sellers;

-- 4) View Creation - products
CREATE VIEW GOLD.products
AS
SELECT 
    p.product_id,
    p.product_category_name,
    t.product_category_name_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM OPENROWSET(
    BULK 'https://handsonproject1.dfs.core.windows.net/silver/products/',
    FORMAT = 'DELTA'
) AS p
LEFT JOIN OPENROWSET(
    BULK 'https://handsonproject1.dfs.core.windows.net/silver/product_category_name_translation/',
    FORMAT = 'DELTA'
) AS t
    ON p.product_category_name = t.product_category_name;

-- Check for NULLs in translation
SELECT 
    product_category_name,
    COUNT(*) AS product_count
FROM GOLD.products
WHERE product_category_name_english IS NULL 
  AND product_category_name IS NOT NULL
GROUP BY product_category_name;

--Products (Final View with NULL Handling)
CREATE OR ALTER VIEW GOLD.products
AS
SELECT 
    p.product_id,
    p.product_category_name,
    CASE 
        WHEN p.product_category_name = 'portateis_cozinha_e_preparadores_de_alimentos' 
            THEN 'portable_kitchen_appliances_and_food_processors'
        WHEN p.product_category_name = 'pc_gamer' 
            THEN 'pc_gamer'
        ELSE t.product_category_name_english
    END AS product_category_name_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM OPENROWSET(
    BULK 'https://handsonproject1.dfs.core.windows.net/silver/products/',
    FORMAT = 'DELTA'
) AS p
LEFT JOIN OPENROWSET(
    BULK 'https://handsonproject1.dfs.core.windows.net/silver/product_category_name_translation/',
    FORMAT = 'DELTA'
) AS t
    ON p.product_category_name = t.product_category_name;

SELECT * FROM GOLD.products;

-- 5) View Creation - order_items
CREATE VIEW GOLD.order_items
AS
SELECT 
    *
FROM 
    OPENROWSET(
        BULK 'https://handsonproject1.dfs.core.windows.net/silver/order_items/',
        FORMAT = 'DELTA'
    ) AS Query1; 

SELECT * FROM GOLD.order_items;

-- 6) View Creation - order_payments
CREATE VIEW GOLD.order_payments
AS
SELECT 
    *
FROM 
    OPENROWSET(
        BULK 'https://handsonproject1.dfs.core.windows.net/silver/order_payments/',
        FORMAT = 'DELTA'
    ) AS Query1; 

SELECT * FROM GOLD.order_payments;

-- 7) View Creation - order_reviews
CREATE VIEW GOLD.order_reviews
AS
SELECT 
    *
FROM 
    OPENROWSET(
        BULK 'https://handsonproject1.dfs.core.windows.net/silver/order_reviews/',
        FORMAT = 'DELTA'
    ) AS Query1; 

SELECT * FROM GOLD.order_reviews;

-- 8) View Creation - orders
CREATE VIEW GOLD.orders
AS
SELECT 
    *
FROM 
    OPENROWSET(
        BULK 'https://handsonproject1.dfs.core.windows.net/silver/orders/',
        FORMAT = 'DELTA'
    ) AS Query1; 

SELECT * FROM GOLD.orders;
