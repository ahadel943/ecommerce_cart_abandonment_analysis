-- USING PSQL cli tool

-- first, switch connection to cart_abandonment database
\c cart_abandonment;

-- CSVs data load
-- users data
\copy raw_data.users (user_id, signup_date, country, city, device, acquisition_channel, customer_type, age, is_premium)
from 'FILE_PATH\\users.csv'
with (format csv, header true);

-- products data
\copy raw_data.products (product_id, product_name, category, brand, price, cost, rating, stock, is_active)
from 'FILE_PATH\\products.csv'
with (format csv, header true);

-- carts data
\copy raw_data.carts (cart_id, user_id, created_at, status)
from 'FILE_PATH\\carts.csv'
with (format csv, header true);

-- cart_items data
\copy raw_data.cart_items (cart_item_id, cart_id, product_id, quantity, unit_price)
from 'FILE_PATH\\cart_items.csv'
with (format csv, header true);

--checkout_attempts data
\copy raw_data.checkout_attempts (checkout_id, cart_id, started_at, payment_method, shipping_cost, completed)
from 'FILE_PATH\\checkout_attempts.csv'
with (header true, format csv);

-- orders data
\copy raw_data.orders (order_id, cart_id, total_amount, payment_method)
from 'FILE_PATH\\orders.csv'
with (header true, format csv);

-- cart_events data
\copy raw_data.cart_events (event_id, cart_id, user_id, event_name, event_time)
from 'FILE_PATH\\cart_events.csv'
with (format csv, header true);

-- abandonment_reasons data 
\copy raw_data.abandonment_reasons (cart_id, reason, confidence)
from 'FILE_PATH\\abandonment_reasons.csv'
with (format csv, header true);