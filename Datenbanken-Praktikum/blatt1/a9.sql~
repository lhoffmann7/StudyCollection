/*Aufgabe 1.9 (UEFA) (10P.)
•Alle Staaten, die Anteil an Europa haben, nehmen an der Qualifikation zur Fussball-Europa-meisterschaft (bzw. der Europa-Qualifikation zur WM) teil.

•Armenien, Georgien, Aserbeidschan, Kasachstan und Israel nehmen ebenfalls an der Qualifikation zur Fussball-Europameisterschaft teil.

•Alle anderen Staaten, zu mindestens ihrer halben Fläche in Asien liegen nehmen an der Qualifikation zur Asienmeisterschaft teil.

Fragen:
•Wieviele Flächen-Anteile an der EM-Qualifikation liegen in Asien?

•Wieviele % der asiatischen Fläche sind bei der Asien-Meisterschaft vertreten?*/

--Aufgabenteil 1

create or replace view laenderEmBonusB1A9 AS select * from country where name='Armenia' or name = 'Georgia' or name = 'Azerbaijan' or name = 'Israel';

create or replace view laenderTeilwInEuropaB1A9 AS select l.name,e.percentage,(l.area*e.percentage/100) AreaInEurope,l.area-(l.area*e.percentage/100) AreaInAsia from country l,encompasses e,continent c where c.name = e.continent AND l.code = e.country AND c.name='Europe' AND e.percentage != 100;

select (sum(emasia.AreaInAsia)+sum(bonus.area))/(sum(em.area)+sum(bonus.area)) AS Percentage_In_Asia from 
(select l.name,l.area from country l, encompasses e, continent c where c.name = e.continent AND l.code = e.country AND c.name='Europe') em,
laenderTeilwInEuropaB1A9 emasia,
laenderEmBonusB1A9 bonus; 

--Aufgabenteil 2
select (c.area-bla.diff)/c.area AS Percentage_in_Asia from continent c,(SELECT (sum(bonus.area)+sum(teilEu.AreaInAsia)) AS Diff FROM laenderEmBonusB1A9 bonus,laenderTeilwInEuropaB1A9 teilEu) bla where c.name='Asia';
