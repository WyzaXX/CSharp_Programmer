--01
CREATE DATABASE Users

USE Users

CREATE TABLE Passports(
PassportID INT PRIMARY KEY IDENTITY(101,1) NOT NULL,
PassportNumber CHAR(8) NOT NULL
)

CREATE TABLE Persons(
PersonID INT NOT NULL,
FirstName NVARCHAR(50) NOT NULL,
Salary DECIMAL (7,2),
PassportId INT
)

INSERT INTO Passports(PassportNumber)
	VALUES
			('N34FG21B'),
			('K65LO4R7'),
			('ZE657QP2')

ALTER TABLE Persons
ADD CONSTRAINT PK_PERSONID PRIMARY KEY (PersonId)
ALTER TABLE Persons
ADD CONSTRAINT FK_Persons_Passports_ID FOREIGN KEY (PassportId) 
REFERENCES Passports(PassportID)

--02
CREATE TABLE Manufacturers(
ManufacturerID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(25) NOT NULL,
EstablishedOn DATE NOT NULL
)

INSERT INTO Manufacturers([Name],EstablishedOn)
	VALUES
			('BMW','1916-03-07'),
			('Tesla','2003-01-01'),
			('Lada','1996-05-01')

CREATE TABLE Models(
ModelID INT PRIMARY KEY IDENTITY(101,1) NOT NULL,
[Name] NVARCHAR (50) NOT NULL,
ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID) NOT NULL
)

INSERT INTO Models([Name],ManufacturerID)
	VALUES
			('X1',1),
			('i6',1),
			('Model S',2),
			('Model X',2),
			('Model 3',2),
			('Nova',3)

--03
CREATE TABLE Students(
StudentID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR (50) NOT NULL
)

INSERT INTO Students([Name])
	VALUES
			('Mila'),
			('Toni'),
			('Ron')

CREATE TABLE Exams(
ExamID INT PRIMARY KEY IDENTITY(101,1)NOT NULL,
[Name] NVARCHAR (50) NOT NULL
)

INSERT INTO Exams([Name])
	VALUES
			('SpringMVC'),
			('Neo4j'),
			('Oracle 11g')

CREATE TABLE StudentsExams(
StudentID INT FOREIGN KEY REFERENCES Students(StudentID) NOT NULL,
ExamID INT FOREIGN KEY REFERENCES Exams(ExamID) NOT NULL
CONSTRAINT PK_StudentsExams PRIMARY KEY (StudentID,ExamID)	
)

INSERT INTO StudentsExams
	VALUES
			(1,101),
			(1,102),
			(2,101),
			(3,103),
			(2,102),
			(2,103)

--04
CREATE TABLE Teachers(
TeacherID INT PRIMARY KEY IDENTITY(101,1) NOT NULL,
[Name] NVARCHAR(25) NOT NULL,
ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers([Name],ManagerID)
	VALUES
			('John',null),
			('Maya',106),
			('Silvia',106),
			('Ted',105),
			('Mark',101),
			('Greta',101)