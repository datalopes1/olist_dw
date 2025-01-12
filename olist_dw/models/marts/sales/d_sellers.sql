WITH source AS (
    SELECT
        seller_id
        , zip_code_prefix
        , CURRENT_TIMESTAMP() AS ingestion_timestamp 
    FROM {{ref('dim_sellers')}}
)

SELECT * FROM source