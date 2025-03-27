{{
    config
(materialized = "table")
}}

WITH cleaned_data AS (
    SELECT
        raw_order_item_id,
        raw_order_id,
        raw_product_id,
        raw_quantity,
        raw_price,
        ROW_NUMBER() OVER (PARTITION BY raw_order_item_id ORDER BY raw_order_id DESC) AS row_num  -- Deduplicate by order_item_id
    FROM
        {{source('src_layer', 'order_items')}}  -- Raw layer table
    WHERE
        raw_order_item_id IS NOT NULL  -- Filter out records where order_item_id is NULL
)
SELECT * FROM cleaned_data
WHERE row_num =1