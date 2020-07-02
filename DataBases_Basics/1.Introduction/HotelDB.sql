CREATE DATABASE Hotel

USE Hotel

CREATE TABLE Employees(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName NVARCHAR(15) NOT NULL,
LastName NVARCHAR(15)NOT NULL,
Title NVARCHAR(20) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Customers(
AccountNumber INT PRIMARY KEY IDENTITY NOT NULL,
FirstName NVARCHAR(20) NOT NULL,
LastName NVARCHAR(20) NOT NULL,
PhoneNumber INT UNIQUE NOT NULL,
EmergencyName NVARCHAR (20) NOT NULL,
EmergencyNumber INT NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE RoomStatus(
RoomStatus NVARCHAR(15) PRIMARY KEY NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE RoomTypes(
RoomType NVARCHAR(15) PRIMARY KEY NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE BedTypes(
BedType NVARCHAR(15) PRIMARY KEY NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Rooms(
RoomNumber INT PRIMARY KEY IDENTITY  NOT NULL,
RoomType NVARCHAR(15) FOREIGN KEY REFERENCES RoomTypes(RoomType) NOT NULL,
BedType NVARCHAR(15) FOREIGN KEY REFERENCES BedTypes(BedType) NOT NULL,
Rate INT NOT NULL,
RoomStatus NVARCHAR(15) FOREIGN KEY REFERENCES RoomStatus(RoomStatus) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Payments(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
PaymentDate DATETIME2 NOT NULL,
AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
FirstDateOccupied DATETIME2 NOT NULL,
LastDateOccupied DATETIME2 NOT NULL,
TotalDays INT NOT NULL,
AmoundCharged INT NOT NULL,
TaxRate INT,
TaxAmount INT,
PaymentTotal INT,
Notes NVARCHAR(MAX)
)

CREATE TABLE Occupancies(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
DateOccupied DATETIME2 NOT NULL,
AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL,
RateApplied INT,
PhoneCharge INT,
Notes NVARCHAR(MAX)
)

INSERT INTO Employees(FirstName,LastName,Title,Notes)
	VALUES
			('Ivan','Ivanov','Kamerier','chisti'),
			('Clara','Mincheva','RECEPTION',NULL),
			('PETUR','PETROV','UPRAVITEL','DOBUR LIDER')

INSERT INTO Customers
(FirstName,LastName,PhoneNumber,EmergencyName,EmergencyNumber,Notes)
	VALUES
			('Misha','Petrova','0000000','Mishka','1111111','baluk'),
			('Genka','Genkova','00880000','Mishka','1131111','baluk'),
			('Test','Test','000000098','Mishka','1111112',NULL)

INSERT INTO RoomStatus(RoomStatus,Notes)
	VALUES
			('CLEAN',NULL),
			('NEEDS CLEANING','YEP'),
			('DIRTY','EW')

INSERT INTO RoomTypes(RoomType,Notes)
	VALUES
			('MEZONET','2 Floors'),
			('Boksoniera','with Kitchen'),
			('Garsoniera',NULL)

INSERT INTO BedTypes(BedType,Notes)
	VALUES
			('prujina','Uncomfortable'),
			('Decent Matrak','Decent'),
			('Dormeo',NULL)

INSERT INTO Rooms(RoomType,BedType,Rate,RoomStatus,Notes)
	VALUES
			('MEZONET','Decent Matrak','80','CLEAN','AVAILABLE'),
			('Boksoniera','prujina','45','NEEDS CLEANING','AVAILABLE TOMORROW'),
			('Garsoniera','Dormeo','120','CLEAN','OCCUPIED')
			
INSERT INTO Payments
(EmployeeId,PaymentDate,AccountNumber,FirstDateOccupied,LastDateOccupied
,TotalDays,AmoundCharged,TaxRate,TaxAmount,PaymentTotal,Notes)
	VALUES
			('1','05.05.2020','2','03.05.2020','05.05.2020','2','160','20','32',NULL,NULL),
			('3','02.05.2020','1','12.04.2020','05.05.2020','7','300','0','0',NULL,NULL),
			('2','01.05.2020','3','10.04.2020','01.05.2020','11','590','10','59',NULL,'LEFT THE ROOM DIRTY!')