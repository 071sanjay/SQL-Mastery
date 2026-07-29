-- SQL Case

/*
CASE
	when condition then ''
	when condition then ''
	when condition then ''
End

-- normal column where and used before group by
-- aggregate column having and used after group by

*/

select
	order_id, customer_id, order_date, required_date, shipped_date, order_status,

	Case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Complected'
		Else 'Invalid Value'
	End as status_label
from sales.orders
where order_status = 4;


select
	order_id, customer_id, order_date, required_date, shipped_date, order_status,

	Case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Complected'
		Else 'Invalid Value'
	End as status_label,
	DATEDIFF(day, order_date, shipped_date) as total_days_to_deliver
from sales.orders
where order_status = 4;

-- find total price spent by customers in orders and label those price as 
-- Low spent if price<6000, average spent if in range of 6000 to 15000
-- High price is spent price>15000

select
	order_id, item_id, product_id, quantity, list_price, discount,
	((quantity * list_price) * (1 - discount)) as total_price,
	((quantity * list_price) - ((quantity * list_price) * discount)) as tp,
	Case
		when ((quantity * list_price) * (1 - discount)) < 6000 then 'low spent'
		when ((quantity * list_price) * (1 - discount)) > 6000 and ((quantity * list_price) 
										* (1 - discount)) < 15000 then 'average spent'
		when ((quantity * list_price) * (1 - discount)) < 15000 then 'high spent'
	end as price_label
from sales.order_items
order by ((quantity * list_price) * (1 - discount)) asc;

select * from sales.customers;

-- id-first_name(2, 4)-last_name(1,3) -email(5,5) -street(2, 2) -city(last 4 letters) - state -zipcode(2, 2)
--concat, substring, left, right

select
	CONCAT(substring(first_name,2,4), ' ', substring(last_name,1,3),' ', substring(email,5,5),' ', substring(street,2,2),
	' ', right(city, 4),' ', state,' ', substring(zip_code,2,2)) as merged_column
from sales.customers;



--UUID -universal unique id
--GUID -global unique id

select
	Case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Complected'
		Else 'Invalid Value'
	End as status_label
from sales.orders
where order_status = 4;

select
	customer_id,
	sum(case when order_status = 1 then 1 else 0 end) as total_pending,
	sum(case when order_status = 2 then 1 else 0 end) as total_processing,
	sum(case when order_status = 3 then 1 else 0 end) as total_rejected,
	sum(case when order_status = 4 then 1 else 0 end) as total_completed
from sales.orders
group by customer_id;



-- 1. Product Price Categorization (CASE).
-- Categorize all bikes into three price tiers based on their list price:
-- "Budget" (Under $500), "Mid-Range" ($500 - $1500), and "Premium" (Over $1500).

select
	product_name, list_price,
		case
			when list_price < 500 then 'budget'
			when list_price > 500 and list_price < 15000 then 'mid-range'
			else 'premium' end as category
from production.products;


-- 2. Store Sales by Product Category (SUM + CASE).
-- Calculate the total order quantity for Mountain bikes versus Road bikes across all stores.
-- This uses conditional aggregation to pivot product categories into distinct columns.

select 
	st.store_name,
	sum(case when pc.category_name = 'Mountain bikes' then soi.quantity else 0 end) as mountain_bikes_sold,
	sum(case when pc.category_name = 'Road bikes' then soi.quantity else 0 end) as road_bikes_sold
from sales.stores st
join sales.orders so
on so.store_id = st.store_id
join sales.order_items soi
on soi.order_id = so.order_id
join production.products pp
on pp.product_id = soi.product_id
join production.categories pc
on pc.category_id = pp.category_id
group by st.store_name;


-- 3. Customer Discount Tiers (SUM + CASE).
-- Count how many orders had no discount, a small discount (1% to 10%),
-- or a high discount (over 10%) by customer.

SELECT
    sc.customer_id,
    COUNT(DISTINCT CASE WHEN soi.discount = 0 THEN so.order_id END) AS no_discount_orders,
    COUNT(DISTINCT CASE WHEN soi.discount >= 0.01 AND soi.discount <= 0.10 THEN so.order_id else 0 END) AS small_discount_orders,
    COUNT(DISTINCT CASE WHEN soi.discount > 0.10 THEN so.order_id else 0 END) AS high_discount_orders
FROM sales.customers sc
JOIN sales.orders so ON so.customer_id = sc.customer_id
JOIN sales.order_items soi ON soi.order_id = so.order_id
GROUP BY sc.customer_id;



