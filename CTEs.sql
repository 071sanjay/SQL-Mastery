/*
CTE
--------
- Common Table Expressions
- Temporary Data Tables

with cte_name as (
	query.
) select * from cte_name;
*/
with customer_details as (
	select
		CONCAT(sc.first_name, ' ', sc.last_name) as full_name,
		so.order_date,
		CASE
			when so.order_status = 1 then 'Pending'
			when so.order_status = 2 then 'Processing'
			when so.order_status = 3 then 'Rejected'
			when so.order_status = 4 then 'Completed'
		end as order_status_label,
		soi.item_id, ((soi.quantity * soi.list_price) * (1 - soi.discount)) as total_price
	from sales.customers sc
	join sales.orders so
	on sc.customer_id = so.customer_id
	join sales.order_items soi
	on soi.order_id = so.order_id
),
total_purchase as (
	select 
		full_name, COUNT(item_id) as total_items, SUM(total_price) as total_purchase
	from customer_details
	group by full_name
) select sum(total_purchase) from total_purchase;


select sum(total_purchase) from (
	select full_name, COUNT(item_id) as total_items, SUM(total_price) as total_purchase from (
		select
			CONCAT(sc.first_name, ' ', sc.last_name) as full_name,
			so.order_date,
			CASE
				when so.order_status = 1 then 'Pending'
				when so.order_status = 2 then 'Processing'
				when so.order_status = 3 then 'Rejected'
				when so.order_status = 4 then 'Completed'
			end as order_status_label,
			soi.item_id, ((soi.quantity * soi.list_price) * (1 - soi.discount)) as total_price
		from sales.customers sc
		join sales.orders so
		on sc.customer_id = so.customer_id
		join sales.order_items soi
		on soi.order_id = so.order_id
	) as data
	group by full_name
) as total_purchase;



--High-Value Customers: Using a subquery or CTE, find the top 5 customers who have 
--spent the most money across all their completed orders. 


select * from sales.customers where exists (
	select 
		customer_id, ((quantity * list_price) * (1 - discount)) as total_price 
	from sales.order_items soi
	join sales.orders so 
	on soi.order_id = so.order_id
	where order_status = 4
);

select * from sales.customers;


select
	sc.customer_id, ((quantity * list_price) * (1 - discount)) as total_price 
from sales.order_items soi
join sales.orders so 
on soi.order_id = so.order_id
join sales.customers sc
on sc.customer_id = so.customer_id
where order_status = 4;

with customer_orders as (
	select 
		sc.customer_id, concat(sc.first_name, ' ', sc.last_name) as full_name,
		((quantity * list_price) * (1 - discount)) as total_price 
	from sales.order_items soi
	join sales.orders so 
	on soi.order_id = so.order_id
	join sales.customers sc
	on sc.customer_id = so.customer_id
) select
	full_name, SUM(total_price) as total_price
from customer_orders
group by full_name
order by total_price desc;


