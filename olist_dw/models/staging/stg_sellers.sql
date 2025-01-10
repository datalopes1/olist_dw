WITH source AS (
    SELECT 
        seller_id 
        , seller_zip_code_prefix 
        , seller_city 
        , seller_state 
    FROM {{source('olist', 'sellers')}}
)

SELECT * FROM source