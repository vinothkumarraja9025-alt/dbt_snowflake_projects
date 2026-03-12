{{ config(materialized='view') }}

select
    e.employee_id,
    e.employee_name,
    e.salary,
    d.department_id,
    d.department_name
from {{ source('raw', 'employees') }} e
join {{ source('raw', 'departments') }} d
on e.department_id = d.department_id