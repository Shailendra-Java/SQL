--Sub-Queries
Select * from Employee
where Salary < (Select Salary from Employee where name = 'Katty')

--IN with sub-query
Select * from Employee
where Dept_Id IN (Select Distinct Dept_Id from Employee where EmpAddress like '%a%')

--Exists with sub-query
Select * from Employee
where Exists (Select name from Employee where Dept_Id = 401)

--ALL & ANY keywords
Select * from Employee
where Salary >ALL (Select Salary from Employee where name like '%t%')

Select * from Employee
where Salary >ANY (Select Salary from Employee where name like '%t%')

Select * from Employee
where Salary <>ALL (Select Salary from Employee where name like '%t%')

Select * from Employee
where Salary <>ANY (Select Salary from Employee where name like '%t%')

--Aggregate Function using sub-query
Select * from Employee
where Salary > (Select AVG(Salary) from Employee where Dept_Id=201)

--Inner Query whithin another sub-query
Select * from Employee
where Emp_Id IN (Select Emp_Id from Employee 
				where Dept_Id = (Select Dept_Id from Employee where Joining_Date IS NOT NULL))

--Correlated Sub Query
Select * from Employee e
where Salary IN (Select Salary from Employee where Dept_Id = e.Dept_Id)