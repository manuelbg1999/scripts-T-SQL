USE [SismaSalud]

DECLARE @aux1 as int
DECLARE @aux2 as int
DECLARE @aux3 as int

SELECT @aux1 =  COUNT(*) FROM [SismaSalud].[dbo].[sis_pabellon] WHERE [nombre] LIKE '2009%'

SELECT * INTO pabellonesCopia FROM [SismaSalud].[dbo].[sis_pabellon] WHERE [nombre] LIKE '2009%' 

BEGIN TRAN 
	DELETE FROM [SismaSalud].[dbo].[sis_pabellon] WHERE [nombre] LIKE '2009%' 
IF @@ROWCOUNT = @aux1 
	COMMIT TRAN
ELSE
	ROLLBACK TRAN

SELECT @aux2 = COUNT(*) FROM [SismaSalud].[dbo].[sis_cama] WHERE PuntoAtencion = '2009'

SELECT * INTO sisCamasCopiaPuntoAtencion2009 FROM [SismaSalud].[dbo].[sis_cama] WHERE PuntoAtencion = '2009'

SELECT codigo INTO #temporal FROM [SismaSalud].[dbo].[sis_cama] WHERE PuntoAtencion = '2009'

BEGIN TRAN
	DELETE FROM [SismaSalud].[dbo].[sis_cama] WHERE PuntoAtencion = '2009'
IF @@ROWCOUNT = @aux2
	COMMIT TRAN
ELSE 
	ROLLBACK TRAN

SELECT @aux3 = COUNT(*) FROM [SismaSalud].[dbo].[camas_manuales] 
WHERE codigo_cama IN (SELECT codigo FROM #temporal)

SELECT * INTO camasManualesCopia FROM [SismaSalud].[dbo].[camas_manuales] 
WHERE codigo_cama IN (SELECT codigo FROM #temporal)

BEGIN TRAN
	DELETE FROM [SismaSalud].[dbo].[camas_manuales] 
	WHERE codigo_cama IN (SELECT codigo FROM  #temporal)

IF @@ROWCOUNT = @aux3
	COMMIT TRAN
ELSE
	ROLLBACK
	  

