
{{ config(
    materialized='dynamic_table',
    snowflake_warehouse = 'COMPUTE_WH',
    database='SNOWFLAKE_DT',
    target_lag = 'DOWNSTREAM',
    schema='Transform_DT'
) }}
WITH Accessory_DT AS (
    SELECT 
        a.cust_id,
        a.acc_id,
        acc_category,
        acc_status,
        price,
        acc_count
    FROM SNOWFLAKE_DT.public.accessory_item a,
         (
            SELECT 
                cust_id,
                acc_id,
                MAX(acc_price) AS price
            FROM SNOWFLAKE_DT.public.Accessory_item
            GROUP BY cust_id, acc_id
         ) max_price
    WHERE a.cust_id = max_price.cust_id
      AND a.acc_id = max_price.acc_id
      AND a.acc_price = max_price.price
)
SELECT * FROM Accessory_DT