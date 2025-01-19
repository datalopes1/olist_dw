WITH source AS (
    SELECT 
        customer_id
        , customer_unique_id
        , customer_zip_code_prefix
        , customer_city
        , customer_state
    FROM {{ref('bronze_customers')}}
    WHERE 
        customer_id IS NOT NULL
        AND customer_unique_id IS NOT NULL
),

clean_source AS (
    SELECT 
        *
        , ROW_NUMBER() OVER(PARTITION BY customer_unique_id) AS rn
    FROM source
)

    SELECT 
        customer_id
        , customer_unique_id
        , customer_zip_code_prefix
        , customer_city
        , customer_state
        , CURRENT_TIMESTAMP() AS ingestion_timestamp
    FROM clean_source
    WHERE 
        rn = 1