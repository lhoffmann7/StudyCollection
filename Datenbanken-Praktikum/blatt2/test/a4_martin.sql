create or replace view at_sea as (select distinct c.code,c.name from geo_sea g,country c where c.code = g.country);

create or replace view not_at_sea as (select code from country where not exists (select * from geo_sea where country=code));

Select c.name from not_at_sea n,country c WHERE not exists (
	select * from geo_sea g where g.country in(
		select b.country2 from symbord b where b.country1 = n.code
	)
) and c.code = n.code;
