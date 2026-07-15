-- orders table eda

-- table volume
select count(*)from analytics_data.orders; -- 64,857 orders
	
select count(distinct cart_id)
from analytics_data.orders; -- 64,857 distinct cart, every cart has one order, same number as in checkouts
	
select count(*)
from analytics_data.orders as o
left join analytics_data.carts as c
on o.cart_id = c.cart_id
where c.cart_id is null; -- 0 carts, every order is associated with a cart

-- total amount analysis
select
	d."Minimum",
	d."Q1",
	d."Median",
	d."Average",
	d."Q3",
	d."Maximum",
	d."Standard Deviation",
	d."Q3" - d."Q1" as "IQR",
	d."Q1" - (1.5 * (d."Q3" - d."Q1")) as "Lower Bounds",
	d."Q3" + (1.5 * (d."Q3" - d."Q1")) as "Upper Bounds"
from (
	select 
		min(total_amount) as "Minimum",
		percentile_cont(0.25) within group (order by total_amount) as "Q1",
		percentile_cont(0.5) within group (order by total_amount) as "Median",
		round(avg(total_amount), 2) as "Average",
		percentile_cont(0.75) within group (order by total_amount) as "Q3",
		max(total_amount) as "Maximum",
		round(stddev(total_amount), 2) as "Standard Deviation"
	from analytics_data.orders
) as d;
























