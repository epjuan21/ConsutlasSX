/*
	Obtiene
		Datos b�sico de Usuarios
		Codigo
		Tipo de Documento
		Primer Nombre
		Segundo Nombre
		Primer Apellido
		Segundo Apellido
		Fecha de Nacimiento en Formato AAAAMMDD
		Fecha de Nacimiento en Formato AAAA-MM-DD
		Fecha de Nacimiento en Formato DD/MM/AAAA
		Fecha de Nacimiento en Foramto DD-MM-AAA
		Edad Actual
		Unidad Edad
		Sexo
		Regimen
		Direccion
		Telefono
		Codigo Etnia
		Grupo Poblacional
		Raza
		Codigo Entidad
		Codigo Supersalud Entidad
		Nombre Entidad
	
	Par�metros
		C�digo Usuario
		
	Tipos de Historia Cl�nica
		No Aplica
	
	Codigo Parametro Laboratorio
		No Aplica
	
	CUPS
		No Aplica
	
	Usada en
		F:\Mi unidad\SX-CONSULTAS\Farmacia.xlsm
*/

USE
BETANIA
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUC_US_01]')
AND type in (N'FN', N'IF',N'TF', N'FS', N'FT'))
DROP FUNCTION dbo.FUC_US_01
GO
CREATE FUNCTION dbo.FUC_US_01 (@Codigo AS VARCHAR(20))
RETURNS TABLE
AS
RETURN
(
	SELECT
	CONVERT(BIGINT,dbo.TKCLIENTES.KC_COD,0) AS Codigo
	,ISNULL(TMUSUARIOSFACTURACION.KC2_TIPO_DOCTO, '') AS TipoDocumento

	--NOMBRES Y APELLIDOS
	,dbo.TMUSUARIOSFACTURACION.KC2_PNOMBRE AS PrimerNombre
	,dbo.TMUSUARIOSFACTURACION.KC2_SNOMBRE AS SegundoNombre
	,dbo.TMUSUARIOSFACTURACION.KC2_PAPELLIDO AS PrimerApellido
	,dbo.TMUSUARIOSFACTURACION.KC2_SAPELLIDO AS SegundoApellido

	,dbo.TKCLIENTES.KC_FCH_NACE AS FechaNacimiento
	,CONVERT(VARCHAR,CAST(CONVERT(VARCHAR, dbo.TKCLIENTES.KC_FCH_NACE, 112) AS DATE),23) AS FechaNacimiento_23
	,CONVERT(VARCHAR,CAST(CONVERT(VARCHAR, dbo.TKCLIENTES.KC_FCH_NACE, 112) AS DATE),103) AS FechaNacimiento_103
	,CONVERT(VARCHAR,CAST(CAST(KC_FCH_NACE AS VARCHAR) AS DATE),105) AS FechaNacimiento_105

	,dbo.FUX_CALCULAR_EDAD(dbo.TKCLIENTES.KC_FCH_NACE, CONVERT(VARCHAR(8), SYSDATETIME(), 112), 'N') AS EdadActual
	,dbo.FUX_CALCULAR_EDAD(dbo.TKCLIENTES.KC_FCH_NACE, CONVERT(VARCHAR(8), SYSDATETIME(), 112), 'U') AS UnidadEdad
	,dbo.FUC_CALCULAR_EDAD(dbo.TKCLIENTES.KC_FCH_NACE, CONVERT(VARCHAR(8), SYSDATETIME(), 112), 'A') AS EdadA�os
	,dbo.FUC_CALCULAR_EDAD(dbo.TKCLIENTES.KC_FCH_NACE, CONVERT(VARCHAR(8), SYSDATETIME(), 112), 'M') AS EdadMeses
	,dbo.FUC_CALCULAR_EDAD(dbo.TKCLIENTES.KC_FCH_NACE, CONVERT(VARCHAR(8), SYSDATETIME(), 112), 'D') AS EdadDias
	,dbo.FUC_CALCULAR_UNIDAD_EDAD(dbo.TKCLIENTES.KC_FCH_NACE, CONVERT(VARCHAR(8), SYSDATETIME(), 112)) AS Unidad

	-- Grupos Quinquenales, Ciclos de Vida y Fecuencias
	,dbo.FUC_CALCULAR_GRUPO_EDAD(dbo.TKCLIENTES.KC_FCH_NACE, CONVERT(VARCHAR(8), SYSDATETIME(), 112)) AS GruposQuinquenales
	,dbo.FUC_CALCULAR_CICLO_VIDA(dbo.TKCLIENTES.KC_FCH_NACE, CONVERT(VARCHAR(8), SYSDATETIME(), 112)) AS CicloVida
	,dbo.FUC_CALCULAR_FRECUENCIAS_EDAD(dbo.TKCLIENTES.KC_FCH_NACE, CONVERT(VARCHAR(8),SYSDATETIME(), 112)) AS FrecuenciaEdad

	,ISNULL(dbo.TMUSUARIOSFACTURACION.KC2_SEXO, '') AS Sexo

	,ISNULL(dbo.TKCLIENTES.KC_DIR1,'') AS Direccion
	,ISNULL(REPLACE(dbo.TKCLIENTES.KC_TEL1,' ',''),'') AS Telefono

	,(CASE ISNULL(dbo.TMUSUARIOSFACTURACION.KC2_COD_ETNIA, '0')
		WHEN '0' THEN '6'
		WHEN '1' THEN '1'
		WHEN '2' THEN '2'
		WHEN '3' THEN '3'
		WHEN '4' THEN '4'
		WHEN NULL THEN '6'
		END) AS CodigoEtnia

	,(CASE dbo.TMUSUARIOSFACTURACION.KC2_COD_ETNIA
		WHEN '0' THEN 'Ninguno'
		WHEN '1' THEN 'Indigena'
		WHEN '2' THEN 'ROM (Gitano)'
		WHEN '3' THEN 'Raizal'
		WHEN '4' THEN 'Palenquero de San Basilio'
		WHEN '5' THEN 'Negro, Mulato, Afrocolmobiano o Afrodescendiente'
		WHEN '6' THEN 'Ninguno'
		WHEN NULL THEN 'Ninguno'
	END) AS Etnia

	,CASE TMUSUARIOSFACTURACION.KC2_ESTADO_CIVIL 
		WHEN 'S' THEN 'Soltero'
		WHEN 'C' THEN 'Casado'
		WHEN 'V' THEN 'Viudo'
		WHEN 'U' THEN 'Union Libre'
		WHEN 'D' THEN 'Divorciado'
		WHEN '' THEN 'Sin Dato'
		WHEN NULL THEN 'Sin Dato'
		ELSE 'Sin Dato'
	END AS EstadoCivil

	,(CASE dbo.TMUSUARIOSFACTURACION.KC2_GRUPO_ATENCION
		WHEN 'A' THEN 'Indigente'
		WHEN 'B' THEN 'Desmovilizado'
		WHEN 'I' THEN 'Indigena'
		WHEN 'D' THEN 'Desplazado'
		WHEN 'O' THEN 'Otro'
		WHEN 'N' THEN 'Negro'
		WHEN '2' THEN 'ROM (Gitano)'
		WHEN '3' THEN 'Raizal'
		WHEN '4' THEN 'Palenquero de San Basilio'
		WHEN '6' THEN 'Otras Etnias'
	END) AS GrupoPoblacional

	,(CASE dbo.TMUSUARIOSFACTURACION.KC2_GRUPO_ATENCION
		WHEN 'A' THEN 'Blanco'
		WHEN 'B' THEN 'Blanco'
		WHEN 'I' THEN 'Indigena'
		WHEN 'D' THEN 'Blanco'
		WHEN 'O' THEN 'Blanco'
		WHEN 'N' THEN 'Negro'
		WHEN '2' THEN 'ROM (Gitano)'
		WHEN '3' THEN 'Raizal'
		WHEN '4' THEN 'Palenquero de San Basilio'
		WHEN '6' THEN 'Blanco'
	END) AS Raza

	,(CASE ISNULL(dbo.TMUSUARIOSFACTURACION.KC2_ESCOLARIDAD,'')
		WHEN 'A' THEN 'A-PREESCOLAR'
		WHEN '2' THEN '2-PRIMARIA'
		WHEN '3' THEN '3-SECUNDARIA BASICA'
		WHEN 'B' THEN 'B-MEDIA ACADEMICA'
		WHEN 'C' THEN 'C-MEDIA TECNICA'
		WHEN 'D' THEN 'D-NORMALISTA'
		WHEN 'F' THEN 'F-TECNICA PROFESIONAL'
		WHEN 'G' THEN 'G-TECNOLOGIA'
		WHEN '4' THEN '4-PROFESIONAL'
		WHEN '5' THEN '5-ESPECIALIZACION'
		WHEN 'H' THEN '5-MAESTRIA'
		WHEN 'I' THEN 'I-DOCTORADO'
		WHEN '1' THEN '1-NINGUNO'
		WHEN '' THEN ''
	END) AS NivelEducativo

	,(CASE ISNULL(dbo.TMUSUARIOSFACTURACION.KC2_ESCOLARIDAD,'')
			WHEN 'A' THEN '1'
			WHEN '2' THEN '2'
			WHEN '3' THEN '3'
			WHEN 'B' THEN '4'
			WHEN 'C' THEN '5'
			WHEN 'D' THEN '6'
			WHEN 'F' THEN '7'
			WHEN 'G' THEN '8'
			WHEN '4' THEN '9'
			WHEN '5' THEN '10'
			WHEN 'H' THEN '11'
			WHEN 'I' THEN '12'
			WHEN '1' THEN '13'
			WHEN '' THEN '13'
			ELSE '13'
	 END) AS CodigoNivelEducativo

	,TMUSUARIOSFACTURACION.KC2_OCUPACION_NV AS Ocupacion

	,(CASE TMENTIDADES.ENT_TIPO 
		WHEN '1' THEN 'Contributivo' 
		WHEN '2' THEN 'Subsidiado' 
		WHEN '3' THEN 'Vinculado' 
		WHEN '4' THEN 'Particular'
		WHEN '5' THEN 'Otro' 
		WHEN '6' THEN 'Otro' 
		WHEN '7' THEN 'Otro' 
		WHEN '8' THEN 'Otro' 
		WHEN '9' THEN 'Otro'
		WHEN 'A' THEN 'Otro' 
		WHEN 'B' THEN 'Otro'
		WHEN NULL THEN 'Otro'
	WHEN 'C' THEN 'Otro' END) AS Regimen

	,dbo.TMUSUARIOSFACTURACION.KC2_EPS_POS AS CodigoEntidad
	,dbo.TMENTIDADES.ENT_COD_SUPER AS CodigoSupersalud
	,dbo.TMENTIDADES.ENT_NOMBRE AS NombreEntidad

	FROM TKCLIENTES

	LEFT JOIN

	dbo.TMUSUARIOSFACTURACION ON (dbo.TMUSUARIOSFACTURACION.KC2_ZONA = dbo.TKCLIENTES.KC_ZONA AND
	dbo.TMUSUARIOSFACTURACION.KC2_COD = dbo.TKCLIENTES.KC_COD AND
	dbo.TMUSUARIOSFACTURACION.KC2_SEQK = dbo.TKCLIENTES.KC_SEQK)

	LEFT JOIN TMENTIDADES ON (TMENTIDADES.ENT_COD = TMUSUARIOSFACTURACION.KC2_EPS_POS)
	
	WHERE CONVERT(BIGINT, dbo.TKCLIENTES.KC_COD) = @Codigo
	
	AND KC_ZONA = '99'
	
);
GO
SELECT * FROM dbo.FUC_US_01('594607')

SELECT TipoDocumento, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, FechaNacimiento, FechaNacimiento_23, FechaNacimiento_103, FechaNacimiento_105, EdadActual, UnidadEdad, EdadA�os, EdadMeses, EdadDias, Unidad, GruposQuinquenales, CicloVida, FrecuenciaEdad, Sexo, Telefono, CodigoEtnia, Etnia, EstadoCivil, GrupoPoblacional, Raza, NivelEducativo, CodigoNivelEducativo, Ocupacion, Regimen, CodigoEntidad, CodigoSupersalud, NombreEntidad FROM dbo.FUC_US_01('594607')
