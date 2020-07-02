CREATE TABLE People(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(200) NOT NULL,
	Picture VARBINARY(MAX) 
	CHECK(DATALENGTH(Picture) <= 2048*1024),
	Height DECIMAL(3,2),
	[Weight] DECIMAL(3,2),
	Gender CHAR(1)NOT NULL,
	[BirthDate] DATETIME2 NOT NULL,
	Biography NVARCHAR(MAX),

)

INSERT INTO People([Name],Height,[Weight],Gender,[BirthDate],Biography)
	VALUES ('John','2.34','3.56','m','05.19.2020','asdfghj'),
('Ivan','2.45','3.78','m','05.10.2020','asdfgsadhj'),
('desi','1.45','2.78','f','04.10.2020','asdasdfgsadhj'),
('Pesho','0.45','0.78','m','03.10.2020','asdfgsadhjhjhj'),
('Gosho','8.45','1.78','m','02.10.2020','asdfgsadhjasdsa')
