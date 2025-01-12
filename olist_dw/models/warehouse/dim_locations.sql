WITH source AS (
    SELECT 
        geolocation_zip_code_prefix AS zip_code_prefix
        , geolocation_lat AS latitude
        , geolocation_lng AS longitude
        , geolocation_city AS city
        , geolocation_state AS state
    FROM {{ref('stg_geolocation')}}
),

clean_source AS (
    SELECT
        *
        , ROW_NUMBER() OVER(PARTITION BY zip_code_prefix) AS rn
    FROM source
)

SELECT
    zip_code_prefix
    , latitude
    , longitude
    , city
    , state
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM clean_source
WHERE rn = 1