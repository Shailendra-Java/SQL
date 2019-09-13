-- Entity integrity: Ensures that each row can be uniquely identified by an attribute called the primary key.
-- Domain integrity: Ensures that only a valid range of values is stored in a column.
-- Referential integrity: Ensures that the values of the foreign key match the value of the corresponding primary key.
-- User-defined integrity: Refers to a set of rules specified by a user, which do not belong to the entity, domain, 
-- and referential integrity categories.
/*   
A constraint can be created by using either of the following statements:
 CREATE TABLE statement
 ALTER TABLE statement
*/
-- 1) Primary Key Constraint
CREATE TABLE Test.Project 
( 
  ProjectCode int CONSTRAINT pkProjectCode PRIMARY KEY, 
  ... 
)

-- 2) Unique Key Constraint
CREATE TABLE HumanResources.Project 
( 
  ProjectCode int CONSTRAINT pkProjectCode PRIMARY KEY, 
  Description varchar(50) CONSTRAINT unDesc UNIQUE, 
  ... 
)

-- 3) Foreign Key Constraint
CREATE TABLE Test.EmployeeLeave 
( 
  EmployeeID int CONSTRAINT fkEmployeeID REFERENCES Test.Employee(EmployeeID), 
  LeaveStartDate datetime CONSTRAINT cpkLeaveStartDate PRIMARY KEY(EmployeeID, LeaveStartDate), 
  ... 
)
-- ON DELETE | ON UPDATE NO ACTION: Can't delete or update primary key
-- ON DELETE | ON UPDATE CASCADE: If delete or update primary key, foreign key get auto update or delete
-- ON DELETE | ON UPDATE SET NULL: If delete or update primary key, foreign key is set to null
-- ON DELETE | ON UPDATE SET DEFAULT: If delete or update primary key, foreign key set to default value

ALTER TABLE Test.EmployeeLeave 
ADD CONSTRAINT rfkcEmployeeID FOREIGN KEY(EmployeeID) REFERENCES Test.Employee(EmployeeID)
ON DELETE NO ACTION ON UPDATE NO ACTION

-- 4) Check Constraint
CREATE TABLE HumanResources.Project 
(
  ........ ........ 
  StartDate datetime, 
  EndDate datetime, 
  Constraint chkDate CHECK (StartDate <= EndDate) 
)
-- IN
LeaveType char(2) CONSTRAINT chkLeave CHECK(LeaveType IN(‘CL’,‘SL’,‘PL’))
-- Like
DeptNo char(4) CHECK (DeptNo LIKE ‘[0-9][0-9][0-9][0-9]’)
-- Between
sal money CHECK (sal BETWEEN 20000 AND 80000)

-- 5) Default Constraint
CREATE TABLE HumanResources.EmployeeLeave 
( 
  ...... 
  LeaveType char(2) CONSTRAINT chLeave CHECK(LeaveType IN(‘CL’,‘SL’,‘PL’)) 
  CONSTRAINT chkDefLeave DEFAULT ‘PL’ 
)

-- Enabling and Disabling Constraints
ALTER TABLE Test.EmployeeLeave NOCHECK CONSTRAINT chkLeave
ALTER TABLE Test.EmployeeLeave CHECK CONSTRAINT chkLeave

-- Applying Rules
CREATE RULE ruleType AS @LeaveType IN (‘CL’, ‘SL’, ‘PL’)
-- Bind Rule
sp_bindrule ‘ruleType’,‘HumanResources.EmployeeLeave.LeaveType’
-- Unbind Rule
sp_unbindrule ‘HumanResources.EmployeeLeave.LeaveType’
-- Drop Rule
Drop Rule ruleType
