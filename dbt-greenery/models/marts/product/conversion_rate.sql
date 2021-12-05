{{
    config(
        materialized='table'
    )
}}

with overall_conversion as (
    select 
        sum(case when event_type = 'checkout' then 1 else 0 end) as number_of_orders,
        count(distinct session_id) as number_of_sesions
    from {{ ref('stg_events')}}
)

select 
    number_of_orders, 
    number_of_sesions, 
    number_of_orders * 100 / number_of_sesions as conversion_rate
from overall_conversion
