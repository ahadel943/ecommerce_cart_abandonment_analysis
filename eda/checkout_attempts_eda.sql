-- checkout_attempts table eda

-- checkout attempts volume
select count(*) from analytics_data.checkout_attempts; 216,796 attempts

select count(distinct cart_id)
from analytics_data.checkout_attempts; -- 216,796 carts

select count(*) 
from analytics_data.checkout_attempts as ca
left join analytics_data.carts as c
on ca.cart_id = c.cart_id
where c.cart_id is null; -- eveery cart in the checkout_attempts exists ib the carts table

-- حayment ةethod distribution
select 
	payment_method as "Payment Method",
	count(*) as "Attempts Count",
	round(count(*) / sum(count(*)) over(), 4)
from analytics_data.checkout_attempts
group by payment_method
order by "Attempts Count" desc;

-- completion status distribution
select
	completed as "Completion Status",
	count(*) as "Attempts Count",
	round(count(*) / sum(count(*)) over(), 4) as "Percentage"
from analytics_data.checkout_attempts
group by completed; -- false	151939 - true	64857

select count(*) from analytics_data.orders; -- 64857 orders, every completed checkout has one order

-- shipping cost distribution analysis
select
	d."Minimum",
	d."Q1",
	d."Median",
	d."Q3",
	d."Maximum",
	d."Average",
	d."Standard Deviation",
	d."Q3" - d."Q1" as "IQR",
	d."Q1" - (1.5 * (d."Q3" - d."Q1")) as "Lower Bound",
	d."Q3" + (1.5 * (d."Q3" - d."Q1")) as "Upper Bound"
from (
	select
		min(shipping_cost) as "Minimum",
		percentile_cont(0.25) within group (order by shipping_cost) as "Q1",
		percentile_cont(0.5) within group (order by shipping_cost) as "Median",
		percentile_cont(0.75) within group (order by shipping_cost) as "Q3",
		max(shipping_cost) as "Maximum",
		round(avg(shipping_cost), 2) as "Average",
		round(stddev(shipping_cost), 2) as "Standard Deviation"
	from analytics_data.checkout_attempts
) as d;

-- shipping cost by cost group
with shipping_cost_groups as (
	select
		case 
			when shipping_cost < 10 then 'Under 10'
			when shipping_cost < 15 then '10 - 14'
			when shipping_cost < 20 then '15 - 19'
			else '20+'
		end as shipping_cost_group
	from analytics_data.checkout_attempts
)
select 
	shipping_cost_group as "Shipping Cost Group",
	count(*) as "Attempts Count",
	sum(count(*)) over() as "Total Count",
	round(count(*) / sum(count(*)) over(), 4) as "Percentage"
from shipping_cost_groups
group by shipping_cost_group
order by 
	case
		when shipping_cost_group = 'Under 10' then 1
		when shipping_cost_group = '10 - 14' then 2
		when shipping_cost_group = '15 - 19' then 3
		else 4
	end
	
-- started_at trend analysis
select
	extract(year from started_at) as "Year",
	extract(month from started_at) as "Month Number",
	to_char(started_at, 'Mon') as "Month Short",
	to_char(started_at, 'Month') as "Month name",
	to_char(started_at, 'Mon-yyyy') as "Date",
	count(*) as "Attempts Count",
	sum(count(*)) over() as "Total Count",
	round(count(*) / sum(count(*)) over(), 4) as "Percentage"
from analytics_data.checkout_attempts
group by "Year", "Month Number", "Month Short", "Month name", "Date";













