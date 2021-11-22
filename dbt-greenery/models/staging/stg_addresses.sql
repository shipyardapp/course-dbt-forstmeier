{{
    config(
        materialized='table',
        unique_key='address_id'
    )
}}

SELECT
    address_id,
    address,
    zipcode,
    state,
    country
FROM {{
    source('tutorial', 'addresses')
}}