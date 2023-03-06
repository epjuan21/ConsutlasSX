USE
Reportes
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[F_RESULTADO_LABORATORIO]')
AND type in (N'FN', N'IF',N'TF', N'FS', N'FT'))
DROP FUNCTION dbo.F_RESULTADO_LABORATORIO
GO
CREATE FUNCTION dbo.F_RESULTADO_LABORATORIO (@Codigo AS VARCHAR(20),@FechaInicial VARCHAR(8), @FechaFinal VARCHAR(8), @CUPS VARCHAR(7), @Parametro VARCHAR(3))
RETURNS TABLE
AS
RETURN
	(
	SELECT
		 ResultadosLaboratorio.Observacion Resultado
		,ResultadosLaboratorio.Fecha Fecha
	FROM
	ResultadosLaboratorio

	WHERE 
	ResultadosLaboratorio.CodigoUsuario = @Codigo
	AND ResultadosLaboratorio.CodigoArticulo IN (@CUPS)
	AND ResultadosLaboratorio.CodigoParametro IN (@Parametro)
	AND ResultadosLaboratorio.Fecha BETWEEN @FechaInicial AND @FechaFinal
	AND ResultadosLaboratorio.Observacion IS NOT NULL
);
GO
SELECT TOP 1 Resultado, Fecha FROM dbo.F_RESULTADO_LABORATORIO('569557','20210101','20230228','*907106','152') ORDER BY Fecha DESC
