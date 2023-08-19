-- ================================================
-- Descripción: Calcula el ciclo de vida basado en fechas
-- ================================================
USE
BETANIA
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUC_CALCULAR_CICLO_VIDA]')
AND type in (N'FN', N'IF',N'TF', N'FS', N'FT'))
DROP FUNCTION dbo.FUC_CALCULAR_CICLO_VIDA
GO
CREATE FUNCTION dbo.FUC_CALCULAR_CICLO_VIDA (
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

    -- Definir ciclos de vida y retornar el ciclo correspondiente
    DECLARE @CicloVida VARCHAR(50);

    IF @Edad >= 0 AND @Edad <= 5
        SET @CicloVida = 'Primera Infancia';
    ELSE IF @Edad >= 6 AND @Edad <= 11
        SET @CicloVida = 'Infancia';
    ELSE IF @Edad >= 12 AND @Edad <= 17
        SET @CicloVida = 'Adolescencia';
    ELSE IF @Edad >= 18 AND @Edad <= 28
        SET @CicloVida = 'Juventud';
    ELSE IF @Edad >= 29 AND @Edad <= 59
        SET @CicloVida = 'Adultez';
    ELSE
        SET @CicloVida = 'Vejez';

    RETURN @CicloVida;
END;
