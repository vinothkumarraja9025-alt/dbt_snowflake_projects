
{{ config(materialized='view') }}

with cte as(
select e.employee_id,e.first_name,e.salary,d.department_name,d.department_id
from {{ source('raw','employees')}} e
join 
{{ source('raw','departments')}} d
on e.department_id=d.department_id
)
select * from cte 

