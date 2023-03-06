USE Reportes
GO
TRUNCATE TABLE Reportes.dbo.ResultadosLaboratorio
GO
INSERT INTO 
	Reportes.dbo.ResultadosLaboratorio (
	TipoCodigo,
	NumeroCodigo,
	Secuencia,
	CodigoTipoF,
	NumeroTipoF,
	Fecha,
	CodigoUsuario,
	CodigoArticulo,
	CodigoParametro,
	Observacion,
	Referencia,
	Parametro,
	Articulo
	)
SELECT
	 TMRESULTADOSLABORATORIOD.RL2_COD_TIPO
	,TMRESULTADOSLABORATORIOD.RL2_COD_NUM
	,TMRESULTADOSLABORATORIOD.RL2_SEQ
	,TMRESULTADOSLABORATORIOD.RL2_COD_TIPO_F
	,TMRESULTADOSLABORATORIOD.RL2_COD_NUM_F
	,CONVERT(DATE, CONVERT(VARCHAR(8), TMRESULTADOSLABORATORIOD.RL2_FCH_F))
	,CONVERT(VARCHAR,CONVERT(BIGINT,TMRESULTADOSLABORATORIOD.RL2_COD_COD))
	,TMRESULTADOSLABORATORIOD.RL2_COD_ARTIC
	,TMRESULTADOSLABORATORIOD.RL2_COD_PARA
	,TMRESULTADOSLABORATORIOD.RL2_OBS
	,TMRESULTADOSLABORATORIOD.RL2_OBS_REF
	,TMRESULTADOSLABORATORIOD.RL2_NOM_PARAM
	,TMRESULTADOSLABORATORIOD.RL2_NOM_ARTIC
FROM BETANIA.dbo.TMRESULTADOSLABORATORIOD
WHERE TMRESULTADOSLABORATORIOD.RL2_COD_TIPO IN ('RL','RL8')