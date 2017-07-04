--3a
-- Update nicht über das View (GB zu UK), dann ist auch die Änderung im View vorhanden
--SET constraints all deferred;
--update Country SET code='UK' WHERE Code='GB';
--update Province SET country='UK' WHERE Country='GB';
--Update Population set country='UK' WHERE Country='GB';
--Update Economy set country='UK' WHERE Country='GB';
--COMMIT;

--Create or replace View help as( select c.population * p.population_growth as population , c.code as country from population p,country c where c.code = p.country);

update View1 set population =  population*(1+ population_growth/100);

--(select h.population from help h where h.country =  country.code) where country.code in (select h.country from help h where h.country =  country.code);

Create or replace View View1 as (
	Select  c.code, c.population, p.infant_mortality,p.population_growth, e.gdp, e.inflation, e.gdp/c.population AS bip_kopf, c.population/c.area as BevDichte
	FROM country c 
	JOIN population p 
	ON p.country = c.code 
	JOIN economy e 
	ON e.country = c.code );


Select code, bip_kopf, BevDichte, infant_mortality, population_growth
from View1
Order by bip_kopf ;

Select * from USER_UPDATABLE_COLUMNS
WHERE Table_Name = 'VIEW1';

-- Update GB zu UK über das View
-- Dann fehlt Great Britain, weil über den code gejoint wird

update View1
set code = 'UK'
where code = 'GB';

--update View1
--set population = population*population_growth;









