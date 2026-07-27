-- 8. What factors are associated with high-value abandoned carts ?

-- high value carts analysis
-- 8.1 high value carts CAR analysis by country and city
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
		coalesce(u.country, 'Unknown') as "Country",
		coalesce(u.city, 'Unknown') as "City"
	from analytics_data.carts as c
	left join items_count as ic
	on c.cart_id = ic."Cart ID"
	left join cart_value as cv
	on c.cart_id = cv."Cart ID"
	left join has_order as ho
	on c.cart_id = ho."Cart ID"
	left join analytics_data.users as u
	on c.user_id = u.user_id
),
high_value_carts_status as (
	select 
		case
			when "Cart Value" >= 1499 then '1500+'
		end as "High Value Group",
		"Country",
		"City",
		"Items Count",
		"Has Order"
	from carts_status
),
summary as (
	select
		"High Value Group",
		"Country",
		"City",
		count(*) filter(where "Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 1) as "Completed Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 0) as "Abandoned Carts Count"
	from high_value_carts_status
	group by "High Value Group", "Country", "City"
)
select
	"High Value Group",
	"Country",
	"City",
	"Abandoned Carts Count",
	"Completed Carts Count",
	"Eligible Carts Count",
	round((1.0 * "Abandoned Carts Count") / "Eligible Carts Count", 4) as "CAR"
from summary
where "High Value Group" = '1500+';

-- 8.2 high value carts CAR analysis by device
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
		u.device as "Device"
	from analytics_data.carts as c
	left join items_count as ic
	on c.cart_id = ic."Cart ID"
	left join cart_value as cv
	on c.cart_id = cv."Cart ID"
	left join has_order as ho
	on c.cart_id = ho."Cart ID"
	left join analytics_data.users as u
	on c.user_id = u.user_id
),
high_value_carts_status as (
	select 
		case
			when "Cart Value" >= 1499 then '1500+'
		end as "High Value Group",
		"Device",
		"Items Count",
		"Has Order"
	from carts_status
),
summary as (
	select
		"High Value Group",
		"Device",
		count(*) filter(where "Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 1) as "Completed Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 0) as "Abandoned Carts Count"
	from high_value_carts_status
	group by "High Value Group", "Device"
)
select
	"High Value Group",
	"Device",
	"Abandoned Carts Count",
	"Completed Carts Count",
	"Eligible Carts Count",
	round((1.0 * "Abandoned Carts Count") / "Eligible Carts Count", 4) as "CAR"
from summary
where "High Value Group" = '1500+';



















