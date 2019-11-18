--Derived Tables OR Virtual Tables OR Temp. Table
Select T1.ProductId, TotalQuantityOrdered, TotalSalesOrderPlaced
from (Select ProductId, sum(OrderQty) as TotalQuantityOrdered
from Sales.SalesOrderDetail
group by ProductId) as T1
INNER JOIN
(Select ProductId, sum(OrderQty) as TotalSalesOrderPlaced
from Sales.SalesOrderDetail
group by ProductID, SalesOrderID) as T2
ON T1.ProductId = T2.ProductId

--DDL Statements
--Create Database Statements
Create Database StudentDB

--Create Schema
Create Schema std

--Create Table Statement
Create Table std.Student
(
	StdID int identity(100,2) primary key,
	Name varchar(20) not null,
	Email varchar(35),
	Marks int default 0.0,
	fee money check (fee > 2000)
)

Create Table std.Course
(
	CID int identity(1000,5) Constraint PK_CID primary Key,
	Name varchar(20) not null,
	Duration varchar(10),
	Fee money default 0.0
)


--Modify Table & add Constraints
Alter table std.Student add Constraint UK_Email unique(Email)
Alter table std.Student add CID int

Alter Table std.Student add Constraint FK_CID Foreign Key(CID)
references std.Course(CID)
ON DELETE CASCADE
ON UPDATE CASCADE

--Disabling OR Enable Constraints
ALTER TABLE std.Student NOCHECK CONSTRAINT CK__Student__fee__117F9D94
ALTER TABLE std.Student CHECK CONSTRAINT CK__Student__fee__117F9D94

--Droping Constraint
Alter Table std.Student
drop Constraint	CK__Student__fee__117F9D94


--Create Rules
Create Rule Crs_Dur 
as @Crs_Dur IN('2 Months','3 Months','6 Months','1 Year')

--Apply Rule on Table Attribute
sp_bindrule 'Crs_Dur','std.Course.Duration'

--Define User-Defined Data Type
Create Type CRDECRP
from varchar(250) Not Null

--Apply User-Define Type
Alter table std.Course add Course_Desp CRDECRP

--Create Synonyms for Student Table
Create Synonym StdRep
for std.Student

Select * from StdRep

--Rename a table
sp_rename std.Course, std.CourseDetail

--Droping a table
Drop table std.Student