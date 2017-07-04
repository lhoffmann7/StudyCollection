--Geben Sie für jeden Kontinent an, wieviele Länder auf diesem Kontinent liegen, die keine Küste haben

-- hier sind noch duplikate drinnen, d.h. russland zaehlt zu beiden kontinenten z.B., wobei das eh am meer liegt. Kann aber doppelte geben
select e.continent, count(*) as noSea from encompasses e, country c where e.country=c.code and (not exists (select * from geo_sea l where l.country=c.code)) group by e.continent;

create or replace view not_at_sea as (select code from country where not exists (select * from geo_sea where country=code));

create or replace view not_at_sea2 as (select distinct code from country where not exists (select * from geo_sea where country=code));

create or replace view neighbors as (select b.country1, b.country2 from symbord b, not_at_sea nas where nas.code = b.country1);

--das hier ist noch kaputt, bzw. sicher falsch.

--select nas.code from neighbors n, not_at_sea2 nas where not exists (select * from geo_sea gs where gs.country=n.country2) and n.country1=nas.code order by 1 asc;

--select nas.code from not_at_sea2 nas where not exists (select * from geo_sea gs where not exists ( select * from neighbors n where gs.country=n.country2 and n.country1=nas.code)) order by 1 asc;

Select c.name from not_at_sea n,country c WHERE not exists (
	select * from geo_sea g where g.country in(
		select b.country2 from symbord b where b.country1 = n.code
	)
) and c.code = n.code;
