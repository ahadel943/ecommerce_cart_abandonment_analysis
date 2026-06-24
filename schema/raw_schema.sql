-- create the tables for the raw schema layer
-- NOTE: table columns should not have any PKs, FKs or any constraints

-- users table
create table raw_data.users (
	user_id uuid,
	signup_date timestamp,
	country varchar(50),
	city varchar(100),
	device varchar(20),
	acquisition_channel varchar(50),
	customer_type varchar(20),
	gender varchar(20),
	agt int,
	is_premium boolean
);

-- products table
create table raw_data.products (
	product_id uuid,
	product_name varchar(100),
	category varchar(100),
	brand varchar(100),
	price numeric(10, 2),
	cost numeric(10, 2),
	rating numeric(2, 1),
	stock int,
	is_active boolean
);

-- carts table
create table raw_data.carts (
	cart_id uuid,
	user_id uuid,
	created_at timestamp,
	status varchar(30)
);


-- cart_items table
create table raw_data.cart_items (
	cart_item_id uuid,
	cart_id uuid,
	product_id uuid,
	quantity int,
	unit_price numeric(10, 2)
);


-- checkout_attempts table
create table raw_data.checkout_attempts (
	checkout_id uuid,
	cart_id uuid,
	started_at timestamp,
	payment_method varchar(50),
	shipping_cost numeric(10, 2),
	completed boolean
);

-- orders table
create table raw_data.orders (
	order_id uuid,
	cart_id uuid,
	total_amount numeric(10, 2),
	payment_method varchar(30)
);

-- cart_events table 
create table raw_data.cart_events (
	event_id uuid,
	cart_id uuid,
	user_id uuid,
	event_name varchar(30),
	event_time timestamp
);

-- abandonment_reasons table
create table raw_data.abandonment_reasons(
	cart_id uuid,
	reason varchar(100),
	confidence numeric(3, 2)
);






















