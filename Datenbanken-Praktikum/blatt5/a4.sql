create or replace type Geocoord as object (
Latitude NUMBER,
Longitude NUMBER,
MEMBER FUNCTION distance(bla in Geocoord) RETURN NUMBER	
) NOT FINAL
;
/

CREATE TYPE BODY Geocoord
AS
	MEMBER FUNCTION distance(bla in Geocoord) RETURN NUMBER 
	IS
	rueck number:= 0;
	BEGIN
		select sqrt((self.longitude-bla.longitude)*(self.longitude-bla.longitude)+(self.latitude-bla.latitude)*(self.latitude-bla.latitude)) into rueck from dual;
		
		return rueck;
	END distance;
END;
/
--Wie heißt der Berg? Irazu.
--select m.coordinates.distance(GeoCoord(s.latitude,s.longitude)) as distance,m.name,m.elevation from (select coordinates,name,elevation from mountain) m,(select c.latitude,c.longitude from city c where c.name = 'San Jose' and c.country = 'CR' and c.Province = 'San Jose') s order by 1 asc offset 0 ROWS FETCH NEXT 1 ROWS ONLY ;
--
--Was können wir sehen? Alles in einem Umkreis von 209,313 km (wenn der Blick den Erdboden auf Höhe von 0mNN trifft) sqrt((6378000+3432+1,7)²-6378000²)
--209,3163KM entsprechen 1.91°
--select * from (select m.coordinates.distance(s.coordinates) as distance,m.name,m.elevation from (select coordinates,name,elevation from mountain) m,(select coordinates from mountain c where c.name = 'Irazu') s) n where n.distance <= 1.91;
--select * from (select m.coordinates.distance(s.coordinates) as distance,m.name from (select Geocoord(latitude,longitude) as coordinates,name from city) m,(select coordinates from mountain c where c.name = 'Irazu') s) n where n.distance <= 1.91;

--CREATE TYPE BODY Geocoord
--AS
--	MEMBER FUNCTION distance(bla in Geocoord) RETURN NUMBER 
--	IS
--	rueck number:= 0;
--	BEGIN
--		select (111.324 * acos(sin(self.latitude) * sin(bla.latitude) + cos(self.latitude) * cos(bla.latitude) * cos(self.longitude - bla.longitude))) into rueck from dual;
--		
--		return rueck;
--	END distance;
--END;
--/
