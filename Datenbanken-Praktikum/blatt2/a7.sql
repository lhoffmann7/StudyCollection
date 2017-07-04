-- relation country_new erstellen, daten der laender ohne einwohnerzahlen
-- view country_v, ersetzt country und enthaelt korrekte Einwohnerzahlen

create table country_new (
  name varchar2(50) not null,
  code varchar2(4) primary key,
  capital varchar2(50),
  province varchar2(50),
  area number
);

insert into country_new select name, code, capital, province, area from country;

create or replace view country_v as (select c.code, sum(p.population) as population from country_new c, Province p where c.code=p.country group by c.code);
