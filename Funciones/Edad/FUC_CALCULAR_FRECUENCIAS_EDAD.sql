-- ================================================
-- Descripción: Calcula las Frecuencias de Edad basadas en fechas
-- ================================================
USE
BETANIA
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUC_CALCULAR_FRECUENCIAS_EDAD]')
AND type in (N'FN', N'IF',N'TF', N'FS', N'FT'))
DROP FUNCTION dbo.FUC_CALCULAR_FRECUENCIAS_EDAD
GO
CREATE FUNCTION dbo.FUC_CALCULAR_FRECUENCIAS_EDAD (
    @FechaInicial CHAR(8),
    @FechaFinal CHAR(8)
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @Resultado VARCHAR(100);
    DECLARE @EdadAnios INT;
    DECLARE @EdadMeses INT;
    
    -- Convertir fechas en formato AAAAMMDD a tipo DATE
    DECLARE @FechaIni DATE = CONVERT(DATE, @FechaInicial, 112);
    DECLARE @FechaFin DATE = CONVERT(DATE, @FechaFinal, 112);
    
    -- Calcular la edad en años y meses
    SELECT @EdadAnios = DATEDIFF(YEAR, @FechaIni, @FechaFin) - (CASE WHEN DATEADD(YY, DATEDIFF(YEAR, @FechaIni, @FechaFin), @FechaIni) > @FechaFin THEN 1 ELSE 0 END);
    SELECT @EdadMeses = DATEDIFF(MONTH, @FechaIni, @FechaFin);
    
    -- Definir ciclos de vida
    SET @Resultado =
        CASE
            WHEN @EdadMeses = 0 THEN '1 - M'
            WHEN @EdadMeses BETWEEN 1 AND 2 THEN '2 - 3 M'
            WHEN @EdadMeses BETWEEN 3 AND 5 THEN '4 - 5 M'
            WHEN @EdadMeses BETWEEN 6 AND 8 THEN '6 - 8 M'
            WHEN @EdadMeses BETWEEN 9 AND 11 THEN '9 - 11 M'
            WHEN @EdadMeses BETWEEN 12 AND 18 THEN '12 - 18 M'
            WHEN @EdadMeses BETWEEN 19 AND 23 THEN '19 - 23 M'
            WHEN @EdadMeses BETWEEN 24 AND 29 THEN '24 - 29 M'
            WHEN @EdadMeses BETWEEN 30 AND 35 THEN '30 - 35 M'
            WHEN @EdadAnios = 3 THEN '3 A'
            WHEN @EdadAnios = 4 THEN '4 A'
            WHEN @EdadAnios = 5 THEN '5 A'
            WHEN @EdadAnios = 6 THEN '6 A'
            WHEN @EdadAnios = 7 THEN '7 A'
            WHEN @EdadAnios = 8 THEN '8 A'
            WHEN @EdadAnios = 9 THEN '9 A'
            WHEN @EdadAnios = 10 THEN '10 A'
            WHEN @EdadAnios = 11 THEN '11 A'
            WHEN @EdadAnios = 12 THEN '12 A'
            WHEN @EdadAnios = 13 THEN '13 A'
            WHEN @EdadAnios = 14 THEN '14 A'
            WHEN @EdadAnios = 15 THEN '15 A'
            WHEN @EdadAnios = 16 THEN '16 A'
            WHEN @EdadAnios = 17 THEN '17 A'
            WHEN @EdadAnios = 18 THEN '18 A'
            WHEN @EdadAnios = 19 THEN '19 A'
            WHEN @EdadAnios = 20 THEN '20 A'
            WHEN @EdadAnios = 21 THEN '21 A'
            WHEN @EdadAnios = 22 THEN '22 A'
            WHEN @EdadAnios = 23 THEN '23 A'
            WHEN @EdadAnios = 24 THEN '24 A'
            WHEN @EdadAnios = 25 THEN '25 A'
            WHEN @EdadAnios = 26 THEN '26 A'
            WHEN @EdadAnios = 27 THEN '27 A'
            WHEN @EdadAnios = 28 THEN '28 A'
            WHEN @EdadAnios BETWEEN 29 AND 34 THEN '29 - 34 A'
            WHEN @EdadAnios BETWEEN 35 AND 39 THEN '35 - 39 A'
            WHEN @EdadAnios BETWEEN 40 AND 44 THEN '40 - 44 A'
            WHEN @EdadAnios BETWEEN 45 AND 49 THEN '45 - 49 A'
            WHEN @EdadAnios BETWEEN 50 AND 52 THEN '50 - 52 A'
            WHEN @EdadAnios BETWEEN 53 AND 55 THEN '53 - 55 A'
            WHEN @EdadAnios BETWEEN 56 AND 59 THEN '56 - 59 A'
            WHEN @EdadAnios BETWEEN 60 AND 62 THEN '60 - 62 A'
            WHEN @EdadAnios BETWEEN 63 AND 65 THEN '63 - 65 A'
            WHEN @EdadAnios BETWEEN 66 AND 68 THEN '66 - 68 A'
            WHEN @EdadAnios BETWEEN 69 AND 71 THEN '69 - 71 A'
            WHEN @EdadAnios BETWEEN 72 AND 74 THEN '72 - 74 A'
            WHEN @EdadAnios BETWEEN 75 AND 77 THEN '75 - 77 A'
            WHEN @EdadAnios BETWEEN 78 AND 79 THEN '78 - 79 A'
            WHEN @EdadAnios >= 80 THEN '80 y más Años'
            ELSE 'Otra Frecuencia'
        END;
    
    RETURN @Resultado;
END;