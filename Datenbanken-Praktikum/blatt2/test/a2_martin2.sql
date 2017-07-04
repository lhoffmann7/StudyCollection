Select distinct c.name,n.country2 from country c, organization o, (select s.country1,s.country2 from symbord s,country co where s.country1=co.code) n where c.code = o.country and c.code = n.country1;
