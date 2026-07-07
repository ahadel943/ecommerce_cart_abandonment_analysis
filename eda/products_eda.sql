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

-- products count by price bucket
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

	





