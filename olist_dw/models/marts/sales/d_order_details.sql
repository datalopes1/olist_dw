WITH source AS  (
    SELECT 
        order_id
        , product_id
        , payment_type
        , payment_installments
        , CURRENT_TIMESTAMP() AS ingestion_timestamp
    FROM {{ref('dim_order_details')}}
)

SELECT * FROM source