WITH source AS (
    SELECT 
        seller_id 
        , seller_zip_code_prefix AS zip_code_prefix
    FROM {{ref('stg_sellers')}}
),

clean_source AS (
    SELECT
        *
        , ROW_NUMBER() OVER(PARTITION BY seller_id) AS rn
    FROM source
)

SELECT 
    seller_id
    , zip_code_prefix
    , CURRENT_TIMESTAMP() AS ingestion_timestamp 
FROM clean_source
WHERE rn = 1