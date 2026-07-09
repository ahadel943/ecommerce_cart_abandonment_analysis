-- products table eda

-- products table volume
select count(*) from analytics_data.products;
select count(distinct product_id) from analytics_data.products;

-- products count by category
select
	category as "Category",
	count(*) as "Products Count",
	sum(count(*)) over() as "Total Products Count", 
	count(*) / sum(count(*)) over() as "Percentage"
from analytics_data.products
group by "Category"
order by "Products Count" desc;

-- products count by brand
select distinct brand from analytics_data.products;
select
	brand as "Brand",
	count(*) as "Products Count",
	sum(count(*)) over() as "Total Products Count", 
	count(*) / sum(count(*)) over() as "Percentage"
from analytics_data.products
group by "Brand"
order by "Products Count" desc;

-- products count by active status
select
	is_active as "Active Status",
	count(*) as "Products Count",
	sum(count(*)) over() as "Total Products Count", 
	count(*) / sum(count(*)) over() as "Percentage"
from analytics_data.products 
group by "Active Status"
order by "Products Count" desc;

-- price distribution analysis
select
	d."Avg Price",
	d."Median",
	d."Max Price",
	d."Q1",
	d."Q3",
	d."Standard Deviation",
	d."Q3" - d."Q1" as "IQR",
	d."Max Price" - d."Min Price" as "Range",
	d."Q1" - (1.5 * (d."Q3" - d."Q1")) as "Lower Bounds",
	d."Q3" + (1.5 * (d."Q3" - d."Q1")) as "Upper Bound"
from (
	select
		min(price) as "Min Price",
		percentile_cont(0.25) within group (order by price) as "Q1",
		percentile_cont(0.5) within group (order by price) as "Median",
		percentile_cont(0.75) within group (order by price) as "Q3",
		max(price) as "Max Price",
		round(avg(price), 2) as "Avg Price",
		round(stddev(price), 2) as "Standard Deviation"
	from analytics_data.products
) as d;

-- price outliers count
select
	count(*) as "Upper Outliers Count"
from analytics_data.products
where price > 1671.87;

-- products count by price group
/*
Under 100
100 - 300
300 - 700
700 - 1200
1200 - 1700
1700+
*/
with price_groups as (
	select
		case 
			when price < 100 then 'Under 100'
			when price < 300 then '100 - 300'
			when price < 700 then '300 - 700'
			when price < 1200 then '700 - 1200'
			when price < 1700 then '1200 - 1700'
			else '1700+'
		end as price_group
	from analytics_data.products
)
select 
	price_group as "Price Group",
	count(*) as "Products Count",
	sum(count(*)) over () as "Total Products Count",
	count(*) / sum(count(*)) over() as "Percentage"
from price_groups
group by price_group
order by 
	case
		when price_group = 'Under 100' then 1
		when price_group = '100 - 300' then 2
		when price_group = '300 - 700' then 3
		when price_group = '700 - 1200' then 4
		when price_group = '1200 - 1700' then 5
		else 6
	end;

-- cost distribution analysis
select
	d."Average",
	d."Minimum",
	d."Median",
	d."Q1",
	d."Q3",
	d."Maximum",
	d."Standard Deviation",
	d."Q3" - d."Q1" as "IQR",
	d."Q1" - (1.5 * (d."Q3" - d."Q1")) as "Lower Bounds",
	d."Q3" + (1.5 * (d."Q3" - d."Q1")) as "Upper Bounds" 
from (
	select
		min(cost) as "Minimum",
		round(avg(cost), 2) as "Average",
		percentile_cont(0.25) within group (order by cost) as "Q1",
		percentile_cont(0.5) within group (order by cost) as "Median",
		percentile_cont(0.75) within group (order by cost) as "Q3",
		max(cost) as "Maximum",
		round(stddev(cost), 2) as "Standard Deviation"
	from analytics_data.products
) as d;

select
	count(*) as "Outliers Count",
	count(*) / 5000
from analytics_data.products
where cost > 1082.87; -- 231 positive outliers 

-- products count by cost group
with cost_groups as (
	select
		case
			when cost < 100 then 'Under 100'
			when cost < 300 then '100 - 299'
			when cost < 450 then '300 - 449'
			when cost < 700 then '450 - 699'
			when cost < 950 then '700 - 949'
			when cost < 1100 then '950 - 1099'
			else '1100+'
		end as cost_group
	from analytics_data.products
)
select
	cost_group as "Cost Group",
	count(*) as "Products Count",
	sum(count(*)) over () as "Total Products Count",
	count(*) / sum(count(*)) over() as "Percentage"
from cost_groups
group by cost_group
order by
	case
		when cost_group = 'Under 100' then 1
		when cost_group = '100 - 299' then 2
		when cost_group = '300 - 449' then 3
		when cost_group = '450 - 699' then 4
		when cost_group = '700 - 949' then 5
		when cost_group = '950 - 1099' then 6
		else 7
	end;
	
-- margin distribution analysis
with margin_calc as (
	select
		price - cost as "Margin"
	from analytics_data.products
)
select
	d."Minimum",
	d."Q1",
	d."Median",
	d."Q3",
	d."Average",
	d."Standard Deviation",
	d."Maximum",
	d."Q3" - d."Q1" as "IQR",
	d."Q1" - (1.5 * (d."Q3" - d."Q1")) as "Lower Bounds",
	d."Q3" + (1.5 * (d."Q3" - d."Q1")) as "Upper Bounds"
from (
	select
		min("Margin") as "Minimum",
		percentile_cont(0.25) within group (order by "Margin") as "Q1",
		percentile_cont(0.5) within group (order by "Margin") as "Median",
		percentile_cont(0.75) within group (order by "Margin") as "Q3",
		round(avg("Margin"), 2) as "Average",
		round(stddev("Margin"), 2) as "Standard Deviation",
		max("Margin") as "Maximum"
	from margin_calc
) as d

-- outliers count
select 
	count(price - cost) as "Positive Outliers Count"
from analytics_data.products
where price - cost > 581.892; -- 228 outliers found

select 228*100.0 / 5000 -- 4.56%

-- products count by margin groups
with margin_groups as (
	select
		case
			when price - cost < 100 then 'Under 100'
			when price - cost < 180 then '100 - 179'
			when price - cost < 260 then '180 - 259'
			when price - cost < 340 then '260 - 339'
			when price - cost < 420 then '340 - 419'
			when price - cost < 500 then '420 - 499'
			when price - cost < 580 then '500 - 579'
			else '580+'
		end as margin_group
	from analytics_data.products
)
select
	margin_group as "Margin Group",
	count(*) as "Products Count",
	sum(count(*)) over() as "Total Count",
	count(*) / sum(count(*)) over() as "Percentage"
from margin_groups
group by margin_group
order by 
	case
		when margin_group = 'Under 100' then 1
		when margin_group = '100 - 179' then 2
		when margin_group = '180 - 259' then 3
		when margin_group = '260 - 339' then 4
		when margin_group = '340 - 419' then 5
		when margin_group = '420 - 499' then 6
		when margin_group = '500 - 579' then 7
		else 8
	end;
	
-- rating distribution analysis
select 
	min(rating) as "Minimum",
	round(avg(rating), 2) as "Average",
	percentile_cont(0.5) within group (order by rating) as "Median",
	max(rating) as "Maximum",
	round(stddev(rating), 2) as "Standard Deviation"
from analytics_data.products;

-- stock distribution analysis
select
	d."Minimum",
	d."Q1",
	d."Median",
	d."Q3",
	d."Average",
	d."Maximum",
	d."Standard Deviation",
	d."Q3" - d."Q1" as "IQR",
	d."Q1" - (1.5 * (d."Q3" - d."Q1")) as "Lower Bounds",
	d."Q3" + (1.5 * (d."Q3" - d."Q1")) as "Upper Bounds"
from (
	select
		min(stock) as "Minimum",
		percentile_cont(0.25) within group (order by stock) as "Q1",
		percentile_cont(0.5) within group (order by stock) as "Median",
		percentile_cont(0.75) within group (order by stock) as "Q3",
		round(avg(stock), 2) as "Average",
		max(stock) as "Maximum",
		round(stddev(stock), 2) as "Standard Deviation"
	from analytics_data.products
) as d;

select
	count(*)
from analytics_data.products
where stock = 0; -- 11 products with 0 stock



















