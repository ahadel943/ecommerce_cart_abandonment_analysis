-- 7.Are specific abandonment reasons associated with particular cart characteristics ?

-- 7.1 cart value by reason
with items_count as (
	select 
		cart_id as "Cart ID",
		count(*) as "Items Count"
	from analytics_data.cart_items 
	group by cart_id
),
cart_value as (
	select 
		cart_id as "Cart ID",
		sum(quantity * unit_price) as "Cart Value"
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
		c.cart_id as "Cart ID",
		coalesce(ic."Items Count", 0) as "Items Count",
		coalesce(cv."Cart Value", 0) as "Cart Value",
		coalesce(ho."Has Order", 0) as "Has Order",
		coalesce(ar.reason, 'Did not make to checkout') as "Reason"
	from analytics_data.carts as c
	left join items_count as ic
	on c.cart_id = ic."Cart ID"
	left join cart_value as cv
	on c.cart_id = cv."Cart ID"
	left join has_order as ho
	on c.cart_id = ho."Cart ID"
	left join analytics_data.abandonment_reasons as ar
	on c.cart_id = ar.cart_id
),
amount_groups as (
	select 
		case
			when "Cart Value" < 250 then 'Under 250'
			when "Cart Value" < 500 then '250 - 499'
			when "Cart Value" < 750 then '500 - 749'
			when "Cart Value" < 1000 then '750 - 999'
			when "Cart Value" < 1250 then '1000 - 1249'
			when "Cart Value" < 1500 then '1250 - 1499'
			else '1500+'
		end as "Total Amount Group",
		"Items Count",
		"Has Order",
		"Reason"
	from carts_status
)
select
	"Total Amount Group",
	"Reason",
	count(*) as "Abandoned Carts Count"
from amount_groups
where "Reason" <> 'Did not make to checkout'
group by "Total Amount Group", "Reason"
order by 
	case 
		when "Total Amount Group" = 'Under 250' then 1
		when "Total Amount Group" = '250 - 499' then 2
		when "Total Amount Group" = '500 - 749' then 3
		when "Total Amount Group" = '750 - 999' then 4
		when "Total Amount Group" = '1000 - 1249' then 5
		when "Total Amount Group" = '1250 - 1499' then 6
		else 7
	end;














