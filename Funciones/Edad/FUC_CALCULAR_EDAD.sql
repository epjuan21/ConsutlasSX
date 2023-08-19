-- ================================================
-- Descripción: Calcula la edad en diferentes unidades
-- ================================================
USE BETANIA;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUC_CALCULAR_EDAD]')
AND type in (N'FN', N'IF',N'TF', N'FS', N'FT'))
DROP FUNCTION dbo.FUC_CALCULAR_EDAD;
GO

CREATE FUNCTION dbo.FUC_CALCULAR_EDAD (
    @FechaInicial CHAR(8),
    @FechaFinal CHAR(8),
	@Opciones CHAR(1)
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @FechaIni DATE;
    DECLARE @FechaFin DATE;
    DECLARE @Edad INT;
    DECLARE @UnidadEdad VARCHAR(50);
	DECLARE @Anios INT, @Meses INT;

    -- Convertir fechas en formato AAAAMMDD a tipo DATE
    SET @FechaIni = CONVERT(DATE, @FechaInicial, 112);
    SET @FechaFin = CONVERT(DATE, @FechaFinal, 112);

    -- Calcular diferencia en días
    SET @Edad = DATEDIFF(DAY, @FechaIni, @FechaFin);

    -- Calcular unidades basado en la opción
    IF @Opciones = 'D'
    BEGIN
        SET @UnidadEdad = CAST(@Edad AS VARCHAR);
    END
    ELSE IF @Opciones = 'M'
	BEGIN
        -- Calcular edad en meses
        SET @UnidadEdad = CAST(DATEDIFF(MONTH, @FechaIni, @FechaFin) AS VARCHAR);
    END
    ELSE IF @Opciones = 'A'
    BEGIN
        -- Calcular edad en años
        SET @UnidadEdad = CAST(DATEDIFF(YEAR, @FechaIni, @FechaFin) - (CASE WHEN DATEADD(YY, DATEDIFF(YEAR, @FechaIni, @FechaFin), @FechaIni) > @FechaFin THEN 1 ELSE 0 END) AS VARCHAR);
    END
    BEGIN
        SET @UnidadEdad = 'Opción inválida';
    END

    RETURN @UnidadEdad;
END;
