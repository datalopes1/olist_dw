WITH source AS (
    SELECT
        order_id
        , payment_sequential
        , payment_type
        , payment_installments
        , payment_value
    FROM {{ref('bronze_order_payments')}}
    WHERE order_id IS NOT NULL
),

clean_source AS (
    SELECT 
        *
        , ROW_NUMBER() OVER(PARTITION BY order_id) AS rn
    FROM source
)

SELECT 
    order_id
    , payment_sequential
    , payment_type
    , payment_installments
    , payment_value
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM clean_source
WHERE 
    rn = 1