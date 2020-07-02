--1
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT FirstName,LastName
	FROM Employees
		WHERE Salary>35000
END

EXEC usp_GetEmployeesSalaryAbove35000
GO
--2

CREATE PROC usp_GetEmployeesSalaryAboveNumber(@Num DECIMAL(18,4))
AS
BEGIN
	SELECT FirstName,LastName
	FROM Employees
		WHERE Salary >= @Num
END

EXEC usp_GetEmployeesSalaryAboveNumber 3500.00
GO

--3
CREATE PROC usp_GetTownsStartingWith (@str varchar(max))
AS
BEGIN
	SELECT [Name] as Town
		FROM Towns
		WHERE [Name] LIKE @str +'%'
END
EXEC usp_GetTownsStartingWith 'b'
GO

--4
CREATE PROC usp_GetEmployeesFromTown(@Tname varchar(max))
AS
BEGIN
	SELECT FirstName,LastName from Employees E
	JOIN Addresses A ON E.AddressID = A.AddressID
	JOIN Towns T ON A.TownID=T.TownID
	WHERE T.Name = @Tname
END

GO

--5
CREATE FUNCTION ufn_GetSalaryLevel(@salary Decimal(18,4))
RETURNS	VARCHAR(7)
AS
BEGIN
DECLARE @SalaryLevel VARCHAR(7);

	IF (@salary<30000)
		BEGIN
			SET @SalaryLevel = 'Low';
		END
	ELSE IF (@salary>=30000 AND @salary<=50000)
		BEGIN
			SET @SalaryLevel = 'Average';
		END
	ELSE
		BEGIN
			SET @SalaryLevel = 'High';
		END

RETURN @SalaryLevel
END

GO

--6
CREATE PROC usp_EmployeesBySalaryLevel(@salaryLevel VARCHAR(7))
AS
BEGIN
	SELECT FirstName,LastName
	FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel
END
GO

--7
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters varchar(MAX),@word varchar(max))
RETURNS BIT
AS
BEGIN
DECLARE @i INT = 1; 
WHILE(@i <= LEN(@word))
	BEGIN
DECLARE @CURR CHAR = SUBSTRING(@word,@i,1);
DECLARE @CHARI INT = CHARINDEX(@CURR,@setOfLetters);

	IF (@CHARI =0)
		BEGIN
			RETURN 0;
		END

SET @i+=1;
	END
	RETURN 1;
END
GO

--8
CREATE PROC usp_DeleteEmployeesFromDepartment(@departmentId INT )
AS
BEGIN
	
	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (
		SELECT EmployeeID FROM Employees 
		WHERE DepartmentID = @departmentId
		)
		UPDATE Employees
		SET ManagerID = NULL
		WHERE ManagerID IN 
		(
		SELECT EmployeeID FROM Employees 
		WHERE DepartmentID = @departmentId
		)
		
		ALTER TABLE Departments
		ALTER COLUMN ManagerID INT

		UPDATE Departments
		SET ManagerID = NULL
			WHERE ManagerID IN
			(
			SELECT EmployeeID FROM Employees 
			WHERE DepartmentID = @departmentId
			)

		DELETE FROM Employees
		WHERE DepartmentID = @departmentId
		
		delete from Departments
		WHERE DepartmentID = @departmentId

		SELECT COUNT(*) FROM Employees
		WHERE DepartmentID = @departmentId
END

GO

--9
CREATE PROC usp_GetHoldersFullName
AS
BEGIN
SELECT FirstName + ' '+ LastName AS [Full Name] FROM AccountHolders
END

GO

--10
CREATE PROC usp_GetHoldersWithBalanceHigherThan(@cash DECIMAL(18,4))
AS
BEGIN
	SELECT FirstName,LastName FROM AccountHolders AH
	JOIN Accounts A ON AH.Id=A.AccountHolderId
	GROUP BY FirstName,LastName
	HAVING SUM(Balance)> @cash
	ORDER BY FirstName,LastName
	
END

GO

--11
CREATE FUNCTION ufn_CalculateFutureValue(@sum Decimal(18,4),@interestRate float,@years int)
RETURNS DECIMAL(18,4)
AS
BEGIN
DECLARE @total DECIMAL (18,4);

SET @total = @sum * (POWER((1+@interestRate),@years));

RETURN @total;
END

GO

--12
CREATE PROC usp_CalculateFutureValueForAccount (@accId INT,@yir float)
AS
BEGIN

	SELECT a.Id,FirstName,LastName,Balance,
	dbo.ufn_CalculateFutureValue(Balance,@yir,5)
	AS [Balance in 5 years]
	FROM AccountHolders AH
	JOIN Accounts A ON AH.Id = A.AccountHolderId
	WHERE ah.Id=@accId
END
EXEC usp_CalculateFutureValueForAccount 1,0.1
GO

--13
CREATE FUNCTION ufn_CashInUsersGames (@gameName VARCHAR(50))
RETURNS TABLE
AS
RETURN SELECT(
				SELECT SUM(Q.Cash) AS [SumCash] FROM
	(SELECT G.Name,UG.Cash,
	ROW_NUMBER() OVER (PARTITION BY G.[Name] ORDER BY UG.Cash DESC) AS [RowNum]
	FROM Games G
	JOIN UsersGames UG ON G.Id=UG.GameId
	WHERE G.Name = @gameName
	) AS Q
	WHERE Q.RowNum %2=1) as [Sum]
GO