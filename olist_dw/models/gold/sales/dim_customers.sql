SELECT
    customer_id
    , customer_unique_id
    , customer_zip_code_prefix AS zip_code_prefix
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ref('silver_customers')}}