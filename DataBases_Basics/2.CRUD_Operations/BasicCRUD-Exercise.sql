--Working with SoftUniDB
--1 select departments
SELECT *
  FROM Departments

--2 select all departments Names
SELECT [Name] 
	FROM Departments

--3 select First,Last Names and Salary from Employees
SELECT FirstName,LastName,Salary
	FROM Employees

--4 select First,Middle and Last Names from Employees
SELECT FirstName,MiddleName,LastName
	FROM Employees

--5 Forge Email Address
SELECT 
FirstName + '.'+LastName+'@softuni.bg' AS [Full Email Address]
	FROM Employees

--6 Select only Unique Salaries from Employees
SELECT DISTINCT Salary
	FROM Employees

--7 Select all Employees with Specific Title
SELECT *
	FROM Employees
	WHERE JobTitle = 'Sales Representative'

--8 Select all Employees within a salary range
SELECT FirstName,LastName,JobTitle
	FROM Employees
	WHERE Salary>=20000 AND Salary<=30000

--9 Select all Employees with specific Salary
SELECT 
FirstName + ' ' + 
MiddleName + ' ' +
LastName AS [Full Name]
	FROM Employees
	WHERE Salary IN (25000,14000,12500,23600)

--10 Select all Employees without a Manager
SELECT FirstName,LastName
	FROM Employees
	WHERE ManagerID IS NULL

-- 11 Select all Employees with Salary more than 50k ordered by salary
SELECT FirstName,LastName,Salary
	FROM Employees
	WHERE Salary > 50000
	ORDER BY Salary DESC

--12 Select top 5 Employees By salary.
SELECT TOP (5)FirstName,LastName
	FROM Employees
	ORDER BY Salary DESC

--13 Select all Employees except those from Marketing
SELECT FirstName,LastName
	FROM Employees
	WHERE DepartmentID != 4

--14 Custom Sorting Of Employees table
SELECT *
	FROM Employees
	ORDER BY SALARY DESC,
	FirstName,
	LastName DESC,
	MiddleName

--15 Create View of Employees with First,Last Names and Salary
CREATE VIEW V_EmployeesSalaries AS
SELECT FirstName,LastName,Salary
	FROM Employees

--16 Create View Of Employees with FullName and JobTitle
CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName + ' ' +
ISNULL(MiddleName,'')+ ' ' +
LastName AS [Full Name],
JobTitle
FROM Employees

--17 Select all Unique JobTitles From Employees
SELECT DISTINCT JobTitle
	FROM Employees

--18 SELECT FIRST 10 PROJECTS AND SORT THEM
SELECT TOP(10) *
	FROM Projects
	ORDER BY StartDate,Name

--19 Select the last 7 hired Employees and sort them
SELECT TOP(7) FirstName,LastName,HireDate
	FROM Employees
	ORDER BY HireDate DESC

--20 Increase Salary by 12% in Certain Departments
UPDATE Employees
SET Salary = Salary * 1.12
	WHERE DepartmentID IN (1,2,4,11)
SELECT Salary
	FROM Employees

--Working with GeographyDB
--21 Select all Mountain Peaks and Sort them
SELECT PeakName
FROM Peaks
GROUP BY PeakName

--22 Select the 30 biggest countries by Population IN Europe
SELECT TOP(30) CountryName,[Population]
	FROM Countries
	WHERE ContinentCode = 'EU'
	ORDER BY Population DESC

--23 Select all countries with info about Currency
SELECT CountryName,CountryCode,
CASE
	WHEN CurrencyCode = 'EUR' THEN 'Euro'
	WHEN CurrencyCode != 'EUR' THEN 'Not Euro' 
	END AS Currency
	FROM Countries
	WHERE CurrencyCode IS NOT NULL
	ORDER BY CountryName

select * from Countries

--Working with DiabloDB
--24 Select all diablo characters
SELECT [Name]
	FROM Characters
	ORDER BY [Name]