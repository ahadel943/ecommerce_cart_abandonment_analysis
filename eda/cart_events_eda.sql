-- cart_events table eda

-- events table overview
select count(*) from analytics_data.cart_events; -- 3,251,588 events

select count(distinct user_id) from analytics_data.cart_events; -- 100,000 distinct users, all users are active

select count(distinct cart_id) from analytics_data.cart_events; -- 361,028 carts, all carts are evently actice, even the half that has the temporal issu

-- event distribution analysis
select	
	event_name as "Event Name",
	count(*) as "Events Count",
	round(count(*) / sum(count(*)) over(), 4) as "Percentage"
from analytics_data.cart_events
group by event_name
order by "Events Count" desc;
/*
Event Name	Events Count	Percentage
checkout_started	465,815	14.33%
cart_created	464,569	14.29%
payment_failed	464,546	14.29%
add_item	464,482	14.28%
purchase_completed	464,360	14.28%
remove_item	464,217	14.28%
cart_abandoned	463,599	14.26%
*/

/*
checkout_started
cart_created
payment_failed
add_item
purchase_completed
remove_item
cart_abandoned
*/
select
	count(*) as "Checkout Started Total Count",
	count(distinct cart_id) as "Distinct Cart Count"
from analytics_data.cart_events
where event_name = 'checkout_started'; -- the checkout_started happened in 255,360 carts

select
	count(*) as "Cart Created Total Count",
	count(distinct cart_id) as "Distinct Cart Count"
from analytics_data.cart_events
where event_name = 'cart_created'; -- the checkout_started happened in 254,943 carts, with 464,569 total events

select
	count(*) as "Payment Failed Total Count",
	count(distinct cart_id) as "Distinct Cart Count"
from analytics_data.cart_events
where event_name = 'payment_failed'; -- the checkout_started happened in 255,227 carts, with 464,546 total events

select
	count(*) as "Add Item Total Count",
	count(distinct cart_id) as "Distinct Cart Count"
from analytics_data.cart_events
where event_name = 'add_item'; -- the checkout_started happened in 254,933 carts, with 464,482 total events

select
	count(*) as "Purchase Completed Total Count",
	count(distinct cart_id) as "Distinct Cart Count"
from analytics_data.cart_events
where event_name = 'purchase_completed'; -- the checkout_started happened in 255,101 carts, with 464,360 total events

select
	count(*) as "Remove Item Total Count",
	count(distinct cart_id) as "Distinct Cart Count"
from analytics_data.cart_events
where event_name = 'remove_item'; -- the checkout_started happened in 255,086 carts, with 464,217 total events

select
	count(*) as "Cart Abandoned Total Count",
	count(distinct cart_id) as "Distinct Cart Count"
from analytics_data.cart_events
where event_name = 'cart_abandoned'; -- the checkout_started happened in 254,812 carts, with 463,599 total events


-- event frequency per cart
with cart_stats as (
	select
		min(d."Events Count") as "Minimum",
		percentile_cont(0.25) within group (order by d."Events Count") as "Q1",
		percentile_cont(0.5) within group (order by d."Events Count") as "Median",
		round(avg(d."Events Count"), 2) as "Average",
		percentile_cont(0.75) within group (order by d."Events Count") as "Q3",
		round(stddev(d."Events Count"), 2) as "Std Dev",
		max(d."Events Count") as "Maximum"
	from (
		select 
			cart_id as "Cart ID",
			count(*) as "Events Count"
		from analytics_data.cart_events
		group by cart_id
	) as d
)
select 
	cs."Minimum",
	cs."Q1",
	cs."Median",
	cs."Q3",
	cs."Average",
	cs."Std Dev",
	cs."Maximum",
	cs."Q3" - cs."Q1" as "IQR",
	cs."Q1" - (1.5 * (cs."Q3" - cs."Q1")) as "Lower Bounds",
	cs."Q3" + (1.5 * (cs."Q3" - cs."Q1")) as "Upper Bounds"
from cart_stats as cs;



