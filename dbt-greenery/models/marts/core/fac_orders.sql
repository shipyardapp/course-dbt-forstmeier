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
            when estimated_delivery_at is null then 'no estimated delivery'
            when delivered_at is null then 'no delivery'
            when estimated_delivery_at > delivered_at then 'on time delivery'
            when estimated_delivery_at < delivered_at then 'late delivery'
        end as delivery_status
    from {{ ref('stg_orders') }}
),

address_data as (
    select
        address_id,
        address as street,
        zipcode as zip,
        state,
        country
    from {{ ref('stg_addresses') }}
),

promo_data as (
    select
        promo_id,
        discount
    from {{ ref('stg_promos') }}
),

fac_orders as (
    select
        od.order_id as order_id,
        od.user_id as user_id,
        od.promo_applied as promo_applied,
        od.created_at as order_created_at,
        od.order_cost as item_cost,
        od.shipping_cost as shipping_cost,
        od.order_total as total_cost,
        od.shipping_service as shipping_service,
        od.estimated_delivery_at as estimated_delivery_at,
        od.delivered_at as delivered_at,
        od.status as order_status,
        od.delivery_status as delivery_status,
        ad.street as shipping_street,
        ad.zip as shipping_zip,
        ad.state as shipping_state,
        ad.country as shipping_country,
        pd.discount as discount,
        pd.promo_id as promo_name
    from (
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
    on od.promo_id = pd.promo_id
)

select * from fac_orders