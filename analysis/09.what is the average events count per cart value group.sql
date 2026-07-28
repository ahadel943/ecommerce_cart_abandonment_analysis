-- 9.average events count by cart value group
with events_count as (
	select
    cart_id,
    count(*) as events_count
	from analytics_data.cart_events
	group by cart_id
),
cart_value as (
	select
    cart_id,
    sum(quantity * unit_price) as cart_value
	from analytics_data.cart_items
	group by cart_id
),
cart_info as (
	select
    ec.cart_id as "Cart ID",
    ec.events_count as "Events Count",
    cv.cart_value as "Cart Value"
	from events_count as ec
	left join cart_value as cv
	on ec.cart_id = cv.cart_id
)
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
		round(avg("Events Count"), 2) as "AVG Cart Events"
from cart_info
group by "Total Amount Group";
