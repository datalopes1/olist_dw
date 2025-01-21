
SELECT
    geolocation_zip_code_prefix AS zip_code_prefix
    , geolocation_lat AS latitude
    , geolocation_lng AS longitude
    , geolocation_city AS city
    , geolocation_state AS state
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ref('silver_geolocations')}}