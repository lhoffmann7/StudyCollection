/*Aufgabe 1.5 (10P.)
Bestimmen Sie die Bevölkerungsdichte der Region, die die Länder Algerien (DZ), Libyen (LAR)
und sämtliche Nachbarn dieser Länder umfasst. Berechnen Sie in einer zweiten Anfrage die
Bevölkerungsdichte die man erhält, wenn man dieWüsten als unbewohnbar berücksichtigt.*/


-- Abfrage für Aufgabenteil 1
SELECT sum(population)/sum(area) AS Density 
FROM (	SELECT DISTINCT c.area,c.population 
	FROM country c,borders b 
		WHERE (c.code = b.country1 OR c.code = b.country2) 
		AND (b.country1 = 'DZ' OR b.country2 = 'DZ' OR b.country1 = 'LAR' OR b.country2 = 'LAR'));

--View für die betroffenen Länder
CREATE OR REPLACE VIEW LaenderBlatt1Aufgabe5 	AS SELECT DISTINCT c.code, c.area,c.population 
						FROM country c,borders b 
							WHERE (c.code = b.country1 OR c.code = b.country2) 
							AND (b.country1 = 'DZ' OR b.country2 = 'DZ' OR b.country1 = 'LAR' OR b.country2 = 'LAR');

--View für die Fläche der Wüsten in den betroffenen Ländern
CREATE OR REPLACE VIEW AreaDesertBlatt1Aufgabe5 AS SELECT distinct d.name,d.area AS DesertArea 
						FROM LaenderBlatt1Aufgabe5 l,geo_Desert g,Desert d 
							WHERE g.desert = d.name 
							AND l.code = g.country;


--Abfrage für Aufgabenteil 2
SELECT (SELECT sum(population) FROM LaenderBlatt1Aufgabe5)/((SELECT sum(area) FROM LaenderBlatt1Aufgabe5)-(SELECT sum(DesertArea) from AreaDesertBlatt1Aufgabe5)) AS Density
FROM DUAL;
/*(	SELECT DISTINCT c.name,c.area,c.population 
	FROM country c,borders b 
		WHERE (c.code = b.country1 OR c.code = b.country2) 
		AND (b.country1 = 'DZ' OR b.country2 = 'DZ' OR b.country1 = 'LAR' OR b.country2 = 'LAR'));*/



--Abfrage von Kevin: select sum(population)/sum(area) from (select * from borders where country1='LAR' union select * from borders where country2='LAR') as libya, (select * from borders where country1='DZ' union select * from borders where country2='DZ') as alg, country c where
