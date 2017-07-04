/*Aufgabe 1.3 (10P.)
a) Geben Sie alle Länder an, bei denen die Hauptstadt nicht die größte Stadt ist.
b) Geben Sie für diese Länder an, wieviele ihrer Städte größer als die Hauptstadt sind.*/

select c.name from country c where exists (select * from city ci, city cap where ci.country=c.code and cap.country=c.code and cap.name=c.capital and ci.population > cap.population);

/*SELECT c.name 
FROM country c 
	WHERE EXISTS (	SELECT * 
			FROM city ci, city cap 
				WHERE ci.country=c.code 
				AND cap.country=c.code 
				AND cap.name=c.capital 
				AND ci.population > cap.population);*/

--select c.name from city c where  exists (select * from country ci where ci.country=c.code and ci.population > x.population);
--select c.name from country c, (select t.population as population,co.code as name from country co, city t where t.name=co.capital) caps where exists (select * from city ci where ci.country=caps.name and ci.country=c.code and ci.population > caps.population);
-- create or replace view cigrcap (select city.name city, country.name country from city, country where city.country = country.code) minus all
--b
select c.name, count(*) from country c,city ci, city cap where ci.country=c.code and cap.country=c.code and cap.name=c.capital and ci.population > cap.population group by c.name;

/*SELECT c.name, count(*) 
FROM country c,city ci, city cap 
	WHERE ci.country=c.code 
	AND cap.country=c.code 
	AND cap.name=c.capital 
	AND ci.population > cap.population 
GROUP BY c.name;*/
