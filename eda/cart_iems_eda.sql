-- cart_items table eda
select count(*) from analytics_data.cart_items; -- 1,083,844 items 

select count(distinct cart_id) from analytics_data.cart_items; -- 361,028 distinct cart

select count(distinct product_id) from analytics_data.cart_items; -- 5,000 products

-- quantity distribution analysis
select
	d."Minimum",
	d."Average",
	d."Q1",
	d."Median",
	d."Q3",
	d."Standard Deviation",
	d."Maximum",
	d."Q3" - d."Q1" as "IQR",
	d."Q1" - (1.5 * (d."Q3" - d."Q1")) as "Lower Bounds",
	d."Q3" + (1.5 * (d."Q3" - d."Q1")) as "Upper Bounds"
from (
	select 
		min(quantity) as "Minimum",
		round(avg(quantity), 2) as "Average",
		percentile_cont(0.25) within group (order by quantity) as "Q1",
		percentile_cont(0.5) within group (order by quantity) as "Median",
		percentile_cont(0.75) within group (order by quantity) as "Q3",
		round(stddev(quantity), 2) as "Standard Deviation",
		max(quantity) as "Maximum"
	from analytics_data.cart_items
) as d;

select count(*)
from analytics_data.cart_items
where quantity > 6; -- No Positive outleirs found

select count(*)
from analytics_data.cart_items
where quantity = 1;
/*
 * quantity = 3, 361,897 
 * quantity = 2, 360,441
 * quantity = 1, 361,506
 */

-- cart size analysis
with items_count_by_cart as (
	select
		cart_id as "Cart ID",
		count(cart_item_id) as "Cart Item Count"
	from analytics_data.cart_items
	group by cart_id
)
select
	min("Cart Item Count") as "Minimum",
	round(avg("Cart Item Count"), 2) as "Average",
	percentile_cont(0.25) within group (order by "Cart Item Count") as "Q1",
	percentile_cont(0.5) within group (order by "Cart Item Count") as "Median",
	percentile_cont(0.75) within group (order by "Cart Item Count") as "Q3",
	max("Cart Item Count") as "Maximum",
	round(stddev("Cart Item Count"), 2) as "Standard Deviation"
from items_count_by_cart;
















