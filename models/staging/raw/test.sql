{{ config (materialized='table')}}


select  1 as employee_id,
        'vinoth' as first_name,
        50000 as salary,
        current_date as hire_date