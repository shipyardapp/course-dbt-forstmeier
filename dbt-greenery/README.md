# Project Answers

## Week 1

- Question: How many users do we have?
- Answer: `130`
- Query: 

```
select count(*) from users;
```

- Question: On average, how many orders do we receive per hour?
- Answer: `16.2500000000000000`
- Query: 

```
with orders_by_hour as (
    select count(*) 
    from orders 
    where created_at is not null 
    group by date_part('hour', created_at)
) 
select avg(count) 
from orders_by_hour;
```

- Question: On average, how long does an order take from being placed to being delivered?
- Answer: `3 days 22:13:10.504451`
- Query: 

```
select avg(delivered_at - created_at) as diff
from orders
where delivered_at is not null;
```

- Question: How many users have only made one purchase? Two purchases? Three+ purchases?
- Answer: `25`, `22`, and `81` respectively
- Query:

```
with order_counts as (
    select count(*), user_id
    from orders
    group by user_id
)
select op.one_purchasers, tp.two_purchasers, tpp.three_plus_purchasers
from (
    select count(*) as one_purchasers, 'const' joiner
    from order_counts
    where count = 1
) op
left join (
    select count(*) as two_purchasers, 'const' joiner
    from order_counts
    where count = 2
) as tp
on op.joiner = tp.joiner
left join (
    select count(*) as three_plus_purchasers, 'const' joiner
    from order_counts
    where count >= 3
) as tpp
on tp.joiner = tpp.joiner;
```

- Question: On average, how many unique sessions do we have per hour?
- Answer: `120.5600000000000000`
- Query:

```
with unique_events as (
    select count(distinct session_id)
    from events
    group by date_part('hour', created_at)
)
select avg(count)
from unique_events;
```