WITH source AS (
  SELECT
    product_id 
    , COALESCE(product_category_name, "Sem Categoria") AS product_category_name
    , product_name_lenght 
    , product_description_lenght 
    , product_photos_qty 
    , product_weight_g 
    , product_length_cm 
    , product_height_cm 
    , product_width_cm 
    FROM {{ref('bronze_products')}}
    WHERE product_id IS NOT NULL
),

clean AS (
  SELECT 
    *
    , ROW_NUMBER() OVER(PARTITION BY product_id) AS rn
  FROM source
)

SELECT
  product_id 
  , INITCAP(REPLACE(product_category_name, "_", " ")) AS product_category_name
  , product_name_lenght 
  , product_description_lenght 
  , product_photos_qty 
  , product_weight_g 
  , product_length_cm 
  , product_height_cm 
  , product_width_cm
  , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM clean
WHERE rn = 1


