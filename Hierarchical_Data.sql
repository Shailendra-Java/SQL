-- Store XML data in rowset 
DECLARE @Doc int
DECLARE @XMLDoc nvarchar(1000)
SET @XMLDoc = N'<ROOT>
<Customer CustomerID="JH01" ContactName="John Henriot">
  <Order OrderID="1001" CustomerID="JH01">
      <OrderDate="2006-07-04T00:00:00">
    <OrderDetail ProductID="11" Quantity="12"/>
    <OrderDetail ProductID="22" Quantity="10"/>
  </Order>
</Customer>
<Customer CustomerID="SG01" ContactName="Steve Gonzlez">
    <Order OrderID="1002" CustomerID="SG01">
      OrderDate="2006-08-16T00:00:00">
    <OrderDetail ProductID="32" Quantity="3"/>
  </Order>
 </Customer>
</ROOT>'

--1.  Create an internal representation of the XML document by executing the following statement:
EXEC sp_xml_preparedocument @Doc OUTPUT, @XMLDoc

--2.	Execute the following statement to store the data in a table, CustomerDetails by using the OPENXML function:
SELECT * INTO CustomerDetails
FROM OPENXML (@Doc, '/ROOT/Customer', 1)
    WITH (CustomerID varchar(10),
      ContactName varchar(20))
      
 --3.	Remove the internal tree from the memory by executing the following statement:
EXEC sp_xml_removedocument @Doc

-- OR We can also copy data like this

DECLARE @Doc int
DECLARE @XMLDoc nvarchar(1000)
SET @XMLDoc = N'<ROOT>
<Customer CustomerID="JH01" ContactName="John Henriot">
<Order OrderID="1001" CustomerID="JH01">
     <OrderDate="2006-07-04T00:00:00">
     <OrderDetail ProductID="11" Quantity="12"/>
     <OrderDetail ProductID="22" Quantity="10"/>
   </Order>
</Customer>
<Customer CustomerID="SG01" ContactName="Steve Gonzlez">
<Order OrderID="1002" CustomerID="SG01">
     OrderDate="2006-08-16T00:00:00">
     <OrderDetail ProductID="32" Quantity="3"/>
</Order>
</Customer>
</ROOT>'
EXEC sp_xml_preparedocument @Doc OUTPUT, @XMLDoc
SELECT *
FROM OPENXML (@Doc, '/ROOT/Customer/Order/OrderDetail',1)
  WITH (CustomerID varchar(10) '../../@CustomerID',
    ContactName varchar(20) '../../@ContactName',
      OrderID int '../@OrderID',
      OrderDate datetime '../@OrderDate',
      ProdID int '@ProductID',
      Quantity int)
EXEC sp_xml_removedocument @Doc


-- Importing XML data into SQL Server

OPENROWSET( BULK,'file-name',Encoding-Scheme)

/*where:
BULK:- keyword to be used for bulk import.
'file-name':- name of the XML file to be imported.
Encoding-Scheme:- scheme to be used. SINGLE_BLOB, if provided as the encoding scheme, 
ensures that the XML parser in SQL Server imports the data according to the encoding scheme specified in the XML declaration.*/

-- Save it to drive in computer with Student.xml name
<Students>
<Student>
   <SID>1</SID>
   <Marks>70</Marks>
   <Grade>B</Grade>
</Student>
<Student>
   <SID>2</SID>
   <Marks>80</Marks>
   <Grade>A</Grade>
  </Student>
</Students>

CREATE TABLE STUDENTS(SID int PRIMARY KEY, Marks int, Grade varchar(5))

INSERT INTO STUDENTS(SID,Marks,Grade)
SELECT x.Stud.QUERY('SID').VALUE('.', 'INT'),
x.Stud.QUERY('Marks').VALUE('.', 'INT'),
x.Stud.QUERY('Grade').VALUE('.', 'VARCHAR(5)')
FROM
(SELECT CAST(x AS XML)FROM OPENROWSET(BULK 'd:\Students.xml',SINGLE_BLOB)AS T(x))
AS T(x)CROSS APPLY x.nodes('Students/Student') AS X(Stud);


--Storing XML Data in XML Columns
CREATE TABLE CustDetails
(
CUST_ID int,
CUST_DETAILS XML
)

INSERT INTO CustDetails VALUES (2, '<Customer Name="Abrahim Jones" City="Selina" />')
INSERT INTO CustDetails VALUES(2, convert(XML,'<Customer Name="Abrahim Jones" City="Selina" />'))
INSERT INTO CustDetails VALUES(4, cast('<Customer Name="Abrahim Jones" City="Selina" />' as XML))


--Storing Typed XML Data
CREATE XML SCHEMA COLLECTION <Name> as Expression

/*
Name specifies an identifier name with which SQL Server will identify the schema collection.
Expression specifies an XML value that contains one or more XML schema documents.
*/

--customer details are associated with the following schema
<schema xmlns="http://www.w3.org/2001/XMLSchema">
   <element name="CustomerName" type="string"/>
   <element name="City" type="string"/>
</schema>'

--following statement to register the preceding schema with the database
CREATE XML SCHEMA COLLECTION CustomerSchemaCollection AS
'<schema xmlns="http://www.w3.org/2001/XMLSchema">
   <element name="CustomerName" type="string"/>
   <element name="City" type="string"/>
</schema>'

--use the schemas to validate typed XML values while inserting records into the tables
CREATE TABLE Customer_Details
(
CustID int,
CustDetail XML (CustomerSchemaCollection)
)

INSERT INTO Customer_Details
VALUES(2,'<CustomerName>Abrahim Jones</CustomerName><City>Selina</City>')

-- Will throw error
INSERT INTO Customer_Details
VALUES(2,'<Name>John</Name><City>New York</City>')


--Retrieving Table Data into XML Format
--Using the FOR XML Clause in the SELECT Statement
o	RAW
o	AUTO
o	PATH
o	EXPLICIT

/*
  Using the RAW Mode
The RAW mode is used to return an XML file with each row representing an XML element. The RAW mode transforms each row 
in the query result set into an XML element with the element name, row. Each column value that is not NULL is mapped 
to an attribute with the same name as the column name.
*/

SELECT EmployeeID, ContactID, LoginID, Title
FROM HumanResources.Employee
WHERE EmployeeID=1 OR EmployeeID=2
FOR XML RAW

--Output
<row EmployeeID="1" ContactID="1209" Loginid="adventure-works\guy1" Title="Production Technician - WC60" />
<row EmployeeID="2" ContactID="1030" Loginid="adventure-works\kevin0" Title="Marketing Assistant" />

/*If the ELEMENTS directive is specified with the FOR XML clause, each column value is mapped to a subelement of the <row> 
element, as shown in the following query:*/

SELECT EmployeeID, ContactID, LoginID, Title
FROM HumanResources.Employee
WHERE EmployeeID=1 OR EmployeeID=2
FOR XML RAW, ELEMENTS

--Output
<row>
  <EmployeeID>1</EmployeeID>
  <ContactID>1209</ContactID>
  <LoginID>adventure-works\guy1</LoginID>
  <Title>Production Technician - WC60</Title>
</row>
<row>
  <EmployeeID>2</EmployeeID>
  <ContactID>1030</ContactID>
  <LoginID>adventure-works\kevin0</LoginID>
  <Title>Marketing Assistant</Title>
</row>

--XSINIL
SELECT ProductID, Name, Color
FROM Production.Product Product
WHERE ProductID = 1 OR ProductID = 317
FOR XML RAW, ELEMENTS XSINIL

--Output
<row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>1</ProductID>
  <Name>Adjustable Race</Name>
  <Color xsi:nil="true" />
</row>
<row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>317</ProductID>
  <Name>LL Crankarm</Name>
  <Color>Black</Color>
</row>

/*
Using the AUTO Mode
The AUTO mode is used to return query results as nested XML elements. Similar to the RAW mode, each column value that is not NULL 
is mapped to an attribute that is named after either the column name or the column alias. The element that these attributes belong 
to is named to the table that they belong to or to the table alias that is used in the SELECT statement, as shown in the following query:
/*
SELECT EmployeeID, ContactID, LoginID, Title
FROM HumanResources.Employee Employee
WHERE EmployeeID=1 OR EmployeeID=2
FOR XML AUTO

--Output
<Employee EmployeeID="1" ContactID="1209" Loginid="adventure works\guy1" Title="Production Technician - WC60" />
<Employee EmployeeID="2" ContactID="1030" Loginid="adventure-works\kevin0" Title="Marketing Assistant" />

SELECT EmployeeID, ContactID, LoginID, Title
FROM HumanResources.Employee Employee
WHERE EmployeeID=1 OR EmployeeID=2
FOR XML AUTO, ELEMENTS

--Output
<Employee>
  <EmployeeID>1</EmployeeID>
  <ContactID>1209</ContactID>
  <LoginID>adventure-works\guy1</LoginID>
  <Title>Production Technician - WC60</Title>
</Employee>
<Employee>
  <EmployeeID>2</EmployeeID>
  <ContactID>1030</ContactID>
  <LoginID>adventure-works\kevin0</LoginID>
  <Title>Marketing Assistant</Title>
</Employee>

/*
Using the PATH Mode
The PATH mode is used to return specific values by indicating the column names for which you need to retrieve the data, as shown 
in the following query:
*/

SELECT EmployeeID "@EmpID",
  FirstName "EmpName/First",
  MiddleName "EmpName/Middle",
  LastName "EmpName/Last"
FROM HumanResources.Employee e JOIN Person.Contact c
ON e.ContactID = c.ContactID
AND e.EmployeeID=1
FOR XML PATH

--Output
<row EmpID="1">
 <EmpName>
  <First>Guy</First>
  <Middle>R</Middle>
  <Last>Gilbert</Last>
 </EmpName>
</row>

SELECT EmployeeID "@EmpID",
  FirstName "EmpName/First",
  MiddleName "EmpName/Middle",
  LastName "EmpName/Last"
FROM HumanResources.Employee e JOIN Person.Contact c
ON e.ContactID = c.ContactID
AND e.EmployeeID=1
FOR XML PATH('Employee')

--Output
<Employee EmpID="1">
 <EmpName>
  <First>Guy</First>
  <Middle>R</Middle>
  <Last>Gilbert</Last>
 </EmpName>
</Employee>

/*
Using the EXPLICIT Mode
The EXPLICIT mode is used to return an XML file that obtains the format as specified in the SELECT statement. Separate SELECT 
statements can be combined with the UNION ALL statement to generate each level/element in the resulting XML output. 
*/

ElementName!TagNumber!AttributeName!Directive

/*where,
ElementName specifies the name of the element.
TagNumber specifies the unique tag value assigned to an element. It, along with the value in the Parent tag, determines the 
nesting of the elements in the resulting XML.
AttributeName specifies the name of the attribute. This attribute will be created in the element specified by the ElementName, 
if the directive is not specified.
Directive specifies the type of AttributeName. It is used to provide additional information for construction of the XML. 
It is optional and can have values, such as xml, cdata, or element. */

SELECT 1 AS Tag,
  NULL AS Parent,
  ProductID AS [Product!1!ProductID],
  Name AS [Product!1!ProductName!element],
  Color AS [Product!1!Color!elementxsinil]
FROM Production.Product
Where ProductID = 1 OR ProductID = 317
FOR XML EXPLICIT

--Output
<Product xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ProductID="1">
  <ProductName>Adjustable Race</ProductName>
  <Color xsi:nil="true" />
</Product>
<Product xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ProductID="317">
  <ProductName>LL Crankarm</ProductName>
  <Color>Black</Color>
</Product>


--Including XML Namespaces
WITH XMLNAMESPACES ('http://www.adventureWorks.com' AS ad)
SELECT EmployeeID AS 'ad:EMPID',
  ContactID AS 'ad:ContactID',
  Title AS 'ad:Title'
FROM HumanResources.Employee Employee
FOR XML RAW ('ad:Employee'), ELEMENTS

--Output
ad:Employee xmlns:ad="http://www.adventureWorks.com">
  <ad:EMPID>1</ad:EMPID>
  <ad:ContactID>1209</ad:ContactID>
  <ad:Title>Production Technician - WC60</ad:Title>
</ad:Employee>
<ad:Employee xmlns:ad="http://www.adventureWorks.com">
  <ad:EMPID>2</ad:EMPID>
  <ad:ContactID>1030</ad:ContactID>
  <ad:Title>Marketing Assistant</ad:Title>
</ad:Employee>

/*
Using XQuery
In addition to FOR XML, SQL Server allows you to extract data stored in variables or columns with the XML data type by using XQuery. 
XQuery is a language that uses a set of statements and functions provided by the XML data type to extract data. */

o	for: Used to iterate through a set of nodes at the same level as in an XML document.
o	let: Used to declare variables and assign values.
o	order by: Used to specify a sequence.
o	where: Used to specify criteria for the data to be extracted.
o	return: Used to specify the XML returned from a statement.

INSERT INTO Sales.DeliverySchedule
VALUES
(GetDate(), 3, 'Bill',
'<?xml version="1.0" ?>
<DeliveryList xmlns="http://schemas.adventure works.com/DeliverySchedule">
  <Delivery SalesOrderID="43659">
    <CustomerName>Steve Schmidt</CustomerName>
    <Address>6126 North Sixth Street, Rockhampton</Address>
  </Delivery>
  <Delivery SalesOrderID="43660">
    <CustomerName>Tony Lopez</CustomerName>
    <Address>6445 Cashew Street, Rockhampton</Address>
  </Delivery>
</DeliveryList>')

SELECT DeliveryDriver, DeliveryList.query
  ('declare namespace ns="http://schemas.adventure works.com/DeliverySchedule"; ns:DeliveryList/ns:Delivery/ns:CustomerName') 
  as 'Customer Names' FROM Sales.DeliverySchedule
  
  /*	Value: Used to return a single value from an XML document. To extract a single value, you need to specify an XQuery 
  expression that identifies a single node and a data type of the value to be retrieved.*/
  
  SELECT DeliveryList.value
('declare namespace ns="http://schemas.adventure works.com/DeliverySchedule";
  (ns:DeliveryList/ns:Delivery/ns:Address)[1]', 'nvarchar(100)') DeliveryAddress
FROM Sales.DeliverySchedule

/*Exist: Used to check the existence of a node in an XML data. The function returns 1 if the specified node exists, 
else it returns 0. */
SELECT DeliveryDriver
FROM Sales.DeliverySchedule
WHERE DeliveryList.exist
  ('declare namespace ns="http://schemas.adventure works.com/DeliverySchedule";
  /ns:DeliveryList/ns:Delivery[@SalesOrderID=43659]') = 1


--Modifying XML Data
	Insert:
UPDATE CustomDetails SET Cust_Details.modify('
insert attribute Type{"Credit"} as first
into (/Customer)[1]')

	Replace:
UPDATE CustomDetails SET Cust_Details.modify ('
replace value of(Customer/@Type)[1] with "Cash"') WHERE Cust_ID = 3

	Delete:
UPDATE CustomDetails SET Cust_Details.modify (
'delete(/Customer/@City)[1]')

