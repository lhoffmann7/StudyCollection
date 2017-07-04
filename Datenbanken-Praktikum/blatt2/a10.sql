create or replace view City_V (name,country,province,population,Coordinates,elevation) AS select name,country,province,population,GeoCoord(c.latitude,c.longitude),elevation from city c;

select name from city_v c where c.coordinates.latitude >= 0;
