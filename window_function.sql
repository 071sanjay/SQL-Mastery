/*
	Window Functions
	------------------
*/

select * from dbo.[HR_Dataset Refresh];

--1. Row Number
-- Checking Duplicate Record
select * from (
	select
		EmpId, Employee_Name, Department, Salary, ManagerName, EmploymentStatus,
		ROW_NUMBER() Over(partition by EmpId order by salary) as rn
	from dbo.[HR_Dataset Refresh]
) as data
where rn > 1;

-- Deleteing Duplicate Record
with emp_duplicate as (
	select
		EmpId, Employee_Name, Department, Salary, ManagerName, EmploymentStatus,
		ROW_NUMBER() Over(partition by EmpId order by salary) as rn
	from dbo.[HR_Dataset Refresh]
) delete from emp_duplicate where rn > 1;

select
	EmpId, Employee_Name, Department, Salary, ManagerName, EmploymentStatus,
	ROW_NUMBER() Over(partition by EmpId order by salary) as rn
from dbo.[HR_Dataset Refresh];


-- Rank
select
	EmpId, Employee_Name, Department, Salary,
	Rank() Over(order by Department) as rn
from dbo.[HR_Dataset Refresh];

-- Dense Rank
select
	EmpId, Employee_Name, Department, Salary,
	Dense_Rank() Over(order by Department) as rn
from dbo.[HR_Dataset Refresh];

select * from (
	select
		EmpId, Employee_Name, Department, Salary,
		Dense_Rank() Over(order by Salary desc) as rn
	from dbo.[HR_Dataset Refresh]
) as data
where rn = 10;

--select * from production.products where list_price = (
--	select max(list_price) from production.products where list_price < (
--		select
--			max(list_price)
--		from production.products
--	)
--);

--select * from (
--	select
--		*, DENSE_RANK() Over(order by list_price desc) as rn
--	from production.products
--) as price_data
--where rn = 3;

-- NTile, Lead, Lag

with salary_label as (
	select
		EmpId, Employee_Name, Department, Salary,
		NTILE(3) Over(order by salary desc) as ntile_number
	from dbo.[HR_Dataset Refresh]
)select
	EmpId, Employee_Name, Department, Salary,
	case
		when ntile_number = 1 then 'High Salary'
		when ntile_number = 2 then 'Average Salary'
		when ntile_number = 3 then 'Low Salary'
	End as salary_label
from salary_label;

-- Lead (Next Value)
select
	EmpId, Employee_Name, Department, Salary,
	LEAD(Employee_Name,2) Over(order by salary) emp_name
from dbo.[HR_Dataset Refresh];


-- Lag (Previous Value)
select
	EmpId, Employee_Name, Department, Salary,
	Lag(Employee_Name) Over(order by salary) emp_name
from dbo.[HR_Dataset Refresh];




select
	EmpId, Employee_Name, Department, Salary,
	AVG(Salary) Over(order by salary) as cumi_salary
from dbo.[HR_Dataset Refresh];

select
	EmpId, Employee_Name, Department, Salary,
	SUM(Salary) Over(partition by department order by salary) as cumi_salary
from dbo.[HR_Dataset Refresh];

select
	department, sum(salary) as total_salary
from dbo.[HR_Dataset Refresh]
group by Department;