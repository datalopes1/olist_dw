WITH source AS (
    SELECT
        zip_code_prefix
        , latitude
        , longitude
        , city
        , state
        , CURRENT_TIMESTAMP() AS ingestion_timestamp
    FROM {{ref('dim_locations')}}
)

SELECT * FROM source