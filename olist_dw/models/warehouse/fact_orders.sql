WITH source AS (
SELECT
    o.order_id
    , o.order_approved_at AS order_date
    , oi.seller_id
    , c.customer_unique_id AS customer_id
    , o.order_status
    , oi.price AS order_value
    , oi.freight_value
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ ref('stg_orders')}} o
LEFT JOIN {{ref('stg_order_items')}} oi ON o.order_id = oi.order_id 
LEFT JOIN {{ref('stg_customers')}} c ON c.customer_id = o.customer_id
WHERE seller_id IS NOT NULL
),

clean_source AS (
    SELECT 
        *
        , ROW_NUMBER() OVER(PARTITION BY order_id) AS rn
    FROM source
    ORDER BY order_date DESC
)

SELECT 
    order_id
    , order_date
    , seller_id
    , customer_id
    , order_status
    , order_value
    , freight_value
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM clean_source 
WHERE rn = 1