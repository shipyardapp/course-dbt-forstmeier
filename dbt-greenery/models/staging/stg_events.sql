{{
    config(
        materialized='table',
        unique_key='event_id'
    )
}}

SELECT
    event_id,
    session_id,
    user_id,
    event_type,
    page_url,
    created_at
FROM {{
    source('tutorial', 'events')
}}