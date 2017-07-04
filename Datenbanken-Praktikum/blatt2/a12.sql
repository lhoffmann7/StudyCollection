-- setzen meines Datumsformats
alter session set nls_date_format= 'DD.MM.YYYY';

-- erste Anfrage
SELECT Country, Independence FROM politics
WHERE Independence BETWEEN '01.01.1300' AND '31.12.1599';

-- zweite Anfrage
-- 'J' ist das julianische Datum
Select to_date(round(avg(to_number(to_char(p.independence,'J')))),'J') as avg_date
from politics p, encompasses e
where e.country = p.country
and e.continent='Europe';


-- dritte anfrage
alter session set nls_date_format = 'DD. MON';
select country, independence from politics;
--
---- vierte anfrage, schmeisst die null werte automatisch raus
alter session set nls_date_format ='dd/MM/yy';
select country, independence from politics where extract(month from independence) between '01' and '06';
--
----fuenfte anfrage
-- symmetric relation mit allen die innerhalb max. eines halben jahres liegen.
create or replace view symmetricInd as select p.country as c1, p1.country as c2, p.independence as i1, p1.independence as i2 from politics p, politics p1 where p.country != p1.country and (p.independence - p1.independence between -182 and 182);
--
--rausschmeissen der duplikate (geht so weil ich weiss, dass alle doppelt vorkommen)
select s.c1, s.c2, s.i1, s.i2 from symmetricInd s inner join symmetricInd s1 on s.c1=s1.c2 and s.c2=s1.c1 and s.c1>s1.c1;

