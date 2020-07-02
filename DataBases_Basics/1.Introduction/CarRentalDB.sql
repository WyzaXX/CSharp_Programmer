CREATE DATABASE CarRental

USE CarRental

CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY NOT NULL,
CategoryName NVARCHAR(20) NOT NULL,
DailyRate INT NOT NULL,
WeeklyRate INT NOT NULL,
MonthlyRate INT NOT NULL,
WeekendRate INT NOT NULL
)

CREATE TABLE Cars(
Id INT PRIMARY KEY IDENTITY NOT NULL,
PlateNumber NVARCHAR (10) UNIQUE NOT NULL,
Manufacturer NVARCHAR (20) NOT NULL,
Model NVARCHAR (20) NOT NULL,
CarYear INT NOT NULL,
CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
Doors INT ,
Picture VARBINARY(MAX)
CHECK(DATALENGTH(Picture) <= 2048*1024),
Condition NVARCHAR (10) NOT NULL,
Available CHAR(3)
)

CREATE TABLE Employees(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName NVARCHAR(15) NOT NULL,
LastName NVARCHAR(15)NOT NULL,
Title NVARCHAR(20) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Customers(
Id INT PRIMARY KEY IDENTITY NOT NULL,
DriverLicenceNumber INT UNIQUE NOT NULL,
FullName NVARCHAR(30) NOT NULL,
[Address] NVARCHAR(50)NOT NULL,
City NVARCHAR(15) NOT NULL,
ZipCode INT,
Notes NVARCHAR(MAX)
)

CREATE TABLE RentalOrders(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
CustomerId INT FOREIGN KEY REFERENCES Customers(Id),
CarId INT FOREIGN KEY REFERENCES Cars(Id),
TankLevel DECIMAL (5,2) NOT NULL,
KilometrageStart INT NOT NULL,
KilometrageEnd INT NOT NULL,
TotalKilometrage INT NOT NULL,
StartDate DATETIME2 NOT NULL,
EndDate DATETIME2 NOT NULL,
TotalDays INT,
RateApplied DECIMAL (5,2),
TaxRate INT,
OrderStatus NVARCHAR (20),
Notes NVARCHAR(MAX)
)

INSERT INTO Categories(CategoryName,DailyRate,WeeklyRate,MonthlyRate,WeekendRate)
	VALUES
			('Budget','15','70','300','24'),
			('Normal','30','180','650','50'),
			('Sport','50','320','1000','85')

INSERT INTO Cars
(PlateNumber,Manufacturer,Model,CarYear,
CategoryId,Doors,Condition,Available)
	VALUES
			('CB3553HA','BMW','M3','2005','3','3','GOOD','YES'),
			('CB9857BA','AUDI','A4','2003','2','5','USED','NO'),
			('CB6831XA','RENAULT','CLIO','1994','1','3','USED','YES')			

INSERT INTO Employees(FirstName,LastName,Title,Notes)
	VALUES
			('Pesho','Peshov','Mechanic',NULL),
			('Jordan','Ivanov','CEO','GOOD BOI'),
			('Pancho','Misirkov','Manager','Corrupt Boi')

INSERT INTO Customers
(DriverLicenceNumber,FullName,[Address],City,ZipCode,Notes)
	VALUES
			('704636491','Petar Geshhev','Momin Prohod 32 ','Izvor',NULL,NULL),
			('124336482','Getar Peshov','Momin Prohod 23 ','Izvor','9000',NULL),
			('804960658','Wetar Mihalcheff','Momin Prohod 987 ','Izvor','1223','kradec')

INSERT INTO RentalOrders
(EmployeeId,CustomerId,CarId,TankLevel,KilometrageStart,
KilometrageEnd,TotalKilometrage,StartDate,EndDate)

	VALUES
			(NULL,'1','1','100.00','20','220','200','05.20.2020','02.22.2020'),
			('2',NULL,'2','80.00','60','120','60','05.15.2020','02.19.2020'),
			('3',NULL,'3','55.00','100','600','500','05.10.2020','02.14.2020')