-- carts table eda
select count(*) from analytics_data.carts; -- total carts count: 361,028 carts

select
	min(signup_date), -- 2023-01-01 00:20:19.000
	max(signup_date) -- 2025-12-30 23:53:47.000
from analytics_data.users;  

select 
	min(created_at), -- 2023-01-01 00:04:35.000
	max(created_at) -- 2025-12-30 23:59:48.000
from analytics_data.carts;

select *
from analytics_data.carts
where created_at <= '2023-01-01 00:20:19.000';
-- created_at <= '2023-01-01 00:20:19.000' 4 carts 

select count(*)
from analytics_data.carts as c
left join analytics_data.users as u
on c.user_id = u.user_id
where c.created_at < u.signup_date; -- 180,825 carts

select
	u.user_id,
	c.cart_id,
	min(u.signup_date) as "Signup Date",
	min(c.created_at) as "Cart CreatedAt"
from analytics_data.carts as c
left join analytics_data.users as u
on c.user_id = u.user_id
where c.created_at < u.signup_date
group by u.user_id, c.cart_id; 
/*
						user id																	cart id 												Signup date						cart created_at
0000d9ec-adae-468b-a392-81fc6e214a11	4c83f4f8-b68f-48f9-b1db-0ecac2e9eb53	2024-04-09 17:49:04.000	2024-03-03 18:22:16.000
0000d9ec-adae-468b-a392-81fc6e214a11	9124219c-f608-468d-91e8-ceb335316cd6	2024-04-09 17:49:04.000	2023-04-06 15:07:02.000
000298c2-9c1a-428a-b38d-6e32bc134da3	3fb8a75d-ef51-4107-804d-864be541ff07	2025-04-06 10:17:20.000	2024-12-02 01:05:30.000
000298c2-9c1a-428a-b38d-6e32bc134da3	8f4d0719-a2ca-4a68-b4c3-22f9b79a9e56	2025-04-06 10:17:20.000	2024-12-16 00:24:58.000
000298c2-9c1a-428a-b38d-6e32bc134da3	d340c81f-8db1-42bd-ab58-978d37988f96	2025-04-06 10:17:20.000	2023-11-26 08:30:25.000 
*/

with first_cart as (
	select
		user_id,
		min(created_at) as first_cart_date
	from analytics_data.carts
	group by user_id
)
select count(*) as cart_count
from first_cart as fc
left join analytics_data.users as u
on fc.user_id = u.user_id
where fc.first_cart_date < u.signup_date; -- 74,004

select
	count(*) as cnt
from analytics_data.carts as c
left join analytics_data.users as u
on c.user_id = u.user_id
where c.created_at >= u.signup_date; -- valid carts count: 180,203 carts

/*
A temporal consistency validation identified that some cart creation timestamps occur before
the corresponding user signup dates. This issue originates from the synthetic data generation process
and does not affect the primary objective of this project, which focuses on cart abandonment behavior.

Consequently, analyses relying on the chronological relationship between user registration
and cart creation (e.g., time-to-first-cart or user onboarding analysis) were intentionally excluded.
All other analyses were performed using the complete dataset.
*/

-- cart adoption rate
select count(distinct user_id)
from analytics_data.carts;

-- users with one cart vs. users with more then one cart
with users_cart_count as (
	select 
		user_id as "User ID",
		count(*) as "Cart Count"
	from analytics_data.carts
	group by user_id
	order by "Cart Count" desc
)
select 
	count(*) as "One-Cart Users Count",
	(select count(*) from users_cart_count) - count(*) as "Multi-Cart Users Count",
	(select count(*) from users_cart_count) as "Total Users Count"
from users_cart_count
where "Cart Count" = 1;

-- cart status distribution
select 
	status as "Status",
	count(*) as "Cart Count"
from analytics_data.carts
group by status;






























