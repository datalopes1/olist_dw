WITH source AS (
SELECT
    c.customer_unique_id
    , MAX(o.order_purchase_timestamp) AS last_order
    , COUNT(DISTINCT o.order_id) AS frequency
    , SUM(oi.total_order_value) AS monetary
FROM {{ref('silver_orders')}} o
LEFT JOIN {{ref('silver_customers')}} c
    ON o.customer_id = c.customer_id
LEFT JOIN {{ref('silver_order_items')}} oi
    ON o.order_id = oi.order_id
WHERE c.customer_unique_id IS NOT NULL
GROUP BY c.customer_unique_id
),


rfm AS (
SELECT
    customer_unique_id
    , DATE_DIFF(DATETIME '2018-10-31 00:00:00', SAFE_CAST(last_order AS DATETIME), DAY) AS recency
    , frequency
    , monetary
FROM source
),

score AS(
SELECT
    customer_unique_id
    , recency
    , frequency
    , monetary
    , NTILE(5) OVER(ORDER BY recency DESC) AS r_score
    , NTILE(5) OVER(ORDER BY frequency) AS f_score
    , NTILE(5) OVER(ORDER BY monetary) AS m_score
FROM rfm
),

segmentation AS (
SELECT
  customer_unique_id
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
    customer_unique_id
    , recency
    , frequency
    , monetary
    , r_score
    , f_score
    , m_score
    , rfm_score
    , CASE
        WHEN rfm_score IN ('555', '554', '545', '455') THEN 'Top Customers'
        WHEN rfm_score LIKE '5__' THEN 'Loyal Customers'
        WHEN rfm_score LIKE '__5' THEN 'Big Spenders'
        WHEN rfm_score LIKE '_5_' THEN 'Frequent Buyers'
        WHEN rfm_score IN ('111', '112', '121') THEN 'Lost Customers'
        ELSE 'Average Customers'
    END AS customer_segment
FROM segmentation
