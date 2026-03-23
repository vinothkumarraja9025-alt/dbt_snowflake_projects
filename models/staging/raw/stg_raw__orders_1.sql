{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='order_id'
) }}

WITH source_data AS (

    SELECT
        order_id,
        customer_id,
        amount,
        updated_at,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY updated_at DESC
        ) AS rn
    FROM {{ source('raw', 'orders_1') }}

)

SELECT
    order_id,
    customer_id,
    amount,
    updated_at
FROM source_data
WHERE rn = 1

{% if is_incremental() %}
AND updated_at >= (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}