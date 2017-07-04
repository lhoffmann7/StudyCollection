-- alle russischen berge inkl. coordinaten
create or replace view russianMountains as (select m.name, m.coordinates from Mountain m, geo_Mountain gm where gm.country='R' and gm.mountain=m.name);
-- city eintraege nicht vollstaendig. Bei vielen fehlt longitude/latitude -> rausschmeissen aus der liste 
create or replace view distances as (select c.name, r.name as mountain, sqrt((power(c.latitude-r.coordinates.latitude,2)+power(c.longitude-r.coordinates.longitude,2))) as distance from city c, russianMountains r where c.latitude is not null and c.longitude is not null);
-- finale anfrage, mach subtabelle in der nur mountains und minimale distance drinnenstehen und join ueber mountain und distance
select d.name, d.mountain, d.distance from distances d, (select mountain, min(distance) as distance from distances group by mountain) ds where ds.distance=d.distance and d.mountain=ds.mountain;
