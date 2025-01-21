WITH source AS (
    SELECT 
        order_id
        , order_item_id AS quantity
        , product_id
        , seller_id
        , shipping_limit_date
        , price
        , freight_value
        , (order_item_id * price) + (order_item_id * freight_value) AS total_order_value
    FROM {{ref('bronze_order_items')}}
    WHERE
        order_id IS NOT NULL
        AND product_id IS NOT NULL
        AND seller_id IS NOT NULL
),

clean AS (
  SELECT
    *
    , ROW_NUMBER() OVER(PARTITION BY order_id) AS rn
  FROM source
)

SELECT 
    order_id
    , product_id
    , seller_id
    , shipping_limit_date
    , quantity
    , price 
    , freight_value
    , total_order_value 
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM clean
WHERE rn = 1