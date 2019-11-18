--Fetching all record
select * from Employee;
--Fetching selected columns
select emp_id, name, salary from Employee;

--Customizing columns name
Select 'Employee ID' = emp_id, 'Employee Name' = name from Employee;
		--OR
Select emp_id 'Employee ID', name 'Employee Name' from Employee;
		--OR
Select emp_id as 'Employee ID', name as 'Employee Name' from Employee;

--Add literals 
Select Emp_id, name, ' Earns ' as 'Per Month Income', Salary from Employee

--Concatnating two columns
Select Emp_Id, name+' - '+Email_Id as 'Name & Email' from Employee

Select Emp_Id, name+' have this ID >>'+Email_Id+'<< for communication ' as Communication from Employee

--Apply Arithmetic Operators
Select Emp_Id, Name, Salary as 'Per Month', Salary*12 as 'Anual', Salary/30 as 'Per Day',
Salary/240 as 'Per Hour' from Employee

--Fetching Conditional Record
Select * from Employee
where Salary < 30000

Select * from Employee
where Salary < 30000 OR Dept_Id = 301

--Range Operator
Select * from Employee
where Salary BETWEEN 20000 AND 40000

Select * from Employee
where Salary NOT BETWEEN 20000 AND 40000

--IN Operator
Select * from Employee
where Dept_Id IN(201,401,101)

Select * from Employee
where Dept_Id NOT IN(201,401,101)

--Like Operator
Select * from Employee
where name like 'Al%'

Select * from Employee
where name like '%y'

Select * from Employee
where name like '%a%'

Select * from Employee
where name like '_[^a-f]%'

-- Retrieving records which have NULL value
Select * from Employee
where Dept_Id IS NULL

-- Replace NULL value
Select Emp_Id, Name, Salary, ISNULL(Salary,0.0) as 'Updated Salary'
from Employee

--Coalesce Funsction
Select USERID, FIRSTNAME, ADDRESS, Coalesce(PHONE,Landline) as Contact from Student

--Order by clause
Select * from Employee
order by Emp_Id, Mgr_Id desc

--TOP keyword
Select top 2 * from Employee
where Salary>30000
order by Name

--Offset-Fetch clause
Select * from Employee
Order By Name
Offset 3 rows

Select * from Employee
Order By Name
Offset 3 rows fetch next 3 rows only

--Distinct Keyword
Select Distinct Email_Id from Employee


