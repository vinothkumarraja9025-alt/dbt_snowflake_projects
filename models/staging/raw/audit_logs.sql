{{ config(materialized='incremental',
    unique_key='employee_id' ) 
}}

with cte as 
    (
        select employee_id,salary,last_updated from {{ source('raw','emp_1') }}
    ),
cte1 as
(
    select employee_id,salary,last_updated from {{ ref('stg_raw__emp_1') }}
),

compare as (

    select
        s.employee_id,
        t.salary as old_salary,
        s.salary as new_salary,
        s.last_updated,

        case 
            when t.employee_id is null then 'INSERT'
            when s.salary != t.salary then 'UPDATE'
        end as action

    from cte s
    left join cte1 t
        on s.employee_id = t.employee_id

),

final as(
select
    employee_id,
    action,
    old_salary,
    new_salary,
    last_updated,
    current_timestamp as audit_time
from compare
where action is not null
)

select * from final
{% if is_incremental() %}
where last_updated>(select max(last_updated) from {{ this }})

{% endif %}