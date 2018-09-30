use hotel;
go
--
DROP TABLE Customer;

-- Storing XML data in table
DECLARE @Doc int
DECLARE @XmlDoc nvarchar(1000)
SET @XmlDoc = N'
<ROOT>
	<Customer CustId="JH01" Name="John Ketter">
		<Order OrdId="1001" CustId="JH01" OrdDate="2018-09-29">
			
			<OrdDetail ProdId="11" Qty="12"/>
			<OrdDetail ProdId="22" Qty="10"/>
		</Order>
	</Customer>
	<Customer CustId="SG01" Name="Steve Gonzlez">
		<Order OrdId="1002" CustId="SG01" OrdDate="2017-09-29">
			
			<OrdDetail ProdId="32" Qty="5"/>
		</Order>
	</Customer>
</ROOT>
'
EXEC sp_xml_preparedocument @Doc OUTPUT, @XmlDoc

-- Retrieving data from xml 
SELECT * INTO Customer
FROM OPENXML(@Doc, '/ROOT/Customer/Order/OrdDetail',1)
WITH (CustId varchar(10) '../../@CustId', 
	Name varchar(20) '../../@Name',
	OrdId int '../@OrdId', 
	OrdDate DateTime '../@OrdDate',
	ProdId int '@ProdId', Qty int '@Qty')

EXEC sp_xml_removedocument @Doc

SELECT * from Customer;

-- Storing XML data in xml type column 
CREATE TABLE Data
(
	DataId int,
	Descr XML
)

INSERT INTO Data VALUES(101, convert(xml,'<Detail><data name="Abc" Qty = "12"/></Detail>'))
Select * from Data;

-- Retrieving Table data in XML format

SELECT EmployeeId, ContactId, LoginId, Title
FROM HumanResources.Employee
WHERE EmployeeId = 1 OR EmployeeId = 2
FOR XML RAW

-- RAW with Elements
SELECT EmployeeId, ContactId, LoginId, Title
FROM HumanResources.Employee
WHERE EmployeeId = 1 OR EmployeeId = 2
FOR XML RAW, ELEMENTS

-- RAW with elements and XMLSchema
SELECT EmployeeId, ContactId, LoginId, Title
FROM HumanResources.Employee
WHERE EmployeeId = 1 OR EmployeeId = 2
FOR XML RAW, ELEMENTS XSINIL

--AUTO With ELEMENTS
SELECT EmployeeId, ContactId, LoginId, Title
FROM HumanResources.Employee
WHERE EmployeeId = 1 OR EmployeeId = 2
FOR XML AUTO, ELEMENTS

-- PATH MODE
SELECT EmployeeId "@EmpID",
	FirstName "EmpName/First",
	MiddleName "EmpName/Middle",
	LastName "EmpName/Last"
FROM HumanResources.Employee e
JOIN Person.Contact c 
ON e.ContactId = c.ContactId
FOR XML PATH('Employee')

-- EXPLICIT MODE
SELECT 1 AS Tag,
	NULL AS Parent,
	ProductID AS [Product!1!ProductID],
	Name AS [Product!1!ProductName!element],
	Color AS [Product!1!Color!elementxsinil]
FROM Production.Product
WHERE ProductID = 1 OR ProductID = 317
FOR XML EXPLICIT

-- XML Namespaces 
WITH XMLNAMESPACES ('http://www.niit.com' AS nt)
SELECT EmployeeId AS 'nt:EMPID',
ContactId AS 'nt:ContactId',
Title AS 'nt:Title'
FROM HumanResources.Employee Employee
FOR XML RAW ('nt:Employee'), ELEMENTS

-- Modifying XML DATA
-- INSERT
UPDATE CustomDetails SET Cust_Details.modify('
insert attribute Type{"Credit"} as First 
into (/Customer)[1]')

--REPLACE
UPDATE CustomDetails SET Cust_Details.modify('
replace value of(Customer/@Type)[1] with "Cash"')
WHERE Cust_Id = 3;

--DELETE
UPDATE CustomDetails SET Cust_Details.modify('
delete(/Customer/@City)[1]')