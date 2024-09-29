SELECT
  ivr_id,
IF
  (CONTAINS_SUBSTR(module_aggregation, 'AVERIA_MASIVA'), 1, 0) AS masiva_lg
FROM
`keepcoding.ivr_calls`
QUALIFY
  ROW_NUMBER() OVER(PARTITION BY CAST(ivr_id AS STRING)
  ORDER BY
    module_aggregation DESC) = 1