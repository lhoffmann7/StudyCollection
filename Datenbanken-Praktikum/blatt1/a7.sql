/*Aufgabe 1.7 (10P.)
Geben Sie alle Inseln (nach Größe absteigend geordnet) aus, auf denen es
eine Stadt gibt, die nicht am Meer liegt.*/

--select city from locatedOn lo where not exists (select * from located l where l.city=lo.city and l.sea is not null);
select distinct island, area from locatedOn lo, Island i where not exists (select * from located l where l.city=lo.city and l.country=lo.country and l.sea is not null) and i.name=island order by 2 DESC;
-- probably wrong
--select distinct island, area from locatedOn lo, Island i where exists (select * from located l where l.city=lo.city and l.sea is null) and i.name=island order by 2 DESC;


/*SELECT DISTINCT island, area 
FROM locatedOn lo, Island i 
	WHERE NOT EXISTS (	SELECT * 
				FROM located l 
					WHERE l.city=lo.city 
					AND l.sea IS NOT null) 
	AND i.name=island 
ORDER BY 2 DESC;*/
