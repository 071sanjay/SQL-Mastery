/*
SQL JOin
------------------------
1. Inner JOin
2. Left Join
3. Right Join
4. Outer Join
5. Self JOin
6. Cross Join
7. Natural Join

*/

select		--1445
	*
from sales.customers;

select		--1615
	*
from sales.orders;

select
	*					--1445*1615   (48sec)
from sales.customers
cross join
sales.orders;

-- Inner Join
/*
	select
		customer_id, col2, col3, col4
	from table_a
	join table_b
	on table_a.pk = table_b.fk

	ambigious column customer_id, as it is in both tables so use alias:

	select
		ta.customer_id, ta.col2, tb.col3, tb.col4
	from table_a ta
	join table_b tb
	on ta.pk = tb.fk
*/

-- find details of customer id and their order details

select
	sc.customer_id, sc.first_name, sc.last_name, sc.email, sc.street, sc.city,
	so.order_id, so.order_status, so.order_date
from sales.customers sc
join sales.orders so 
on sc.customer_id = so.customer_id;

-- find customer name and their total orders.
select
	concat(sc.first_name, ' ', sc.last_name) as full_name,
	count(order_id) as total_orders
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
group by concat(sc.first_name, ' ', sc.last_name)
having count(order_id)>2;


select
	concat(sc.first_name, ' ', sc.last_name) as full_name,
	count(so.order_id) as total_orders,
	sum((soi.quantity * soi.list_price) * (1 - soi.discount)) as total_price
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
group by concat(sc.first_name, ' ', sc.last_name);


select 
	concat(sc.first_name, ' ', sc.last_name) as full_name,
	pp.product_name
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
join production.products pp
on pp.product_id = soi.product_id;




-- staff name with total orders and total customers
select 
	concat(ss.first_name, ' ', ss.last_name) as full_name,
	count(distinct so.order_id) as total_orders, count(distinct sc.customer_id) as total_customers
from sales.staffs ss
join sales.orders so
on ss.staff_id = so.staff_id
join sales.customers sc
on so.customer_id = sc.customer_id
group by concat(ss.first_name, ' ', ss.last_name);


-- find customer name, product they have purchased, total price of product, 
-- total days taken to deliver product to customer

select
	concat(sc.first_name, ' ', sc.last_name) as full_name,
	pp.product_name, ((soi.quantity * soi.list_price) * (1 - soi.discount)) AS total_price,
	datediff(day, so.order_date, so.shipped_date) as total_days
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on soi.order_id = so.order_id
join production.products pp
on pp.product_id = soi.product_id
where order_status = 4;		-- here 4 means completed orders

select 
	count(order_id) 
from sales.orders
group by order_status;


-- left join, right join, outer join
select
	*
from sales.customers sc		-- here before left join table is considered left table by query
left join sales.orders so
on sc.customer_id = so.customer_id;


select
	*
from sales.customers sc		
right join sales.orders so
on sc.customer_id = so.customer_id;


select
	*
from sales.customers sc		
full outer join sales.orders so		-- should use full in outer join
on sc.customer_id = so.customer_id;



-- natural join(it is slow but silimar to inner join)
select
	*
from sales.customers sc, sales.orders so
where sc.customer_id = so.customer_id;

select
	*
from sales.customers sc, sales.orders so, sales.order_items soi, production.products pp
where 
	sc.customer_id = so.customer_id
	and soi.order_id = so.order_id
	and soi.product_id = pp.product_id;


select
	concat(sc.first_name, ' ', sc.last_name) as full_name,
	pp.product_name, ((soi.quantity * soi.list_price) * (1 - soi.discount)) AS total_price,
	datediff(day, so.order_date, so.shipped_date) as total_days

from sales.customers sc, sales.orders so, sales.order_items soi, production.products pp
where 
	sc.customer_id = so.customer_id
	and soi.order_id = so.order_id
	and soi.product_id = pp.product_id;




-- self join(also like inner join)

select * from sales.staffs;

select
	*
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id;

select
	concat(s1.first_name, ' ', s1.last_name) as manager_name,		--staff_id and manager_id in same table as multiple managers for multiple staffs
	concat(s2.first_name, ' ', s2.last_name) as staff_name
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id;


--- find store name and its associate staff members and also find how many customers
-- are being handled by each staffs.

select 
	ss.store_name, ssf.staff_id, count(distinct so.customer_id) as customer_count
from sales.stores ss
join sales.staffs ssf 
on ss.store_id = ssf.store_id
join sales.orders so
on so.staff_id = ssf.staff_id
group by ssf.staff_id, ss.store_name
order by ssf.staff_id asc;







