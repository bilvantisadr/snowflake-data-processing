{{
    config
(materialized = "table")
}}

WITH cleaned_data AS (
    SELECT
        raw_order_id,
        raw_customer_id,
        raw_order_date,
        raw_total_amount,
        COALESCE(raw_status, 'Pending') AS raw_status,  -- Default 'Pending' if NULL
        ROW_NUMBER() OVER (PARTITION BY raw_order_id ORDER BY raw_order_date DESC) AS row_num  -- Partition by raw_order_id, order by raw_order_date DESC
    FROM
        {{source('src_layer', 'orders')}}
    WHERE
        raw_order_id IS NOT NULL  -- Filter out records where raw_order_id is NULL
)
SELECT * FROM cleaned_data
WHERE row_num =1