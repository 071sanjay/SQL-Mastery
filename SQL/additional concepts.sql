-- synonym

create synonym our_customers for sales.customers;

select * from our.customers;

-- view
create view customer_details as 
select concat(first_name, ' ', last_name) as customer_name
from sales.customers;

select * from customer_details;


-- stored procedure
--create procedure 

create procedure sp_customers as
select concat(first_name, ' ', last_name) as customer_name
from sales.customers;

exec sp_customers;


create procedure sp_customers_det(@state as varchar(200)) 
as
begin
select concat(first_name, ' ', last_name) as customer_name
from sales.customers where state = @state
end;

exec sp_customers_det 'NY';

select * from sales.customers where state = 'NY';


/*
-- acid properties

1. atomicity

2. consistency

3. isolation

4. durabitily

*/


-- learn more from sql server website