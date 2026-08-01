-- Group by and Having
-----------------------------
/*
Rules of Group by
-----------------------
1. If we use group by then must use aggregate functions with it.
2. If we only use aggregate function then group by is optional.
3. We can specify any column in group by if it exists in selected table.

Aggregate Functions
---------------------
-> avg, sum, count, min, max

-> Aggregate Column -> If aggregate function is used in column then that column is named as aggregate column.
-> Non-Aggregate Column -> If any aggregate functions is not used in columns then that column is named as non aggregate column. 


Rules of Having
-----------------
- used to filter data.
- Having is used after group by.
1. Only column which is specified in group by clause only those columns can be filterd by having clause.
2. Aggregate column data must be filtered using having clause. Cannot use where clause.
*/
-- Find total customers by each state and city where total customers more than 10.
select
	state, city, COUNT(customer_id) as total_customers
from sales.customers
group by state, city
having COUNT(customer_id) > 10;


-- Find those orders from customer order items details whose sum of total price is more than 10000.
select
	order_id, SUM(((quantity * list_price) * (1 - discount))) as total_price
from sales.order_items
group by order_id
having SUM(((quantity * list_price) * (1 - discount))) > 10000;




























