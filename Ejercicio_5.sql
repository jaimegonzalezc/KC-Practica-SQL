WITH
  number AS (
  SELECT
    ivr_id,
    document_identification
  FROM
    `keepcoding.ivr_steps`
  QUALIFY
    ROW_NUMBER() OVER (PARTITION BY CAST(ivr_id AS STRING)
    ORDER BY
      document_identification) = 1),
  type AS (
  SELECT
    ivr_id,
    document_type
  FROM
    `keepcoding.ivr_steps`
  QUALIFY
    ROW_NUMBER() OVER (PARTITION BY CAST(ivr_id AS STRING)
    ORDER BY
      document_type) = 1)
SELECT
  number.ivr_id,
  type.document_type AS document_type,
  number.document_identification AS document_identification
FROM
  number
INNER JOIN
  type
ON
  number.ivr_id = type.ivr_id
ORDER BY
  document_type