-- Problem 1.	Write a SQL query to find the names and salaries of the 
-- employees that take the minimal salary in the company.
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary IN 
	(SELECT MIN(Salary)
	 FROM Employees)

-- Problem 2.	Write a SQL query to find the names and salaries of the employees that have a 
-- salary that is up to 10% higher than the minimal salary for the company.
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary BETWEEN
	(SELECT MIN(Salary) FROM Employees) 
		AND (SELECT MIN(Salary) * 1.1 FROM Employees)

-- Problem 3.	Write a SQL query to find the full name, salary and department of the employees 
-- that take the minimal salary in their departmen
SELECT e.FirstName + ' ' + ISNULL(MiddleName + ' ','') + LastName AS [Full Name], e.Salary, d.Name AS [Deparment Name]
FROM Employees e 
	JOIN Departments d
		ON e.DepartmentID = d.DepartmentID
WHERE Salary = 
  (SELECT MIN(Salary) FROM Employees
   WHERE DepartmentID = e.DepartmentID)
ORDER BY d.DepartmentID

-- Problem 4.	Write a SQL query to find the average salary in the department #1.
SELECT AVG(SALARY)
FROM Employees
WHERE DepartmentID = 1

-- Problem 5.	Write a SQL query to find the average salary in the "Sales" department.
SELECT AVG(SALARY) AS [Average Salary for Sales Department]
FROM Employees e
	JOIN Departments d
		ON e.DepartmentID = d.DepartmentID
WHERE d.Name LIKE 'Sales'

-- Problem 6.	Write a SQL query to find the number of employees in the "Sales" department.
SELECT COUNT(*) 
FROM Employees e
	JOIN Departments d
		ON e.DepartmentID = d.DepartmentID
WHERE d.Name LIKE 'Sales'

-- Problem 7.	Write a SQL query to find the number of all employees that have manager.
SELECT COUNT(ManagerID)
FROM Employees

-- Problem 8.	Write a SQL query to find the number of all employees that have no manager.
SELECT COUNT(*)
FROM Employees
WHERE ManagerID IS NULL

-- Problem 9.	Write a SQL query to find all departments and the average salary for each of them.
SELECT d.Name, AVG(Salary)
FROM Departments d
	JOIN Employees e
		ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.Name
ORDER BY d.Name

-- Problem 10.	Write a SQL query to find the count of all employees in each department and for each town.
SELECT t.Name AS Town, d.Name AS Department,  COUNT(*) AS [Employees count]
FROM Employees e
	JOIN Departments d
		ON d.DepartmentID = e.DepartmentID
	JOIN Addresses a
		ON e.AddressID = a.AddressID
	JOIN Towns t
		ON a.TownID = t.TownID
GROUP BY d.DepartmentID, d.Name, t.Name
ORDER BY d.Name

-- Problem 11.	Write a SQL query to find all managers that have exactly 5 employees.
SELECT e.FirstName, e.LastName, m.[Employees count]
FROM Employees e
	JOIN 
		(SELECT ManagerID, COUNT(ManagerID) AS [Employees count]
		FROM Employees
		GROUP BY ManagerID) m
	ON m.ManagerID = e.EmployeeID
WHERE m.[Employees count] = 5


SELECT m.FirstName, m.LastName, COUNT(e.ManagerID) AS [Employees count]
FROM Employees e 
	JOIN Employees m
		ON m.EmployeeID = e.ManagerID
GROUP BY m.ManagerID, m.FirstName, m.LastName
HAVING COUNT(e.ManagerID) = 5

-- Problem 12.	Write a SQL query to find all employees along with their managers.
SELECT e.FirstName + ' ' + e.LastName AS Employee, 
	ISNULL(m.FirstName + ' ' + m.LastName, 'no manager') AS Manager
FROM Employees e
LEFT OUTER JOIN Employees m
	ON e.ManagerID = m.EmployeeID

-- Problem 13.	Write a SQL query to find the names of all employees whose last name is exactly 5 characters long. 
SELECT FirstName, MiddleName, LastName 
FROM Employees
WHERE LEN(LastName) = 5

-- Problem 14.	Write a SQL query to display the current date and time in the following 
-- format "day.month.year hour:minutes:seconds:milliseconds". 
SELECT CONVERT(nvarchar, GETDATE(), 4) + ' ' 
	+ CONVERT(nvarchar, GETDATE(), 114) AS DateTime

-- Problem 15.	Write a SQL statement to create a table Users.
CREATE TABLE Users (
  UserID int IDENTITY,
  UserName nvarchar(100) NOT NULL,
  [Password] nvarchar(100) NOT NULL,
  FullName nvarchar(100) NOT NULL,
  LastLoginTime smalldatetime,
  CONSTRAINT PK_UserID PRIMARY KEY(UserID),
  CONSTRAINT chk_Password CHECK (LEN(Password) > 5))

GO

-- Problem 16.	Write a SQL statement to create a view that displays the users from the Users table that have been in the system today.
CREATE VIEW [SHOW USERS] AS
SELECT * FROM Users
GO
SELECT * FROM [SHOW USERS]

GO

-- Problem 17.	Write a SQL statement to create a table Groups. 
CREATE TABLE Groups (
  Id int IDENTITY,
  Name nvarchar(100) NOT NULL,
  CONSTRAINT PK_Id PRIMARY KEY(Id),
  CONSTRAINT UK_Name UNIQUE(Name))

 -- Problem 18.	Write a SQL statement to add a column GroupID to the table Users. 
 ALTER TABLE Users 
 ADD GroupId int FOREIGN KEY REFERENCES Groups(Id)

 -- Problem 19.	Write SQL statements to insert several records in the Users and Groups tables
INSERT INTO Groups 
VALUES ('pepi')

INSERT INTO Groups
VALUES ('Desi')

INSERT INTO Groups
VALUES ('Mimi')

INSERT INTO Users (UserName, Password, FullName, LastLoginTime, GroupId)
VALUES ('pepi', '123456', 'pepi pepov', '2015-02-15', 1)

INSERT INTO Users (UserName, Password, FullName, LastLoginTime, GroupId)
VALUES ('Desi', '123456', 'Desislava Painerova', '2015-02-14', 2)

INSERT INTO Users (UserName, Password, FullName, LastLoginTime, GroupId)
VALUES ('Mimi', '123456', 'Mara Otvarachkata', '2015-02-15', 3)

-- Problem 20.	Write SQL statements to update some of the records in the Users and Groups tables.
UPDATE Groups
SET Name = 'Mara'
WHERE Name = 'Mimi'

UPDATE Users
SET UserName = 'Mara', GroupId = 2
WHERE UserName = 'Mimi'

-- Problem 21.	Write SQL statements to delete some of the records from the Users and Groups tables.
Delete Users
WHERE UserName = 'Mara'

Delete Groups
WHERE Name = 'Mara'

-- Problem 22.	Write SQL statements to insert in the Users table the names of all employees from the Employees table.
INSERT INTO Users
SELECT LOWER(LEFT(FirstName, 1) + LEFT(LastName, 1)) AS UserName,
	 LOWER(LEFT(FirstName, 1) + LEFT(LastName, 1)+ '1234') AS Password,
	 FirstName + ' ' + LastName as FullName,
	 NULL AS LastLoginTime,
	 2 AS GroupId
FROM Employees

-- Problem 23.	Write a SQL statement that changes the password to NULL for all users that have not been in the system since 10.03.2010.
UPDATE Users
SET Password = NULL
WHERE LastLoginTime <= CAST('2013-10-03' AS smalldatetime);

-- Problem 24.	Write a SQL statement that deletes all users without passwords (NULL password).
Delete Users
WHERE Password IS NULL

-- Problem 25.	Write a SQL query to display the average employee salary by department and job title.
SELECT d.Name, JobTitle, AVG(Salary) AS [Average Employee Salary]
FROM Employees e
	JOIN Departments d 
		ON d.DepartmentID = e.DepartmentID 
GROUP BY d.Name, JobTitle

-- Problem 26.	Write a SQL query to display the minimal employee salary by department and 
-- job title along with the name of some of the employees that take it.

SELECT FirstName, LastName, d.Name, Salary
FROM Employees e 
	JOIN Departments d 
	ON d.DepartmentID = e.DepartmentID
WHERE Salary = 
  (SELECT MIN(Salary) FROM Employees 
   WHERE DepartmentID = e.DepartmentID)
GROUP BY d.Name,  FirstName, LastName, Salary
ORDER BY d.Name


-- Problem 27.	Write a SQL query to display the town where maximal number of employees work.
SELECT t.Name AS Town, COUNT(t.TownID) AS [Number of employees]
FROM Employees e
	JOIN Addresses a
		ON  a.AddressID = e.AddressID
	JOIN Towns t
		ON a.TownID = t.TownID
GROUP BY  t.Name, t.TownID 

-- Problem 28.	Write a SQL query to display the number of managers from each town.
SELECT mt.Town, COUNT(*) AS [Number of manager]
FROM (SELECT DISTINCT e.EmployeeID, e.FirstName, e.LastName, t.Name AS Town
FROM Employees e 
	JOIN Employees m
		ON m.ManagerID = e.EmployeeID
	JOIN Addresses a
		ON  a.AddressID = e.AddressID
	JOIN Towns t
		ON a.TownID = t.TownID) AS mt
GROUP BY mt.Town
ORDER BY mt.Town

-- Problem 29.	Write a SQL to create table WorkHours to store work reports for each employee.
CREATE TABLE WorkHours
(
        Id int PRIMARY KEY IDENTITY NOT NULL,
		EmployeeId int FOREIGN KEY REFERENCES Employees(EmployeeId)  NOT NULL,
        Date datetime NULL,
        Task nvarchar(150) NOT NULL,
        Hours int NOT NULL,
        Comments ntext NULL

)
GO

-- Problem 30.	Issue few SQL statements to insert, update and delete of some data in the table.
-- Problem 31.	Define a table WorkHoursLogs to track all changes in the WorkHours table with triggers.
CREATE TABLE WorkHoursLogs
(
        Id int PRIMARY KEY IDENTITY NOT NULL,
		Message nvarchar(150) NOT NULL,
		DateOfChange datetime NOT NULL
)

GO

CREATE TRIGGER  tr_WorkHoursInsert 
ON WorkHours
 FOR INSERT
AS 
	INSERT INTO WorkHoursLogs (Message, DateOfChange)
	VALUES('Added row', GETDATE ( ))
GO

CREATE TRIGGER  tr_WorkHoursDelete 
ON WorkHours
 FOR DELETE
AS 
	INSERT INTO WorkHoursLogs (Message, DateOfChange)
	VALUES('Deleted row', GETDATE ( ))
GO

CREATE TRIGGER  tr_WorkHoursUpdate
ON WorkHours
 FOR UPDATE
AS 
	INSERT INTO WorkHoursLogs (Message, DateOfChange)
	VALUES('Update row', GETDATE ( ))
GO

INSERT INTO WorkHours (EmployeeId, Date, Task, Hours)
	VALUES(10, GETDATE ( ), 'Bla-Bla', 10)

INSERT INTO WorkHours (EmployeeId, Date, Task, Hours)
	VALUES(11, GETDATE ( ), 'Bla-Bla-2', 100)

DELETE WorkHours
WHERE EmployeeId = 10

UPDATE WorkHours
SET Task = 'Bla-Bla Ura-a-a'
WHERE EmployeeId = 11

SELECT * FROM WorkHoursLogs

-- Problem 32.	Start a database transaction, delete all employees from the 'Sales' department along 
-- with all dependent records from the pother tables. At the end rollback the transaction.
BEGIN TRAN
DELETE  Employees
WHERE DepartmentID = 
	(SELECT DepartmentID 
	 FROM Departments
	 WHERE Name = 'Sales')

SELECT * FROM Employees e
	JOIN Departments d
		ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ROLLBACK TRAN

-- Problem 33.	Start a database transaction and drop the table EmployeesProjects.
BEGIN TRAN
DROP TABLE EmployeesProjects
ROLLBACK TRAN

-- Problem 34.	Find how to use temporary tables in SQL Server.
BEGIN TRAN
CREATE TABLE #EmployeesProjects(
	EmployeeID int NOT NULL,
	ProjectID int NOT NULL,
 ) 

 INSERT #EmployeesProjects
 SELECT * FROM EmployeesProjects

 DROP TABLE EmployeesProjects

 CREATE TABLE EmployeesProjects(
	EmployeeID int NOT NULL,
	ProjectID int NOT NULL,
 ) 

 INSERT EmployeesProjects
 SELECT * FROM tempdb.#EmployeesProjects

 ROLLBACK TRAN