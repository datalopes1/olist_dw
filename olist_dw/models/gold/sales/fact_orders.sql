SELECT  
    o.order_id
    , c.customer_unique_id AS customer_id
    , oi.product_id
    , oi.seller_id
    , o.order_purchase_timestamp AS order_date
    , o.order_status
    , oi.total_order_value
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ref('silver_orders')}} o
LEFT JOIN {{ref('silver_order_items')}} oi 
    ON o.order_id = oi.order_id
LEFT JOIN {{ref('silver_customer')}} c 
    ON o.customer_id = c.customer_id
WHERE 
    o.order_id IS NOT NULL
    AND c.customer_unique_id IS NOT NULL
    AND oi.product_id IS NOT NULL
    AND oi.seller_id IS NOT NULL
ORDER BY o.order_purchase_timestamp DESC