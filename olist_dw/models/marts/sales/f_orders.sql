WITH source AS (
SELECT 
    order_id
    , order_date
    , seller_id
    , customer_id
    , order_status
    , order_value
    , freight_value
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ref('fact_orders')}}
)

SELECT * FROM source