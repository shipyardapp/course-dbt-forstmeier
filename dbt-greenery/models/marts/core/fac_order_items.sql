{{ 
    config(
        materialized='table',
        unique_key='order_id'
    )
}}

select * from {{ ref('stg_order_items') }}