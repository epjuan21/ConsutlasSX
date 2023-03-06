USE Reportes
GO
IF OBJECT_ID('dbo.ResultadosLaboratorio', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.ResultadosLaboratorio
END
Create TABLE ResultadosLaboratorio(
	Id INT IDENTITY(1,1) NOT NULL,
	TipoCodigo VARCHAR(3) NOT NULL,
	NumeroCodigo DECIMAL(10,0) NOT NULL,
	Secuencia DECIMAL(5,0) NOT NULL,
	CodigoTipoF VARCHAR(3) NULL,
	NumeroTipoF DECIMAL(10,0) NOT NULL,
	Fecha DATE NULL,
	CodigoUsuario VARCHAR(14) NULL,
	CodigoArticulo VARCHAR(20) NULL,
	CodigoParametro VARCHAR(6) NULL,
	Observacion VARCHAR(100) NULL,
	Referencia VARCHAR(100) NULL,
	Parametro VARCHAR(100) NULL,
	Articulo VARCHAR(100) NULL
)
-- CONSULTAR DATOS
SELECT TOP 100 * FROM ResultadosLaboratorio

-- CREAR INDICE AGUPADO
CREATE CLUSTERED INDEX Idx_CodigoUsuario
ON ResultadosLaboratorio (CodigoUsuario);

-- CREAR INDICES NO AGRUPADO
CREATE INDEX Idx_CodigoArticulo
ON ResultadosLaboratorio (CodigoArticulo);

CREATE INDEX Idx_CodigoParametro
ON ResultadosLaboratorio (CodigoParametro) INCLUDE(Observacion);

-- Verificar Indices de la Tabla
SELECT * 
FROM sys.indexes 
WHERE object_id = OBJECT_ID('dbo.ResultadosLaboratorio');
GO
-- Otra Forma
sp_helpindex ResultadosLaboratorio

-- Conocer Fragmentación de la Tabla y Sus Indices
DBCC SHOWCONTIG('dbo.ResultadosLaboratorio')
/*
	Tener en Cuenta
	Scan Density [Best Count:Actual Count].......: 99.80% [2495:2500]
	Avg. Page Density (full).....................: 99.01%
*/

-- Borrar Planes de Ejecución de la Memoria Cache
DBCC FREEPROCCACHE WITH NO_INFOMSGS
DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS
DBCC FREESYSTEMCACHE('ALL')