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
        , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ ref('silver_orders')}} o
LEFT JOIN {{ ref('silver_order_items')}} oi 
        ON o.order_id = oi.order_id
LEFT JOIN {{ ref('silver_order_payments')}} p 
        ON o.order_id = p.order_id
ORDER BY o.order_approved_at DESC