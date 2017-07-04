create or replace view no_sea_country as (select c.code as country from country c where not exists(select * from geo_sea gs where gs.country = c.code) );

create or replace view sea_country as (select c.code as country from country c where exists(select * from geo_sea gs where gs.country = c.code));

create or replace view neighbor_no_sea_country as 
(	select c.country 
	from no_sea_country c 
		where exists(	select * 
				from symbord s 
					where c.country = s.country1 or c.country = s.country2
					and not exists(	select * from sea_country sc where sc.country = s.country2 )
					and not exists(	select * from sea_country sc where sc.country = s.country1 ) ) );




