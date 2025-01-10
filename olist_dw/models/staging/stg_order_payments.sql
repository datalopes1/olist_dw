WITH source AS (
    SELECT 
        order_id
        , payment_sequential
        , payment_type
        , payment_installments
        , payment_value
    FROM {{source('olist', 'order_payments')}}
)

SELECT * FROM source