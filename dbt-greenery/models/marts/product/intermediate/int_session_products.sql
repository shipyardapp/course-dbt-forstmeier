{{
    config(
        materialized='table'
    )
}}

select
    event_type,
    session_id,
    {{ id_from_url("page_url") }} as product_id
from {{ ref('fac_events')}}
