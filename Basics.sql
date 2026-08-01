	use BikeStores;

select * from sales.customers;

-- Find all details of order items whose price is in range of 500 to 2000.
select * from sales.order_items
where list_price >= 500 and list_price <= 2000
order by list_price desc;

select * from sales.order_items
where list_price between 500 and 2000
order by list_price desc;


-- Find details of customers whose lives in state NY or CA.
select * from sales.customers
where state = 'NY' or state = 'CA';

select * from sales.customers
where state In ('NY', 'CA');


-- Find details of customers who lives in state CA and city Campbell.
select
	*
from sales.customers
where state = 'CA' and city = 'Campbell';

-- Like
-- Wildcards (%, _)
select * from production.products;

-- Find details of products whose name starts with letter S.
select * from production.products where product_name like 'S%';

-- Find details of products whose name must consist of digit 2018.
select * from production.products where product_name like '%2018%';

-- Find detials of products whose name must start with letter T and its first word must consis of 
-- 4 letters in total which ends with letter k.

select * from production.products where product_name like 'T__k%';




select top 5
	* 
from sales.order_items
where list_price >= 500 and list_price <= 2000
order by 5;

--MySQL/PgSQL -> limit
--Oracle -> offset and Fetch
--MSSQL Server -> Top

select
	order_id, item_id, product_id, quantity, list_price, discount,
	(list_price * quantity) as total_price
from sales.order_items
order by total_price desc;

--DBMS
-------
--Relational Algebra

--Projection(pie)     Join(x)     Selection(sigma)

-- From, Join, Where, Group by, Having, Select, order by, Top/Limit

--Substring
-- Substring(column_name, starting point, no_of_letters)

-- Extracting letters from texts or digits.

-- Extract 3 letters from first name starting from 2nd letter.
select
	first_name, SUBSTRING(first_name, 2, 3) as extracted_text
from sales.customers;


select
	last_name, SUBSTRING(last_name, 1, 3) as first_3_letters
from sales.customers;

-- Left and Right
-- Left / Right (column_name, no_of_letters)

select
	last_name, RIGHT(last_name, 3) as last_3_letters
from sales.customers;

select
	last_name, LEFT(last_name, 3) as first_3_letters_left,
	SUBSTRING(last_name, 1, 3) as first_3_letters_sub
from sales.customers;


--concat
-- Concat() function / Concat Operator (+)
select
	CONCAT(first_name, ' ', last_name) as full_name
from sales.customers;


select
	first_name + ' ' + last_name as full_name
from sales.customers;


select
	CONCAT(product_name, '-----', list_price) as pp
from production.products;

select
	product_name + '------------' + list_price as pp
from production.products;



--date function
select
	order_date,
	-- SSMS / Powerbi / Tableau / Excel / Googlesheet
	YEAR(order_date) as order_year,
	MONTH(order_date) as order_month,
	DAY(order_date) as order_day,

	-- SSMS / Tableau
	DATENAME(MONTH, order_date) as month_name,
	DATENAME(WEEKDAY, order_date) as day_name,

	-- SSMS / Powerbi
	FORMAT(order_date, 'MMMM') as month_format,
	FORMAT(order_date, 'dddd') as day_format
from sales.orders;

-- Is null function is used to fill null values in sql
select
	GETDATE(),
	order_date,
	shipped_date,
	ISNULL(shipped_date, GETDATE()),
	DATEDIFF(Month, order_date, ISNULL(shipped_date, GETDATE()))
from sales.orders;

-- To find null values data
select
	*
from sales.customers
where phone is null;

-- To find data except null values.
select
	*
from sales.customers
where phone is not null;

select
	*
from sales.customers
where phone != '';

select * from sales.customers where phone <> '';


-- SQL Case
/*
Case
	When Condition then ''
	When condition then ''
	When condition then ''
End
*/

select
	order_id, customer_id, order_date, required_date, shipped_date, order_status,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	Case
		When order_status = 1 then 'Pending'
		When order_status = 2 then 'Processing'
		When order_status = 3 then 'Rejected'
		When order_status = 4 then 'Completed'
		Else 'Invalid Value'
	End as status_label,
	DateDiff(day, order_date, shipped_date) as total_days_to_deliver
from sales.orders
where order_status = 4;


/*
	Find total price spent by customers in orders and
	label those price as Low Spent if price < 6000
	Average Spent if spent price is in range of 6000 to 15000
	High Price if spent price more than 15000
*/

select
	order_id, item_id, product_id, quantity, list_price, discount,
	((quantity * list_price) * (1 - discount)) as total_price,
	((quantity * list_price) - ((quantity * list_price) * discount)) as tp,
	CASE
		When ((quantity * list_price) * (1 - discount)) < 6000 then 'Low Spent'
		When ((quantity * list_price) * (1 - discount)) >= 6000 and ((quantity * list_price) * (1 - discount)) < 15000 then 'Average Spent'
		When ((quantity * list_price) * (1 - discount)) >= 15000 then 'High Spent'
	End as price_label
from sales.order_items;





select
	*
from sales.customers;


--concat, substring, left, right

--id-first_name(2, 4)-last_name(1, 3)-email(5, 5)-street(2, 2)-city(last 4 letters)-state-zipcode(2, 2)

select
	CONCAT(
		customer_id, '-', SUBSTRING(first_name, 2, 4), '-', LEFT(last_name, 3), '-', SUBSTRING(email, 5, 5),
		'-', SUBSTRING(street, 2, 2), '-', RIGHT(city, 4), '-', state, '-', SUBSTRING(zip_code, 2, 2)
	) as main_id, first_name, last_name, email, phone, city, zip_code, state
from sales.customers;

-- UUID -> Universal Unique ID
-- GUID -> Global Unique ID

select
	Count(customer_id) as total_customers,
	Case
		When order_status = 1 then 'Pending'
		When order_status = 2 then 'Processing'
		When order_status = 3 then 'Rejected'
		When order_status = 4 then 'Completed'
		Else 'Invalid Value'
	End as status_label
from sales.orders
group by 
Case
		When order_status = 1 then 'Pending'
		When order_status = 2 then 'Processing'
		When order_status = 3 then 'Rejected'
		When order_status = 4 then 'Completed'
		Else 'Invalid Value'
	End;


select
	customer_id,
	sum(case when order_status = 1 then 1 else 0 end) as total_pending,
	sum(case when order_status = 2 then 1 else 0 end) as total_processing,
	sum(case when order_status = 3 then 1 else 0 end) as total_rejected,
	sum(case when order_status = 4 then 1 else 0 end) as total_completed
from sales.orders
group by customer_id
having sum(case when order_status = 1 then 1 else 0 end) > 0;


--2. Product Category Stock Evaluation Write a query using the products table to group items by 
--their category ID. Use a CASE expression to count how many products in each category are 
--'Expensive' (price over $2,000). Filter your final results using a HAVING clause to only show 
--category IDs that have more than 5 expensive products.

select
	category_id,
	sum(case when list_price > 2000 then 1 else 0 end) as total_expensive
from production.products
group by category_id;

select
	*
from production.products
where category_id = 4 and list_price > 2000;