CREATE FUNCTION dbo.SplitString
(
    @String NVARCHAR(MAX),
    @Delimiter NVARCHAR(1)
)
RETURNS @Result TABLE (Value NVARCHAR(MAX))
AS
BEGIN
    DECLARE @Value NVARCHAR(MAX)
    
    WHILE CHARINDEX(@Delimiter, @String) > 0
    BEGIN
        SET @Value = SUBSTRING(@String, 1, CHARINDEX(@Delimiter, @String) - 1)
        INSERT INTO @Result (Value) VALUES (@Value)
        SET @String = SUBSTRING(@String, CHARINDEX(@Delimiter, @String) + 1, LEN(@String))
    END

    INSERT INTO @Result (Value) VALUES (@String)
    
    RETURN
END
