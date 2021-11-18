{{
    config(
        materialized='table',
        unique_key='product_id'
    )
}}

SELECT
    product_id,
    name,
    price,
    quantity
FROM {{
    source('tutorial', 'products')
}}