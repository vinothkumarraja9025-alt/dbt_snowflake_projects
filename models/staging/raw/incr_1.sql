{{ config(materialized='incremental') }}

select
    O_ORDERKEY,
    O_CUSTKEY,
    O_ORDERSTATUS,
    O_TOTALPRICE,
    O_ORDERDATE,
    O_ORDERPRIORITY,
    O_CLERK,
    O_SHIPPRIORITY,
    O_COMMENT
from {{ source('raw','orders') }}

{% if is_incremental() %}

where O_ORDERDATE >
(
    select max(O_ORDERDATE) from {{ this }}
)

{% endif %}