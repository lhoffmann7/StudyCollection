/*Aufgabe 1.8 (20P.)
[Hauptstädte und Headquarters]
•Geben Sie Informationen zu allen Städten wie folgt aus: Name, Province und Country, ausser dem in der Spalte capitalOf den Namen des Landes,
falls eine Stadt Hauptstadt eines Landes ist, und in der Spalte headqOf die Organisationen, die dort ihren Sitz haben.

•Geben Sie Name, Province und Country, ausserdem in der Spalte CapOrHQ den Namen des Landes, falls eine Stadt Hauptstadt eines Landes ist, und
sonst die Organisationen, die dort ihren Sitz haben.*/

--Aufgabenteil 1 (Gaza-Streifen hat keine Hauptstadt!!!!!)
--SELECT ci.name,ci.province,caps.country AS CapitalOf, o.name AS HeadqOf from city ci LEFT OUTER JOIN (Select c.name,c.province,capList.name AS country from (Select name,code,capital from country) capList,city c where capList.capital = c.name AND capList.code = c.country) caps  ON ci.name=caps.name left outer join organization o on ci.name=o.city order by 1 desc;

-- aufgabenteil2

create or replace view capAndHq as SELECT ci.name,ci.province,caps.country AS CapitalOf, o.name AS HeadqOf from city ci LEFT OUTER JOIN (Select c.name,c.province,capList.name AS country from (Select name,code,capital from country) capList,city c where capList.capital = c.name AND capList.code = c.country) caps  ON ci.name=caps.name left outer join organization o on ci.name=o.city;

create or replace view removeDuplicatesAndBlanks as select * from capAndHq minus select * from capAndHq where (capitalof is null and headqof is null) or (capitalof is not null and headqof is not null);

create or replace view finalResult as (select name, province, capitalof as caporhq from capAndHq where capAndHq.capitalof is not null);

(select name, province, caporhq from finalResult) union (select name,province,headqof as caporhq from removeDuplicatesAndBlanks where headqof is not null);
