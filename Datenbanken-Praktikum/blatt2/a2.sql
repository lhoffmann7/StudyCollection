create or replace view orgcountry as (select i.country,i.organization
from ismember i
	where not exists(select * 
			 from symbord s
				where s.country1 = i.country
				and exists(	select * 
						from ismember im
						where s.country2 = im.country
						and i.organization = im.organization)));


create or replace view nomember as (select c.code as country, o.abbreviation as organization
from country c, organization o
	where not exists(select * from ismember i where i.country = c.code and i.organization =  o.abbreviation));
	

--select i.country,i.organization
--from nomember i
--	where exists(	select * 
--			from symbord s
--				where s.country1 = i.country
--				and  exists(	select * 
--						from nomember im
--						where s.country2 = im.country
--						and i.organization = im.organization));



--das geht so nicht, da man alle laender rausnimmt, die auch nur eine insel haben und die das zutrifft.

--erster Aufgabenteil
create or replace view B2A2a as select i.country, i.organization from nomember i where not exists (select im.country,im.organization from nomember im, symbord s where i.country=s.country1 and im.country=s.country2 and im.organization=i.organization) order by 1 asc;

select c.name,o.name from country c,organization o, B2A2a bla where bla.country=c.code and bla.organization = o.abbreviation;

-- zweiter Aufgabenteil
create or replace view B2A2b as select i.country, i.organization from nomember i where not exists (select im.country,im.organization from nomember im, symbord s where i.country=s.country1 and im.country=s.country2 and im.organization=i.organization) and i.country not in (select gi.country from geo_island gi where gi.country=i.country and not exists (select * from symbord sy where gi.country = sy.country1 )) order by 1 asc;

select c.name,o.name from country c,organization o, B2A2b bla where bla.country=c.code and bla.organization = o.abbreviation;



