
-- group by and having

/* 
rules of group by
---------------------
1. if we use group by then must use aggregate functon with it
2. if we only use aggregate function then group by is optional


Aggregate functions
------------------------
-> avg, sum, count, min, max

-> aggregate column -> if aggregate function is used in column then that column is named as aggregate colum.
-> Non-aggregate column -> if not used


rules of having
-------------------
- used to filter data. 
- used after group by, where is used before groupby
1. only column which is specified in group by clause only those columns can be filtered by having clause.
2. aggregate column data must be filtered using having clause. cannot use where clause.

*/

--find total customers by each state.
use BikeStores;
select
	state, count(customer_id)
from sales.customers
group by state;			--here state is non aggregate column which must be grouped

select
	state, city, count(customer_id)  --here city is also non aggregate which must be grouped
from sales.customers
group by state, city;	

select
	state, count(customer_id)
from sales.customers
group by state, city;		-- can specify any column in group by if it exists in table

-- find total customers by each state and city where total customers more than 10.
select
	state, city, count(customer_id) as total_customers 
from sales.customers
-- where count(customer_id)>10, cant use this
group by state, city
having count(customer_id)>10;

-- find those order items from customer order items details whose sum of total_price is more than 10000
select
	order_id, sum((quantity*list_price) * (1-discount)) as total_price
from sales.order_items
group by order_id
having sum((quantity*list_price) * (1-discount))>1000;
	


/*
2. Product Category Stock Evaluation Write a query using the products table to group items by 
their category ID. Use a CASE expression to count how many products in each category are 
'Expensive' (price over $2,000). Filter your final results using a HAVING clause to only show 
category IDs that have more than 5 expensive products. 
*/

select
	category_id,
	sum(case when list_price > 2000 then 1 else 0 end) as total_expensive
from production.products
group by category_id;

					-- 5:15


/*
4. High-Value Item Density in Orders Write a query using the order items table to find out which 
unique orders contain a heavy amount of premium items. Group the rows by order_id. Use a CASE 
expression to calculate the total quantity of items in that order where the list_price is greater than 
$1,000. Display only the order IDs where the total quantity of these premium items is strictly 
greater than 3. 
*/

select
	order_id,
	sum(case when list_price > 1000 then 1 else 0 end) as total_quantity
from sales.order_items
group by order_id;

				-- 5:15

/*
1. Customer Base by Region.
Tier Write a query using the customers table to group customers by their state. Use a CASE expression within 
the SELECT and GROUP BY clauses to label 'NY' as 'East Coast', 'CA' as 'West Coast', and any other state as 
'Other Region'. Only display region groups that have a total customer count greater than 30. 
*/

select 
	count(customer_id) as total_customers, state,
	case
		when state = 'NY' then 'East Coast'
		when state = 'CA' then 'West Cosat'
		else 'Other Region'
		END as Region
from sales.customers
group by state
having count(customer_id)>30;



/*
3. Order Volume by Seasonal Quarters.
Write a query using the orders table to analyze order volumes based on when they were placed. Use a CASE 
expression to group the order_date values into 'First Half' (months January through June) and 'Second Half' 
(months July through December). Use a WHERE clause to only look at orders from the year 2018, and use a 
HAVING clause to only show halvesthat processed more than 200 orders.
*/




/*
5. Store Order Status Performance.
Write a query using the orders table to find stores that have an elevated number of unfulfilled requests.
Group the records by store_id. Filter the data first using a WHERE clause to only look at orders placed in 2018.
Then, use a CASE expression inside a HAVING clause to only display store IDs that have more than 15 orders marked 
with a status other than 'Shipped' (where order_status is not equal to 4).
*/



