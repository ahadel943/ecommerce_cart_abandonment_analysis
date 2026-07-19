-- 1. What is the overall CAR?
/*
 * Eligible Cart: cart has at least one item
 * Completed Cart: Cart has at lest one item and has an order
 * Abandoned Cart: Cart has at least one item and has no order

 * Cart Completion Rate (CCR) = Completed Carts / Eligible Carts
 * Cart Abandonedment Rate (CAR) = Abandoned Carts / Eligible Carts
*/


-- identifing the valid and eligible carts
with eligible_carts as (
	select
		c.cart_id as "Eligible Cart ID",
		count(ci.cart_item_id) as "Items Count per Cart"
	from analytics_data.carts as c
	left join analytics_data.cart_items as ci
	on c.cart_id = ci.cart_id
	group by c.cart_id
)
select
	count(ec."Eligible Cart ID")
from eligible_carts as ec
where ec."Items Count per Cart" >= 1; -- 361,028 eligible carts, all carts contains items

-- calculating completed cart
with completed_carts as (
	select c.cart_id as "Completed Cart ID"
	from analytics_data.carts as c
	left join analytics_data.orders as o
	on c.cart_id = o.cart_id
	where o.order_id is not null
)
select 
	count(cc."Completed Cart ID") as "Completed Cart Count"
from completed_carts as cc; -- 64,857 completed carts 

-- calculating abandoned cart
with abandoned_carts as (
	select c.cart_id as "Abandoned Cart ID"
	from analytics_data.carts as c
	left join analytics_data.orders as o
	on c.cart_id = o.cart_id
	where o.order_id is null
)
select 
	count(ac."Abandoned Cart ID") as "Abandoned Cart Count"
from abandoned_carts as ac; -- 296,171 abandoned carts

-- calculating CAR and CCR
with carts_status as (
	select 
		c.cart_id as "Cart ID",
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
	group by c.cart_id
)
select
	d."Eligible Carts Count",
	d."Completed Carts Count",
	d."Abandoned Carts Count",
	round(1.0 * d."Completed Carts Count" / d."Eligible Carts Count", 4) as "CCR",
	round(1.0 * d."Abandoned Carts Count" / d."Eligible Carts Count", 4) as "CAR"
from (
	select
		count(*) filter(where cs."Items Count" >= 1) as "Eligible Carts Count",
		count(*) filter(where cs."Items Count" >= 1 and cs."Has Order" = 1) as "Completed Carts Count",
		count(*) filter(where cs."Items Count" >= 1 and cs."Has Order" = 0) as "Abandoned Carts Count"
	from carts_status as cs
) as d;












