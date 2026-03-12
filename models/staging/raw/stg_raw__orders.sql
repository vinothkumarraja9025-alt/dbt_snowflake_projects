{{ config(materialized='view') }}

with 

source as (

    select * from {{ source('raw', 'orders') }}

),

renamed as (

    select
        o_orderkey,
        o_custkey,
        o_orderstatus,
        o_totalprice
    from source

)

select * from renamed