INSERT INTO Towns([Name])
	VALUES
			('Sofia'),
			('Plovdiv'),
			('Varna'),
			('Burgas')

INSERT INTO Departments([Name])
	VALUES
			('Engineering'),
			('Sales'),
			('Marketing'),
			('Software Development'),
			('Quality Assurance')

INSERT INTO Employees (FirstName,MiddleName,LastName,JobTitle,DepartmentId,HireDate,Salary)
	VALUES
			('Ivan','Ivanov','Ivanov','.NET Developer','4','2013.02.01','3500.00'),
			('Petar','Petrov','Petrov','Senior Engineer','1','2004.03.02','4000.00'),
			('Maria','Petrova','Ivanova','Intern','5','2016.08.28','525.25'),
			('Georgi','Teziev','Ivanov','CEO','2','2007.12.09','3000.00'),
			('Peter','Pan','Pan','Intern','3','2016.08.28','599.88')
			
--BASIC ORDERING BY NAME
SELECT * FROM Towns
ORDER BY [Name]
SELECT * FROM Departments
ORDER BY [Name]

--DESCENDING BY SALARY
SELECT * FROM Employees
ORDER BY Salary DESC
			
--ORDERING BY SPECIFIC COLUMN
SELECT [Name] FROM Towns
ORDER BY [Name]
SELECT [Name] FROM Departments
ORDER BY [Name]
SELECT FirstName,LastName,JobTitle,Salary FROM Employees
ORDER BY Salary DESC

--INCREASING SALARY BY 10%
UPDATE Employees
SET Salary= Salary*1.10
SELECT Salary FROM Employees

