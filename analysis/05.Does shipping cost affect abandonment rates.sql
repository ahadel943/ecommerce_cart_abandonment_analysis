-- 5. Does shipping cost affect abandonment rates ?

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
		ca.shipping_cost as "Shipping Cost"
	from analytics_data.carts as c
	left join items_count as ic
	on c.cart_id = ic."Cart ID"
	left join has_order as ho
	on c.cart_id = ho."Cart ID"
	left join analytics_data.checkout_attempts as ca
	on c.cart_id = ca.cart_id
),
shiiping_cost_groups as (
	select 
		case
			when "Shipping Cost" is null then 'No Checkout Attempt'
			when "Shipping Cost" < 10 then 'Under 10'
			when "Shipping Cost" < 15 then '10 - 14'
			when "Shipping Cost" < 20 then '15 - 19'
			else '20+'
		end as "Shipping Cost Group",
		"Items Count",
		"Has Order" 
	from carts_status 
),
summary as (
	select 
		"Shipping Cost Group",
		count(*) filter(where "Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 1) as "Completed Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 0) as "Abandoned Carts Count"
	from shiiping_cost_groups
	group by "Shipping Cost Group"
)
select
	"Shipping Cost Group",
	"Abandoned Carts Count",
	"Completed Carts Count",
	"Eligible Carts Count",
	round((1.0 * "Abandoned Carts Count") / "Eligible Carts Count", 4) as "CAR"
from summary
order by 
	case
		when "Shipping Cost Group" = 'No Checkout Attempt' then 1
		when "Shipping Cost Group" = 'Under 10' then 2
		when "Shipping Cost Group" = '10 - 14' then 3
		when "Shipping Cost Group" = '15 - 19' then 4
		else 5
	end;








