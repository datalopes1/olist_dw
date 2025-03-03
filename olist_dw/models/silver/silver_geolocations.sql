WITH source AS (
    SELECT 
        geolocation_zip_code_prefix 
        , geolocation_lat 
        , geolocation_lng 
        , INITCAP(geolocation_city) AS geolocation_city
        , geolocation_state
    FROM {{ref('bronze_geolocation')}}
    WHERE geolocation_zip_code_prefix IS NOT NULL
),

clean AS (
  SELECT
    *
    , ROW_NUMBER() OVER(PARTITION BY geolocation_zip_code_prefix) AS rn
  FROM source
)

SELECT 
  geolocation_zip_code_prefix 
  , geolocation_lat 
  , geolocation_lng 
  , geolocation_city 
  , geolocation_state 
  , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM clean
WHERE rn = 1