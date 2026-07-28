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

-- 8.3 high value carts CAR analysis by acquisition channel
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
		u.acquisition_channel as "Acquisition Channel"
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
		"Acquisition Channel",
		"Items Count",
		"Has Order"
	from carts_status
),
summary as (
	select
		"High Value Group",
		"Acquisition Channel",
		count(*) filter(where "Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 1) as "Completed Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 0) as "Abandoned Carts Count"
	from high_value_carts_status
	group by "High Value Group", "Acquisition Channel"
)
select
	"High Value Group",
	"Acquisition Channel",
	"Abandoned Carts Count",
	"Completed Carts Count",
	"Eligible Carts Count",
	round((1.0 * "Abandoned Carts Count") / "Eligible Carts Count", 4) as "CAR"
from summary
where "High Value Group" = '1500+';

-- 8.4 high value carts CAR analysis by customer type
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
		u.customer_type as "Customer Type"
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
		"Customer Type",
		"Items Count",
		"Has Order"
	from carts_status
),
summary as (
	select
		"High Value Group",
		"Customer Type",
		count(*) filter(where "Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 1) as "Completed Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 0) as "Abandoned Carts Count"
	from high_value_carts_status
	group by "High Value Group", "Customer Type"
)
select
	"High Value Group",
	"Customer Type",
	"Abandoned Carts Count",
	"Completed Carts Count",
	"Eligible Carts Count",
	round((1.0 * "Abandoned Carts Count") / "Eligible Carts Count", 4) as "CAR"
from summary
where "High Value Group" = '1500+';

-- 8.5 high value carts CAR analysis by premium status
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
		u.is_premium as "Premium Status"
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
		"Premium Status",
		"Items Count",
		"Has Order"
	from carts_status
),
summary as (
	select
		"High Value Group",
		"Premium Status",
		count(*) filter(where "Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 1) as "Completed Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 0) as "Abandoned Carts Count"
	from high_value_carts_status
	group by "High Value Group", "Premium Status"
)
select
	"High Value Group",
	"Premium Status",
	"Abandoned Carts Count",
	"Completed Carts Count",
	"Eligible Carts Count",
	round((1.0 * "Abandoned Carts Count") / "Eligible Carts Count", 4) as "CAR"
from summary
where "High Value Group" = '1500+';


-- 8.6 high value carts CAR analysis by shipping cost group
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
		case
			when ca.shipping_cost is null then 'No Checkout Attempt'
			when ca.shipping_cost < 10 then 'Under 10'
			when ca.shipping_cost < 15 then '10 - 14'
			when ca.shipping_cost < 20 then '15 - 19'
			else '20+'
		end as "Shipping Cost Group"
	from analytics_data.carts as c
	left join items_count as ic
	on c.cart_id = ic."Cart ID"
	left join cart_value as cv
	on c.cart_id = cv."Cart ID"
	left join has_order as ho
	on c.cart_id = ho."Cart ID"
	left join analytics_data.checkout_attempts as ca
	on c.cart_id = ca.cart_id
),
high_value_carts_status as (
	select 
		case
			when "Cart Value" >= 1499 then '1500+'
		end as "High Value Group",
		"Shipping Cost Group",
		"Items Count",
		"Has Order"
	from carts_status
),
summary as (
	select
		"High Value Group",
		"Shipping Cost Group",
		count(*) filter(where "Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 1) as "Completed Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 0) as "Abandoned Carts Count"
	from high_value_carts_status
	group by "High Value Group", "Shipping Cost Group"
)
select
	"High Value Group",
	"Shipping Cost Group",
	"Abandoned Carts Count",
	"Completed Carts Count",
	"Eligible Carts Count",
	round((1.0 * "Abandoned Carts Count") / "Eligible Carts Count", 4) as "CAR"
from summary
where "High Value Group" = '1500+'
order by 
	case
		when "Shipping Cost Group" = 'No Checkout Attempt' then 1
		when "Shipping Cost Group" = 'Under 10' then 2
		when "Shipping Cost Group" = '10 - 14' then 3
		when "Shipping Cost Group" = '15 - 19' then 4
		else 5
	end;

-- 8.7 high value carts CAR analysis by payment method
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
		coalesce(ca.payment_method, 'Did not make it to checkout') as "Payment Method"
	from analytics_data.carts as c
	left join items_count as ic
	on c.cart_id = ic."Cart ID"
	left join cart_value as cv
	on c.cart_id = cv."Cart ID"
	left join has_order as ho
	on c.cart_id = ho."Cart ID"
	left join analytics_data.checkout_attempts as ca
	on c.cart_id = ca.cart_id
),
high_value_carts_status as (
	select 
		case
			when "Cart Value" >= 1499 then '1500+'
		end as "High Value Group",
		"Payment Method",
		"Items Count",
		"Has Order"
	from carts_status
),
summary as (
	select
		"High Value Group",
		"Payment Method",
		count(*) filter(where "Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 1) as "Completed Carts Count",
		count(*) filter(where "Items Count" >= 1 and "Has Order" = 0) as "Abandoned Carts Count"
	from high_value_carts_status
	group by "High Value Group", "Payment Method"
)
select
	"High Value Group",
	"Payment Method",
	"Abandoned Carts Count",
	"Completed Carts Count",
	"Eligible Carts Count",
	round((1.0 * "Abandoned Carts Count") / "Eligible Carts Count", 4) as "CAR"
from summary
where "High Value Group" = '1500+';

