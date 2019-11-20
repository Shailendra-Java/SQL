--Constructs (IF-ELSE, CASE, WHILE)
Declare @amount money
Select @amount = fee
from std.Student where StdID = 102
if @amount < 6000
begin
	print 'Fee is below 6000 INR'
	print @amount
end
else
begin
	print 'Fee is above 6000 INR'
	print @amount
end
go

--CASE Statement
Select StdId, Name, 'GENDER' = 
CASE Gender
	WHEN 'M' THEN 'MALE'
	WHEN 'F' THEN 'FEMALE'
	ELSE 'Not Specified'
End
FROM std.Student
go

--WHILE Construct
WHILE (Select avg(fee) from std.Student) < 9500
BEGIN
	Update std.Student set fee = fee-750
	Select max(fee) as 'Max Fee' from std.Student
	IF(Select max(fee) from std.Student) > 9500
	BEGIN
		BREAK
	END
	ELSE
		CONTINUE
END
go

--Exception Handling
BEGIN TRY
Insert into std.Student
values('Allen','all@gmail.com',67,29000,1005,'M')

Insert into std.Student
values('Saira','sr@gmail.com',78,18000,1010,'F')

END TRY
BEGIN CATCH
	Select 'There was an Error! '+ERROR_MESSAGE() as 'Error In SQL',
	ERROR_LINE() as 'Line',
	ERROR_SEVERITY() as 'Severity',
	ERROR_STATE() as 'State'
END CATCH
go

Select * from std.Student

