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
	count(*) as "Attempts Count"
from analytics_data.checkout_attempts
group by payment_method
order by "Attempts Count" desc;
















