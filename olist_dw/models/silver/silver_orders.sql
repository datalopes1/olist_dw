WITH source AS (
    SELECT 
        order_id
        , customer_id
        , UPPER(order_status) AS order_status
        , order_purchase_timestamp
        , order_approved_at
        , order_delivered_carrier_date
        , order_delivered_customer_date
        , order_estimated_delivery_date
    FROM {{ref('bronze_orders')}}
    WHERE 
        order_id IS NOT NULL 
        AND customer_id IS NOT NULL
),

clean_source AS (
    SELECT 
        *
        , ROW_NUMBER() OVER(PARTITION BY order_id) AS rn
    FROM source
)

SELECT
    order_id
    , customer_id
    , order_status
    , order_purchase_timestamp
    , order_approved_at
    , order_delivered_carrier_date
    , order_delivered_customer_date
    , order_estimated_delivery_date
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM clean_source
WHERE rn = 1