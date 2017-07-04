/*Aufgabe 1.4 (10P.)
Geben Sie die Namen aller Organisationen an, in denen alle Länder mit einem Bruttoinlandspro-
dukt von mehr als 30000$ pro Person Mitglied sind (diese Operation wird als relationale Division
bezeichnet; das BIP eines Landes ist als “gdp” in der Tabelle “Economy” in Millionen $ zu finden).*/


select distinct o.name from organization o, isMember i where o.abbreviation=i.organization and not exists (select * from Country c, Economy e where c.code=e.country and (e.gdp*1000000/c.population)>100000 and not exists (select * from isMember im where im.organization=i.organization and c.code=im.country));



/*SELECT DISTINCT o.name 
FROM organization o, isMember i 
	WHERE o.abbreviation=i.organization 
	AND NOT EXISTS (SELECT * 
			FROM Country c, Economy e 
				WHERE c.code=e.country 
				AND (e.gdp*1000000/c.population)>100000 
				AND NOT EXISTS (SELECT * 
						FROM isMember im 
							WHERE im.organization=i.organization 
							AND c.code=im.country));*/
