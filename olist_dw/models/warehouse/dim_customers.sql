WITH source AS (
    SELECT 
        customer_unique_id AS customer_id
        , customer_zip_code_prefix AS zip_code_prefix
    FROM {{ref('stg_customers')}}
),

clean_source AS (
    SELECT
        *
        , ROW_NUMBER() OVER(PARTITION BY customer_id) AS rn
    FROM source
)

SELECT 
    customer_id
    , zip_code_prefix
    , CURRENT_TIMESTAMP() AS ingestion_timestamp 
FROM clean_source
WHERE rn = 1