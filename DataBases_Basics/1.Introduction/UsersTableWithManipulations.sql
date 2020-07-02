CREATE TABLE Users(
	Id BIGINT PRIMARY KEY IDENTITY NOT NULL,
	Username VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(26) UNIQUE NOT NULL,
	Picture VARBINARY(MAX) 
	CHECK(DATALENGTH(Picture) <= 900*1024),
	LastLoginTime DATETIME2 NOT NULL,
	IsDeleted BIT NOT NULL
)

INSERT INTO Users(Username,[Password],LastLoginTime,IsDeleted)
	VALUES ('Pesho0','123456','01.01.2020',0),
	('Pesho1','123356','01.01.2020',0),
	('Pesho2','123556','02.01.2020',1),
	('Pesho3','123656','03.01.2020',0),
	('Pesho4','1234856','04.01.2020',1)
	
	--remove the current primary key
	ALTER TABLE Users
	DROP CONSTRAINT [PK__Users__3214EC07D3B6BE7B]

	--set the primary key to be composite with id+username
	ALTER TABLE Users
	ADD CONSTRAINT PK_Users_CompositeIdUsername
	PRIMARY KEY (Id,Username)

	--set the password lenght to be atlest 5 chars
	ALTER TABLE Users
	ADD CONSTRAINT CK_Users_PasswordLength
	CHECK(LEN([Password]) >= 5)
	 
	--set the default loginTime to now
	ALTER TABLE Users
	ADD CONSTRAINT DF_Users_LastLoginTime
	DEFAULT GETDATE() FOR LastLoginTime

	--remove current PK
	ALTER TABLE Users
	DROP CONSTRAINT PK_Users_CompositeIdUsername

	--ADD NEW PK
	ALTER TABLE Users 
	ADD CONSTRAINT PK_Users_Id
	PRIMARY KEY (Id)

	--set checker for username to be atleast 3 chars
	ALTER TABLE Users
	ADD CONSTRAINT CK_Users_UsernameLength
	CHECK (LEN(Username) >=3)
