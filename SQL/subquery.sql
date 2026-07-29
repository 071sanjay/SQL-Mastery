
-- Subquery/logical query, to fill dynamic values



-- single row subquery
		--> <, >, =, !=, >=, <=  

-- multiple row subquery
		--> in
		--> any(or), all(and)




-- find all products whose list proce is less than its average list price.

select avg(list_price) from production.products;

select
	*
from production.products
where list_price < (				--here inside where, list_price
	select avg(list_price) from production.products			-- inside subquery, list_price as it is in where
);


-- interview que
-- find second highest price among all products.
select
	*
from production.products
order by list_price desc;

select
	*
from production.products where list_price = (
	select max(list_price) from production.products where list_price < (
		select
			max(list_price)		
		from production.products		--11999.99
	)		--7499.99
);


-- find the third highest among all products

select * from production.products where list_price = (
	select max(list_price) from production.products where list_price < ( 
		select max(list_price) from production.products where list_price < (
			select
			max(list_price)		
		from production.products		--11999.99
		)		--7499.99
	)
);


select * from sales.orders;


-- to find order from 2 day in database
select
	*
from sales.orders where order_date = (
	select min(order_date) from sales.orders where order_date > (
		select
			min(order_date)	
		from sales.orders		
	)		
);

--find details of customers whose order status have been completed.

select
	sc.customer_id, sc.first_name, sc.last_name, sc.phone, sc.email, sc.state, sc.city,
	sc.state, sc.zip_code

from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
where so.order_status = 4;


--using subquery

select * from sales.customers where customer_id in (		--in because it is multirow subquery
	select customer_id from sales.orders where order_status = 4
);

-- find customer name whose order was handled by staff id 6.

select
	concat(sc.first_name, ' ', sc.last_name) as customer_name
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.staffs ss
on ss.staff_id = so.staff_id
where ss.staff_id = 6;

select concat(first_name, ' ', last_name) as customer_name
from sales.customers where customer_id in (
	select customer_id from sales.orders where staff_id = (
		select staff_id from sales.staffs where staff_id = 6
	)
);


-- Multi row sub-query

select * from production.products
order by list_price;

-- find product details whose price is lower than 249.99 or 279.99
select * from production.products where list_price < any (
	select list_price from production.products where list_price in (249.99, 279.99)
) order by list_price;

-- find product details whose price is lower than 249.99 and 279.99	

select * from production.products where list_price < all (
	select list_price from production.products where list_price in (249.99, 279.99)
) order by list_price;


select store_name from sales.stores where store_id in (
	select store_id from production.stocks where product_id in (
		select product_id from production.products where list_price < all (
			select list_price from production.products where list_price in (249.99, 279.99)
		)
	)
);

-- to find customers who buy products in ......
select first_name from sales.customers where customer_id in (
	select customer_id from sales.orders where store_id in (
		select store_id from production.stocks where product_id in (
			select product_id from production.products where list_price < all (
				select list_price from production.products where list_price in (249.99, 279.99)
			)
		)
	)
);






















