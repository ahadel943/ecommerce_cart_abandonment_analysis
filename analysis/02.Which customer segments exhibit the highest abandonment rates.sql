-- 2. Which customer segments exhibit the highest abandonment rates ?

-- 2.1 - CAR by Customer Type
with carts_info as (
	select 
		c.cart_id as "Cart ID",
		u.customer_type as "Customer Type",
		count(ci.cart_item_id) as "Items Count",
		max(
			case
				when o.order_id is not null then 1
				else 0
			end
		) as "Has Order"
	from analytics_data.carts as c
	left join analytics_data.cart_items as ci
	on c.cart_id = ci.cart_id
	left join analytics_data.orders as o
	on c.cart_id = o.cart_id
	left join analytics_data.users as u
	on c.user_id = u.user_id 
	group by c.cart_id, u.customer_type
)
select 
	ci."Customer Type",
	count(*) filter(where ci."Items Count" >= 1) as "Eligible Carts Count",
	count(*) filter(where ci."Items Count" >= 1 and ci."Has Order" = 0) as "Abandoned Carts Count",
	(1.0 * count(*) filter(where ci."Items Count" >= 1 and ci."Has Order" = 0)) / 
	(1.0 * count(*) filter(where ci."Items Count" >= 1)) as "CAR"
from carts_info as ci
group by ci."Customer Type";
















