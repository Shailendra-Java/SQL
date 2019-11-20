--DML Statements (INSERT, UPDATE, DELETE)
Insert into std.Course(Name,Duration,Fee,Course_Desp)
values('Java Programming','2 Months',4500,'This course cover all core concepts')

Insert into std.Course(Name,Duration,Fee,Course_Desp)
values('SQL Programming','3 Months',6500,'This course cover all SQL Statements')

Insert into std.Course(Name,Duration,Fee,Course_Desp)
values('Web Development','1 Year',9500,'It includes HTML, CSS, JS, Angularjs')

Insert into std.Course(Name,Duration,Fee,Course_Desp)
values('Android Development','6 Months',8500,'It includes all API regarding mobile app')

Insert into std.Student(Name,Email,Fee,Marks,CID)
values('Neha','nh@yahoo.com',10800,85,1020)
go


--Update Statement
update std.Student set Marks = 79 where StdID=108

Update std.Student set Marks=78, fee=12000 where StdID=110

--Delete Statement
Delete from std.Course where CID = 1020

Select * from std.Student
Select * from std.Course

--Create View
Create view vStudent as
Select s.StdID, s.name, s.marks, c.name as 'Course', c.Duration, c.Fee*3 as 'Complete Course Fee'
from std.Student s JOIN std.Course c
ON s.CID = c.CID

--Management of views
Alter view vStudent As
Select s.StdID, s.name, s.marks, c.name as 'Course', c.Duration, c.Fee*3 as 'Complete Course Fee'
from std.Student s JOIN std.Course c
ON s.CID = c.CID
where s.Marks >= 80

--Rename a View
sp_rename vStudent, vStudentDetail

--Dropping a View
Drop view vStudentDetail

--Schemabind with view
Alter View vStudentDetail
WITH Schemabinding AS
Select s.StdID, s.name, s.marks, c.name as 'Course', c.Duration, c.Fee*3 as 'Complete Course Fee'
from std.Student s JOIN std.Course c
ON s.CID = c.CID
where s.Marks >= 80

--Index on View
CREATE UNIQUE CLUSTERED INDEX idx_vStudent
ON vStudentDetail(StdId)

--Variable in Batch
Declare @Amount int
Select @Amount = Fee
from std.Course where CID = 1000
Print 'Your fee is : '+convert(varchar(5),@Amount)
go
