

use BikeStores;

select * from sales.customers;

-- find all details of order items whise price is in range of 500 to 2000
select * from sales.order_items
where list_price >= 500 and list_price <= 2000
order by list_price desc;
-- order by 5 desc; (5 is list_price column place)

select * from sales.order_items
where list_price between 500 and 2000
order by list_price desc;


-- find details of customers whose lives in state NY or CA.
select * from sales.customers
where state = 'NY' or state = 'CA';

select * from sales.customers
where state in ('NY', 'CA');

-- find details of customers who lives in state CA and city Campbell
select * from sales.customers
where state = 'CA' and city = 'Campbell';

--like
-- wildcards (%, _)
select * from production.products;

-- find details of products whose name starts with letter S.
select * from production.products
where product_name like 'S%';

-- find details of products whose name must consist of digit 2018
select * from production.products
where product_name like'%2018%';

-- find details of products whose name must start with letter T and first word nust consists of 
-- 4 letters in total which ends with letter k.
select * from production.products
where product_name like'T__k%';

--MySQL/PgSQL -> limit
--Oracle -> offset and fetch
--MSSQL Server -> Top

select top 5 * from sales.order_items
where list_price >=500 and list_price <= 2000
order by 5;


--Relational Algebra
-- ->projection(pie)    join(x)     selection(sigma)

-- flow of execution is SQL--> from, join, where, groupby, having, select, order by, top/limit


-- substring	
	-- substring(column_name, starting point, no_of_letters)
	-- (extracting letters from texts or digits)

--select 3 letters from first_name starting from 2nd letter

select
	first_name, SUBSTRING(first_name, 2, 3)
from sales.customers;

select
	last_name, SUBSTRING(last_name, 1, 3) as first_3_letters
from sales.customers;

-- left(substring) and right function(column name, number of letters)
select
	last_name, right(last_name, 3) as last_3_letters
from sales.customers;

select
	last_name, left(last_name, 3) as first_3_letters_left,
	substring(last_name, 1, 3) as first_3_letters_sub
from sales.customers;


-- concat
	-- concat() function / concat operation(+)
select
CONCAT(first_name, ' ', last_name) as full_name
from sales.customers;

select
	first_name + ' ' + last_name as full_name
from sales.customers;

-- what is difference? ( using operatior cannot concat integer and string)
select
concat(product_name, '-----', list_price) as pp
from production.products;

select
product_name + '------' + list_price as pp
from production.products;

	

-- date function
select
	order_date,
	year(order_date) as order_year,
	month(order_date) as order_month,
	day(order_date) as order_day,

	-- SSMS / Tableau
	datename(month, order_date) as month_name,
	datename(weekday, order_date) as day_name,

	FORMAT(order_date, 'MMMM') as month_format,
	FORMAT(order_date, 'dddd') as day_format

	-- SSMS / Power BI
from sales.orders;

-- isnull function is used to fill null values in sql
select
	getdate(),
	shipped_date,
	isnull(shipped_date, getdate())    --here null vallues get filled by todays date
from sales.orders;

select
	getdate(),
	order_date,
	shipped_date,
	isnull(shipped_date, getdate()),
	datediff(day, order_date, isnull(shipped_date, getdate()))
from sales.orders;

select
	getdate(),
	order_date,
	shipped_date,
	isnull(shipped_date, getdate()),
	datediff(month, order_date, isnull(shipped_date, getdate()))
from sales.orders;

select
	* 
from sales.customers
where phone is null;

-- to find data except null values

select * from sales.customers
where phone is not null;

select
	* 
from sales.customers
where phone != ' ';

select * from sales.customers where phone <> ' ';



