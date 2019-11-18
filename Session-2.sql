use niit;

Select * from Department;

--String Functions
Select Emp_id, Name, len(name) as 'Length', left(name,3) as '3 Char',
REVERSE(name) as 'Reverse Name', UPPER(Name) as 'Upper Case' from Employee;

--Date Functions
Select Emp_id, Name, Joining_Date, DATEADD(mm,5,Joining_Date) as 'Termaniting Date'
from Employee;

Select Emp_Id, Name, Joining_Date, DATENAME(month,convert(date,Joining_Date)) as 'Month of Joining'
from Employee

--Maths Function
Select CEILING(15.789)
Select SQRT(256)
Select ROUND(14.1567,3)
Select POWER(2,5)

--Logical Functions
Select CHOOSE(2,'Lion','Tiger','Cheetah','Jaguar')
Select IIF(10>15,'10 is largest','15 is largest')

--Aggregate Functions
Select AVG(Salary) as 'Average' from Employee
Select MIN(Salary) as 'Minimum' from Employee
Select MAX(Salary) as 'Maximum' from Employee
Select SUM(Salary) as 'Total' from Employee
Select COUNT(Distinct Salary) as 'No of Salary' from Employee

--Group By Clause
Select SUM(Salary), Dept_Id 
from Employee
group by Dept_Id

Select EmpAddress, Dept_Id, AVG(Salary)
from Employee
Group By
GROUPING Sets
(
	(EmpAddress,Dept_Id),
	(EmpAddress),
	(Dept_Id)
)

Select SUM(Salary), Dept_Id 
from Employee
group by Dept_Id
having (MIN(Salary)>25000)

--Inner Join
Select e.Emp_Id, e.Name, e.EmpAddress, d.Dept_Name
from Employee e JOIN Department d
ON e.Dept_Id = d.Dept_Id

--Outer Join
Select e.Emp_Id, e.Name, e.EmpAddress, d.Dept_Name
from Employee e LEFT OUTER JOIN Department d
ON e.Dept_Id = d.Dept_Id

Select e.Emp_Id, e.Name, e.EmpAddress, d.Dept_Name
from Employee e RIGHT OUTER JOIN Department d
ON e.Dept_Id = d.Dept_Id

Select e.Emp_Id, e.Name, e.EmpAddress, d.Dept_Name
from Employee e FULL OUTER JOIN Department d
ON e.Dept_Id = d.Dept_Id

--Cross Join
Select e.Emp_Id, e.Name, e.EmpAddress, d.Dept_Name
from Employee e CROSS JOIN Department d

--Equi Join
Select * from 
Employee e JOIN Department d
ON e.Dept_Id = d.Dept_Id

--Self Join
Select e.Emp_Id, e.Name as 'Employee', e.Mgr_Id, m.Name as Manager
from Employee e JOIN Employee m
ON e.Mgr_Id = m.Emp_Id