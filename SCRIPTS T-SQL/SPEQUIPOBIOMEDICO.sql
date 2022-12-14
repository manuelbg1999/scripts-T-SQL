USE [SismaSalud2022]
GO
/****** Object:  StoredProcedure [dbo].[spEquiposBiomedicos]    Script Date: 30/07/2022 9:32:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spEquiposBiomedicos]
	
	-- PARAMETROS DEL SP
	@Op										AS VARCHAR(max) = NULL,
	@estudio								AS BIGINT=0,
	@numOrden								AS BIGINT = 0,
	@fechaEntrega							AS VARCHAR(255) = '',
	@hora									AS VARCHAR(20) = '',
	@medico									AS VARCHAR(255) = '',
	@codMedico								AS INT = 0,
	@identificacion							AS BIGINT = 0,
	@puntoAtencion							AS INT = 0, 
	@IdTipoEquipoBiomedico					AS INT = 0,
	@idPaciente								AS INT=0,
	@NombreTipoEquipoBiomedico				AS VARCHAR(255) = '',
	@DescripcionTipoEquipoBiomedico			AS VARCHAR(255) = '',
	@EstadoTipoEquipoBiomedico				AS BIT = 0,
	@IdProveedorEquipoBiomedico				AS INT = 0,
	@NombreProveedorEquipoBiomedico			AS VARCHAR(255) = '',
	@DescripcionProveerdorEquipoBiomedico	AS VARCHAR(255) = '',
	@EstadoProveedorEquipoBiomedico			AS BIT = 0,
	@IdEquipoBiomedico						AS INT = 0,
	@IdRegionalEquipoBiomedico				AS INT = 0,
	@IdProEquipoBiomedico					AS INT = 0,
	@IdTiEquipoBiomedico					AS INT = 0,
	@NombreEquipoBiomedico					AS VARCHAR(255) = '',
	@SerialEquipoBiomedico					AS VARCHAR(255) = '',
	@MarcaEquipoBiomedico					AS VARCHAR(255) = '',
	@AlquiladoEquipoBiomedico				AS BIT = 0,
	@DescEquipoBiomedico					AS VARCHAR(255) = '',
	@IdUsuario								AS BIGINT = NULL,
	@manejaLaTransaccion					AS BIT = 1,
	@Xml									AS XML=NULL,
	@desc_orden								AS VARCHAR(255) = NULL,
	@llamadaSp								AS CHAR(1) = 'N',
	@Debug									AS BIT = 0
 	
AS
BEGIN
	SET NOCOUNT ON;
	
	-- DEFINICION DEL SP
	DECLARE @ERRORMSG AS VARCHAR(MAX);	
	DECLARE @TipoLog AS CHAR(1);
	DECLARE @DetalleLog AS VARCHAR(1000);
	DECLARE @Mensaje AS VARCHAR(255);
	DECLARE @idEB INT;
	DECLARE @SolicitudId INT

	IF(@manejaLaTransaccion = 1) BEGIN TRAN	
	BEGIN TRY
		IF(@Op='GuardarTipoEquipoBiomedico')
			BEGIN
				IF(@IdTipoEquipoBiomedico <> 0)
				BEGIN
					IF(EXISTS(SELECT 1  FROM TipoEquipo WHERE id = @IdTipoEquipoBiomedico))
					BEGIN					
						UPDATE TipoEquipo SET descripcion = @DescripcionTipoEquipoBiomedico , nombre = @NombreTipoEquipoBiomedico,estado = @EstadoTipoEquipoBiomedico, fechaActualizacion = GETDATE() WHERE id = @IdTipoEquipoBiomedico
						SET @Mensaje = 'Equipo Actualizado'
					END
				END
				ELSE
					BEGIN					
						INSERT INTO TipoEquipo(descripcion, estado, fechaCreacion,nombre) VALUES (@DescripcionTipoEquipoBiomedico, @EstadoTipoEquipoBiomedico, GETDATE(), @NombreTipoEquipoBiomedico)
						SET @Mensaje = 'Equipo Creado'
					END
				Select 'success' Tipo, @Mensaje Mensaje
				--IF(@manejaLaTransaccion = 1) COMMIT;			
			END
		IF(@Op='GuardarProveedorEquipoBiomedico')
			BEGIN
				IF(@IdProveedorEquipoBiomedico <> 0)
				BEGIN
					IF(EXISTS(SELECT 1 FROM ProveedorEquipoBiomedico WHERE id = @IdProveedorEquipoBiomedico))
					BEGIN
						UPDATE ProveedorEquipoBiomedico SET nombre = @NombreProveedorEquipoBiomedico,descripcion = @DescripcionProveerdorEquipoBiomedico , estado = @EstadoProveedorEquipoBiomedico, fechaActualizacion = GETDATE() WHERE id = @IdProveedorEquipoBiomedico
						SET @Mensaje = 'Proveedor Actualizado'
					END
				END
				ELSE
					BEGIN
						
						INSERT INTO ProveedorEquipoBiomedico(descripcion, estado, fechaCreacion,nombre) VALUES (@DescripcionProveerdorEquipoBiomedico, @EstadoProveedorEquipoBiomedico, GETDATE(), @NombreProveedorEquipoBiomedico)
						SET @Mensaje = 'Proveedor Creado'
					END
				Select 'success' Tipo, @Mensaje Mensaje
				--IF(@manejaLaTransaccion = 1) COMMIT;
			
			END
		IF(@Op='GetOrdenesPendientesGeneral')
			BEGIN



				SELECT seb.id Consecutivo,orEQ.numOrden NumeroOrden, CONCAT('',convert(date,orEQ.fechaEntrega,121),' ', orEQ.hora) FechaDocumento,
				sme.nombre Generador, CONCAT(sp.tipo_id,' - ',sp.num_id,': ',sp.primer_nom,' ',sp.segundo_nom, ' ',sp.primer_ape,' ',sp.segundo_ape) Observacion,
				Case when seb.fechaDispensacion is not null and seb.totalItems>p.c then 'PARCIALMENTE DISPENSADO' else 
				Case when seb.fechaDispensacion is not null and seb.totalItems=p.c and seb.dispensadototalmente=1 then 'TOTALMENTE DISPENSADO' ELSE
				'NO DISPENSADO' END END as Estado
				, pa.Nombre Origen,
				datediff(hour,convert(datetime,orEQ.fechaentrega+orEQ.hora),GETDATE()) as TiempoActual
				FROM ordenesEquiposBiomedicos orEQ
				INNER JOIN Solcitudes_EB Seb ON Seb.numOrden = oreq.numOrden
				JOIN sis_paci sp on sp.num_id = orEQ.idUsuario
				JOIN sis_medi sme on sme.codigo = orEQ.codMedico
				JOIN puntoAtencion pa on pa.Id = orEQ.PuntoAtencion
				JOIN sis_maes sma on sma.con_estudio = orEQ.estudio
				outer apply(select top 1 count (*) as c from Novedades_SolicitudesEB seb2 where seb.numOrden=seb2.NumOrden and idItem<>'NE' and seb2.tipoNovedad='DS' ) as p
				WHERE (orEQ.puntoAtencion = @puntoAtencion OR @puntoAtencion = 0) and orEQ.estado=1 and seb.estado=1
				ORDER BY orEQ.numOrden DESC
				--IF(@manejaLaTransaccion = 1) COMMIT;
			
			END
			IF(@Op='GetOrdenesPendientesGeneralPaciente')
			BEGIN

			
				SELECT orEQ.idSolicitudEB Consecutivo,orEQ.numOrden, CONCAT('',convert(date,orEQ.fechaEntrega,121),' ', orEQ.hora) FechaDocumento,
				sme.nombre Generador, CONCAT(sp.tipo_id,' - ',sp.num_id,': ',sp.primer_nom,' ',sp.segundo_nom, ' ',sp.primer_ape,' ',sp.segundo_ape) Observacion,
				case when orEQ.estado=1 then 'Activo' else 'Anulado' end Estado, pa.Nombre Origen,
				Case when seb.fechaDispensacion is not null and seb.totalItems>p.c then 'PARCIALMENTE' else 
				Case when seb.fechaDispensacion is not null and seb.totalItems=p.c and seb.dispensadototalmente=1 then 'TOTALMENTE' ELSE
				'NO' END END as Dispensado,orEQ.estudio as Estudio
				FROM ordenesEquiposBiomedicos orEQ
				JOIN sis_paci sp on sp.num_id = orEQ.idUsuario
				JOIN sis_medi sme on sme.codigo = orEQ.codMedico
				JOIN puntoAtencion pa on pa.Id = orEQ.PuntoAtencion
				INNER JOIN Solcitudes_EB Seb ON Seb.numOrden = oreq.numOrden
				outer apply(select top 1 count (*) as c from Novedades_SolicitudesEB seb2 where seb.numOrden=seb2.NumOrden and idItem<>'NE' and seb2.tipoNovedad='DS' ) as p
				where orEQ.idUsuario = @idPaciente
				ORDER BY orEQ.numOrden DESC
				Select 'success' Tipo, @Mensaje Mensaje
				--IF(@manejaLaTransaccion = 1) COMMIT;
			
			END
		IF(@Op='GetInformacionPacientes')
			BEGIN
				SELECT DISTINCT CONCAT(sp.primer_nom,' ',sp.segundo_nom,' ',sp.primer_ape,' ',sp.segundo_ape) NombrePaciente,
				sp.tipo_id TipoId, sp.num_id Id, se.r_social Sede,
				sp.zona Zona, sp.direccion Direccion, CONVERT(VARCHAR(MAX), STUFF((SELECT ' - '+numero+' ' FROM telefonos_usuarios WHERE autoid = sma.autoid ORDER BY es_principal DESC FOR XML PATH('')), 1, 2, '')) AS Telefono, CONCAT('',CONVERT(DATE,sma.fecha_ing ,121),' ',sma.hora_ing) FechaIngreso, 
				(SELECT TOP 1 CONVERT(DATE,fechaEntrega,121) FROM ordenesEquiposBiomedicos WHERE idUsuario = orEQ.idUsuario ORDER BY fechaEntrega DESC) AS FechaUltimaOrden,
				sma.nom_egreso UsuarioAlta,
				CONVERT(DATE,sma.fecha_egr,121)  FechaAlta,
				sma.hora_egr HoraAlta,
				(SELECT DATEDIFF(DAY, sma.fecha_egr,GETDATE())) AS TiempoAlta
				FROM ordenesEquiposBiomedicos orEQ
				LEFT JOIN sis_paci sp ON sp.num_id = orEQ.idUsuario
				JOIN sis_medi sme ON sme.codigo = orEQ.codMedico
				JOIN puntoAtencion pa on pa.Id = orEQ.PuntoAtencion
				JOIN seriales se on se.id = sp.id_sede
				JOIN sis_maes sma on sma.con_estudio = orEQ.estudio
				where orEq.PuntoAtencion=@puntoAtencion
				Select 'success' Tipo, @Mensaje Mensaje
				--IF(@manejaLaTransaccion = 1) COMMIT;			
			END
		IF(@Op='GuardarEquipoBiomedico')
			BEGIN
				IF(@IdEquipoBiomedico <> 0)
				BEGIN
					IF(EXISTS(SELECT 1 FROM ProveedorEquipoBiomedico WHERE id = @IdProveedorEquipoBiomedico))
					BEGIN
						UPDATE EquipoBiomedico SET regional = @IdRegionalEquipoBiomedico, proveedor = @IdProEquipoBiomedico,
						tipo = @IdTiEquipoBiomedico, equipo = @NombreEquipoBiomedico, marca = @MarcaEquipoBiomedico,
						alquilado = @AlquiladoEquipoBiomedico, descripcion = @DescEquipoBiomedico, fechaActualizacion = GETDATE() WHERE id = @IdEquipoBiomedico
						SET @Mensaje = 'Equipo Actualizado'
					END
				END
				ELSE
					BEGIN						
						INSERT INTO EquipoBiomedico(regional, proveedor,tipo, equipo,serial,marca,alquilado,descripcion,fechaCreacion) VALUES (@IdRegionalEquipoBiomedico,@IdProEquipoBiomedico, @IdTiEquipoBiomedico, @NombreEquipoBiomedico,@SerialEquipoBiomedico,@MarcaEquipoBiomedico,@AlquiladoEquipoBiomedico,@DescEquipoBiomedico, GETDATE())
						SET @idEB = SCOPE_IDENTITY();
						INSERT INTO ExistenciasEquiposBiomedicos(idEquipoBiomedico,cantidad,dispensado,reposicion) values (@idEB,1,0,0)
						SET @Mensaje = 'Equipo Creado'
					END
				Select 'success' Tipo, @Mensaje Mensaje	
			END

			IF(@Op='DelOrdenEquipoBiomedico')
			BEGIN
				
				update ordenesEquiposBiomedicos set estado=0 where numOrden=@numOrden
				update Solcitudes_EB  set estado=0,anulado=1 where numOrden=@numOrden
				Select 'success' Tipo, @Mensaje Mensaje	
END

	IF(@Op='DisponibilidadEquipo')
			BEGIN
				
			select dispensado from ExistenciasEquiposBiomedicos ex
             join EquipoBiomedico eb on eb.id=ex.idEquipoBiomedico 
			 where eb.serial=@SerialEquipoBiomedico
				Select 'success' Tipo, @Mensaje Mensaje	
END


		IF(@Op='GuardarOrdenEquipoBiomedico')
			BEGIN
				IF EXISTS(SELECT 1 FROM ordenesEquiposBiomedicos WHERE numOrden = @numOrden )
				BEGIN
					RAISERROR('Ya existe una orden con ese consecutivo.!',16,1)
				END

				INSERT INTO ordenesEquiposBiomedicos(numOrden,estudio,fechaEntrega,hora,medico,codMedico,idUsuario,PuntoAtencion,descripcionOrden,estado) VALUES 
				(@numOrden,@estudio,@fechaEntrega,@hora,@medico,@codMedico,@identificacion,@puntoAtencion,@desc_orden,1)

				SET @idEB = SCOPE_IDENTITY();

				INSERT INTO detalle_orden_equipos_biomedicos(idOrden,idTipoItem,cantidadItem) 
				SELECT 
				@idEB,
				doc.item.value('@codigoEquipoBiomedico','VARCHAR(10)') as codigoEquipoBiomedico,
				doc.item.value('@cantidadItem','INT') as cantidadItem
				FROM @xml.nodes('//item') doc(item) 

				EXEC spSolicitudesEquipoBiomedico
				@Op = 'GenerarSolicitud',
				@NumeroOrden = @numOrden,
				@estudio = @estudio,
				@Medico = @codMedico,
				@xmlEquipos = @Xml,
				@puntoate=@puntoAtencion,
				@observacion=@desc_orden,
				@SolicitudId = @SolicitudId OUTPUT,
				@Debug = @Debug,
				@manejaLaTransaccion = 0

				UPDATE ordenesEquiposBiomedicos SET idSolicitudEB = @SolicitudId WHERE id = @idEB




				if(@Debug = 1)
				BEGIN
					SELECT 'Cabecera',* FROM ordenesEquiposBiomedicos where id = @idEB
					SELECT 'Detalle',* FROM detalle_orden_equipos_biomedicos where idOrden = @idEB

				END

				SET @Mensaje = 'Orden  Creada'
				Select 'success' Tipo, @Mensaje Mensaje	
			END
	IF(@manejaLaTransaccion = 1) COMMIT;			
	END TRY
	BEGIN CATCH
		
		IF (@manejaLaTransaccion = 1) ROLLBACK
		SET @ERRORMSG = ERROR_MESSAGE();
		IF(@llamadaSp = 'N')
		BEGIN
			SELECT @ERRORMSG AS ERRORMSG;
		END
		ELSE
		BEGIN
			RAISERROR('%s', 16 ,1, @ERRORMSG);
		END
	END CATCH
END