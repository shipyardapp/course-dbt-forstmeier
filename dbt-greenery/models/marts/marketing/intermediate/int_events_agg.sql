{{
    config(
        materialized='table',
        unique_key='session_id'
    )dbt
}}

with int_events_agg as (
    select 
        session_id,
        created_at,
        user_id,
        count(event_type) as event_types
    from {{ ref('fac_events') }}
    group by session_id, created_at, user_id
    order by event_types DESC
)

select * from int_events_agg