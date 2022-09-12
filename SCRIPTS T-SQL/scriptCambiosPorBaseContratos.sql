--hcingres
update hcingres set contrato = acuf.ContratoNuevo
from sis_maes sm
inner join sis_cama sc on sc.estudio_paciente = sm.con_estudio and sc.estudio_paciente <> '-1'
inner join Ufuncionales uf on uf.id = sm.ufuncional
inner join actualizacionuf acuf on acuf.ContratoViejo = sm.contrato and convert(varchar, acuf.uFunciononalVieja) = uf.codigo
inner join Ufuncionales uf2 on uf2.codigo = convert(varchar,acuf.uFuncionalNueva)

--sis_paci
update sis_paci set contrato = acuf.ContratoNuevo
from sis_maes sm
inner join sis_cama sc on sc.estudio_paciente = sm.con_estudio and sc.estudio_paciente <> '-1'
inner join Ufuncionales uf on uf.id = sm.ufuncional
inner join actualizacionuf acuf on acuf.ContratoViejo = sm.contrato and convert(varchar, acuf.uFunciononalVieja) = uf.codigo
inner join Ufuncionales uf2 on uf2.codigo = convert(varchar,acuf.uFuncionalNueva)

--sis_maes
update sis_maes set contrato = acuf.ContratoNuevo, ufuncional = uf2.id 
from sis_maes sm
inner join sis_cama sc on sc.estudio_paciente = sm.con_estudio and sc.estudio_paciente <> '-1'
inner join Ufuncionales uf on uf.id = sm.ufuncional
inner join actualizacionuf acuf on acuf.ContratoViejo = sm.contrato and convert(varchar, acuf.uFunciononalVieja) = uf.codigo
inner join Ufuncionales uf2 on uf2.codigo = convert(varchar,acuf.uFuncionalNueva)

--dos sis_maes
update sis_maes set contrato = acuf.ContratoNuevo, ufuncional = uf2.id 
from sis_maes sm
inner join sis_cama sc on sc.estudio_paciente = sm.con_estudio and sc.estudio_paciente <> '-1' 
inner join Ufuncionales uf on uf.id = sm.ufuncional
inner join actualizacionuf acuf on acuf.ContratoNuevo = sm.contrato and convert(varchar, acuf.uFunciononalVieja) = uf.codigo
inner join Ufuncionales uf2 on uf2.codigo = convert(varchar,acuf.uFuncionalNueva)

--sis_deta
update sis_deta set ufuncional = uf2.id, total = total from sis_maes sm
inner join sis_cama sc on sc.estudio_paciente = sm.con_estudio and sc.estudio_paciente <> '-1' 
inner join sis_deta sd on sd.estudio = sc.estudio_paciente 
inner join Ufuncionales uf on uf.id = sd.ufuncional
inner join actualizacionuf acuf on  acuf.uFunciononalVieja = uf.codigo
inner join Ufuncionales uf2 on uf2.codigo = acuf.uFuncionalNueva