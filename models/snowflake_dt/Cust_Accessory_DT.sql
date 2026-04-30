
{{ config(
    materialized='dynamic_table',
    snowflake_warehouse = 'COMPUTE_WH',
    database='SNOWFLAKE_DT',
    target_lag = '24 HOURS',
    schema='Transform_DT'
) }}

WITH Cust_Accessory_DT AS (
    SELECT 
        c.cust_id,
        c.cust_name,
        c.crid,
        c.location,
        c.cust_created,
        a.acc_id,
        a.acc_category,
        a.acc_status,
        a.price,
        a.acc_count,
        a.price / a.acc_count AS Price_Per_Accessory
    FROM {{ ref('Customer_DT') }} c,
         {{ ref('Accessory_DT') }} a
    WHERE c.cust_id = a.cust_id
)

SELECT * FROM Cust_Accessory_DT