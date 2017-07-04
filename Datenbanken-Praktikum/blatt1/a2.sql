/*Aufgabe 1.2 (5P.)
Geben Sie Name und Departement (=Provinz) von allen französischen Städten an, die nicht an einem Fluss liegen.*/

select name,province from city c where c.country='F' and not exists (select * from located l where l.city=c.name and l.country='F' and river is not null);

-- select distinct name, province from city where country='F' and name not in (select city from located l where l.river is not null); 

/*SELECT name,province 
FROM city c 
	WHERE c.country='F' 
	AND NOT EXISTS (SELECT * 
			FROM located l 
				WHERE l.city=c.name 
				AND river IS NOT null);*/
