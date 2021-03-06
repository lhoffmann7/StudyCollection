-- Khartoum ist Hauptstadt vom Sudan (Code = 'SUD')

--Nachbarländer der Nachbarländer vom Sudan ohne den Sudan selber und ohne die Länder, die selber Nachbarland vom Sudan sind.
Create or replace view NachbarNachbarLaenderB2A6 AS select distinct s.country2 from symbord s ,encompasses e,(Select country2 from symbord sy where sy.country1 = 'SUD') bla where bla.country2 = s.country1 and s.country2 != 'SUD' and e.continent='Africa' and e.country = s.country2 MINUS (Select country2 from symbord sy where sy.country1 = 'SUD');

--Alle Nachbarlaender der Nachbarlaender deren Bevölkerungsdichte größer ist als 60
Create or replace view DichteGroesser60B2A6 AS Select c.name,c.code,c.population,c.area AS Density from NachbarNachbarLaenderB2A6 n,country c where n.country2 = c.code and c.population/c.area>60;

--Alle Nachbarlaender der Nachbarlaender deren Bevölkerungsdichte kleiner ist als 60
Create or replace view DichteKleiner60B2A6 AS (select c.name,c.population,c.area AS Density from country c, NachbarNachbarLaenderB2A6 n where not exists(select country2 from DichteGroesser60B2A6 d where d.code = n.country2) and n.country2 = c.code);

--Aufgabenteil 1
select sum(floor(c.population/100000)) AS Haeuptlinge1 from country c, NachbarNachbarLaenderB2A6 n where n.country2 = c.code;

--Aufgabenteil 2
select (gr.groesser+kl.kleiner) AS Haeuptlinge2 from (select sum(floor(k.population/100000)) AS kleiner from DichteKleiner60B2A6 k) kl,(select sum(floor(g.population/200000)) AS groesser from DichteGroesser60B2A6 g) gr;
