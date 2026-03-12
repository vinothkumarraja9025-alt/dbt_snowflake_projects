
{{ config (materialized='view') }}

with 

source as (

    select * from {{ source('raw_stg', 'customers') }}

),

renamed as (

    select
        c_custkey as cutsomer_id,
        substr(c_name,10) as customer_name,
        c_phone as phone_number,
        round(c_acctbal) as total_amount
    from source


)

select * from renamed