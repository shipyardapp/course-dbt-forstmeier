select *
from {{ ref('stg_orders') }}
where created_at > estimated_delivery_at or created_at > delivered_at