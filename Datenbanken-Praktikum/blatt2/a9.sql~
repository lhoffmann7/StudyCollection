-- alle afrikanischen Kolonien die von Europaeischen Laendern besetzt waren oder sind.
create or replace view afriColsWasDep as 
	(
		(select distinct p.country as country , p.wasdependent as wasdependent 
			from Politics p, encompasses e, encompasses enc 
			start with e.country=p.wasdependent connect by nocycle p.wasdependent= prior e.country  and
			(p.wasdependent is not null and p.country=e.country and e.continent='Africa' and
			p.wasdependent=enc.country and enc.continent='Europe'))
	);
	
	
create or replace view afriColsNotEu as 
	(
		(select distinct p.country as country , p.wasdependent as wasdependent 
			from Politics p, encompasses e, encompasses enc 
			where p.wasdependent is not null and p.country=e.country and e.continent='Africa' 
		)
	);
	
	create or replace view penis as select * from afriColsNotEu union (select distinct a.wasdependent, 'wurst' from Politics p,afriColsNotEu a, encompasses en  where en.country=a.wasdependent and a.wasdependent = p.country and p.wasdependent is null and en.continent = 'Europe');
	
	
	
	create or replace view dep as 
	(
		(select distinct p.country as country , p.wasdependent as wasdependent 
			from Politics p, encompasses e, encompasses enc 
			where p.wasdependent is not null and p.country=e.country  
		)
	);

	
	create or replace view eu_country as (select c.code as country from country c, encompasses e where c.code = e.country and e.continent = 'Europe');
	create or replace view eu_start as (select c.country as country from eu_country c where exists(select * from politics p where p.wasdependent = c.country));
--(select distinct b.country, a.wasdependent from  penis a,afriColsNotEu b start with b.country=a.wasdependent connect by nocycle a.wasdependent= prior b.country) order by 1 asc;

--(select distinct a.wasdependent,b.country from afriColsWasDep a, afriColsWasDep b start with a.wasdependent=b.country connect by nocycle b.country = prior a.wasdependent) order by 1 asc;

(select distinct c.country, a.wasdependent from africolswasdep a, eu_start c start with a.wasdependent = c.country connect by nocycle a.wasdependent = prior a.country) order by 1; 

create or replace view afriColsIsDep as 
	(
		(select p.country as country , p.dependent as dependent 
			from Politics p, encompasses e, encompasses enc 
			where p.dependent is not null and p.country=e.country and e.continent='Africa' and
			p.dependent=enc.country and enc.continent='Europe')
	);
	
create or replace view afriCols as 
	(select w.country,w.wasdependent 
			from afriColsWasDep w 
			UNION Select d.country,d.dependent 
			from afriColsIsDep d 
	);


--create or replace view afriCols as (select p.country, p.wasdependent from Politics p, encompasses e where p.wasdependent is not null and p.country=e.country and e.continent='Africa');

--gib totale flaeche aus fuer jeden europaischen staat (united nation ist kein europaeischer staat denke ich)
select af.wasdependent, sum(c.area) from afriCols af, country c where c.code=af.country group by af.wasdependent;

-- view von obrigen erstellen tabelle machen

create or replace view totalArea as (select af.wasdependent, sum(c.area) as area from afriCols af, country c where c.code=af.country group by af.wasdependent);

select ta.wasdependent as badboy, (ta.area/c.area)*100 as areaInPercent from totalArea ta, continent c where c.name='Africa';


--connect by 
select 'Zaire',sum(length) from riverorlake start with name='Zaire' connect by river = prior name;

