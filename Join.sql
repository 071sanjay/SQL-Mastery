/*
SQL Join
-------------
1. Inner Join
2. Left Join
3. Right Join
4. Outer Join
5. Self Join
6. Cross Join
7. Natural Join
*/


select
	*
from sales.customers; -- 1445

select
	*
from sales.orders; -- 1615
-- 2333675

select
	*
from sales.customers
cross join
sales.orders;

-- Inner Join
/*
	select
		ta.customer_id, ta.col2, tb.col3, tb.col4
	from table_a ta
	join table_b tb
	on ta.pk = tb.fk;
	-- ambigious column customer_id.
*/

-- Find details of customer id and their order details.

select
	sc.customer_id, sc.first_name, sc.last_name, sc.email, sc.street, sc.city, 
	so.order_id, so.order_status, so.order_date
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id;


-- Find customer name and their total orders.
select
	CONCAT(sc.first_name, ' ', sc.last_name) as full_name,
	count(order_id) as total_orders
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
group by CONCAT(sc.first_name, ' ', sc.last_name)
having count(order_id) > 2;


select
	CONCAT(sc.first_name, ' ', sc.last_name) as full_name,
	count(so.order_id) as total_orders,
	sum((soi.quantity * soi.list_price) * (1 - soi.discount)) as total_price
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
group by CONCAT(sc.first_name, ' ', sc.last_name);

select
	CONCAT(sc.first_name, ' ', sc.last_name) as full_name,
	pp.product_name
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
join production.products pp
on soi.product_id = pp.product_id;



-- Find staff name and total orders, customers they have handled.
select
	CONCAT(ss.first_name, ' ', ss.last_name) as full_name,
	COUNT(distinct so.order_id) as total_orders, COUNT(distinct sc.customer_id) as total_customers
from sales.staffs ss
join sales.orders so
on ss.staff_id = so.staff_id
join sales.customers sc
on so.customer_id = sc.customer_id
group by CONCAT(ss.first_name, ' ', ss.last_name);

-- Find total products each customer has purchased.
select
	CONCAT(sc.first_name, ' ', sc.last_name) as full_name,
	COUNT(pp.product_id) as total_products
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.stores ss
on so.store_id = ss.store_id
join production.stocks ps
on ss.store_id = ps.store_id
join production.products pp
on ps.product_id = pp.product_id
group by CONCAT(sc.first_name, ' ', sc.last_name);



select
	CONCAT(sc.first_name, ' ', sc.last_name) as full_name,
	COUNT(pp.product_id) as total_products
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.staffs sss
on so.staff_id = sss.staff_id
join sales.stores ss
on sss.store_id = ss.store_id
join production.stocks ps
on ps.store_id = ss.store_id
join production.products pp
on ps.product_id = pp.product_id
group by CONCAT(sc.first_name, ' ', sc.last_name);

-- Find customer name, product they have purchased, total price of product, total days taken to deliver product to customer.
select
	CONCAT(sc.first_name, ' ', sc.last_name) as full_name,
	pp.product_name, ((soi.quantity * soi.list_price) * (1 - soi.discount)) as total_price,
	DATEDIFF(day, so.order_date, so.shipped_date) as total_days
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
join production.products pp
on soi.product_id = pp.product_id
where order_status = 4;

--Left Join, Right Join, Outer Join

-- Left Join
select
	*
from sales.customers sc
left join 
sales.orders so
on sc.customer_id = so.customer_id;

-- Right Join
select
	*
from sales.customers sc
right join
sales.orders so
on sc.customer_id = so.customer_id;

-- Outer Join
select
	*
from sales.customers sc
full outer join
sales.orders so
on sc.customer_id = so.customer_id;



select
	CONCAT(sc.first_name, ' ', sc.last_name) as full_name,
	pp.product_name, ((soi.quantity * soi.list_price) * (1 - soi.discount)) as total_price,
	DATEDIFF(day, so.order_date, so.shipped_date) as total_days

from sales.customers sc, sales.orders so, sales.order_items soi, production.products pp
where 
	sc.customer_id = so.customer_id
	and soi.order_id = so.order_id
	and soi.product_id = pp.product_id;

-- Self Join
----------------

select * from sales.staffs;

select
	CONCAT(s1.first_name, ' ', s1.last_name) as manager_name,
	CONCAT(s2.first_name, ' ', s2.last_name) as staff_name
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Find store name and its associate staff members and also find how many customers are being handled by each staffs.
select
	ss.store_name, CONCAT(sss.first_name, ' ', sss.last_name) as staff_name,
	COUNT(distinct so.customer_id) as total_customers
from sales.stores ss
join sales.staffs sss
on ss.store_id = sss.store_id
join sales.orders so
on sss.staff_id = so.staff_id
group by ss.store_name, CONCAT(sss.first_name, ' ', sss.last_name);

