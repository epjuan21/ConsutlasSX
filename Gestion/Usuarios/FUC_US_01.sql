/*
	Obtiene
		Datos básico de Usuarios
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
	
	Parámetros
		Código Usuario
		
	Tipos de Historia Clínica
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

	,dbo.FUX_CALCULAR_EDAD(dbo.TKCLIENTES.KC_FCH_NACE,CONVERT(VARCHAR(8),SYSDATETIME(),112),'N')AS EdadActual
	,dbo.FUX_CALCULAR_EDAD(dbo.TKCLIENTES.KC_FCH_NACE, CONVERT(VARCHAR(8), SYSDATETIME(), 112), 'U') AS UnidadEdad

	,ISNULL(dbo.TMUSUARIOSFACTURACION.KC2_SEXO, '') AS Sexo

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