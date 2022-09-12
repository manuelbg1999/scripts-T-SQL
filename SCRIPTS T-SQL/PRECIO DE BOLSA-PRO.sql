----------------CALCULO PRECIO BOLSA---------------------------------

declare 
@plantaid int,
@df float=0,
@w int=0,
@p1 float=0,
@p2 float=0,
@demandatotal float,
@Dftotal float,

----caso al que se le quiere calcular el PrecioBolsa
@casoanalisis int=7416


create table #DF (
df float,
plantaid int,
nombreplanta varchar
)

-----------BARRAN------------------------

select  RP.*,PL.NOMBRE into #temporal from casoanalisis.[ResPlt_Saeb] RP
join [informacionBasica].[Planta] pl on pl.plantaid=rp.indice1
where casoanalisisid=@casoanalisis and indice2='B_arran' 


-----------------GENERACION IDEAL---------------------
select  pl.nombre,rp.valor,rp.periodo,rp.indice1,rp.casoAnalisisID,rp.indice2 into #temporal2
from casoAnalisis.[ResPlt_Saeb] rp
join [informacionBasica].[Planta] pl on pl.plantaid=rp.indice1
where casoAnalisisid=@casoanalisis and indice2='PrgPlt' 
order by pl.plantaid,rp.periodo asc
-----------------------MARGINAL-------------------------

select rg.periodo,rg.valor into #temp from casoAnalisis.ResGeneral rg
where casoAnalisisid=@casoanalisis and indice2='PMarginal' order by rg.periodo asc

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


while (select count(*) from #plantas)>0 begin

select top 1 @plantaid=plantaID from #plantas

select 
@p1=sum(isnull(rp2.valor,0)*CFP.pap),@p2=sum(rp.valor*(rp3.valor-ibp.precio)) 
from casoAnalisis.CasoAnalisis CA
join casoBase.InfoBasePlanta IBP on IBP.casoBaseID = CA.casoBaseID
join informacionBasica.Planta PL on PL.plantaID = IBP.plantaID and PL.fechaVigencia = CA.fechaAnalisis
join [informacionBasica].[ConfiguracionPlanta] CFP on CFP.configPlantaID =IBP.configuracionPlantaID  
join #temporal2 rp on rp.indice1=pl.plantaid and rp.periodo=ibp.periodo and indice2='PrgPlt' and rp.casoanalisisid=ca.casoanalisisid
left join #temporal rp2 on pl.plantaid=rp2.indice1 and rp2.periodo=ibp.periodo 
join #temp rp3 on rp3.periodo=ibp.periodo
where CA.casoAnalisisID=@casoanalisis and PL.estado=1 and IBP.configuracionPlantaID is not null and pl.plantaID=@plantaid


--------------------------GI por planta periodo-----------
select top 1
@w=case when sum(convert(float,rp.valor))>0 then 1 else 0 end 
from casoAnalisis.[ResPlt_Saeb] rp
join [informacionBasica].[Planta] pl on pl.plantaid=rp.indice1
where casoAnalisisid=@casoanalisis and indice2='PrgPlt' and rp.indice1 in(@plantaid)
group by pl.nombre,pl.plantaid


set @DF=(@w*@p1)-(@p2)


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

select @demandatotal=sum(ia.demandaTotal)  from [casoAnalisis].[InfoAnalisisSubarea] ia
JOIN casoAnalisis.CasoAnalisis ca on ia.casoAnalisisID=ca.casoAnalisisID
join informacionBasica.Subarea sb on sb.subareaID=ia.subareaID
where ia.casoanalisisid=@casoanalisis and sb.estado=1 
and 
ia.subareaID in (
select subareaid from informacionBasica.Subarea where estado=1 and interconexion=0 )

select isnull(@demandatotal,0) Demandatotal,isnull(@Dftotal,0) Dftotal,isnull(@Dftotal/@demandatotal,0) DeltaI


drop table #temporal2
drop table #temporal
drop table #plantas
drop table #DF
drop table #temp





