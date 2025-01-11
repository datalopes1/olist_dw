WITH source AS (
    SELECT 
        review_id
        , order_id
        , review_score
        , review_comment_title
        , review_comment_message
        , review_creation_date
        , review_answer_timestamp 
    FROM {{ref('stg_order_reviews')}}
),

clean_source AS (
    SELECT 
        *
        , ROW_NUMBER() OVER(PARTITION BY review_id) AS rn
    FROM source
    ORDER BY review_creation_date DESC
)

SELECT 
    review_id
    , order_id
    , review_score
    , review_comment_title
    , review_comment_message
    , review_creation_date
    , review_answer_timestamp
    , CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM clean_source
WHERE rn = 1