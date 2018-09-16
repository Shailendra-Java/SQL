CREATE schema Student;
CREATE schema Teacher;
go

CREATE TABLE Student.StudentRecord
(
	Std_Id int IDENTITY(100,3) PRIMARY KEY,
	FirstName varchar(15) not null,
	MiddleName varchar(8),
	LastName varchar(12) not null,
	Gender char not null,
	PhoneNo bigint UNIQUE,
	Course_Id int
	FOREIGN KEY(Course_Id) references Student.Course(Course_id)	
)

CREATE TABLE Student.Course
(
	Course_Id int IDENTITY(10,1) PRIMARY KEY,
	Name varchar(20),
	Duration varchar(10) DEFAULT '3 Months',
	Fee Money CHECK (Fee<=25000)
)

CREATE TABLE Teacher.Faculty
(
	T_Code int IDENTITY(1000,2) PRIMARY KEY,
	Name varchar(20),
	Phone bigint,
	Department_Id int
	FOREIGN KEY(Department_Id) references Teacher.Department(Department_id)
)

CREATE TABLE Teacher.Department
(
	Department_Id int IDENTITY(20,5) PRIMARY KEY,
	Name varchar(25)
)

INSERT INTO Teacher.Department(Name) values('Electrical Engineering')
INSERT INTO Teacher.Faculty values('Latham',887778767,35)
INSERT INTO Student.Course(Name,Fee) values('JAVA',20000)
INSERT INTO Student.Course values('HTML','2 Months',12000)
INSERT INTO Student.StudentRecord values('Rahul',' ','Kumar','M',8898787776,12)
Select * from Teacher.Department;
Select * from Teacher.Faculty;
Select * from Student.Course;
Select * from Student.StudentRecord;