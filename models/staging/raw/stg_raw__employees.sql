{{ config(materialized='view') }}

with 

source as (

    select * from {{ source('raw', 'employees') }}

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
        department_id

    from source

)

select * from renamed