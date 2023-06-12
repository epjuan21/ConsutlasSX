-- Obtener Ultima Tarifas de Todos los Articulos de la Tabla TMTARIFAARTICULO
WITH CTE_TARIFAS AS (
	SELECT 
		 TRF_TARIFA Tarifa
		,TRF_ARTIC Articulo
		,TRF_FCH Fecha
		,TRF_VALOR Valor
        ,DENSE_RANK() OVER (PARTITION BY TRF_ARTIC ORDER BY TRF_FCH DESC) AS Ranking
FROM TMTARIFAARTICULO
)
SELECT 
	 CTE_TARIFAS.Tarifa
	,CTE_TARIFAS.Articulo
	,CTE_TARIFAS.Fecha
	,CTE_TARIFAS.Valor
	,CTE_TARIFAS.Ranking
FROM CTE_TARIFAS
WHERE CTE_TARIFAS.Ranking = 1
AND Tarifa = '01'