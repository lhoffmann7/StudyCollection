create or replace procedure lol 
is
asdf number :=0;
begin
	for entry in (select * from dbis.distances order by dist asc)
	loop
--   if entry.code1 in (select * from banlist) and entry.code2 in (select * from banlist) then
--	continue;
--   end if;
--   insert into table banlist values (entry.code1);
--   insert into table banlist values (entry.code2);
--   insert into table mstlist values (entry.code1,entry.code2,entry.dist);
	end;
--dbms_output.put_line(select max(dist) as maximum from mstlist);
end;
/
