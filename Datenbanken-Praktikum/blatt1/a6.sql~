/*Aufgabe 1.6 (5P.)
Welches ist die Stadt, in der die Sonne nach dem Sonnenaufgang am 21.9.in Dakar als nächstes aufgeht?
Welches ist diejenige Großstadt (>500.000 Einwohner), für die dies gilt?*/

--Aufgabenteil 1
Select c.name from (select MAX(c.longitude) AS longitude from (select longitude from city where name = 'Dakar') DakarLong,city c  where c.longitude<Dakarlong.longitude) maxlong,city c where c.longitude = maxlong.longitude;

--Aufgabenteil 2
Select c.name from (select MAX(c.longitude) AS longitude from (select longitude from city where name = 'Dakar') DakarLong,city c  where c.longitude<Dakarlong.longitude and c.population >500000) maxlong,city c where c.longitude = maxlong.longitude;
