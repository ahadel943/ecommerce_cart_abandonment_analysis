-- 10. Is a specific abandonment reason associated with high value carts ?

with carts_reasons as (
	select 
		cart_id as "Cart ID",
		reason as "Reason"
	from analytics_data.abandonment_reasons 
),
cart_value as (
	select
    cart_id as "Cart ID",
    sum(quantity * unit_price) as "Cart value"
	from analytics_data.cart_items
	group by cart_id
),
cart_info as (
	select
		cr."Cart ID",
		cv."Cart value",
		cr."Reason"
	from carts_reasons as cr
	left join cart_value as cv
	on cr."Cart ID" = cv."Cart ID" 
)
select
	d."Cart Value Group",
	d."Reason",
	d."Abandoned Carts Count",
	sum(d."Abandoned Carts Count") over() as "Abandoned Carts Total Count"
from (
	select
		case
			when "Cart value" > 1499 then 'High Value Cart'		
		end as "Cart Value Group",
		"Reason",
		count(*) as "Abandoned Carts Count"
	from cart_info
	group by "Cart Value Group", "Reason"
) as d
where d."Cart Value Group" = 'High Value Cart'




