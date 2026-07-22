-- 2. Which customer segments exhibit the highest abandonment rates ?

-- 2.1 - CAR by customer type
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

-- 2.2 CAR by acquisition channel
with carts_info as (
	select 
		c.cart_id as "Cart ID",
		u.acquisition_channel as "Acquisition Channel",
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
	group by c.cart_id, u.acquisition_channel
)
select
	d."Acquisition Channel",
	d."Eligible Carts Count",
	d."Abandoned Carts Count",
	round((1.0 * d."Abandoned Carts Count") / (1.0 * d."Eligible Carts Count"), 4) as "CAR"
from (
	select 
		ci."Acquisition Channel",
		count(*) filter(where ci."Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where ci."Items Count" >= 1 and ci."Has Order" = 0) as "Abandoned Carts Count"
	from carts_info as ci
	group by ci."Acquisition Channel"
	order by "Abandoned Carts Count" desc
) as d;

-- 2.3 - CAR by premium status
with carts_info as (
	select 
		c.cart_id as "Cart ID",
		u.is_premium as "Premium Status",
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
	group by c.cart_id, u.is_premium 
)
select
	d."Premium Status",
	d."Eligible Carts Count",
	d."Abandoned Carts Count",
	round((1.0 * d."Abandoned Carts Count") / (1.0 * d."Eligible Carts Count"), 4) as "CAR"
from (
	select
		ci."Premium Status",
		count(*) filter(where ci."Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where ci."Items Count" >= 1 and ci."Has Order" = 0) as "Abandoned Carts Count"
	from carts_info as ci
	group by ci."Premium Status"
	order by "Abandoned Carts Count" desc
) as d;

-- 2.3 - CAR by age group
with carts_info as (
	select 
		c.cart_id as "Cart ID",
		case 
			when u.age between 18 and 24 then 'Young Adults'
			when u.age between 25 and 34 then 'Adults'
			when u.age between 35 and 44 then 'Mid-age Adults'
			when u.age between 45 and 54 then 'Mature Adults'
			else 'Seniors'
		end as "Age Group",
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
	group by c.cart_id, "Age Group"
)
select
	d."Age Group",
	d."Eligible Carts Count",
	d."Abandoned Carts Count",
	round((1.0 * d."Abandoned Carts Count") / (1.0 * d."Eligible Carts Count"), 4) as "CAR"
from (
	select
		ci."Age Group",
		count(*) filter(where ci."Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where ci."Items Count" >= 1 and ci."Has Order" = 0) as "Abandoned Carts Count"
	from carts_info as ci
	group by ci."Age Group"
	order by "Abandoned Carts Count" desc
) as d;
























