WITH source AS (
    SELECT
        seller_id	
        , seller_zip_code_prefix	
        , seller_city	
        , seller_state
    FROM {{ref('bronze_sellers')}}
    WHERE seller_id IS NOT NULL
),

clean_source AS (
    SELECT
        *
        , ROW_NUMBER() OVER(PARTITION BY seller_id) AS rn
    FROM source
)

SELECT
    seller_id	
    , seller_zip_code_prefix	
    , seller_city	
    , seller_state
    , CURRENT_TIMESTAMP() AS ingestions_timestamp
FROM clean_source
WHERE rn = 1