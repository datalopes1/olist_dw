WITH source AS (
    SELECT
        product_id 
        , product_category_name 
        , product_name_lenght 
        , product_description_lenght 
        , product_photos_qty 
        , product_weight_g 
        , product_length_cm 
        , product_height_cm 
        , product_width_cm 
FROM {{ref('stg_products')}}
),

clean_source AS (
    SELECT 
        *
        , ROW_NUMBER() OVER(PARTITION BY product_id) AS rn
    FROM source
)

SELECT
    product_id 
    , product_category_name 
    , product_name_lenght 
    , product_description_lenght 
    , product_photos_qty 
    , product_weight_g 
    , product_length_cm 
    , product_height_cm 
    , product_width_cm 
    , CURRENT_TIMESTAMP() AS ingestion_timestamp 
FROM clean_source
WHERE rn = 1
    
