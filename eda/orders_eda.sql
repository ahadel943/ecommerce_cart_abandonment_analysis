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

-- total amount additional validation 
select
	d."QUARS",
	count(*) as "Orders Count"
from (
	select 
		ntile(4) over(order by total_amount desc) as "QUARS"
	from analytics_data.orders
) as d
group by d."QUARS"
order by d."QUARS"; -- data is well balanced

-- total amount by total amount group
with total_amount_groups as (
	select
		order_id,
		total_amount,
		case 	
			when total_amount < 250 then 'Under 250'
			when total_amount < 500 then '250 - 499'
			when total_amount < 750 then '500 - 749'
			when total_amount < 1000 then '750 - 999'
			when total_amount < 1250 then '1000 - 1249'
			when total_amount < 1500 then '1250 - 1499'
			else '1500+'
		end as total_amount_group
	from analytics_data.orders
)
select
	total_amount_group as "Total Amount Group",
	sum(total_amount) as "Revenue by Group",
	round(sum(total_amount) / sum(sum(total_amount)) over(), 4) as "Revenue Contribution %",
	count(order_id) as "Orders Count",
	round(count(order_id) / sum(count(order_id)) over(), 4) as "Orders Contribution %"
from total_amount_groups
group by total_amount_group
order by
	case
		when total_amount_group = 'Under 250' then 1
		when total_amount_group = '250 - 499' then 2
		when total_amount_group = '500 - 749' then 3
		when total_amount_group = '750 - 999' then 4
		when total_amount_group = '1000 - 1249' then 5
		when total_amount_group = '1250 - 1499' then 6
		else 7
	end;














