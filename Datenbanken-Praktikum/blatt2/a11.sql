-- population of all cities in usa difference 1980 2010

select cp.city, cp.population as eighties, cpp.population as twothousands, (cpp.population-cp.population)/(cp.population)*100 as difference from Citypops cp, Citypops cpp where cp.city=cpp.city and cp.country='USA' and cpp.country='USA' and cp.province=cpp.province and cp.year=1980 and cpp.year=2010 order by 1 asc;

-- was faellt auf? kA, bestimmte staedte mit erklaerbaren, grossen verlusten (n.o. durch hurricane, detriot finanzkrise/zusammenbruch autoindustrie, baltimore drogenhoelle/drecksloch)
-- nashville /nashville davidson buggt
