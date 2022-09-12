----------------CALCULO PRECIO BOLSA INTERNACIONAL---------------------------------



declare

@plantaid int,
@df float=0,
@w float=0,
@w2 int=0,
@w3 float=0,
@p1 float=0,
@p2 float=0,
@aux float=0,
@aux2 float=0,
@demandatotal float,
@Dftotal float,
@tipocasoI int,
@tipocasoN int,


---------------PARAMETROS
----caso al que se le quiere calcular el PrecioBolsa
@casoanalisis int=8822 ,
@casoanalisisnacional int=5596
-------1 si es despacho y 2 si es redespacho

--------------------------------

---bolsa internacional redespacho casos
---8822  tipo 22
---5596 tipo 20
---bolsa internacional despacho casos
---8847  tipo 13
---7416 tipo 7


select top 1 @tipocasoI=infanatipocasoid from [casoAnalisis].[CasoAnalisis]

where casoanalisisid=@casoanalisis

select top 1 @tipocasoN=infanatipocasoid from [casoAnalisis].[CasoAnalisis]

where casoanalisisid=@casoanalisisnacional





create table #DF (
df float,
plantaid int,
nombreplanta varchar
)

-----------BARRAN------------------------

select  RP.*,PL.NOMBRE into #temporal from casoanalisis.[ResPlt_Saeb] RP
join [informacionBasica].[Planta] pl on pl.plantaid=rp.indice1
where casoanalisisid=@casoanalisis and indice2='B_arran' 


-----------------GENERACION IDEAL  INTERNACIONAL---------------------
select  pl.nombre,rp.valor,rp.periodo,rp.indice1,rp.casoAnalisisID,rp.indice2 into #temporal2
from casoAnalisis.[ResPlt_Saeb] rp
join [informacionBasica].[Planta] pl on pl.plantaid=rp.indice1
where casoAnalisisid=@casoanalisis and indice2='PrgPlt' 
order by pl.plantaid,rp.periodo asc



---------------------GENERACION IDEAL NACIONAL--------------
select  pl.nombre,rp.valor,rp.periodo,rp.indice1,rp.casoAnalisisID,rp.indice2 into #GInacional
from casoAnalisis.[ResPlt_Saeb] rp
join [informacionBasica].[Planta] pl on pl.plantaid=rp.indice1
where casoAnalisisid=@casoanalisisnacional and indice2='PrgPlt' 
order by pl.plantaid,rp.periodo asc

-----------------------MARGINAL-------------------------

select rg.periodo,rg.valor into #temp from casoAnalisis.ResGeneral rg
where casoAnalisisid=@casoanalisis and indice2='PMarginal' order by rg.periodo asc
--order by resGeneralID asc



--------------------PLANTAS--------------------------
select distinct pl.plantaID into #plantas
from casoAnalisis.CasoAnalisis CA
join casoBase.InfoBasePlanta IBP on IBP.casoBaseID = CA.casoBaseID
join informacionBasica.Planta PL on PL.plantaID = IBP.plantaID and PL.fechaVigencia = CA.fechaAnalisis
join [informacionBasica].[ConfiguracionPlanta] CFP on CFP.configPlantaID =IBP.configuracionPlantaID  
join #temporal2 rp on rp.indice1=pl.plantaid and rp.periodo=ibp.periodo and indice2='PrgPlt' and rp.casoanalisisid=ca.casoanalisisid
left join #temporal rp2 on pl.plantaid=rp2.indice1 and rp2.periodo=ibp.periodo 
join #temp rp3 on rp3.periodo=ibp.periodo
where CA.casoAnalisisID=@casoanalisis and PL.estado=1 and IBP.configuracionPlantaID is not null 

select count(*) from #plantas
while (select count(*) from #plantas)>0 begin

select top 1 @plantaid=plantaID from #plantas

select 
@p1=sum(isnull(convert(float,rp2.valor),0)*CFP.pap),
@aux=case when (convert(float,rp.valor)-convert(float,isnull(RP4.valor,0)))<=0 then 0 else
(convert(float,rp.valor))-(convert(float,isnull(RP4.valor,0))) end,
@p2=@aux*sum(((rp3.valor-ibp.precio)))
from casoAnalisis.CasoAnalisis CA
join casoBase.InfoBasePlanta IBP on IBP.casoBaseID = CA.casoBaseID
join informacionBasica.Planta PL on PL.plantaID = IBP.plantaID and PL.fechaVigencia = CA.fechaAnalisis
join [informacionBasica].[ConfiguracionPlanta] CFP on CFP.configPlantaID =IBP.configuracionPlantaID  
join #temporal2 rp on rp.indice1=pl.plantaid and rp.periodo=ibp.periodo and indice2='PrgPlt' and rp.casoanalisisid=ca.casoanalisisid
left join #temporal rp2 on pl.plantaid=rp2.indice1 and rp2.periodo=ibp.periodo 
join #GInacional rp4 on rp4.indice1=pl.plantaid and rp4.periodo=ibp.periodo and rp4.indice2='PrgPlt' 
join #temp rp3 on rp3.periodo=ibp.periodo
where CA.casoAnalisisID=@casoanalisis and PL.estado=1 and IBP.configuracionPlantaID is not null and pl.plantaID=@plantaid

group by ibp.precio,rp3.valor,rp.valor,rp4.valor
--------------------------W internacional-----------
select 
@w=sum(convert(float,rp.valor))
from casoAnalisis.[ResPlt_Saeb] rp
join [informacionBasica].[Planta] pl on pl.plantaid=rp.indice1
where casoAnalisisid=@casoanalisis and indice2='PrgPlt' and rp.indice1 in(@plantaid)
group by pl.nombre,pl.plantaid


--------------------------W nacional-----------

select 
@w2=sum(convert(float,rp.valor))
from casoAnalisis.[ResPlt_Saeb] rp
join [informacionBasica].[Planta] pl on pl.plantaid=rp.indice1
where casoAnalisisid=@casoanalisisnacional and indice2='PrgPlt' and rp.indice1 in(@plantaid)
group by pl.nombre,pl.plantaid



if(@w)>0  begin 

set @w3=(@w2/@w)

end 

else begin
set @w3=0
end


set @aux2=(1-@w3)


if(@aux2)<=0 begin

set @aux2=0
end
else begin
set @aux2=(1-@w3)
end

select @w GInternacional,@w2 GINacional,@w3 W,@aux2 [1-W],@p1 [BARRANxPAP],@p2 [MPO-POFE],@aux [GI-GIN],@plantaid plantaid,pl.nombre
from informacionbasica.planta pl where PL.plantaID =@plantaid
set @DF=((@aux2)*@p1)-(@p2)

insert into #DF (df,plantaid) values (@DF,@plantaid)
delete from #plantas where plantaID=@plantaid

end

select #df.df,#df.plantaid,pl.nombre from #DF
join informacionBasica.Planta pl on pl.plantaID=#df.plantaid


select case when #df.df<0 then 0 else #df.df end DF,pl.nombre from #DF
join informacionBasica.Planta pl on pl.plantaID=#df.plantaid


select @dftotal=sum(#DF.df) from #DF
join informacionBasica.Planta pl on pl.plantaID=#df.plantaid
where #DF.df>0

select @demandatotal=isnull(sum(ia.demandaTotal),0)  from [casoAnalisis].[InfoAnalisisSubarea] ia
JOIN casoAnalisis.CasoAnalisis ca on ia.casoAnalisisID=ca.casoAnalisisID
join informacionBasica.Subarea sb on sb.subareaID=ia.subareaID
where ia.casoanalisisid=@casoanalisis and sb.estado=1 
and 
ia.subareaID in (
select subareaid from informacionBasica.Subarea where estado=1 and interconexion=1 )


if(@demandatotal)>0 begin
select isnull(@demandatotal,0) Demandatotal,isnull(@Dftotal,0) Dftotal,isnull(@Dftotal/@demandatotal,0) DeltaI
end

else

begin
select 'La demanda total es 0 no se puede hacer el calculo'
end

drop table #temporal2
drop table #temporal
drop table #plantas
drop table #DF
drop table #temp
drop table #GInacional
