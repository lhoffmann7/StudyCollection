/*Aufgabe 1.10 (10P.)
Geben Sie für jede Organisation die Gesamtlänge ihrer Außengrenzen an (lassen Sie die verschiedenen Arten von Mitgliedschaften unberücksichtigt).*/

--select distinct organization, sum(symborders.length) from isMember, (select * from borders union select country2, country1,length from borders) symborders where exists (select * from country where country.code=isMember.country) and (isMember.country=symborders.country1) and (symborders.country2 not in  (select country from isMember im where symborders.country2=isMember.country and isMember.organization=im.organization)) group by organization;

create or replace view bla as (select distinct i.organization, sum(symborders.length) as summe from isMember i, (select * from borders union select country2, country1,length from borders) symborders where symborders.country1=i.country and symborders.country2 not in (select country from isMember im where im.organization=i.organization) group by organization); 
	select * from bla union (select o.name, 0 from organization o where not exists (select * from bla where bla.organization=o.abbreviation));

with (select distinct i.organization, sum(symborders.length) from isMember i, (select * from borders union select country2, country1,length from borders) symborders where symborders.country1=i.country and symborders.country2 not in (select country from isMember im where im.organization=i.organization) group by organization) as bla
	select * from bla union (select o.name, 0 from organization o where not exists (select organization from bla b where b.organization=o.name) );

/*select distinct i.organization, sum(symborders.length) 
from isMember i, (	select * 
			from borders 
			union 
			select country2, country1,length 
			from borders) symborders 
	where symborders.country1=i.country 
	and (symborders.country2 not in (	select country 
						from isMember im 
							where im.organization=i.organization)) 
group by organization;*/
