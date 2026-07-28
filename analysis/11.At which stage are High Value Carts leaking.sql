-- 11. At which stage are High Value Carts leaking

with cart_value as (
	select
		cart_id,
		sum(quantity * unit_price) as cart_value
	from analytics_data.cart_items
	group by cart_id
),
high_value_carts as (
	select
		cart_id
	from cart_value
	where cart_value >= 1500
)
select
	count(*) as "Total High Value Carts",
	count(*) - count(ca.cart_id) as "Did not make it to Checkout",
	count(ca.cart_id) - count(o.cart_id) as "Reached Checkout but did not Order",
	count(o.cart_id) as "Completed Orders"
from high_value_carts as hv
left join analytics_data.checkout_attempts as ca
on hv.cart_id = ca.cart_id
left join analytics_data.orders as o
on hv.cart_id = o.cart_id;








