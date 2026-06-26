-- raw_data sample check
select * from raw_data.users limit 10;
select * from raw_data.products limit 10;
select * from raw_data.carts limit 10;
select * from raw_data.cart_items limit 10;
select * from raw_data.checkout_attempts limit 10;
select * from raw_data.orders limit 10;
select * from raw_data.cart_events limit 10;
select * from raw_data.abandonment_reasons limit 10;

-- duplicated rows check
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
	
	
	
	
	
	
	
	


























