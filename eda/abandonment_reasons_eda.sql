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


































