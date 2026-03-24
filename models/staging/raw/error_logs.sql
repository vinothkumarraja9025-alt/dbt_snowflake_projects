{{ config(materialized='incremental')
}}

with 

source as (

    select * from {{ source('raw', 'emp_2') }}

),

target as 
(select * from {{ ref('stg_raw__emp_2') }}
),

renamed as (

    select
        s.employee_id,
        s.salary as old_salary,
        t.salary as new_salary,
        s.last_updated,
        case 
            when t.employee_id is null then 'INSERT'
            when t.salary != s.salary then 'UPDATE'
        end as action
    from source s 
    left join target t
        on s.employee_id = t.employee_id
        
),
final as(

select employee_id,
        action,
        old_salary, 
        new_salary,
        last_updated,
        current_timestamp as audit_time
from renamed
where action is not null
)

select * from final
{% if is_incremental() %}
where last_updated > ((select max(last_updated) from {{ this }}))

{% endif %}