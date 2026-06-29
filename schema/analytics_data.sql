-- create the tables for the analytics schema layer

-- users table for the analytics_data schema
create table analytics_data.users (
	user_id uuid primary key,
	signup_date timestamp not null,
	country varchar(50),
	city varchar(100),
	device varchar(20),
	acquisition_channel varchar(50),
	customer_type varchar(20),
	age int,
	is_premium boolean
);

-- products table for the analytics_data schema
create table analytics_data.products (
	product_id uuid primary key,
	product_name varchar(100) not null,
	category varchar(100) not null,
	brand varchar(100),
	price numeric(10, 2) not null,
	cost numeric(10, 2) not null,
	rating numeric(2, 1),
	stock int,
	is_active boolean
);

-- carts table for the analytics_data schema
create table analytics_data.carts (
	cart_id uuid primary key,
	user_id uuid references analytics_data.users(user_id),
	created_at timestamp not null,
	status varchar(30)
);

-- cart_items table for the analytics_data schema
create table analytics_data.cart_items (
	cart_item_id uuid primary key,
	cart_id uuid references analytics_data.carts(cart_id),
	product_id uuid references analytics_data.products(product_id),
	quantity int not null,
	unit_price numeric(10, 2) not null 
);

-- checkout_attempts table for the analytics_data schema
create table analytics_data.checkout_attempts (
	checkout_id uuid primary key ,
	cart_id uuid references analytics_data.carts(cart_id),
	started_at timestamp not null,
	payment_method varchar(50),
	shipping_cost numeric(10, 2),
	completed boolean
);

-- orders table for the analytics_data schema
create table analytics_data.orders (
	order_id uuid primary key,
	cart_id uuid references analytics_data.carts(cart_id),
	total_amount numeric(10, 2) not null,
	payment_method varchar(30)
);

-- cart_events table for the analytics_data schema
create table analytics_data.cart_events (
	event_id uuid primary key,
	cart_id uuid references analytics_data.carts(cart_id),
	user_id uuid references analytics_data.users(user_id),
	event_name varchar(30) not null,
	event_time timestamp not null
);

-- abandonment_reasons table for the analytics_data schema
create table analytics_data.abandonment_reasons (
	cart_id uuid references analytics_data.carts(cart_id),
	reason varchar(100),
	confidence numeric(3, 2)
);


