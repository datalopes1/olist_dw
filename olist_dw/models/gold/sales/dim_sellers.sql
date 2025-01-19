SELECT
    seller_id 
    , seller_zip_code_prefix AS zip_code_prefix
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ref('silver_sellers')}}