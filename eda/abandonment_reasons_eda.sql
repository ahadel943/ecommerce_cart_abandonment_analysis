-- abandonment_reasons eda
select count(*) from analytics_data.abandonment_reasons; -- 144,232 reasons

select
	count(*) as "Reasons Count",
	count(distinct cart_id) as "Distinct Carts Count"
from analytics_data.abandonment_reasons; -- 144,232 reasons, 144,232 cart - each cart has one reason

select distinct reason 
from analytics_data.abandonment_reasons;
/*
 * 5 reasons
Just Browsing
Coupon Failed
Price Too High
High Shipping Cost
Payment Issues
*/

select 
	reason as "Reason",
	count(*) as "Carts Count",
	round(count(*) / sum(count(*)) over(), 4) as "Percentage"
from analytics_data.abandonment_reasons
group by reason
order by "Carts Count" desc;

-- confidence score distribution analysis
with confidence_stats as (
	select 
		min(confidence) as "Minimum",
		percentile_cont(0.25) within group (order by confidence) as "Q1",
		percentile_cont(0.5) within group (order by confidence) as "Median",
		round(avg(confidence), 2) as "Average",
		percentile_cont(0.75) within group (order by confidence) as "Q3",
		max(confidence) as "Maximum",
		round(stddev(confidence), 2) as "Standard Deviation"
	from analytics_data.abandonment_reasons
)
select
	cs."Minimum",
	cs."Q1",
	cs."Median",
	cs."Average",
	cs."Q3",
	cs."Maximum",
	cs."Standard Deviation",
	cs."Q3" - cs."Q1" as "IQR",
	cs."Q1" - (1.5 * (cs."Q3" - cs."Q1")) as "Lower Bounds",
	cs."Q3" + (1.5 * (cs."Q3" - cs."Q1")) as "Upper Bounds"
from confidence_stats as cs;


select count(confidence) 
from analytics_data.abandonment_reasons
where confidence = 0.84;
/*
Min 0.5 1,568
Q1 0.61 3,185
Med 0.72 3,238
Q3 0.84  3,233
Max 0.95 1,524
*/



























