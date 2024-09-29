CREATE OR REPLACE FUNCTION
  keepcoding.clean_integer(integer INT64)
  RETURNS INT64 AS (
    CASE
      WHEN integer IS NULL THEN -999999
      ELSE integer
  END
    );