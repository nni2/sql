-- churn users 

with
monthly_activity as (
  select distinct
    date_trunc('month', created_at) as month,
    user_id
  from events
),
first_activity as (
  select user_id, date(min(created_at)) as month
  from events
  group by 1
)
select
  this_month.month,
  count(distinct user_id)
from monthly_activity this_month
left join monthly_activity last_month
  on this_month.user_id = last_month.user_id
  and this_month.month = add_months(last_month.month,1)
join first_activity
  on this_month.user_id = first_activity.user_id
  and first_activity.month != this_month.month
where last_month.user_id is null
group by 1

-- % change
with monthly_active_users as (
 select
   date_trunc('month', created_at) as month,
   count (distinct user_id) as mau
 from events
 group by 1
)
select
 this_month.month,
 [(this_month.mau - last_month.mau)*1.0/last_month.mau:%] as pct_change
from monthly_active_users this_month
join monthly_active_users last_month
 on this_month.month = add_months(last_month.month,1)