
/*
window functions
--------------------
1. row number
2. rank
3. dense rank
4. Ntile
5. Lead
6. lag
7. Cumilative Sum / Avg

	partition by -> advanced group by

	select
		column_names, window_function() over(partition by column_name order_ny column_name)
	from table_name;

*/

/*
select
	state, count(customer_id) as total_customers
from sales.customers group by state;


select
	customer_id, first_name, last_name, email, street, city, state, zip_code,
	row_number() over(partition by city order by state desc) as rn
from sales.customers;

*/

select * from dbo.[HR_Dataset Refresh];

-- 1.row number

-- checking duplicates record

select * from (
	select 
		EmpID, Employee_Name, Department, Salary, ManagerName, EmploymentStatus,
		ROW_NUMBER() over(partition by empid order by salary) as rn
	from dbo.[HR_Dataset Refresh]
) as data
where rn > 1;

-- now remove those duplicates data
with emp_duplicate as (
	select 
		EmpID, Employee_Name, Department, Salary, ManagerName, EmploymentStatus,
		ROW_NUMBER() over(partition by empid order by salary) as rn
	from dbo.[HR_Dataset Refresh]
) delete from emp_duplicate where rn > 1;

select 
	EmpID, Employee_Name, Department, Salary, ManagerName, EmploymentStatus,
	ROW_NUMBER() over(partition by empid order by salary) as rn
from dbo.[HR_Dataset Refresh];


-- analyze the difference here,
select
	EmpID, Employee_Name, Department, Salary, ManagerName, EmploymentStatus, count(empid)
from dbo.[HR_Dataset Refresh]
group by EmpID, Employee_Name, Department, Salary, ManagerName, EmploymentStatus;


--2. Rank
select
	empid, employee_name, department, salary,
	rank() over(order by department) as rn
from dbo.[HR_Dataset Refresh];

--3. Dense Rank\(no. of departments)
select
	empid, employee_name, department, salary,
	dense_rank() over(order by department) as rn
from dbo.[HR_Dataset Refresh];   

-- to find second highest salary

select * from(
	select
		empid, employee_name, department, salary,
		dense_rank() over(order by department) as rn
	from dbo.[HR_Dataset Refresh]
) as data
where rn = 2;

-- from bikesotres to find third highest 
--  without dense rank




-- 4. Ntile, lead, lag
--  salary divided into 3 category : (high, medium and low)
select
	EmpID, Employee_Name, Department, salary,
	NTILE(3) over (order by salary desc) as ntile_number
from dbo.[HR_Dataset Refresh];


-- add salary_label 
with salary_label as (
	select
		EmpID, Employee_Name, Department, salary,
		NTILE(3) over (order by salary desc) as ntile_number
	from dbo.[HR_Dataset Refresh]
)select
	EmpID, Employee_Name, Department, salary,
	case
		when ntile_number = 1 then 'high salary'
		when ntile_number = 2 then 'average salary'
		else 'low salary' end as salary_label
	from salary_label;


-- 5. lead(next value)
select
	EmpID, Employee_Name, Department, salary,
	lead(employee_name) over(order by salary) emp_name
from dbo.[HR_Dataset Refresh];

select
	EmpID, Employee_Name, Department, salary,
	lead(employee_name, 2) over(order by salary) emp_name --change in employee name, 3rd row emp_name comes here
from dbo.[HR_Dataset Refresh];


-- 6. lag(previous value)

select
	EmpID, Employee_Name, Department, salary,
	lag(employee_name) over(order by salary) emp_name
from dbo.[HR_Dataset Refresh];

select
	EmpID, Employee_Name, Department, salary,
	lag(employee_name, 2) over(order by salary) emp_name --change in employee name
from dbo.[HR_Dataset Refresh];


-- cumulative value(fibonachi)

select
	EmpID, Employee_Name, Department, salary,
	sum(salary) over(order by salary) cumi_salary
from dbo.[HR_Dataset Refresh];


select
	EmpID, Employee_Name, Department, salary,
	avg(salary) over(order by salary) cumi_salary
from dbo.[HR_Dataset Refresh];

-- department wise salary distribution
select
	EmpID, Employee_Name, Department, salary,
	sum(salary) over(partition by department order by salary) cumi_salary
from dbo.[HR_Dataset Refresh];






