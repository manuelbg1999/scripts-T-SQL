USE [SismaSalud2022]
GO
/****** Object:  StoredProcedure [dbo].[spSolicitudesEquipoBiomedico]    Script Date: 30/07/2022 9:31:39 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spSolicitudesEquipoBiomedico]
@Op VARCHAR(50),
@NumeroOrden INT=0,
@Estudio INT = 0 ,
@Consecutivo INT = 0,
@Medico INT = 0,
@xmlEquipos XML = NULL,
@SolicitudId INT = NULL OUTPUT ,
@Debug AS BIT = 0,
@puntoate int=0,
@observacion varchar(max)=null,
@manejaLaTransaccion BIT = 1,
@XmlDispensacion XML=NULL
AS
BEGIN
	DECLARE @ERRORMSG VARCHAR(100);
	BEGIN TRY
		IF(@manejaLaTransaccion = 1) BEGIN TRAN

		IF(@Op = 'GenerarSolicitud')
		BEGIN
			DECLARE 
			@EquiposTotales INT,
			@IdCabecera INT

			CREATE TABLE #EquiposBiomedicos(
				id int IDENTITY(1,1),
				idTipoItem INT NOT NULL,
				cantidadItem INT NOT NULL
			)

			IF(@xmlEquipos IS NULL) RAISERROR('No se puede generar una solicitud sin items.',16,1)

			INSERT INTO #EquiposBiomedicos
			SELECT 
				doc.item.value('@codigoEquipoBiomedico','VARCHAR(10)'),
				doc.item.value('@cantidadItem','INT')
			FROM @xmlEquipos.nodes('//item') doc(item)

			if(@Debug = 1) SELECT 'Temp',* FROM #EquiposBiomedicos

			SELECT @EquiposTotales = SUM(cantidadItem) FROM #EquiposBiomedicos

			INSERT INTO Solcitudes_EB (numOrden,Estudio,totalItems,medico,fechaGeneracion,estado,puntoAtencion,observacion)
			SELECT @NumeroOrden,@Estudio,@EquiposTotales,@Medico,GETDATE(),1,@puntoate,@observacion

			SET @IdCabecera = SCOPE_IDENTITY()

			; WITH cte AS (
				SELECT 1 AS num,  idtipoItem, cantidadItem 
				FROM #EquiposBiomedicos
				UNION ALL 
				SELECT num+1, idtipoItem, cantidadItem 
				FROM cte c 
				WHERE c.num < cantidadItem
			) 
			INSERT INTO Detalles_Solcitudes_EB (idSolicitudEB,idTipoItem,numOrden)
			SELECT @IdCabecera,idTipoItem,(select top 1 numorden from Solcitudes_EB where id=@IdCabecera )
			FROM cte
			WHERE 1=1
			ORDER BY idTipoItem

			SET @SolicitudId = @IdCabecera

			IF(@Debug = 1)
			BEGIN
				SELECT 'Cabecera Solicitud' Nombre ,* FROM Solcitudes_EB where Id = @IdCabecera
				SELECT 'Detalle Solicitud' Nombre ,* FROM Detalles_Solcitudes_EB where idSolicitudEB = @IdCabecera
			END
		END

		IF(@Op = 'GetDocumento')
		BEGIN
			SELECT Seb.id,Seb.numOrden,Seb.fechaGeneracion,CONCAT(Usuario.cedula,' - ',Usuario.nombre) UsuarioSolicitud,seb.puntoAtencion,pa.Nombre PAtencion,
			Seb.observacion,Seb.fechaDispensacion,medico.codigo,seb.dispensadototalmente
			FROM Solcitudes_EB Seb
			INNER JOIN sis_medi Medico ON Seb.medico = Medico.codigo
			INNER JOIN usuario Usuario ON Usuario.cedula = Medico.cedula
			left JOIN puntoAtencion Pa ON Pa.Id = Seb.PuntoAtencion
			WHERE (Seb.id = @Consecutivo) 
		END


		IF(@Op = 'GetDocumentoImp')
		BEGIN
			SELECT Seb.id,Seb.numOrden,Seb.fechaGeneracion,CONCAT(Usuario.cedula,' - ',Usuario.nombre) UsuarioSolicitud,seb.puntoAtencion,pa.Nombre PAtencion,
			Seb.observacion,Seb.fechaDispensacion,medico.codigo,seb.dispensadototalmente,Case when seb.fechaDispensacion is not null and seb.totalItems>p.c then 'PARCIALMENTE DISPENSADO' else 
				Case when seb.fechaDispensacion is not null and seb.totalItems=p.c then 'TOTALMENTE DISPENSADO' ELSE
				'NO DISPENSADO' END END as Dispensado,medico.codigo as codmed
			FROM Solcitudes_EB Seb
			INNER JOIN sis_medi Medico ON Seb.medico = Medico.codigo
			INNER JOIN usuario Usuario ON Usuario.cedula = Medico.cedula
			left JOIN puntoAtencion Pa ON Pa.Id = Seb.PuntoAtencion
			outer apply(select top 1 count (*) as c from Novedades_SolicitudesEB seb2 where seb.numOrden=seb2.NumOrden and idItem<>'NE' ) as p
			WHERE (Seb.numOrden = @Consecutivo) 
		END

		IF(@Op = 'GetDetalleDocumento')
		BEGIN
		

		declare @numorden int

		select @numorden=numorden from Solcitudes_EB where id=@Consecutivo
			IF((SELECT COUNT (*) FROM Novedades_SolicitudesEB WHERE NumOrden=@numorden and tipoNovedad='DS')>0  ) BEGIN
		
	

		SELECT Dseb.id,Dseb.idTipoItem,Te.nombre,ns.idItem
			FROM Solcitudes_EB Seb
			INNER JOIN Detalles_Solcitudes_EB Dseb ON Seb.id = Dseb.idSolicitudEB
			INNER JOIN TipoEquipo Te ON Te.id = Dseb.idTipoItem
			LEFT JOIN Novedades_SolicitudesEB ns on ns.idDetalle=Dseb.id
			WHERE Seb.id = @Consecutivo and (ns.tipoNovedad='DS') and (ns.tipoNovedad<>'DV')
			

			END

		ELSE
		BEGIN
			SELECT Dseb.id,Dseb.idTipoItem,Te.nombre,ns.idItem
			FROM Solcitudes_EB Seb
			INNER JOIN Detalles_Solcitudes_EB Dseb ON Seb.id = Dseb.idSolicitudEB
			INNER JOIN TipoEquipo Te ON Te.id = Dseb.idTipoItem
			LEFT JOIN Novedades_SolicitudesEB ns on ns.idDetalle=Dseb.id
			WHERE Seb.id = @Consecutivo and (ns.tipoNovedad='DS' or 1=1) and (ns.tipoNovedad<>'DV' or 1=1)

			END
			
		
		END


IF(@Op = 'GetDetalleDocumento2')
		BEGIN
		

		---IF((SELECT COUNT (*) FROM Novedades_SolicitudesEB WHERE idDetalle=@Consecutivo)>0 ) BEGIN
		

			---END

			---ELSE
			---BEGIN
			--	SELECT Distinct  Dseb.idTipoItem,Te.nombre,ns.idItem
			--FROM Solcitudes_EB Seb
			--INNER JOIN Detalles_Solcitudes_EB Dseb ON Seb.id = Dseb.idSolicitudEB
			--INNER JOIN TipoEquipo Te ON Te.id = Dseb.idTipoItem
			--LEFT join Novedades_SolicitudesEB ns on ns.idDetalle=seb.id
			--WHERE Seb.id = @Consecutivo

			-----END
			--IF((SELECT COUNT (*) FROM Novedades_SolicitudesEB WHERE idDetalle=@Consecutivo )>0) BEGIN
		
	SELECT  Dseb.id,Dseb.idTipoItem,Te.nombre,ns.idItem,EXB.dispensado
			FROM Solcitudes_EB Seb
			INNER JOIN Detalles_Solcitudes_EB Dseb ON Seb.id = Dseb.idSolicitudEB
			INNER JOIN TipoEquipo Te ON Te.id = Dseb.idTipoItem
			LEFT JOIN Novedades_SolicitudesEB ns on ns.idDetalle=Dseb.id
			LEFT JOIN EquipoBiomedico EB on EB.serial=ns.idItem
			LEFT JOIN ExistenciasEquiposBiomedicos EXB on EXB.idEquipoBiomedico=EB.id
			WHERE Seb.id=@Consecutivo and exb.dispensado=1 and (ns.tipoNovedad='DS') and (liberadocompletamente=0 or liberadocompletamente is null) and (ns.porliberar=1 )
			END

	--		ELSE
	--		BEGIN
	--			SELECT Distinct ns.id, Dseb.idTipoItem,Te.nombre,ns.idItem,EXB.dispensado
	--		FROM Solcitudes_EB Seb
	--		INNER JOIN Detalles_Solcitudes_EB Dseb ON Seb.id = Dseb.idSolicitudEB
	--		INNER JOIN TipoEquipo Te ON Te.id = Dseb.idTipoItem
	--		LEFT join Novedades_SolicitudesEB ns on ns.idDetalle=seb.id
	--		LEFT JOIN EquipoBiomedico EB on EB.serial=ns.idItem
	--		LEFT JOIN ExistenciasEquiposBiomedicos EXB on EXB.idEquipoBiomedico=EB.id
	--		WHERE Seb.id =@Consecutivo and EXB.dispensado=1 and (ns.tipoNovedad='DV' or 1=1) and (ns.tipoNovedad<>'DS' or 1=1)
		
	--END

		----END
		
	
		IF(@Op = 'GetDetalleDocumentoImp')
		BEGIN
		

		---IF((SELECT COUNT (*) FROM Novedades_SolicitudesEB WHERE idDetalle=@Consecutivo)>0 ) BEGIN
		

			---END

			---ELSE
			---BEGIN
			--	SELECT Distinct  Dseb.idTipoItem,Te.nombre,ns.idItem
			--FROM Solcitudes_EB Seb
			--INNER JOIN Detalles_Solcitudes_EB Dseb ON Seb.id = Dseb.idSolicitudEB
			--INNER JOIN TipoEquipo Te ON Te.id = Dseb.idTipoItem
			--LEFT join Novedades_SolicitudesEB ns on ns.idDetalle=seb.id
			--WHERE Seb.id = @Consecutivo

			---END
			---IF((SELECT COUNT (*) FROM Novedades_SolicitudesEB WHERE idDetalle=@Consecutivo)>0 ) BEGIN
	
			SELECT seb.id,Dseb.idTipoItem,Te.nombre,ns.idItem
			FROM Solcitudes_EB Seb
			INNER JOIN Detalles_Solcitudes_EB Dseb ON Seb.id = Dseb.idSolicitudEB
			INNER JOIN TipoEquipo Te ON Te.id = Dseb.idTipoItem
			LEFT JOIN Novedades_SolicitudesEB ns on ns.idDetalle=Dseb.id
			WHERE Seb.numOrden = @Consecutivo and ( ns.tipoNovedad='DS' or 1=1) and (ns.tipoNovedad<>'DV' )
		END


		IF(@Op = 'DispensarEquipo')
		BEGIN
 
 CREATE TABLE #dispensacion(
	id INT IDENTITY(1,1),
	idDetalle INT NOT NULL,
	NumOrden int,
	idItem varchar (max),
	tipoNovedad varchar(maX) CHECK(tipoNovedad in ('DS','DV','RE')),
	fechaRegistro DATETIME,
	usuario INT
)
		declare @idDetalle int,
		@sql2 NVARCHAR(MAX),
		@serial varchar(max)


		INSERT INTO #dispensacion
			SELECT 
				idDetalle=doc.item.value('@consecutivo','INT'),
				NumOrden=doc.item.value('@numeroorden','INT'),
				idItem=doc.item.value('@serial','VARCHAR (max)'),
				tipoNovedad='DS',
				fecharegistro=GETDATE(),
				usuario=doc.item.value('@usuario','INT')
                FROM @XmlDispensacion.nodes('//item') doc(item)



     if(@Debug=1) begin 
	 select * from #dispensacion
	 end

	 DECLARE @AUX1 INT,@aux2 int 


	 SELECT TOP 1 @AUX1=NumOrden,@aux2=usuario  FROM #dispensacion 

	declare @fechaactual datetime=GETDATE()

	IF((select fechaDispensacion from Solcitudes_EB where numOrden=@AUX1) is null ) begin 
	 UPDATE Solcitudes_EB set fechaDispensacion=@fechaactual,usuarioEntrega=@aux2 WHERE numOrden=@AUX1
     ---UPDATE ordenesEquiposBiomedicos set fechaEntrega=@fechaactual,idUsuario=@aux2  WHERE numOrden=@AUX1
	 end 



	 delete from Novedades_SolicitudesEB where NumOrden=@Consecutivo and tipoNovedad='DS'

	
	 while((select count(*) from #dispensacion)>0) begin
	 
	 
	 select top 1 @idDetalle=idDetalle from #dispensacion 
	     
        select top 1 @serial=idItem from #dispensacion where idDetalle=@idDetalle


-------SI EXISTE EL REGISTRO
	 IF EXISTS(select top 1 * from #dispensacion d join Novedades_SolicitudesEB neb on d.idDetalle=d.idDetalle
	 where neb.idDetalle=@idDetalle) BEGIN
	    
  update ExistenciasEquiposBiomedicos set dispensado=1 where idEquipoBiomedico=(select id from EquipoBiomedico where serial=@serial)



  SELECT TOP 1 
		 @sql2='UPDATE Novedades_SolicitudesEB set idItem='''+CONVERT(varchar,idItem)+''' where idDetalle='''+CONVERT(varchar,idDetalle)+''''
	      FROM #dispensacion 

		  	print @sql2
	      execute (@sql2)

		  if(@Debug=1) begin 
		  select * from Novedades_SolicitudesEB
		  end
	 delete from #dispensacion where idDetalle=@idDetalle
		END

		ELSE

		BEGIN

		update ExistenciasEquiposBiomedicos set dispensado=1 where idEquipoBiomedico=(select id from EquipoBiomedico where serial=@serial)

		
		if(@Debug=1) BEGIN
		select * from ExistenciasEquiposBiomedicos

		END

		 SELECT TOP 1 
		 @sql2='INSERT INTO Novedades_SolicitudesEB (idDetalle,NumOrden,idItem,tipoNovedad,fechaRegistro,usuario,porliberar) 
		 VALUES ('''+convert(varchar,idDetalle)+''','''+convert(varchar,NumOrden)+''','''+convert(varchar,idItem)+''','''+convert(varchar,tipoNovedad)+''','''+convert(varchar,fechaRegistro)+''','''+convert(varchar,usuario)+''',''1'')'
		 
	      FROM #dispensacion 

		  	print @sql2
	      execute (@sql2)

		  if(@Debug=1) begin 
		  select * from Novedades_SolicitudesEB
		  end
	 delete from #dispensacion where idDetalle=@idDetalle
	 END

	 END

	 declare @canti int

	  select @canti=count (*)  from Novedades_SolicitudesEB seb2 join Solcitudes_EB seb on
	 seb.numOrden=seb2.NumOrden where idItem<>'NE' and seb.numOrden=@AUX1

	 if((select totalitems from Solcitudes_EB where numOrden=@AUX1)=@canti) begin

	 update Solcitudes_EB set dispensadototalmente=1 where numOrden=@AUX1

	 end

	 
	
	 ---RAISERROR('ERROPR',16,1)

	 select 'ok' as respuesta
		END


		IF(@Op = 'LiberarEquipo')
		BEGIN
 
 CREATE TABLE #dispensacion2(
	id INT IDENTITY(1,1),
	idDetalle INT NOT NULL,
	NumOrden int,
	idItem varchar (max),
	tipoNovedad varchar(maX) CHECK(tipoNovedad in ('DS','DV','RE')),
	fechaRegistro DATETIME,
	usuario INT,
	checkeado bit
	
)
		declare @idDetalle2 int,
		@sql22 NVARCHAR(MAX),
		@serial2 varchar(max),
		@sql23 NVARCHAR(MAX)


		INSERT INTO #dispensacion2
			SELECT 
				idDetalle=doc.item.value('@consecutivo','INT'),
				NumOrden=doc.item.value('@numeroorden','INT'),
				idItem=doc.item.value('@serial','VARCHAR (max)'),
				tipoNovedad='DV',
				fecharegistro=GETDATE(),
				usuario=doc.item.value('@usuario','INT'),
				checkeado=doc.item.value('@check','bit')
                FROM @XmlDispensacion.nodes('//item') doc(item)



     if(@Debug=1) begin 
	 select * from #dispensacion2
	 end

	 DECLARE @AUX4 INT,@aux5 int 


	 SELECT TOP 1 @AUX4=NumOrden,@aux5=usuario  FROM #dispensacion2 

	--declare @fechaactual2 datetime=GETDATE()

	--IF((select fechaDispensacion from Solcitudes_EB where numOrden=@AUX1) is null ) begin 
	-- UPDATE Solcitudes_EB set fechaDispensacion=@fechaactual,usuarioEntrega=@aux2 WHERE numOrden=@AUX1
 --    ---UPDATE ordenesEquiposBiomedicos set fechaEntrega=@fechaactual,idUsuario=@aux2  WHERE numOrden=@AUX1
	-- end 


	declare @checkeado bit,@estado bit,@porliberar bit
	 
	 
	 delete from Novedades_SolicitudesEB where NumOrden=@Consecutivo AND tipoNovedad='DV' 
	 while((select count(*) from #dispensacion2)>0) begin


	    select top 1 @idDetalle2=id from #dispensacion2 
	     
        select top 1 @serial2=idItem from #dispensacion2

		select top 1 @checkeado=checkeado from #dispensacion2
		
		if(@checkeado=1)
		begin

		set @estado=0
		set @porliberar=0

		end
		else
		begin
			set @estado=1
			set @porliberar=1
		end

		update ExistenciasEquiposBiomedicos set dispensado=@estado where idEquipoBiomedico=(select id from EquipoBiomedico where serial=@serial2)


		
		if(@Debug=1) begin 
		select * from ExistenciasEquiposBiomedicos

		end

		 SELECT TOP 1 
		 @sql22='INSERT INTO Novedades_SolicitudesEB (idDetalle,NumOrden,idItem,tipoNovedad,fechaRegistro,usuario) 
		 VALUES ('''+convert(varchar,idDetalle)+''','''+convert(varchar,NumOrden)+''','''+convert(varchar,idItem)+''','''+convert(varchar,tipoNovedad)+''','''+convert(varchar,fechaRegistro)+''','''+convert(varchar,usuario)+''')',
		 @sql23='UPDATE Novedades_SolicitudesEB SET porliberar='''+convert(varchar,@porliberar)+''' where idDetalle='''+convert(varchar,idDetalle)+''' and NumOrden='''+convert(varchar,NumOrden)+'''  and tipoNovedad=''DS'' 
		 and idItem='''+convert(varchar,idItem)+''''
		  FROM #dispensacion2 

		  	print @sql22
			print @sql23
	      execute (@sql22)
		   execute (@sql23)

		  if(@Debug=1) begin 
		  select * from Novedades_SolicitudesEB
		  end
	 delete from #dispensacion2 where id=@idDetalle2
	 END

	 declare @canti3 int

	  select @canti3=count (*)  from Novedades_SolicitudesEB seb2 join Solcitudes_EB seb on
	 seb.numOrden=seb2.NumOrden where seb2.tipoNovedad='DS' and seb.numOrden=@AUX4 and porliberar=0

	 if((select totalitems from Solcitudes_EB where numOrden=@AUX4)=@canti3) begin

	 update Solcitudes_EB set liberadocompletamente=1 where numOrden=@AUX4

	 end
	
	 
      ---RAISERROR('error',16,1)
	 select 'ok' as respuesta
		END
		IF(@manejaLaTransaccion = 1) COMMIT TRAN
	END TRY
	BEGIN CATCH
		IF(@manejaLaTransaccion = 1) ROLLBACK TRAN
		SET @ERRORMSG = ERROR_MESSAGE();
		SELECT @ERRORMSG AS ERRORMSG;
	END CATCH
END

