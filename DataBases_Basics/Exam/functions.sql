CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT,@Date DATE,@People INT)
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @Text VARCHAR(100);
DECLARE @Price DECIMAL (18,2);
	
		DECLARE @ArrDate DATE =(
			SELECT TOP(1) ArrivalDate FROM Trips T
			JOIN Rooms R ON T.RoomId = R.Id
			JOIN Hotels H ON R.HotelId=H.Id
			WHERE H.Id = @HotelId AND T.CancelDate IS NULL
			ORDER BY R.Price DESC)

		DECLARE @RetDate DATE =(
			SELECT TOP(1) ReturnDate FROM Trips T
			JOIN Rooms R ON T.RoomId = R.Id
			JOIN Hotels H ON R.HotelId=H.Id
			WHERE H.Id = @HotelId AND T.CancelDate IS NULL
			ORDER BY R.Price DESC)
			
		DECLARE @BEDS INT = 
		(
			SELECT TOP(1) R.Beds FROM Trips T
			JOIN Rooms R ON T.RoomId = R.Id
			JOIN Hotels H ON R.HotelId=H.Id
			WHERE H.Id = @HotelId AND T.CancelDate IS NULL
			ORDER BY R.Price DESC
		)

		IF(@ArrDate IS NULL)
		RETURN 'No rooms available'
		ELSE IF (@Date BETWEEN @ArrDate AND @RetDate)
		RETURN 'No rooms available'
		ELSE IF(@RetDate IS NULL)
		RETURN 'No rooms available'
		ELSE IF(@BEDS<@People)
		RETURN 'No rooms available'
		
		DECLARE @RoomID INT  =
		(
			SELECT TOP(1)R.Id FROM Rooms R
			JOIN Hotels H ON R.HotelId = H.Id
			WHERE @HotelId =H.Id
			ORDER BY R.Price DESC
		)

		DECLARE @RoomType varchar(25) =
		(
			SELECT TOP(1) R.Type FROM Rooms R
			JOIN Hotels H ON R.HotelId = H.Id
			WHERE @HotelId =H.Id
			ORDER BY R.Price DESC
		)
		DECLARE @HotelRate DECIMAL (18,2) = (SELECT TOP(1)
		H.BaseRate FROM Hotels H
			JOIN Rooms R ON R.HotelId = H.Id
			WHERE @HotelId =H.Id
			ORDER BY R.Price DESC)

			DECLARE @RoomRate DECIMAL (18,2) = (SELECT TOP(1)
		r.Price FROM Hotels H
			JOIN Rooms R ON R.HotelId = H.Id
			WHERE @HotelId =H.Id
			ORDER BY R.Price DESC)

		SET @Price = (@HotelRate + @RoomRate) * @People;

		 SET @Text = CONCAT('Room ',
		 CAST(@RoomID AS VARCHAR(3)),
		 ': ',CAST(@RoomType AS VARCHAR(20)),
		 ' (',CONVERT(varchar(2),@BEDS),' beds) - $',
		 CONVERT(VARCHAR(10),@Price));
		
	RETURN @Text;
END
GO
 SELECT dbo.udf_GetAvailableRoom(112, '2011-12-17', 2)
 SELECT dbo.udf_GetAvailableRoom(94, '2015-07-26', 3)


CREATE PROC usp_SwitchRoom(@TripId INT,@TargetRoomId INT)
AS
BEGIN

DECLARE @CurrRoom INT = 
(
SELECT RoomId FROM TRIPS T 
JOIN Rooms R ON T.RoomId= R.Id
WHERE T.Id=@TripId
)
DECLARE @NextRoom INT = (
SELECT RoomId FROM TRIPS T 
JOIN Rooms R ON T.RoomId= R.Id
WHERE T.Id=@TargetRoomId
)

declare @CurrHotelId INT = 
(
SELECT HotelId FROM TRIPS T 
JOIN Rooms R ON T.RoomId= R.Id
WHERE T.Id=@TripId
)

declare @NextHotelId INT = 
(
SELECT HotelId FROM TRIPS T 
JOIN Rooms R ON T.RoomId= R.Id
WHERE T.Id=@TargetRoomId
)
	
	IF(@CurrHotelId!=@NextHotelId)
	BEGIN
	THROW 50001,'Target room is in another hotel!',1;
	END
	IF()
	THROW 50002,'Not enough beds in target room!',1;

	SET @TripId = @TargetRoomId;
	RETURN @TargetRoomId;
END
GO