/*
	Obtener Diagn�sticos
	Seg�n N�mero de Documento, Fecha Inicial, Fecha Final, Listado Diagnosticos
*/

USE
BETANIA
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUC_DX_01]')
AND TYPE IN (N'FN', N'IF',N'TF', N'FS', N'FT'))
DROP FUNCTION dbo.FUC_DX_01
GO
CREATE FUNCTION dbo.FUC_DX_01 
(
    @Codigo AS VARCHAR(20), 
    @FechaInicial AS VARCHAR(8), 
    @FechaFinal AS VARCHAR(8),
    @CodigosCIE10 AS VARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
(
	SELECT
		 TQMOVIMIENTOHC.QM1_COD Codigo

		-- Signos Vitales
		,CONVERT(INT,TQMOVIMIENTOHC.QM1_NUM_PESO) Peso
		,TQMOVIMIENTOHC.QM1_COD_UNIPESO UnidadPeso
		,CASE
			WHEN TQMOVIMIENTOHC.QM1_COD_UNIPESO = 'G' THEN CONVERT(INT,TQMOVIMIENTOHC.QM1_NUM_PESO) / 1000
			ELSE CONVERT(INT,TQMOVIMIENTOHC.QM1_NUM_PESO)
		END PesoKg
		,TQMOVIMIENTOHC.QM1_TALLA_CM AS Talla	

		,TQMOVIMIENTOHC.QM1_EST_ARTE_S PresionSistolica
		,TQMOVIMIENTOHC.QM1_EST_ARTE_D PresionDiastolica

		-- Diagn�stico - Otros Datos del Diagn�stico
		,TQMOVIMIENTOHC.QM1_COD_DXPP DiagnosticoPrincipal
		,TQMOVIMIENTOHC.QM1_COD_DXR1 DiagnosticoRelacionado1
		,TQMOVIMIENTOHC.QM1_COD_DXR2 DiagnosticoRelacionado2
		,TQMOVIMIENTOHC.QM1_COD_DXR3 DiagnosticoRelacionado3
		,TQMOVIMIENTOHC.QM1_TIPO_DIAG TipoDiagnostico
		,TQMOVIMIENTOHC.QM1_TIPO_DISCAP TipoDiscapacidad
		,TQMOVIMIENTOHC.QM1_GRADO_DISCAP GradoDiscapacidad

		-- Diagn�stico - Finalidad/Causa
		,TQMOVIMIENTOHC.QM1_EST_FINACON Finalidad
		,TQMOVIMIENTOHC.QM1_EST_CAUSAEXT CausaExterna
		,TQMOVIMIENTOHC.QM1_EST_SINTRESP SintomaticoRespiratorio

		,[QM1_EDAD_DIAS] EdadDias
		,[QM1_EDAD_MESES] EdadMeses
		,CONVERT(INT,[QM1_EDAD_ANOS],0) Edad

		,CONVERT(VARCHAR,CAST(CAST(TQMOVIMIENTOHC.QM1_FCH_FECHA AS VARCHAR) AS DATE),23) FechaAtencion
		,TMMEDICOS.MED_NOMBRE Responsable
		
		,TQMOVIMIENTOHC.QM1_COD_TIPOATEN TipoAtencion
		,TQCONFIGURARHC.QP1_NOM NombreAtencion
		,TQMOVIMIENTOHC.QM1_NUM_CONSE Consecutivo

	FROM 
		TQMOVIMIENTOHC

	LEFT JOIN TMMEDICOS
	ON TQMOVIMIENTOHC.QM1_NUM_MED = TMMEDICOS.MED_COD

	LEFT JOIN TQCONFIGURARHC 
	ON TQCONFIGURARHC.QP1_COD_ESP = TQMOVIMIENTOHC.QM1_COD_ESP AND TQCONFIGURARHC.QP1_COD_TIPOATEN = TQMOVIMIENTOHC.QM1_COD_TIPOATEN

	WHERE
		CONVERT(BIGINT,TQMOVIMIENTOHC.QM1_COD) = @Codigo
		AND TQMOVIMIENTOHC.QM1_FCH_FECHA BETWEEN @FechaInicial AND @FechaFinal
		AND TQMOVIMIENTOHC.QM1_NUM_PESO IS NOT NULL
		AND TQMOVIMIENTOHC.QM1_FCH_FECHA <> 0
		AND TQMOVIMIENTOHC.QM1_EST_ANULADO IS NULL
		AND TQMOVIMIENTOHC.QM1_COD_TIPOATEN NOT IN ('X01M','X03','X04','X05','X07','X05P','X05U','X23A','X24','X24O','X27A','X30A','X31A','X31N','X32A','X33A','X33P','X35','X36','X41D','X41E','X41T')
        AND (TQMOVIMIENTOHC.QM1_COD_DXPP IN (SELECT value FROM SplitString(@CodigosCIE10, ','))
             OR TQMOVIMIENTOHC.QM1_COD_DXR1 IN (SELECT value FROM SplitString(@CodigosCIE10, ','))
             OR TQMOVIMIENTOHC.QM1_COD_DXR2 IN (SELECT value FROM SplitString(@CodigosCIE10, ','))
             OR TQMOVIMIENTOHC.QM1_COD_DXR3 IN (SELECT value FROM SplitString(@CodigosCIE10, ','))
            )
);

GO
SELECT DiagnosticoPrincipal, DiagnosticoRelacionado1, DiagnosticoRelacionado2, DiagnosticoRelacionado3, EdadDias, EdadMeses, Edad, FechaAtencion, Responsable, TipoAtencion, NombreAtencion, Consecutivo FROM dbo.FUC_DX_01('568236','20130101', '20230630', 'E785,E784,E780,E781,E782,E783,E782,E785,E786') ORDER BY FechaAtencion DESC

--SELECT * FROM TQMOVIMIENTOHC WHERE QM1_COD LIKE '%3369230%' AND QM1_NUM_CONSE = 22 ORDER BY QM1_FCH_FECHA DESC