SELECT
    product_id
    , product_category_name 
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ref('silver_products')}}