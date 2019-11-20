--PARTITION TABLE 
USE StudentDB;
GO
-- Adds four new filegroups to the StudentDB database  
ALTER DATABASE StudentDB  
ADD FILEGROUP test1fg;  
GO  
ALTER DATABASE StudentDB  
ADD FILEGROUP test2fg;  
GO  
ALTER DATABASE StudentDB  
ADD FILEGROUP test3fg;  
GO  
ALTER DATABASE StudentDB  
ADD FILEGROUP test4fg;   

-- Adds one file for each filegroup.  
ALTER DATABASE StudentDB   
ADD FILE   
(  
    NAME = test1dat1,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\t1dat1.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP test1fg;  
ALTER DATABASE StudentDB   
ADD FILE   
(  
    NAME = test2dat2,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\t2dat2.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP test2fg;  
GO  
ALTER DATABASE StudentDB   
ADD FILE   
(  
    NAME = test3dat3,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\t3dat3.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP test3fg;  
GO  
ALTER DATABASE StudentDB   
ADD FILE   
(  
    NAME = test4dat4,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\t4dat4.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP test4fg;  
GO  
-- Creates a partition function called myRangePF1 that will partition a table into four partitions  
CREATE PARTITION FUNCTION myRangePF1 (int)  
    AS RANGE LEFT FOR VALUES (1, 100, 1000) ;  
GO  
-- Creates a partition scheme called myRangePS1 that applies myRangePF1 to the four filegroups created above  
CREATE PARTITION SCHEME myRangePS1  
    AS PARTITION myRangePF1  
    TO (test1fg, test2fg, test3fg, test4fg) ;  
GO  
-- Creates a partitioned table called PartitionTable that uses myRangePS1 to partition col1  
CREATE TABLE PartitionTable (col1 int PRIMARY KEY, col2 char(10))  
    ON myRangePS1 (col1) ;  
GO  