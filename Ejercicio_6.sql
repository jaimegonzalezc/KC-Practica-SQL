SELECT
  ivr_id,
  phone_number AS customer_phone
FROM
  `keepcoding.ivr_calls`
QUALIFY
  ROW_NUMBER() OVER (PARTITION BY CAST(ivr_id AS STRING)
  ORDER BY
    phone_number) = 1