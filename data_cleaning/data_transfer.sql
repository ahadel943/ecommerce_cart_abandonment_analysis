-- ====================================================
--                     DATA CLEANING
-- ====================================================

-- loading 'users' data into the analytics_data.users table
-- 5,125  missing values were found in the 'city' column in the raw_data.users table
-- the missing values will be replaced with 'Unknown' to preserve user records while maintaining data completeness.
insert into analytics_data.users
select *from raw_data.users;

select * from analytics_data.users limit 10;

-- No data quality issues were found in the products table.
-- Data transferred directly to analytics_data.products.
insert into analytics_data.products
select * from raw_data.products;

select count(*) from analytics_data.users;
select * from analytics_data.products limit 10;

-- No data quality issues were found in the carts table.
-- Data transferred directly to analytics_data.carts.
insert into analytics_data.carts
select * from raw_data.carts;

select count(*) from analytics_data.carts;
select * from analytics_data.carts limit 10;

-- No data quality issues were found in the cart_items table.
-- Data transferred directly to analytics_data.cart_items.	
insert into analytics_data.cart_items
select * from raw_data.cart_items;

select count(*) from analytics_data.cart_items;
select * from analytics_data.cart_items limit 10;

-- No data quality issues were found in the checkout_attempts table.
-- Data transferred directly to analytics_data.checkout_attempts.
insert into analytics_data.checkout_attempts
select * from raw_data.checkout_attempts;

select count(*) from analytics_data.checkout_attempts;
select * from analytics_data.checkout_attempts limit 10;

-- No data quality issues were found in the orders table.
-- Data transferred directly to analytics_data.orders.
insert into analytics_data.orders
select * from raw_data.orders;

select count(*) from analytics_data.orders;
select * from analytics_data.orders limit 10;

-- No data quality issues were found in the cart_events table.
-- Data transferred directly to analytics_data.cart_events.
insert into analytics_data.cart_events
select * from raw_data.cart_events;

select count(*) from analytics_data.cart_events;
select * from analytics_data.cart_events limit 10;

-- No data quality issues were found in the abandonment_reasons table.
-- Data transferred directly to analytics_data.abandonment_reasons.
insert into analytics_data.abandonment_reasons
select * from raw_data.abandonment_reasons;

select count(*) from analytics_data.abandonment_reasons;
select * from analytics_data.abandonment_reasons limit 10;







