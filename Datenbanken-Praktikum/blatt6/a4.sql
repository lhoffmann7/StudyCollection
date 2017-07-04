create or replace view coneco as (select c.code as country,c.population as population, e.gdp as gdp from country c, economy e where c.code = e.country );

create or replace view gdpbigger as ((select c1.country as country, sum(e.gdp) + c1.gdp as bigger from economy c1, coneco e, country c where c.code = c1.country and e.gdp/e.population > c1.gdp/c.population group by c1.country, c1.gdp) union (select c1.country as country, c1.gdp as bigger from economy c1, coneco e, country c where c.code = c1.country and e.country = c1.country and not exists (select * from economy e2, country c2 where c2.code = e2.country and e2.gdp/c2.population > c1.gdp/c.population) and c1.gdp is not null));

create or replace view welthalbe as (select sum(e.gdp)/2 troet from economy e);

create or replace view aussort as (select * from gdpbigger g, welthalbe w where g.bigger >= w.troet);

create or replace view erg as (select a1.country , a1.bigger from  aussort a1 where not exists (select * from aussort a2 where a2.bigger < a1.bigger) );
