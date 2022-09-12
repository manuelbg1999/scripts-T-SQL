USE SismaSalud

DROP TABLE sis_cama_copia_elias_morelos

--Se crea una copia de todas las camas que hay en el sistema
SELECT * INTO sis_cama_copia_elias_morelos FROM sis_cama

DROP TABLE #codigosCamasRepetidas

/*
	Consulta para obtener los codigos de las camas que aparecen más de una vez 
	y la cantidad de veces que salen sin importar si tienen pacientes acostados o no y 
	sin importar el estado de la cama
*/
SELECT COUNT(codigo) AS CantidadCamasRepetidas, 
codigo AS CodigoCama
INTO #codigosCamasRepetidas
FROM sis_cama
GROUP BY codigo
HAVING COUNT(codigo) > 1 

--Consulta para obtener las camas duplicadas que no tienen pacientes acostados
SELECT ccr.CantidadCamasRepetidas,scm.* FROM sis_cama AS scm
INNER JOIN #codigosCamasRepetidas AS ccr ON ccr.CodigoCama = scm.codigo
where scm.estudio_paciente = -1

--Consulta para obtener las camas con pacientes en el mismo punto de atención
SELECT * FROM sis_cama AS scm
INNER JOIN #codigosCamasRepetidas AS ccr ON ccr.CodigoCama = scm.codigo
INNER JOIN sis_maes AS sm ON sm.con_estudio = scm.estudio_paciente and sm.PuntoAtencion = scm.PuntoAtencion
ORDER BY scm.codigo DESC

--Consulta para obtener las camas con pacientes en diferentes puntos de atención
SELECT * FROM sis_cama AS scm
INNER JOIN #codigosCamasRepetidas AS ccr ON ccr.CodigoCama = scm.codigo
INNER JOIN sis_maes AS sm ON sm.con_estudio = scm.estudio_paciente and sm.PuntoAtencion <> scm.PuntoAtencion
ORDER BY scm.codigo DESC

