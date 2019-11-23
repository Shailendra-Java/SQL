--Stored Procedures
Create Procedure sp_student
As
Begin
	Select s.StdId as 'Student ID', s.Name, s.Email,
	c.Name as 'Course Name', c.Duration
	From std.Student s JOIN std.Course c
	ON s.CID = c.CID 
End
go

--Execute Procedure
Exec sp_student

--Modify Procedure
Alter Procedure sp_student
As
Begin
	Select s.StdId as 'Student ID', s.Name, s.Email,s.Fee,
	c.Name as 'Course Name', c.Duration
	From std.Student s JOIN std.Course c
	ON s.CID = c.CID 
	Where s.fee > 8000
End
go

--Droping Procedure
Drop Procedure sp_student

--Parameterised Stored Procedures
Create Procedure sp_student @amount money
As
Begin
	Select s.StdId as 'Student ID', s.Name, s.Email,s.Fee,
	c.Name as 'Course Name', c.Duration
	From std.Student s JOIN std.Course c
	ON s.CID = c.CID 
	Where s.Fee > @amount
End
go

Execute sp_student 5000

--Return & Output in Procedure
Create Procedure sp_maxfee @courseId int, @amount money output
As
begin
	Select @amount = max(fee) from std.Student
	Where CID =  @courseId
	return 0
end


Declare @amount money
exec sp_maxfee 1010, @amount output
Print 'Max fee in CID 1010 is '+convert(varchar(16), @amount)


--Implicit Transaction
Set IMPLICIT_TRANSACTIONS ON
begin try
	Insert into std.Course values('Python','2 Months',6500,'Cover core functionality')
	Insert into std.Course values('Angular JS','3 Months',7500,'Cover all Angular modules')
	COMMIT Transaction
end try
begin catch
	Select ERROR_MESSAGE() as Error
	ROLLBACK TRANSACTION
end catch

--Explicit TRANSACTION
Begin Transaction trans1
begin try
	Insert into std.Course values('Python','2 Months',6500,'Cover core functionality')
	Insert into std.Course values('Angular JS','3 Months',7500,'Cover all Angular modules')
	COMMIT Transaction trans1
end try
begin catch
	Select ERROR_MESSAGE() as Error
	ROLLBACK TRANSACTION trans1
end catch

--Reverting Transaction
SET EXACT_ABORT ON
BEGIN TRAN mytrans
BEGIN TRY
	INSERT INTO std.Course values('Data Science','1 Year',45000,'Data Science with python')
	INSERT INTO std.Course values('History','2 Months',5000,'History about NIIT')
	SAVE TRAN sp1
	UPDATE std.Student SET fee = 15000 where StdID = 1000
	UPDATE std.Student SET fee = 1500 where StdID = 1002
	SAVE TRAN sp2
	COMMIT TRAN mytrans
END TRY
BEGIN CATCH
	SELECT 'There was some problem at line no ',ERROR_LINE() as 'Line No.'
	ROLLBACK TRAN sp2
END CATCH

--Seting ISOLATION LEVEL
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN mytrans
BEGIN TRY
	INSERT INTO std.Course values('Data Science','1 Year',45000,'Data Science with python')
	INSERT INTO std.Course values('History','2 Months',5000,'History about NIIT')
	SAVE TRAN sp1
	UPDATE std.Student SET fee = 15000 where StdID = 1000
	UPDATE std.Student SET fee = 1500 where StdID = 1002
	SAVE TRAN sp2
	COMMIT TRAN mytrans
END TRY
BEGIN CATCH
	SELECT 'There was some problem at line no ',ERROR_LINE() as 'Line No.'
	ROLLBACK TRAN sp2
END CATCH
