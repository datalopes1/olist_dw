WITH source AS (
    SELECT
        product_id 
        , product_category_name 
        , CURRENT_TIMESTAMP() AS ingestion_timestamp
    FROM {{ref('dim_products')}}
)

SELECT * FROM source