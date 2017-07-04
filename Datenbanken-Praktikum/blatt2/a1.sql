/*Die borders-Relation ist in Mondial als nicht-symmetrische Relation gespeichert. Es ist sinnvoll,
wenn man sich ein View, das die symmetrische Hülle von borders enthält, definiert und zur Lösung
der weiteren Aufgaben verwendet*/

create or replace view symbord as (select * from borders) union (select country2, country1, length from borders);
