-- raw_data sample check
select * from raw_data.users limit 10;
select * from raw_data.products limit 10;
select * from raw_data.carts limit 10;
select * from raw_data.cart_items limit 10;
select * from raw_data.checkout_attempts limit 10;
select * from raw_data.orders limit 10;
select * from raw_data.cart_events limit 10;
select * from raw_data.abandonment_reasons limit 10;

-- ===============================================
-- 							Duplicated Rows Check
-- ===============================================
-- users table duplicates check
select 
	count(*) as duplicates_count
from raw_data.users
group by 
	user_id,
	signup_date,
	country,
	city,
	device,
	acquisition_channel,
	customer_type,
	age,
	is_premium
having count(*) > 1; -- NO duplicates found

-- products table duplicates check
select
	count(*) as duplicates_count
from raw_data.products
group by 
	product_id,
	product_name,
	category,
	brand,
	price,
	cost,
	rating,
	stock,
	is_active
having count(*) > 1; -- NO duplicates found

-- orders table duplicates check
select
	count(*) as duplicates_count
from raw_data.orders
group by
	order_id,
	cart_id,
	total_amount,
	payment_method
having count(*) > 1; -- NO duplicates found

-- checkout_attempts table duplicates check
select
	count(*) as duplicates_count
from raw_data.checkout_attempts
group by
	checkout_id,
	cart_id,
	started_at,
	payment_method,
	shipping_cost,
	completed
having count(*) > 1; -- NO duplicates found

-- carts table duplicates check
select
	count(*) as duplicates_count
from raw_data.carts
group by
	cart_id,
	user_id,
	created_at,
	status
having count(*) > 1; -- NO duplicates found

-- cart_items table duplicates check
select
	count(*) as duplicates_count
from raw_data.cart_items
group by 
	cart_item_id,
	cart_id,
	product_id,
	quantity,
	unit_price
having count(*) > 1; -- NO duplicates found

-- cart_events table duplicates check
select
	count(*) as duplicates_count
from raw_data.cart_events
group by 
	event_id,
	cart_id,
	user_id,
	event_name,
	event_time
having count(*) > 1; -- NO duplicates found

-- abandonment_reasons table duplicates check
select
	count(*) as duplicates_count
from raw_data.abandonment_reasons
group by
	cart_id,
	reason,
	confidence
having count(*) > 1; -- NO duplicates found
	
-- ===============================================
-- 							missing values check
-- ===============================================
-- users table missing values check
select
	count(*) filter(where user_id is null) as user_id_missing, -- NO missing values
	count(*) filter(where signup_date is null) as signup_date_missing, -- NO missing values
	count(*) filter(where country is null) as country_missing, -- NO missing values
	count(*) filter(where city is null) as city_missing, -- 5,125 missing values in the city column, 5.12% of the total volume
	count(*) filter(where device is null) as device_missing, -- NO missing values
	count(*) filter(where acquisition_channel is null) as acquisition_channel_missing, -- NO missing values
	count(*) filter(where customer_type is null) as customer_type_missing, -- NO missing values
	count(*) filter(where age is null) as age_missing, -- NO missing values
	count(*) filter(where is_premium is null) as is_premium_missing -- NO missing values
from raw_data.users;
	
select 
	count(*) filter(where city is null) * 1.0 * 100.0 / count(*) as perc
from raw_data.users;

-- products table missing values check
select
	count(*) filter(where product_id is null) as product_id_missing, -- NO missing values
	count(*) filter(where product_name is null) as product_name_missing, -- NO missing values
	count(*) filter(where category is null) as category_missing, -- NO missing values
	count(*) filter(where brand is null) as brand_missing, -- NO missing values
	count(*) filter(where price is null) as price_missing, -- NO missing values
	count(*) filter(where cost is null) as cost_missing, -- NO missing values
	count(*) filter(where rating is null) as rating_missing, -- NO missing values
	count(*) filter(where stock is null) as stock_missing, -- NO missing values
	count(*) filter(where is_active is null) as is_active_missing -- NO missing values
from raw_data.products;

-- orders table missing values check
select 
	count(*) filter(where order_id is null) as order_id_missing, -- NO missing values
	count(*) filter(where cart_id is null) as cart_id_missing, -- NO missing values
	count(*) filter(where total_amount is null) as total_amount_missing, -- NO missing values
	count(*) filter(where payment_method is null) as payment_method_missing -- NO missing values
from raw_data.orders;
	
-- checkout_attempts table missing values check
select 
	count(*) filter(where checkout_id is null) as checkout_id_missing, -- NO missing values
	count(*) filter(where cart_id is null) as cart_id_missing, -- NO missing values
	count(*) filter(where started_at is null) as started_at_missing, -- NO missing values
	count(*) filter(where payment_method is null) as payment_method_missing, -- NO missing values
	count(*) filter(where shipping_cost is null) as shipping_cost_missing, -- NO missing values
	count(*) filter(where completed is null) as completed_missing -- NO missing values
from raw_data.checkout_attempts;

-- carts table missing values check
select
	count(*) filter(where cart_id is null) as cart_id_missing, -- NO missing values
	count(*) filter(where user_id is null) as user_id_missing, -- NO missing values
	count(*) filter(where created_at is null) as created_at_missing, -- NO missing values
	count(*) filter(where status is null) as status_missing -- NO missing values
from raw_data.carts;

-- cart_items table missing values check
select
	count(*) filter(where cart_item_id is null) as cart_item_id_missing, -- NO missing values
	count(*) filter(where cart_id is null) as cart_id_missing, -- NO missing values
	count(*) filter(where product_id is null) as product_imissing, -- NO missing values
	count(*) filter(where quantity is null) as quantity_missing, -- NO missing values
	count(*) filter(where unit_price is null) as unit_price_missing -- NO missing values
from raw_data.cart_items;

-- cart_events table missing values check
select
	count(*) filter(where event_id is null) as event_id_missing, -- NO missing values
	count(*) filter(where cart_id is null) as cart_id_missing, -- NO missing values
	count(*) filter(where user_id is null) as user_id_missing, -- NO missing values
	count(*) filter(where event_name is null) as event_name_missing, -- NO missing values
	count(*) filter(where event_time is null) as event_time_missing -- NO missing values
from raw_data.cart_events;

-- abandonment_reasons table missing values check
select
	count(*) filter(where cart_id is null) as cart_id_missing, -- NO missing values
	count(*) filter(where reason is null) as reason_missing, -- NO missing values
	count(*) filter(where confidence is null) as confidence_missing -- NO missing values
from raw_data.abandonment_reasons;

-- ===============================================
-- 							Orphan Records Check
-- ===============================================
-- carts to users orphan records check
select count(*)
from raw_data.carts as c
left join raw_data.users as u
on c.user_id = u.user_id
where u.user_id is null; -- NO orphan records found

-- cart_items to carts orphan records check
select count(*)
from raw_data.cart_items as ci
left join raw_data.carts as c
on ci.cart_id = c.cart_id
where c.cart_id is null; -- NO orphan records found

-- cart_items to products orphan records check
select count(*)
from raw_data.cart_items as ci
left join raw_data.products as p
on ci.product_id = p.product_id
where p.product_id is null; -- NO orphan records found

-- checkout_attempts to carts orphan records check
select count(*)
from raw_data.checkout_attempts as ca
left join raw_data.carts as c
on ca.cart_id = c.cart_id
where c.cart_id is null; -- NO orphan records found

-- orders to carts orphan records check
select count(*)
from raw_data.orders as o
left join raw_data.carts as c
on o.cart_id = c.cart_id 
where c.cart_id is null; -- NO orphan records found

-- cart_events to carts orphan records check
select count(*)
from raw_data.cart_events as ce
left join raw_data.carts as c
on ce.cart_id = c.cart_id 
where c.cart_id is null;

-- cart_events to users orphan records check
select count(*)
from raw_data.cart_events as ce
left join raw_data.users as u
on ce.user_id = u.user_id
where u.user_id is null; -- NO orphan records found

-- abandonment_reasons to carts orphan records check
select count(*)
from raw_data.abandonment_reasons as ar
left join raw_data.carts as c
on ar.cart_id = c.cart_id
where c.cart_id is null;

-- ===============================================
-- 							Primary Keys Uniqueness Check
-- ===============================================
-- users table PK check
select
	count(*) as total_cnt,
	count(distinct user_id) as ids_cnt
from raw_data.users; -- NO duplicated user_id found

-- products table PK check
select
	count(*) as total_cnt,
	count(distinct product_id) as ids_cnt
from raw_data.products; -- NO duplicated product_id found

-- orders table PK check
select
	count(*) as total_cnt,
	count(distinct order_id) as ids_cnt
from raw_data.orders; -- NO duplicated order_id found

-- checkout_attempts table PK check
select
	count(*) as total_cnt,
	count(distinct checkout_id) as ids_cnt
from raw_data.checkout_attempts; -- NO duplicated checkout_id found

-- checkout_attempts table PK check
select
	count(*) as total_cnt,
	count(distinct cart_id) as ids_cnt
from raw_data.carts; -- NO duplicated cart_id found

-- cart_items table PK check
select
	count(*) as total_cnt,
	count(distinct cart_item_id) as ids_cnt
from raw_data.cart_items; -- NO duplicated cart_item_id found

-- cart_events table PK check
select
	count(*) as total_cnt,
	count(distinct event_id) as ids_cnt
from raw_data.cart_events; -- NO duplicated event_id found

-- abandonment_reasons table PK check
select
	count(*) as total_cnt,
	count(distinct cart_id) as cart_ids_cnt
from raw_data.abandonment_reasons; -- NO duplicated cart_id found

-- ===================================================================================
-- 							Domain Validation (Categorical Values Sequences) Check
-- ===================================================================================
select distinct customer_type from raw_data.users; -- Returning, New
select distinct device from raw_data.users; -- Mobile, Tablet, Desktop

select distinct payment_method from raw_data.checkout_attempts; -- Wallet, Card, Cash

select distinct event_name from raw_data.cart_events; -- checkout_started, payment_failed, cart_created, remove_item, add_item, cart_abandoned, purchase_completed

select distinct status from raw_data.carts; -- Active

-- ================================================
-- 							Data Type Validation
-- ================================================
select count(user_id) from raw_data.users where age <= 0; -- 0












