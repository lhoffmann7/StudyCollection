--Alle Länder in Europa mit den dazugehörigen Meeren
create or replace view seacountryeuB2A3 as select distinct c.code AS code,g.sea AS sea from country c, encompasses e,geo_sea g where e.country = c.code and e.continent = 'Europe' AND g.country = c.code order by c.code asc; 
--Alle Länder in Europa mit der Anzahl der Meere an die sie Grenzen
create or replace view seacounteuB2A3 as select distinct code, count(*) AS num from seacountryeuB2A3 group by code order by code; 

create or replace view sameseacountry as (SELECT DISTINCT x1.code as land1, x2.code as land2, x1.sea as sea
FROM seacountryeuB2A3 x1, seacountryeuB2A3 x2
WHERE x1.sea = x2.sea AND x1.code != x2.code);

--Länder, die an die selbe Anzahl an Meeren grenzen (D-E und E-D kommen drin vor!!!)
--Select distinct s1.code,s2.code from seacounteuB2A3 s1, seacounteuB2A3 s2 where s1.num=s2.num and s1.code != s2.code order by 1 desc;

/*select s1.code AS code1,s2.code AS code2,s1.sea AS sea1,s2.sea AS sea2 from seacountryeuB2A3 s1, seacountryeuB2A3 s2,seacounteuB2A3 se1, seacounteuB2A3 se2 where s1.sea = s2.sea and s1.code != s2.code and se1.num=se2.num and se1.code!=se2.code and s1.code = se1.code and s2.code = se2.code order by 1 asc;*/


create or replace view seareal as (select y.country as country ,
y.sea as sea from geo_sea y where exists (select x.land1, x.land2, x.sea
from sameseacountry x where x.sea = y.sea));

select x.land1, x.land2, x.sea
from sameseacountry x
where not exists (select * 
			from seareal sr
			where sr.sea = x.sea
			and not exists (select *
					from seareal sr2
					where x.land1 = sr.country) );
