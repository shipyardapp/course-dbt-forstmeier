{{
    config(
        materialized='table',
        unique_key='promo_id'
    )
}}

SELECT
    promo_id,
    discout as discount,
    status
FROM {{
    source('tutorial', 'promos')
}}