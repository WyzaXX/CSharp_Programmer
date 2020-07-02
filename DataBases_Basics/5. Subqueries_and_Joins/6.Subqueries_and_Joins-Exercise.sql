--1
SELECT TOP (5) EmployeeID,JobTitle,e.AddressID,AddressText
	FROM Employees e
	JOIN Addresses a ON a.AddressID = e.AddressID
	ORDER BY AddressID

--2
SELECT TOP(50) FirstName,LastName,t.Name,a.AddressText
	FROM Employees e
	JOIN Addresses a on a.AddressID=e.AddressID
	JOIN Towns t on t.TownID = a.TownID
	ORDER BY FirstName,LastName

--3
SELECT e.EmployeeID,FirstName,LastName,d.Name
	FROM Employees e
	JOIN Departments d ON d.DepartmentID = e.DepartmentID
	WHERE d.Name = 'Sales'
	ORDER BY EmployeeID

--4
SELECT TOP (5) e.EmployeeID,FirstName,
Salary,d.Name
	FROM Employees e
	JOIN Departments d ON d.DepartmentID = e.DepartmentID
	WHERE e.Salary >15000
	ORDER BY e.DepartmentID

--5
SELECT TOP (3) e.EmployeeID,FirstName
	FROM Employees e
	LEFT JOIN EmployeesProjects ep ON e.EmployeeID = ep.EmployeeID
	LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID
	WHERE EP.ProjectID IS NULL
	ORDER BY e.EmployeeID

--6
SELECT FirstName,LastName,HireDate,d.Name
	FROM Employees e
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
	WHERE d.Name = 'Finance' OR d.Name = 'Sales' AND HireDate > '1999-01-01'
	ORDER BY HireDate

--7
SELECT TOP (5) e.EmployeeID,FirstName,p.Name
	FROM Employees e
	JOIN EmployeesProjects ep ON e.EmployeeID=ep.EmployeeID
	JOIN Projects p ON ep.ProjectID = p.ProjectID
	WHERE p.StartDate > '2002-08-13' AND EndDate is null
	ORDER BY e.EmployeeID

--8
SELECT e.EmployeeID,FirstName,
	CASE	
		WHEN DATEPART(YEAR,p.StartDate) >=2005 THEN NULL
		ELSE p.Name 
		END AS [Project Name]
	FROM Employees e
	JOIN EmployeesProjects ep ON e.EmployeeID = ep.EmployeeID
	JOIN Projects p ON ep.ProjectID=p.ProjectID
	WHERE e.EmployeeID = 24

--9
SELECT e.EmployeeID,e.FirstName,e.ManagerID,em.FirstName
	FROM Employees e
	LEFT JOIN Employees em ON e.ManagerID = em.EmployeeID
	WHERE e.ManagerID IN (3,7)
	ORDER BY e.EmployeeID
	
--10
SELECT TOP (50) e.EmployeeID,
e.FirstName + ' ' + e.LastName
AS [EmployeeName],
em.FirstName + ' ' + em.LastName
AS [ManagerName],
d.Name
	FROM Employees e
	LEFT JOIN Employees em ON e.ManagerID = em.EmployeeID
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
	ORDER BY e.EmployeeID
	
--11
SELECT MIN([Average Salary]) FROM
(SELECT DepartmentID,AVG(Salary) AS [Average Salary]
	FROM Employees e
	GROUP BY DepartmentID) AVGQ
	
--working with GeographyDB
--12
SELECT c.CountryCode,
m.MountainRange,
p.PeakName,
p.Elevation
FROM MountainsCountries mc
LEFT JOIN Countries c ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains m ON mc.MountainId = m.Id
LEFT JOIN Peaks p ON m.Id = p.MountainId
WHERE c.CountryCode = 'BG' 
AND p.Elevation > 2835
ORDER BY Elevation DESC

--13
SELECT c.CountryCode,COUNT(m.MountainRange)
	FROM MountainsCountries mc
	JOIN Countries c ON	mc.CountryCode=c.CountryCode
	JOIN Mountains m ON mc.MountainId = m.Id
	WHERE c.CountryCode IN ('BG','US','RU')
	GROUP BY c.CountryCode

--14
SELECT TOP(5) CountryName,RiverName
	FROM Countries C
	LEFT JOIN CountriesRivers CR ON C.CountryCode = CR.CountryCode
	LEFT JOIN Rivers R ON CR.RiverId = R.Id
	WHERE C.ContinentCode = 'AF'
	ORDER BY CountryName

--15*
SELECT f.ContinentCode,f.CurrencyCode,f.[Currency Usage] FROM 
	(SELECT *,DENSE_RANK() OVER
(PARTITION BY ContinentCode 
 ORDER BY [Currency Usage] DESC) AS [Rank]
	FROM
	(SELECT ContinentCode,CurrencyCode,
		COUNT(*) AS [Currency Usage]
	FROM Countries
		GROUP BY ContinentCode,CurrencyCode)
	AS Q) AS f
	WHERE RANK =1 AND [Currency Usage]>1
	ORDER BY ContinentCode,CurrencyCode

--16
SELECT COUNT(*) FROM Countries C
LEFT JOIN MountainsCountries MC ON C.CountryCode=MC.CountryCode
LEFT JOIN Mountains M ON MC.MountainId=M.Id
WHERE MountainId IS NULL

--17
SELECT TOP(5)C.CountryName,
MAX(P.Elevation) AS [Highest Peak Elevation],
MAX(R.Length) AS [Longest River Length]
	FROM Countries C
		LEFT JOIN MountainsCountries MC 
		ON C.CountryCode=MC.CountryCode
		LEFT JOIN Mountains M
		ON MC.MountainId=M.Id
		LEFT JOIN Peaks P 
		ON P.MountainId=M.Id
		LEFT JOIN CountriesRivers CR 
		ON C.CountryCode=CR.CountryCode
		LEFT JOIN Rivers R 
		ON CR.RiverId = R.Id
		GROUP BY CountryName
		ORDER BY [Highest Peak Elevation] DESC,
		[Longest River Length] DESC,
		CountryName

--18*
SELECT TOP(5)C.CountryName,
CASE WHEN P.PeakName IS NULL THEN '(no highest peak)'
ELSE P.PeakName END AS [Highest Peak Name],
CASE WHEN MAX(P.Elevation) IS NULL THEN '0'
ELSE MAX(P.Elevation)
END AS [Highest Peak Elevation],
CASE WHEN m.MountainRange IS NULL THEN '(no mountain)'
ELSE M.MountainRange
END AS [Mountain]
FROM Countries C
LEFT JOIN MountainsCountries MC ON C.CountryCode=MC.CountryCode
LEFT JOIN Mountains M ON MC.MountainId=M.Id
LEFT JOIN Peaks P ON M.Id=P.MountainId
GROUP BY CountryName,p.PeakName,p.Elevation,m.MountainRange
ORDER BY C.CountryName,P.PeakName
