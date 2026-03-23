{{ config(materialized='table')}}


select first_name,
        last_name,
        salary
        from {{ source ('raw','employees')}}