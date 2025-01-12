WITH source AS (
    SELECT
        customer_id
        , zip_code_prefix
        , CURRENT_TIMESTAMP() AS ingestion_timestamp 
    FROM {{ref('dim_customers')}}
)

SELECT * FROM source