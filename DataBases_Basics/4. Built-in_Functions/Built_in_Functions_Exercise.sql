--Working with SoftUniDB
USE SoftUni
--1 Select all employees where firstname starts with "Sa..."

SELECT FirstName,LastName
  FROM Employees
  WHERE FirstName LIKE 'Sa%'

--2 Select all employees where lastname contains "ei"

SELECT FirstName,LastName
  FROM Employees
  WHERE LastName LIKE '%ei%'

--3 Select all employees with a specific department ID 

SELECT FirstName
	FROM Employees
	WHERE DepartmentID=3 OR DepartmentID=10

--4 Select all employees except Engineers

SELECT FirstName,LastName
  FROM Employees
  WHERE JobTitle != 'engineer'

--5 Select all towns with names > 6 symbols

SELECT [Name]
  FROM Towns
  WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
  ORDER BY [Name]

--6 Select all towns with specific letter

SELECT *
	FROM Towns
	WHERE LEFT([Name],1)='M' 
	OR LEFT([Name],1)='K'
	OR LEFT([Name],1)='B'
	OR LEFT([Name],1)='E'
	ORDER BY [Name]

--7 Select all towns without a specific letter

SELECT *
	FROM Towns
	WHERE LEFT([Name],1)!='R' 
	AND LEFT([Name],1)!='D'
	AND LEFT([Name],1)!='B'
	ORDER BY [Name]

--8 Create a view with employees hired after year 2000

CREATE VIEW V_EmployeesHiredAfter2000 AS
	SELECT FirstName,LastName
		FROM Employees
		WHERE YEAR(HireDate) > 2000

--9 Select all employees with lastName lenght = 5

SELECT FirstName,LastName
	FROM Employees
	WHERE LEN(LastName) = 5

--10 Rank employees by Salary
SELECT * FROM
(SELECT EmployeeID,FirstName,LastName,Salary,
RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID)
AS [Rank]
	FROM Employees
	WHERE SALARY >=10000 AND SALARY <=50000
	) AS [Data]
	WHERE [Rank] =2
	ORDER BY SALARY DESC

--Working with GeographyDB
USE Geography
--11 Select all countries with letter 'a' >=3

SELECT CountryName,IsoCode
	FROM Countries
	WHERE CountryName LIKE '%a%a%a%' OR CountryName LIKE 'A%a%a%'
	ORDER BY IsoCode

--12 Select all rivers by specific condition and combine them with their peakname

SELECT  PeakName,RiverName,LOWER(Peakname + SUBSTRING(RiverName,2,LEN(RiverName))) AS Mix
	FROM Rivers,Peaks
	WHERE RIGHT(PeakName,1) = LEFT (RiverName,1)
	ORDER BY Mix

--Working with DiabloDB
--13 Select all games from 2011 and 2012

SELECT TOP 50 [Name], CONVERT(varchar,[Start],23) AS [Start]
	FROM Games
	WHERE YEAR([Start]) = 2011 OR YEAR([Start]) = 2012
	ORDER BY [Start],[Name]

--14 FIND ALL USERS WITH EMAIL PROVIDER ONLY INCLUDED

SELECT Username,
SUBSTRING([Email],CHARINDEX('@',[Email])+1,LEN([Email]))
AS [Email Provider]
	FROM Users
	ORDER BY [Email Provider],Username

--15 FIND ALL USERS WITH SPECIFIC IPAddress PATTERN

SELECT Username,IpAddress
	FROM Users
	WHERE IpAddress LIKE '[0-9][0-9][0-9].[1][0-9]%.[0-9]%.[0-9][0-9][0-9]'
	ORDER BY Username

--16 SELECT ALL GAMES WITH CUSTOM DURATION

SELECT [Name], 
	CASE
			WHEN DATEPART(HOUR,[Start])  BETWEEN 0 AND 11 THEN 'Morning'
			WHEN DATEPART(HOUR,[Start])  BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
			END AS [Part of the Day],

	CASE
			WHEN Duration BETWEEN 0 AND 3 THEN 'Extra Short'
			WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
			WHEN Duration > 6 THEN 'Long'
			ELSE 'Extra Long'
			END AS [Duration]
	FROM Games
	ORDER BY [Name],[Duration],[Part of the Day]