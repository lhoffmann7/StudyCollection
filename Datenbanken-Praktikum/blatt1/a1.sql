/*Aufgabe 1.1 (5P.)
Geben Sie von jeder Organisation die Summe der Einwohner aller Mitgliedsländer absteigend geordnet an.
(lassen Sie die verschiedenen Arten von Mitgliedschaften unberücksichtigt).*/

select o.name, sum(c.population) from organization o,country c,isMember i where i.country=c.code and i.organization=o.abbreviation group by o.name order by 2 DESC;

/*SELECT o,name, sum(c.population)
FROM organization o, country c, ismember i
	WHERE i.country = c.code
	AND i.organization = o.abbreviation
GROUP BY o.name
ORDER BY 2 DESC;*/

