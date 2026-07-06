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
	country as "Country",
	city as "City",
	count(*) as "Users Count",
	sum(count(*)) over() as "Total Count",
	count(*) / sum(count(*)) over() as "Percentage"
from analytics_data.users
group by "Country", "City"
order by "Country";

-- users count by device
select
	device as "Device",
	count(*) as "Users Count",
	sum(count(*)) over() as "Total Count",
	count(*) / sum(count(*)) over() as "Percentage"
from analytics_data.users
group by "Device"
order by "Users Count" desc;

-- users count by acquisition_channel
select
	acquisition_channel as "Acquisition Channel",
	count(*) as "Users Count",
	sum(count(*)) over() as "Total Count",
	count(*) / sum(count(*)) over() as "Percentage"
from analytics_data.users
group by "Acquisition Channel"
order by "Users Count" desc;

-- users count by customer_type
select
	customer_type as "Customer Type",
	count(*) as "Users Count",
	sum(count(*)) over() as "Total Count",
	count(*) / sum(count(*)) over() as "Percentage"
from analytics_data.users
group by "Customer Type"
order by "Users Count" desc;

-- users sigup trend over time
select
	extract(year from signup_date) as "Year",
	extract(month from signup_date) as "Month",
	to_char(signup_date, 'Mon') as "Month Tag",
	to_char(signup_date, 'Month') as "Month Name",
	to_char(signup_date, 'Mon-yy') as "Month-Year",
	count(*) as "Users Count",
	count(*) / sum(count(*)) over() as "Percentage"
from analytics_data.users
group by "Year", "Month", "Month Tag", "Month Name","Month-Year"
order by "Year", "Month";

select 
	min(signup_date) as "min", max(signup_date) as "max"
from analytics_data.users -- 2023-01-01 00:20:19.000	2025-12-30 23:53:47.000

-- users volume by age bucket
select
	case
		when age between 18 and 24 then 'Young Adults'
		when age between 25 and 34 then 'Adults'
		when age between 35 and 44 then 'Mid-age Adults'
		when age between 45 and 54 then 'Mature Adults'
		else 'Seniors'
	end as "Age Group",
	count(*) as "Users Count",
	count(*) / sum(count(*)) over() as "Percentage"
from analytics_data.users
group by "Age Group"
order by "Users Count" desc;

























