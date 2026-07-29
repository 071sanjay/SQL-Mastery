
/*
CTE
--------
- common table expressions, temporary data tables

with cte_name as (
	query.
) select * from cte_name;

*/

-- which customers buys how many products
-- here we create temp table customers details and extract other columns from that table
-- all query must be selected to run

with customer_details as(
	select
		concat(sc.first_name, ' ', sc.last_name) as full_name,
		so.order_date,
		case
			when  so.order_status = 1 then 'pending'
			when so.order_status = 2 then 'processing'
			when so.order_status = 3 then 'rejected'
			when so.order_status = 4 then 'completed'
		end as order_status_label,
		soi.item_id, ((soi.quantity * soi.list_price) * (1 - soi.discount)) as total_price
	from sales.customers sc
	join sales.orders so
	on so.customer_id = sc.customer_id
	join sales.order_items soi
	on soi.order_id = so.order_id
)
select
	full_name, count(item_id) as total_items, sum(total_price) as total_purchase
from customer_details
group by full_name;

-- add one more cte total_purchase inside it

with customer_details as(
	select
		concat(sc.first_name, ' ', sc.last_name) as full_name,
		so.order_date,
		case
			when  so.order_status = 1 then 'pending'
			when so.order_status = 2 then 'processing'
			when so.order_status = 3 then 'rejected'
			when so.order_status = 4 then 'completed'
		end as order_status_label,
		soi.item_id, ((soi.quantity * soi.list_price) * (1 - soi.discount)) as total_price
	from sales.customers sc
	join sales.orders so
	on so.customer_id = sc.customer_id
	join sales.order_items soi
	on soi.order_id = so.order_id
),
total_purchase as (
	select
		full_name, count(item_id) as total_items, sum(total_price) as total_purchase
	from customer_details
	group by full_name
) select sum(total_purchase) from total_purchase;

-- same thing with subquery, sometimes it is preferred

select sum(total_purchase) from (
	select
		full_name, count(item_id) as total_items, sum(total_price) as total_purchase from (
		select
			concat(sc.first_name, ' ', sc.last_name) as full_name,
			so.order_date,
			case
				when  so.order_status = 1 then 'pending'
				when so.order_status = 2 then 'processing'
				when so.order_status = 3 then 'rejected'
				when so.order_status = 4 then 'completed'
			end as order_status_label,
			soi.item_id, ((soi.quantity * soi.list_price) * (1 - soi.discount)) as total_price
		from sales.customers sc
		join sales.orders so
		on so.customer_id = sc.customer_id
		join sales.order_items soi
		on soi.order_id = so.order_id
	) as data
	group by full_name
) as total_purchase;



-- 12. High-Value Customers: Using a subquery or CTE, find the top 5 customers who have 
-- spent the most money across all their completed orders.

-- cant use join and subquery

with customer_orders as (
	select
		sc.customer_id, concat(sc.first_name, ' ', sc.last_name) as full_name,
		((quantity*list_price) * (1-discount)) as total_price
	from sales.order_items soi
	join sales.orders so
	on soi.order_id = so.order_id
	join sales.customers sc
	on sc.customer_id = so.customer_id
) select top 5
	full_name, sum(total_price) as total_price
from customer_orders
group by full_name
order by total_price desc; 