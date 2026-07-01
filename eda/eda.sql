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
	country as "Country",
	count(*) as "Users Count",
	sum(count(*)) over() as "Total Count",
	count(*) / sum(count(*)) over() as "Percentage"
from analytics_data.users
group by "Country"
order by "Users Count" desc;

-- users count by city
select
	city as "City",
	count(*) as "Users Count",
	sum(count(*)) over() as "Total Count",
	count(*) / sum(count(*)) over() as "Percentage"
from analytics_data.users
group by "City"
order by "Users Count" desc;

-- users count by device
select
	device,
	count(*) as users_count,
	sum(count(*)) over() as total_count,
	count(*) / sum(count(*)) over() as perc
from analytics_data.users
group by device
order by users_count desc;

-- users count by acquisition_channel
select
	acquisition_channel,
	count(*) as users_count,
	sum(count(*)) over() as total_count,
	count(*) / sum(count(*)) over() as perc
from analytics_data.users
group by acquisition_channel 
order by users_count desc;

-- users count by customer_type
select
	customer_type,
	count(*) as users_count,
	sum(count(*)) over() as total_count,
	count(*) / sum(count(*)) over() as perc
from analytics_data.users
group by customer_type
order by users_count desc;

-- users sigup trend over time
select
	extract(year from signup_date) as "Year",
	extract(month from signup_date) as "Month",
	to_char(signup_date, 'Mon') as "Month Name",
	count(*) as users_count
from analytics_data.users
group by "Year", "Month", "Month Name"




