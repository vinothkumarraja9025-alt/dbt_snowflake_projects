{{ config(materialized='incremental',
            unique_key='employee_id')}}

with 

source as (

    select * from {{ source('raw', 'emp_2') }}

),

renamed as (

    select
        employee_id,
        first_name,
        last_name,
        email,
        phone_number,
        hire_date,
        job_id,
        salary,
        commission_pct,
        manager_id,
        department_id,
        last_updated

    from source

)

select * from renamed

{% if is_incremental() %}
where last_updated>(select max(last_updated) from {{ this }} 
)
{% endif %}