{{
    config(
        materialized='table',
        unique_key='event_id'
    )
}}

with fac_events as (
    select 
        event_id,
        session_id,
        user_id,
        created_at,
        page_url,
        event_type
    from {{ ref('stg_events') }}
)

select * from fac_events