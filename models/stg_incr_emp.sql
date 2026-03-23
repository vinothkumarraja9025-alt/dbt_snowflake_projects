{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='employee_id'
) }}


SELECT *
FROM {{ source('raw', 'emp_1') }}

{% if is_incremental() %}
WHERE last_updated > (
        SELECT (MAX(last_updated))
        FROM {{ this }}
)
{% endif %}