CREATE DATABASE Reportes
ON Primary
(NAME=ReportesPrimary, FILENAME="D:\DatosSQL\Reportes.mdf", SIZE=50MB, FILEGROWTH=25%)
LOG ON 
(NAME=ReportesLog, FILENAME="D:\DatosSQL\ReportesLog.ldf", SIZE=25MB, FILEGROWTH=25%)