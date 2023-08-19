-- ================================================
-- Descripción: Calcula la Unidad de la Edad
-- ================================================
USE BETANIA;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUC_CALCULAR_UNIDAD_EDAD]') AND type in (N'FN', N'IF',N'TF', N'FS', N'FT'))
DROP FUNCTION dbo.FUC_CALCULAR_UNIDAD_EDAD;
GO

CREATE FUNCTION dbo.FUC_CALCULAR_UNIDAD_EDAD (
    @FechaInicial CHAR(8),
    @FechaFinal CHAR(8)
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @FechaIni DATE;
    DECLARE @FechaFin DATE;
    DECLARE @DiferenciaDias INT;
    DECLARE @UnidadEdad VARCHAR(50);

	 -- Convertir fechas en formato AAAAMMDD a tipo DATE
    SET @FechaIni = CONVERT(DATE, @FechaInicial, 112);
    SET @FechaFin = CONVERT(DATE, @FechaFinal, 112);

    SET @DiferenciaDias = DATEDIFF(DAY, @FechaIni, @FechaFin);

    IF @DiferenciaDias < 30
    BEGIN
        SET @UnidadEdad = 'Días';
    END
    ELSE IF @DiferenciaDias <= 365 AND @DiferenciaDias >= 30
    BEGIN
        SET @UnidadEdad = 'Meses';
    END
    ELSE
    BEGIN
        SET @UnidadEdad = 'Años';
    END;

    RETURN @UnidadEdad;
END;
