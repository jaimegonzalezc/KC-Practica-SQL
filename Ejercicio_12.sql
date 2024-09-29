CREATE OR REPLACE TABLE
  keepcoding.ivr_summary AS
WITH
  vdn_aggregation_table AS (
  SELECT
    ivr_id,
    CASE
      WHEN STARTS_WITH(vdn_label,'ATC') THEN 'FRONT'
      WHEN STARTS_WITH(vdn_label,'TECH') THEN 'TECH'
      WHEN vdn_label ='ABSORPTION' THEN 'ABSORPTION'
      ELSE 'RESTO'
  END
    AS vdn_aggregation
  FROM
    `keepcoding.ivr_calls`),
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
      document_type) = 1),
  document_info_table AS(
  SELECT
    number.ivr_id,
    type.document_type AS document_type,
    number.document_identification AS document_identification
  FROM
    number
  INNER JOIN
    type
  ON
    number.ivr_id = type.ivr_id ),
  customer_phone_table AS (
  SELECT
    ivr_id,
    phone_number AS customer_phone
  FROM
    `keepcoding.ivr_calls`
  QUALIFY
    ROW_NUMBER() OVER (PARTITION BY CAST(ivr_id AS STRING)
    ORDER BY
      phone_number) = 1 ),
  billing_account_table AS (
  SELECT
    ivr_id,
    billing_account_id
  FROM
    `keepcoding.ivr_steps`
  QUALIFY
    ROW_NUMBER() OVER (PARTITION BY CAST(ivr_id AS STRING)
    ORDER BY
      billing_account_id) = 1),
  masiva_table AS (
  SELECT
    ivr_id,
  IF
    (CONTAINS_SUBSTR(module_aggregation, 'AVERIA_MASIVA'), 1, 0) AS masiva_lg
  FROM
    `keepcoding.ivr_calls`
  QUALIFY
    ROW_NUMBER() OVER(PARTITION BY CAST(ivr_id AS STRING)
    ORDER BY
      module_aggregation DESC) = 1),
  info_by_phone_table AS (
  SELECT
    calls_ivr_id,
    MAX(
    IF
      (step_name ='CUSTOMERINFOBYPHONE.TX'
        AND step_result ='OK', 1, 0)) AS info_by_phone_lg
  FROM
    `keepcoding.ivr_detail`
  GROUP BY
    calls_ivr_id),
  info_by_dni_table AS (
  SELECT
    calls_ivr_id,
    MAX(
    IF
      (step_name ='CUSTOMERINFOBYDNI.TX'
        AND step_result ='OK', 1, 0)) AS info_by_dni_lg
  FROM
    `keepcoding.ivr_detail`
  GROUP BY
    calls_ivr_id),
  dates AS (
  SELECT
    ivr_id,
    phone_number,
    start_date,
    LAG(start_date) OVER (PARTITION BY phone_number ORDER BY start_date) AS fecha_anterior,
    LEAD(start_date) OVER (PARTITION BY phone_number ORDER BY start_date) AS fecha_siguiente
  FROM
    `keepcoding.ivr_calls` ),
  calls_24h AS (
  SELECT
    ivr_id,
  IF
    (TIMESTAMP_DIFF(start_date, fecha_anterior, HOUR) <= 24, 1, 0) AS repeated_phone_24H,
  IF
    (TIMESTAMP_DIFF(fecha_siguiente, start_date, HOUR) <= 24, 1, 0) AS cause_recall_phone_24H
  FROM
    dates)
SELECT
  details.calls_ivr_id AS ivr_id,
  details.calls_phone_number AS phone_number,
  details.calls_ivr_result AS ivr_result,
  vdn_aggregation_table.vdn_aggregation,
  details.calls_start_date AS start_date,
  details.calls_end_date AS end_date,
  details.calls_total_duration AS total_duration,
  details.calls_customer_segment AS customer_segment,
  details.calls_ivr_language AS ivr_language,
  details.calls_steps_module AS steps_module,
  details.calls_module_aggregation AS module_aggregation,
  document_info_table.document_type,
  document_info_table.document_identification,
  customer_phone_table.customer_phone,
  billing_account_table.billing_account_id,
  masiva_table.masiva_lg,
  info_by_phone_table.info_by_phone_lg,
  info_by_dni_table.info_by_dni_lg,
  calls_24h.repeated_phone_24H,
  calls_24h.cause_recall_phone_24H
FROM
  `keepcoding.ivr_detail` details
INNER JOIN
  vdn_aggregation_table
ON
  details.calls_ivr_id = vdn_aggregation_table.ivr_id
INNER JOIN
  document_info_table
ON
  details.calls_ivr_id = document_info_table.ivr_id
INNER JOIN
  customer_phone_table
ON
  details.calls_ivr_id = customer_phone_table.ivr_id
INNER JOIN
  billing_account_table
ON
  details.calls_ivr_id = billing_account_table.ivr_id
INNER JOIN
  masiva_table
ON
  details.calls_ivr_id = masiva_table.ivr_id
INNER JOIN
  info_by_dni_table
ON
  details.calls_ivr_id = info_by_dni_table.calls_ivr_id
INNER JOIN
  info_by_phone_table
ON
  details.calls_ivr_id = info_by_phone_table.calls_ivr_id
INNER JOIN
  calls_24h
ON
  details.calls_ivr_id = calls_24h.ivr_id
QUALIFY
  ROW_NUMBER() OVER (PARTITION BY CAST(ivr_id AS STRING)
  ORDER BY
    phone_number) = 1