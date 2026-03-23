{{ config(materialized='view') }}


with 

source as (

    select * from {{ source('raw', 'nation') }}

),

renamed as (

    select
        n_nationkey as nation_id,
        n_name as country_name,
        n_regionkey as region

    from source

)

select * from renamed