-- 3. Does cart value influence abandonment behavior ?

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
		coalesce(ho."Has Order", 0) as "Has Order"
	from analytics_data.carts as c
	left join items_count as ic
	on c.cart_id = ic."Cart ID"
	left join has_order as ho
	on c.cart_id = ho."Cart ID"
),
amount_groups as (
	select 
		case 
			when "Items Count" = 1 then '1 Item Cart'
			when "Items Count" = 2 then '2 Items Cart'
			when "Items Count" = 3 then '3 Items Cart'
			when "Items Count" = 4 then '4 Items Cart'
			else '5 Items Cart'
		end as "Items Count Group",
		"Items Count",
		"Has Order" 
	from carts_status 
),
summary as (
	select 
		"Items Count Group",
		count(*) filter(where "Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 1) as "Completed Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 0) as "Abandoned Carts Count"
	from amount_groups
	group by "Items Count Group"
)
select
	"Items Count Group",
	"Abandoned Carts Count",
	"Completed Carts Count",
	"Eligible Carts Count",
	round((1.0 * "Abandoned Carts Count") / "Eligible Carts Count", 4) as "CAR"
from summary
order by 
	case
		when "Items Count Group" = '1 Item Cart' then 1
		when "Items Count Group" = '2 Items Cart' then 2
		when "Items Count Group" = '3 Items Cart' then 3
		when "Items Count Group" = '4 Items Cart' then 4
		else 5
	end;


select 
	cart_id,
	count(*) as cnt
from analytics_data.cart_items
group by cart_id
order by cnt;







