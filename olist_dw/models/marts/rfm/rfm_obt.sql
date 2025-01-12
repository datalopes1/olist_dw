WITH source AS (
SELECT 
  customer_id
  , MAX(order_date) AS last_order
  , COUNT(DISTINCT order_id) AS total_orders
  , SUM(order_value) AS total_spent 
FROM {{ref('fact_orders')}} 
GROUP BY 1
),

rfm AS (
SELECT
  customer_id
  , DATETIME_DIFF(DATETIME '2018-10-31 00:00:00', SAFE_CAST(last_order AS DATETIME), DAY) AS recency
  , total_orders AS frequency
  , total_spent AS monetary
FROM source
),

score AS (
SELECT
    customer_id
    , recency
    , frequency
    , monetary
    , NTILE(5) OVER (ORDER BY recency DESC) AS r_score
    , NTILE(5) OVER (ORDER BY frequency) AS f_score
    , NTILE(5) OVER (ORDER BY monetary) AS m_score
FROM rfm
),

segmentation AS(
SELECT
  customer_id
  , recency
  , frequency
  , monetary
  , r_score
  , f_score
  , m_score
  , CONCAT(CAST(r_score AS STRING), CAST(f_score AS STRING), CAST(m_score AS STRING)) AS rfm_score
FROM score
)

SELECT 
    customer_id
    , recency
    , frequency
    , monetary
    , r_score
    , f_score
    , m_score
    , rfm_score
    , CASE
        WHEN rfm_score IN ('555', '554', '544', '545') THEN 'Champion'
        WHEN rfm_score IN ('445', '444', '454', '455', '355', '354') THEN 'Loyal'
        WHEN rfm_score IN ('554', '544', '534', '535', '525', '515') THEN 'Potential Loyalist'
        WHEN rfm_score IN ('555', '554', '553', '552', '551', '511') THEN 'Recent Customer'
        WHEN rfm_score IN ('344', '345', '334', '335', '325', '315') THEN 'At Risk'
        WHEN rfm_score IN ('111', '112', '113', '114', '115', '121', '131', '141') THEN 'Lost'
        WHEN rfm_score IN ('511', '512', '513', '514', '515') THEN 'Promising'
        WHEN rfm_score IN ('244', '243', '242', '241', '234', '233', '232', '231') THEN 'Need Attetion'
        ELSE 'Others'
    END AS customer_segment
    , CURRENT_TIMESTAMP() AS ingestion_timestamp

FROM segmentation