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