{{
    config(
        materialized='table',
        unique_key='order_id'
    )
}}

SELECT
    order_id,
    product_id,
    quantity
FROM {{
    source('tutorial', 'order_items')
}}