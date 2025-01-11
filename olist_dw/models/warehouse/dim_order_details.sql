WITH source AS (
    SELECT 
        o.order_id
        , oi.product_id
        , o.order_purchase_timestamp
        , o.order_approved_at
        , o.order_delivered_carrier_date
        , o.order_delivered_customer_date
        , o.order_estimated_delivery_date
        , p.payment_type
        , p.payment_installments
    FROM {{ ref('stg_orders')}} o
    LEFT JOIN {{ ref('stg_order_items')}} oi ON o.order_id = oi.order_id
    LEFT JOIN {{ ref('stg_order_payments')}} p ON o.order_id = p.order_id
),

clean_source AS (
    SELECT 
        *
        , ROW_NUMBER() OVER(PARTITION BY order_id) AS rn
    FROM source
    ORDER BY order_approved_at DESC
)

SELECT
    order_id
    , product_id
    , order_purchase_timestamp
    , order_approved_at
    , order_delivered_carrier_date
    , order_delivered_customer_date
    , order_estimated_delivery_date
    , payment_type
    , payment_installments
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM clean_source
WHERE rn = 1