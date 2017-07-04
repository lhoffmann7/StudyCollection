create or replace synonym country for lukashoffmann2.country;
create or replace synonym mountain for stefansiemer.mountain;
create or replace synonym encompasses for kneuman.encompasses;
create or replace synonym continent for stefansiemer.continent;
--maybe more

create or replace view doublem as (select a.mountain,a.country as c1,b.country as c2 from geo_mountain a, geo_mountain b where a.mountain=b.mountain and a.country!=b.country);

select distinct * from doublem m where not exists (select * from borders where (m.c1=country1 and m.c2=country2) or (m.c1=country2 and m.c2=country1));

select c.name from continent c where not exists (select * from encompasses where continent=c.name);

select * from country c where not exists (select * from encompasses enc where enc.country=c.code);
