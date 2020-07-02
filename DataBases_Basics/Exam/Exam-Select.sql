--QUERYING
--1
SELECT FirstName,LastName,
FORMAT(BirthDate,'MM-dd-yyyy') AS [BirthDate],
C.Name,Email
FROM Accounts A
JOIN Cities C ON A.CityId = C.Id
WHERE Email LIKE 'e%'
ORDER BY C.Name

--2
SELECT  C.Name, COUNT(*) AS Hotels
FROM Hotels H
JOIN Cities C ON H.CityId = C.Id
GROUP BY C.Name
ORDER BY COUNT(*) DESC ,C.Name

--3
SELECT DISTINCT AccountId,
FirstName + ' ' + LastName AS [FullName],
MAX(DATEDIFF (DAY,ArrivalDate,ReturnDate))AS [LongestTrip],
MIN(DATEDIFF (DAY,ArrivalDate,ReturnDate))AS [ShortestTrip]
FROM Accounts A
JOIN AccountsTrips [AT] ON AT.AccountId=A.Id
JOIN Trips T ON T.Id = AT.TripId
WHERE A.MiddleName IS NULL AND T.CancelDate IS NULL
GROUP BY AT.AccountId,FirstName,LastName
ORDER BY LongestTrip DESC,ShortestTrip

--4
SELECT TOP(10) C.Id,C.Name,C.CountryCode AS [Country],
COUNT(*) AS [Accounts]
FROM Accounts A
JOIN Cities C ON A.CityId = C.Id
GROUP BY C.Name,C.CountryCode,C.Id
ORDER BY Accounts DESC

--5
SELECT A.Id,A.Email,C.Name,COUNT(*) AS [Trips]
FROM Trips T
JOIN Rooms R ON T.RoomId = R.Id
JOIN Hotels H ON R.HotelId = H.Id
JOIN AccountsTrips AT ON AT.TripId = T.Id
JOIN Accounts A ON AT.AccountId = A.Id
JOIN Cities C ON A.CityId = C.Id
WHERE H.CityId = A.CityId
GROUP BY Email,C.Name,A.Id
ORDER BY COUNT(*) DESC,A.Id

--6
SELECT T.Id,CASE 
WHEN MiddleName IS NULL THEN 
FirstName + ' ' + LastName
WHEN MiddleName IS NOT NULL THEN FirstName + ' '+ MiddleName+ ' ' + LastName END AS [FullName],
C.Name AS [From],
(SELECT C.Name FROM Cities C WHERE H.CityId = C.Id) AS [To],
CASE 
	 WHEN T.CancelDate IS NULL THEN CONVERT(VARCHAR(MAX), (DATEDIFF(DAY,t.ArrivalDate,t.ReturnDate))) + ' days'
	 WHEN T.CancelDate IS NOT NULL THEN 'Canceled'
END AS [Duration]
	FROM AccountsTrips AT
	JOIN Accounts A ON AT.AccountId = A.Id
	JOIN Cities C ON A.CityId = C.Id
	JOIN Trips T ON T.Id = AT.TripId
	JOIN Rooms R ON T.RoomId = R.Id
	JOIN Hotels H ON R.HotelId = H.Id
	ORDER BY [FullName],T.Id
	
