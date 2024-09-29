WITH
  dates AS (
  SELECT
    ivr_id,
    phone_number,
    start_date,
    LAG(start_date) OVER (PARTITION BY phone_number ORDER BY start_date) AS fecha_anterior,
    LEAD(start_date) OVER (PARTITION BY phone_number ORDER BY start_date) AS fecha_siguiente
  FROM
    `keepcoding.ivr_calls` )
SELECT
  ivr_id,
IF
  (TIMESTAMP_DIFF(start_date, fecha_anterior, HOUR) <= 24, 1, 0) AS repeated_phone_24H,
IF
  (TIMESTAMP_DIFF(fecha_siguiente, start_date, HOUR) <= 24, 1, 0) AS cause_recall_phone_24H
FROM
  dates