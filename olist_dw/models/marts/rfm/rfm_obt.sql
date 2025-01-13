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
        WHEN r_score = 5 AND f_score >= 4 AND m_score >= 4 THEN 'Champion'
        WHEN r_score IN (5, 4) AND f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers'
        WHEN r_score IN (4, 5) AND f_score BETWEEN 1 AND 3 AND m_score BETWEEN 1 AND 3 THEN 'Potential Loyalist'
        WHEN r_score = 5 THEN 'Recent Customers'
        WHEN r_score IN (2, 3) AND f_score >= 3 AND m_score >= 3 THEN 'At Risk'
        WHEN r_score = 1 THEN 'Lost Customers'
        WHEN r_score IN (3, 4) AND f_score <= 2 AND m_score <= 2 THEN 'Need Attention'
        WHEN r_score IN (1, 2) AND f_score <= 2 AND m_score <= 2 THEN 'Hibernating'
        ELSE 'Others'
      END AS customer_segment
    , CURRENT_TIMESTAMP() AS ingestion_timestamp

FROM segmentation