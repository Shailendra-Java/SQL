CREATE DATABASE MyDb
ON PRIMARY
(
	FILENAME = 'D:\niit\MyDb_Prm.mdf',
	NAME = 'MyDb_Primary',
	SIZE = 4MB,
	MAXSIZE = 10MB,
	FILEGROWTH = 1MB
),
FILEGROUP	MyDb_FG1
(
		NAME = 'MyDb_FG1_Dat1',
		FILENAME = 'D:\niit\MyDb_FG1_Dat1.ndf',
		SIZE = 1MB,
		MAXSIZE = 10MB,
		FILEGROWTH = 1MB
),
FILEGROUP	MyDb_FG2
(
		NAME = 'MyDb_FG1_Dat2',
		FILENAME = 'D:\niit\MyDb_FG1_Dat2.ndf',
		SIZE = 1MB,
		MAXSIZE = 10MB,
		FILEGROWTH = 1MB
)
LOG ON
(
	FILENAME = 'D:\niit\MyDb.ldf',
	NAME = 'MyDb_Log',
	SIZE = 1MB,
	MAXSIZE = 10MB,
	FILEGROWTH = 1MB
)

--Renaming a Database
sp_renamedb Old_Database_Name, New_Database_Name

sp_renamedb MyDb, Ecommerce

--Dropping a Database
drop Database database_name
