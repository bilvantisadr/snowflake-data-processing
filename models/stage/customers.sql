{{
    config
(materialized = "table")
}}

-- Step 1: Clean the data and assign row numbers
WITH cleaned_data AS (
    SELECT
        raw_customer_id,
        raw_first_name,
        raw_last_name,
        raw_email,
        raw_phone_number,
        ROW_NUMBER() OVER (PARTITION BY raw_customer_id ORDER BY raw_customer_id DESC) AS row_num  -- Deduplicate by raw_customer_id
    FROM
        {{source('src_layer', 'customers')}}  -- Raw layer table
    WHERE
        raw_customer_id IS NOT NULL  -- Filter out records where raw_customer_id is NULL
)

SELECT * FROM cleaned_data 
WHERE row_num =1