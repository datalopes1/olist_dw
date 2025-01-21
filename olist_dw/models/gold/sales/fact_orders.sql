SELECT  
    o.order_id
    , c.customer_unique_id
    , oi.seller_id
    , o.order_purchase_timestamp AS order_date
    , o.order_status
    , COALESCE(oi.total_order_value, 0) AS total_order_value
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ref('silver_orders')}} o
LEFT JOIN {{ref('silver_order_items')}} oi 
    ON o.order_id = oi.order_id
LEFT JOIN {{ref('silver_customers')}} c 
    ON o.customer_id = c.customer_id
ORDER BY o.order_purchase_timestamp DESC