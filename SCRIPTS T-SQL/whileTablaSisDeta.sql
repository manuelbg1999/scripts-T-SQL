SELECT * INTO #resultadosConsultaSisDeta FROM resultadosConsultaSisDeta

DECLARE @estudio VARCHAR(MAX)
DECLARE @ufuncional VARCHAR(MAX)
DECLARE @consecutivo VARCHAR(MAX)
DECLARE @sql_sis_maes NVARCHAR(MAX)
DECLARE @sql_hcingres NVARCHAR(MAX)
DECLARE @sql_sis_paci NVARCHAR(MAX)
DECLARE @sql NVARCHAR(MAX)
WHILE(SELECT COUNT(*) FROM #resultadosConsultaSisDeta )>0
BEGIN
	SELECT TOP 1 @consecutivo = id, @estudio=estudio,@ufuncional = ufuncional FROM #resultadosConsultaSisDeta

	IF(@ufuncional = '1')--001
		BEGIN
			SET @sql_sis_maes = 'UPDATE sis_maes SET ufuncional = 30345 WHERE con_estudio='''+@estudio+''''
			PRINT @sql_sis_maes
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

		DELETE FROM #resultadosConsulta WHERE con_estudio = @estudio
END

DROP TABLE #resultadosConsulta
