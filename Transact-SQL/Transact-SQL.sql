-- Problem 1.	Create a database with two tables
USE Bank
GO

CREATE PROC usp_SelectFullNamePersons
AS
SELECT
	FirstName + ' ' + LastName AS [Full Name]
FROM Persons
GO

EXEC usp_SelectFullNamePersons


-- Problem 2.	Create a stored procedure
GO
CREATE PROC usp_SelectAllPersonsByMoneyMoreOf(@minMoney money)
AS
SELECT
	FirstName + ' ' + LastName AS [Full Name],
	SUM(a.Balance) AS Sum
FROM Persons p
	JOIN Accounts a
		ON a.PersonId = p.Id
GROUP BY	a.PersonId,
			FirstName,
			LastName
HAVING SUM(a.Balance) >= @minMoney
GO

EXEC usp_SelectAllPersonsByMoneyMoreOf 7000


-- Problem 3.	Create a function with parameters
CREATE FUNCTION ufn_CalculateFutureSum(@sum money, @yearlyInterestRateInPercent money, @monthsNumber int) RETURNS money
AS
	BEGIN
		DECLARE @monthlyInterestRate money
		SET @monthlyInterestRate = @yearlyInterestRateInPercent / 12
		RETURN @sum * (1 + @monthsNumber * @monthlyInterestRate / 100)
	END
GO

SELECT
	FirstName + ' ' + LastName AS [Full Name],
	dbo.ufn_CalculateFutureSum(a.Balance, 5, 24) AS FutereSum
FROM Persons p
	JOIN Accounts a
		ON a.PersonId = p.Id


-- Problem 4.	Create a stored procedure that uses the function from the previous example.
GO
CREATE PROC usp_SelectInterestOfAccount(@accountId  int, @interestRate money)
AS
	DECLARE @oldSum money
	SELECT 	@oldSum = Balance
	FROM Accounts
	WHERE Id = @accountId

	DECLARE @newSum MONEY
	SET @newSum = dbo.ufn_CalculateFutureSum(@oldSum, @interestRate, 1)

	SELECT @newSum - @oldSum AS [Interest for month]
GO

EXEC usp_SelectInterestOfAccount	9, 5

-- Problem 5.	Add two more stored procedures WithdrawMoney and DepositMoney.
GO
CREATE PROC usp_WithdrawMoney (@accountId  int, @money money)
AS
	DECLARE @oldSum money
	SELECT 	@oldSum = Balance
	FROM Accounts
	WHERE Id = @accountId

	IF (@money < 0) 
		BEGIN
			RAISERROR ('The amount must be positive.', 16, 1)
		END

	IF (@money > @oldSum) 
		BEGIN
			RAISERROR ('the amount should be less than the balance.', 16, 1)
		END

	UPDATE Accounts
	SET Balance = (Balance - @money)
	WHERE Accounts.Id = @accountId
GO

EXEC usp_WithdrawMoney	1, 550
SELECT * FROM Accounts

GO
CREATE PROC usp_DepositMoney (@accountId  int, @money money)
AS
	DECLARE @oldSum money
	SELECT 	@oldSum = Balance
	FROM Accounts
	WHERE Id = @accountId

	IF (@money < 0)
		BEGIN
			RAISERROR ('The amount must be positive.', 16, 1)
		END

	UPDATE Accounts
	SET Balance = (Balance + @money)
	WHERE Accounts.Id = @accountId
GO

EXEC usp_DepositMoney	1, 1000
SELECT * FROM Accounts

-- Problem 6.	Create table Logs.
USE [Bank]
GO

CREATE TABLE Logs(
	LogId int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	AccountId int NOT NULL,
	OldValue money NULL,
	NewValue money NULL)

GO

CREATE TRIGGER tr_BankAccountsChange ON Accounts
FOR UPDATE
AS
INSERT INTO dbo.Logs (AccountId, NewValue, OldValue)
	SELECT
		d.Id,
		i.Balance,
		d.Balance
	FROM INSERTED i
		JOIN DELETED d
			ON d.Id = i.Id
GO

-- Problem 7.	Define function in the SoftUni database.
use SoftUni

GO
CREATE FUNCTION ufn_chechWord(@string nvarchar(100), @word nvarchar(100)) RETURNS INT
	BEGIN
		DECLARE  @char nvarchar(1)

		DECLARE @wcount int, @index int, @len int
		SET @wcount= 0
		SET @index = 1
		SET @len= LEN(@word)
	
		WHILE @index <= @len
		BEGIN
			set @char = SUBSTRING(@word, @index, 1)

			if CHARINDEX(@char, @string) = 0
				BEGIN
					RETURN 0
				END

			SET @index= @index+ 1
		END

		RETURN 1
	END
GO

DECLARE empCursor CURSOR READ_ONLY FOR
	(SELECT e.FirstName, e.LastName, t.Name
	FROM Employees e
		JOIN Addresses a
			ON a.AddressID = e.AddressID
		JOIN Towns t
			ON t.TownID = a.TownID)

OPEN empCursor
DECLARE @firstName char(50), @lastName char(50), @town char(50), @string char(50)
FETCH NEXT FROM empCursor INTO @firstName, @lastName, @town

SET @string = 'isofagrek'

WHILE @@FETCH_STATUS = 0
  BEGIN
    FETCH NEXT FROM empCursor INTO @firstName, @lastName, @town
	IF dbo.ufn_chechWord(@string, @firstName) = 1
		BEGIN
			print @firstName
		END	
	IF dbo.ufn_chechWord(@string, @lastName) = 1
		BEGIN
			print @lastName
		END	
	IF dbo.ufn_chechWord(@string, @town) = 1
		BEGIN
			print @town
		END	
  END

CLOSE empCursor
DEALLOCATE empCursor

