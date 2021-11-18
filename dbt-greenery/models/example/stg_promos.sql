{{
    config(
        materialized='table',
        unique_key='promo_id'
    )
}}

SELECT
    promo_id,
    discout,
    status
FROM {{
    source('tutorial', 'promos')
}}