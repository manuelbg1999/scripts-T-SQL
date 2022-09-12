DECLARE @CANTIDAD1 AS INT 
DECLARE @CANTIDAD2 AS INT 

SELECT @CANTIDAD1 =  count(codigo) from sis_cama 
SELECT @CANTIDAD2 =  count(distinct codigo) from sis_cama 

DECLARE @RESULTADO AS INT 

SET @RESULTADO = @CANTIDAD1 - @CANTIDAD2

PRINT 'CANTIDAD DE CAMAS DUPLICADAS: '+CONVERT(VARCHAR,@RESULTADO)

SELECT * FROM sis_cama u
    WHERE codigo IN (
        SELECT codigo FROM sis_cama 
            GROUP BY codigo
            HAVING COUNT(*)>1
    );