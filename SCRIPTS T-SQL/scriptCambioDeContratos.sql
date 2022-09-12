USE SismaSalud

IF OBJECT_ID ('dbo.resultadosConsultaSisDeta') IS NOT NULL
	DROP TABLE dbo.resultadosConsultaSisDeta
GO
CREATE TABLE dbo.resultadosConsultaSisDeta(
	id         INT IDENTITY(1,1) NOT NULL,
	estudio    BIGINT NOT NULL,
	ufuncional VARCHAR (max) NOT NULL
	);
GO
IF OBJECT_ID ('dbo.resultadosConsulta') IS NOT NULL
	DROP TABLE dbo.resultadosConsulta
GO

SELECT sm.contrato,sm.con_estudio,sm.ufuncional,hci.nro_historia,sm.autoid,spa.NombreCompleto INTO resultadosConsulta FROM sis_maes sm
INNER JOIN sis_cama sc ON sc.estudio_paciente = sm.con_estudio
INNER JOIN hcingres hci ON hci.con_estudio = sm.con_estudio 
INNER JOIN sis_paci spa ON spa.autoid = sm.autoid
WHERE sc.estudio_paciente <> -1 
AND sc.estudio_paciente IS NOT NULL 
AND sm.contrato IN ('101','100')
AND sm.ufuncional 
IN ('1','30212','30213','30328','30329','30330','30331','30332','30334',
'30335','30337','30338','30339','30340','30341','30342','30343','30344')

INSERT INTO resultadosConsultaSisDeta 
SELECT rc.con_estudio,sd.ufuncional  FROM resultadosConsulta rc
INNER JOIN sis_deta sd ON sd.estudio =  rc.con_estudio and sd.ufuncional = rc.ufuncional

SELECT * INTO #resultadosConsulta FROM resultadosConsulta

DECLARE @estudio VARCHAR(MAX)
DECLARE @contrato VARCHAR(MAX)
DECLARE @autoid VARCHAR(MAX)
DECLARE @ufuncional VARCHAR (MAX)
DECLARE @sql_sis_maes NVARCHAR(MAX)
DECLARE @sql_hcingres NVARCHAR(MAX)
DECLARE @sql_sis_paci NVARCHAR(MAX)

WHILE (SELECT COUNT(*) FROM #resultadosConsulta)>0
BEGIN
	SELECT TOP 1 @estudio=con_estudio,@contrato = contrato,@autoid = autoid,@ufuncional = ufuncional FROM #resultadosConsulta
	IF (@contrato = '101')
	BEGIN 
		IF(@ufuncional = '1')--001
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30345 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30212')--422
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30345 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30213')--423
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30328')--600
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30345 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30329')--601
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30330')--602
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30331')--603
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes set contrato = 112 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres set contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci set contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30332')--604
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30334')--605
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30346 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30335')--606
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30337')--607
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			print @sql_sis_paci
		END
		IF(@ufuncional = '30338')--608
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30346 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30339')--609
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30340')--610
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30341')--611
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30343')--613
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30345 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30344')--614
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 112 ufuncional = 30345 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 112 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 112 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
	END
	ELSE 
	BEGIN
	IF (@contrato = '100')
	BEGIN
		IF(@ufuncional = '1')--001
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30345 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30212')--422
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30345 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30213')--423
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30328')--600
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30345 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30329')--601
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30330')--602
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30331')--603
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30332')--604
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30334')--605
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30346 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30335')--606
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30337')--607
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30338')--608
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30346 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30339')--609
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30340')--610
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30347   WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30341')--611
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30347 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30343')--613
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30345 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
		IF(@ufuncional = '30344')--614
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET contrato = 111 ufuncional = 30345 WHERE con_estudio='''+@estudio+''''
			SET @sql_hcingres = 'UPDATE hcingres SET contrato = 111 WHERE con_estudio='''+@estudio+''''
			SET @sql_sis_paci = 'UPDATE sis_paci SET contrato = 111 WHERE autoid='''+@autoid+''''
			PRINT @sql_sis_maes
			PRINT @sql_hcingres
			PRINT @sql_sis_paci
		END
	END
END
	DELETE FROM #resultadosConsulta WHERE con_estudio = @estudio
END 

DROP TABLE #resultadosConsulta

