-- 6. Which payment methods are associated with higher checkout completion rates ?

with items_count as (
	select 
		cart_id as "Cart ID",
		count(*) as "Items Count"
	from analytics_data.cart_items
	group by cart_id
),
has_order as (
	select 
		distinct cart_id as "Cart ID",
		1 as "Has Order" 
	from analytics_data.orders
),
carts_status as (
	select
		c.cart_id  as "Cart ID",
		coalesce(ic."Items Count", 0) as "Items Count",
		coalesce(ho."Has Order", 0) as "Has Order",
		coalesce(ca.payment_method, 'Did not reach checkout stage')  as "Payment Method"
	from analytics_data.carts as c
	left join items_count as ic
	on c.cart_id = ic."Cart ID"
	left join has_order as ho
	on c.cart_id = ho."Cart ID"
	left join analytics_data.checkout_attempts as ca
	on c.cart_id = ca.cart_id
),
payment_method as (
	select 
		cs."Payment Method",
		"Items Count",
		"Has Order" 
	from carts_status as cs
),
summary as (
	select 
		"Payment Method",
		count(*) filter(where "Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 1) as "Completed Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 0) as "Abandoned Carts Count"
	from payment_method
	group by "Payment Method"
)
select
	"Payment Method",
	"Abandoned Carts Count",
	"Completed Carts Count",
	"Eligible Carts Count",
	round((1.0 * "Completed Carts Count") / "Eligible Carts Count", 4) as "CCR"
from summary;
