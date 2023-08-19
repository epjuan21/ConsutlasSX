-- ================================================
-- Descripción: Calcula el grupo de edad basado en fechas
-- ================================================
USE
BETANIA
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUC_CALCULAR_GRUPO_EDAD]')
AND type in (N'FN', N'IF',N'TF', N'FS', N'FT'))
DROP FUNCTION dbo.FUC_CALCULAR_GRUPO_EDAD
GO
CREATE FUNCTION dbo.FUC_CALCULAR_GRUPO_EDAD (
    @FechaInicial CHAR(8),
    @FechaFinal CHAR(8)
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @FechaIni DATE;
    DECLARE @FechaFin DATE;
    DECLARE @Edad INT;

    -- Convertir fechas en formato AAAAMMDD a tipo DATE
    SET @FechaIni = CONVERT(DATE, @FechaInicial, 112);
    SET @FechaFin = CONVERT(DATE, @FechaFinal, 112);

    -- Calcular la edad en años
    SET @Edad = DATEDIFF(YEAR, @FechaIni, @FechaFin) - (CASE WHEN DATEADD(YY, DATEDIFF(YEAR, @FechaIni, @FechaFin), @FechaIni) > @FechaFin THEN 1 ELSE 0 END);

    -- Definir rangos de edad y retornar el grupo correspondiente
    DECLARE @GrupoEdad VARCHAR(50);

    IF @Edad >= 0 AND @Edad <= 4
        SET @GrupoEdad = '0 - 4';
    ELSE IF @Edad >= 5 AND @Edad <= 9
        SET @GrupoEdad = '5 - 9';
    ELSE IF @Edad >= 10 AND @Edad <= 14
        SET @GrupoEdad = '10 - 14';
    ELSE IF @Edad >= 15 AND @Edad <= 19
        SET @GrupoEdad = '15 - 19';
    ELSE IF @Edad >= 20 AND @Edad <= 24
        SET @GrupoEdad = '20 - 24';
    ELSE IF @Edad >= 25 AND @Edad <= 29
        SET @GrupoEdad = '25 - 29';
    ELSE IF @Edad >= 30 AND @Edad <= 34
        SET @GrupoEdad = '30 - 34';
    ELSE IF @Edad >= 35 AND @Edad <= 39
        SET @GrupoEdad = '35 - 39';
    ELSE IF @Edad >= 40 AND @Edad <= 44
        SET @GrupoEdad = '40 - 44';
    ELSE IF @Edad >= 45 AND @Edad <= 49
        SET @GrupoEdad = '45 - 49';
    ELSE IF @Edad >= 50 AND @Edad <= 54
        SET @GrupoEdad = '50 - 54';
    ELSE IF @Edad >= 55 AND @Edad <= 59
        SET @GrupoEdad = '55 - 59';
    ELSE IF @Edad >= 60 AND @Edad <= 64
        SET @GrupoEdad = '60 - 64';
    ELSE IF @Edad >= 65 AND @Edad <= 69
        SET @GrupoEdad = '65 - 69';
    ELSE IF @Edad >= 70 AND @Edad <= 74
        SET @GrupoEdad = '70 - 74';
    ELSE IF @Edad >= 75 AND @Edad <= 79
        SET @GrupoEdad = '75 - 79';
    ELSE
        SET @GrupoEdad = '80 y más';

    RETURN @GrupoEdad;
END;
