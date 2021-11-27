{{ 
    config(
        materialized='table',
        unique_key='order_id'
    )
}}

with order_data as (
    select
        order_id,
        user_id,
        promo_id,
        case when promo_id is null then false else true end as promo_applied,
        created_at,
        address_id,
        order_cost,
        shipping_cost,
        order_total,
        tracking_id,
        shipping_service,
        estimated_delivery_at,
        delivered_at,
        status,
        case
            when estimated_delivery_at is null then "no estimated delivery",
            when delivered_at is null then "no delivery",
            when estimated_delivery_at > delivered_at then "on time delivery",
            when estimated_delivery_at < delivered_at then "late delivery"
        end as delivery_status
    from {{ ref('stg_orders') }}
),

with address_data as (
    select
        address_id,
        address as street,
        zipcode as zip
        state,
        country
    from {{ ref('stg_addresses') }}
),

with promo_data as (
    select
        promo_id,
        discount
    from {{ ref('stg_promos') }}
),

fac_orders as (
    select (
        select *
        from order_data
    ) as od
    left join (
        select *
        from address_data
    ) as ad
    on od.address_id = ad.address_id
    left join (
        select *
        from promo_data
    ) as pd
    join on od.promo_id = pd.promo_id
)

select
    order_id,
    user_id,
    promo_id,
    promo_applied,
    created_at,
    address_id,
    order_cost,
    shipping_cost,
    order_total,
    tracking_id,
    shipping_service,
    estimated_delivery_at,
    delivered_at,
    status,
    delivery_status,
    street,
    zip,
    state,
    country,
    discount
from fac_orders;