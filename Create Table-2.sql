-- SPARSE it would require lesser space as compared to regular column

CREATE TABLE Ord_Det 
( 
  OrderID int, 
  OrderDate datetime, 
  OrderCost money, 
  OrderRetDate datetime SPARSE NULL 
)

-- UNIQUEIDENTIFIER ROWGUIDCOL

CREATE TABLE EmpDetails 
( 
  EmployeeID UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE, 
  EmployeeName varchar(30), 
  EmployeeAddress varchar(100), 
  EmployeeDept varchar(20), 
  EmployeePhoto VARBINARY(MAX) FILESTREAM 
)

/*In the preceding statements, the EmployeeID column is declared as UNIQUEIDENTIFIER ROWGUIDCOL, which uniquely identifies the records in 
  the table across the databases. The values of the column set with the FILESTREAM attribute are stored in the Windows file system. 
  Therefore, you must declare a column as UNIQUEIDENTIFIER ROWGUID while creating a table that stores the FILESTREAM data.*/
