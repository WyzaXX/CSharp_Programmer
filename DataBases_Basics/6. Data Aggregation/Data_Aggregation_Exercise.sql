--1
SELECT COUNT(*) as Count
	FROM WizzardDeposits

--2
SELECT TOP (1) MagicWandSize AS [Longest Magic Wand]
	FROM WizzardDeposits
	ORDER BY MagicWandSize DESC

--3
SELECT DepositGroup, MAX(MagicWandSize) AS [Longest Magic Wand]
	FROM WizzardDeposits
	GROUP BY DepositGroup

--4
SELECT TOP(2) DepositGroup
	FROM WizzardDeposits
	GROUP BY DepositGroup
	ORDER BY AVG(MagicWandSize)

--5
SELECT DepositGroup,SUM(DepositAmount) AS [Total Sum]
	FROM WizzardDeposits
	GROUP BY DepositGroup

--6
SELECT DepositGroup,SUM(DepositAmount) AS [Total Sum]
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup

--7
SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup
	HAVING SUM(DepositAmount) < 150000
	ORDER BY [TotalSum] DESC

--8
SELECT DepositGroup,MagicWandCreator,MIN(DepositCharge)
	FROM WizzardDeposits
	GROUP BY DepositGroup,MagicWandCreator
	ORDER BY MagicWandCreator,DepositGroup

--9
SELECT AgeGroup,COUNT(*) FROM (SELECT *,
	CASE 
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		 ELSE '[61+]'
		END AS [AgeGroup]
FROM WizzardDeposits) AS RESULT
GROUP BY AgeGroup

--10
	SELECT DISTINCT LEFT( FirstName,1)
		FROM WizzardDeposits
		WHERE DepositGroup = 'Troll Chest'
		GROUP BY  FirstName

--11
SELECT DepositGroup,IsDepositExpired,AVG(DepositInterest) AS [Average Interest]
	FROM WizzardDeposits
	WHERE DepositStartDate > '1985-01-01'
	GROUP BY DepositGroup,IsDepositExpired
	ORDER BY DepositGroup DESC,IsDepositExpired

--12
SELECT SUM(DIFFERENCE) FROM
(SELECT *, [Host Wizard Deposit]-[Guest Wizard Deposit] AS [Difference]
	FROM
(SELECT FirstName AS [Host Wizard],
		DepositAmount AS [Host Wizard Deposit],
		LEAD(FirstName) OVER (ORDER BY Id ASC) AS [Guest Wizard],
		LEAD(DepositAmount) OVER(ORDER BY Id ASC) AS [Guest Wizard Deposit]
	FROM WizzardDeposits) AS Q) as qq

--13
SELECT DepartmentID,SUM(Salary)
	FROM Employees
	GROUP BY DepartmentID

--14
SELECT DepartmentID,MIN(Salary)
	FROM Employees
	WHERE HireDate > '2000-01-01' AND 
	DepartmentID IN (2,5,7)
	GROUP BY DepartmentID

--15
SELECT *
 INTO EmployeesTMP
	FROM Employees
	WHERE SALARY > 30000
--
DELETE FROM EmployeesTMP
WHERE EmployeeID =42
--
UPDATE EmployeesTMP
SET SALARY +=5000
WHERE DepartmentID=1
--
SELECT DepartmentID,AVG(Salary)
	FROM EmployeesTMP
	GROUP BY DepartmentID

--16
SELECT DepartmentID,MAX(Salary) AS [Max Salary]
	FROM Employees
	WHERE SALARY NOT BETWEEN 30000 AND 70000
	GROUP BY DepartmentID

--17
SELECT COUNT(*)
	FROM Employees
	WHERE ManagerID IS NULL

--18*
SELECT DepartmentID,Salary FROM
(SELECT *,
DENSE_RANK() 
OVER(PARTITION BY DepartmentID ORDER BY SALARY DESC)
AS [SalaryRank]
FROM Employees) AS [QUERY]
WHERE SalaryRank =3
GROUP BY DepartmentID,Salary

--19**
SELECT TOP(10) E1.FirstName,E1.LastName,E1.DepartmentID
FROM Employees AS E1
WHERE E1.Salary > 
(SELECT AVG(Salary) AS [AVGS] 
FROM Employees AS E2
WHERE E2.DepartmentID=E1.DepartmentID
GROUP BY DepartmentID)
ORDER BY DepartmentID