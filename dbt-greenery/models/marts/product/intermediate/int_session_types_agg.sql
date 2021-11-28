{{
    config(
        materialized='table',
        unique_key='session_id'
    )
}}

with user_event_types as (
    select
        event_type,
        user_id,
        count(*)
    from {{ ref('stg_events')}}
    group by event_type, user_id
)

select * from user_event_types