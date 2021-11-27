{{
    config(
        materialized='table',
        unique_key='user_id'
    )
}}

with user_data as (
    select *
    from {{ ref('stg_users') }}
),

with order_data as (
    select count(*) as number_of_orders, user_id
    from {{ ref('stg_orders') }}
    group by user_id
),

dim_users as (
    select 
        ud.user_id,
        ud.first_name,
        ud.last_name,
        ud.email,
        ud.phone_number,
        ud.created_at,
        ud.updated_at,
        ud.address_id,
        od.number_of_orders
    from user_data as ud
    join order_data as od
    on ud.order_id = od.order_id
)

select * from dim_users;