-- dataset volume
select count(*) from analytics_data.abandonment_reasons; -- 144,232 rows
select count(*) from analytics_data.cart_events; -- 3,251,588 rows
select count(*) from analytics_data.cart_items; -- 1,083,844 rows
select count(*) from analytics_data.carts; -- 361,028 rows
select count(*) from analytics_data.checkout_attempts; -- 216,796 rows
select count(*) from analytics_data.orders; -- 64,857 rows
select count(*) from analytics_data.products; -- 5,000 rows
select count(*) from analytics_data.users; -- 100,000 rows

-- USERS table EDA
-- users count by counrty
select
	country,
	count(*) as users_count
from analytics_data.users
group by country
order by users_count desc;

