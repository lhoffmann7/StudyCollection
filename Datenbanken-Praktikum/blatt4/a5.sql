create or replace synonym distances for dbis.distances;
set serveroutput on;

create table banlist (Code VARCHAR(4));

create table mstlist (Code1 VARCHAR(4),Code2 VARCHAR(4), dist number);

create or replace procedure lol 
is
bool1 number:=0;
bool2 number:=0;
begin
	for entry in (select * from distances order by dist asc)
		loop
		for asdf in (select * from banlist)
		loop
			if asdf.code=entry.code1 then bool1:=1; end if;
			if asdf.code=entry.code2 then bool2:=1; end if;
		end loop;
 		--if entry.code1 in (select * from banlist) and entry.code2 in (select * from banlist) then
		if (bool1=1 and bool2=1) then
			bool1:=0;
			bool2:=0;
			continue;	
  		end if;
  		insert into banlist values (entry.code1);
  		insert into banlist values (entry.code2);
  		insert into mstlist values (entry.code1,entry.code2,entry.dist);
		bool1:=0;
		bool2:=0;
		end loop;
	--dbms_output.put_line(select max(dist) as maximum from mstlist);
end;
/
