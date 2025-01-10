WITH source AS (
    SELECT 
        order_id
        , order_item_id 
        , product_id 
        , seller_id
        , shipping_limit_date 
        , price 
        , freight_value 
    FROM {{source('olist', 'order_items')}}
)

SELECT * FROM source