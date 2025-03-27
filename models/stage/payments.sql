{{
    config
(materialized = "table")
}}

-- Step 1: Clean the data and assign row numbers
WITH cleaned_data AS (
    SELECT
        raw_payment_id,
        raw_order_id,
        raw_payment_date,
        raw_payment_amount,
        raw_payment_status,
        ROW_NUMBER() OVER (PARTITION BY raw_payment_id ORDER BY raw_payment_date DESC) AS row_num  -- Deduplicate by raw_payment_id
    FROM
        {{source('src_layer', 'payments')}}  -- Raw layer table
    WHERE
        raw_payment_id IS NOT NULL  -- Filter out records where raw_payment_id is NULL
)

SELECT * FROM cleaned_data
WHERE row_num =1