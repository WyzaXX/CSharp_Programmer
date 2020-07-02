CREATE DATABASE Movies

USE Movies

CREATE TABLE Directors(
Id INT PRIMARY KEY IDENTITY NOT NULL,
DirectorName NVARCHAR(25) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Genres(
Id INT PRIMARY KEY IDENTITY NOT NULL,
GenreName NVARCHAR(25) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY NOT NULL,
CategoryName NVARCHAR(25) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Movies(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Title NVARCHAR(25) UNIQUE NOT NULL,
CopyrightYear INT NOT NULL,
[Length] INT NOT NULL,
Rating DECIMAL(3,1),
Notes NVARCHAR(MAX)
)

ALTER TABLE Movies
ADD DirectorId INT FOREIGN KEY REFERENCES  Directors(Id)

ALTER TABLE Movies
ADD GenreId INT FOREIGN KEY REFERENCES Genres(Id)

ALTER TABLE Movies
ADD CategoryId INT FOREIGN KEY REFERENCES Categories(Id)

ALTER TABLE Movies
ADD CONSTRAINT CK_Movies_Rating
CHECK (LEN(Rating)<=10.0)

INSERT INTO Categories(CategoryName,Notes)
	VALUES
			('ASD',NULL),
			('FGH','HMMM'),
			('JKL','TEST2'),
			('ZXC',NULL),
			('CVB','TEST')

INSERT INTO Directors(DirectorName,Notes)
	VALUES
			('Jeff',NULL),
			('Ivan','HMMM'),
			('Jordan','TEST2'),
			('desi',NULL),
			('Dani','TEST')

INSERT INTO Genres(GenreName,Notes)
	VALUES
			('Drama',NULL),
			('Action','HMMM'),
			('fgh','TEST2'),
			('qwe',NULL),
			('yes','TEST')

INSERT INTO Movies(Title,CopyrightYear,[Length],Rating,Notes)
	VALUES
			('TITANIC',1999,3,5.2,NULL),
			('TITANIC2',1993,2,4.0,'good'),
			('TITANIC3',1992,1,10.0,'bad'),
			('TITANIC4',1991,5,1.9,'fake'),
			('TITANIC5',1911,6,9.9,'trash')