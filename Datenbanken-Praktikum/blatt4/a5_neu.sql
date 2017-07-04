create or replace synonym distances for dbis.distances;
set serveroutput on;

create table banlist (Code VARCHAR(4), subtreeindex number);

create table mstlist (Code1 VARCHAR(4),Code2 VARCHAR(4), dist number);

create or replace procedure lol 
is
connectto1 number:=0;
connectto2 number:=0;
setsubtreeindex number:=1;
begin
	for entry in (select * from distances order by dist asc)
	loop
		for bentry in (select * from banlist)
		loop
			if bentry.code=entry.code1 then connectto1:=bentry.subtreeindex; end if;
			if bentry.code=entry.code2 then connectto2:=bentry.subtreeindex; end if;
		end loop;
		--if entry.code1 in (select * from banlist) and entry.code2 in (select * from banlist) then
		if (connectto1=0 and connectto2=0) then
			insert into banlist values (entry.code1, setsubtreeindex);
			insert into banlist values (entry.code2, setsubtreeindex);
			insert into mstlist values (entry.code1,entry.code2,entry.dist);
			setsubtreeindex:= setsubtreeindex + 1;
			connectto1:=0;
			connectto2:=0;
		elsif (connectto1 = connectto2) then
			connectto1:=0;
			connectto2:=0;
			continue;
		elsif (connectto1 = 0) then
			insert into banlist values (entry.code1, connectto2);
			connectto1:=0;
			connectto2:=0;
		elsif (connectto2 = 0) then
			insert into banlist values (entry.code2, connectto1);
			connectto1:=0;
			connectto2:=0;
		else 
			for banentry in (select * from banlist)
			loop
				if banentry.subtreeindex = connectto2 then banentry.subtreeindex:= connectto1; end if;
			end loop;
			connectto1:=0;
			connectto2:=0;			
			
			
		end if;
	end loop;
	--dbms_output.put_line(select max(dist) as maximum from mstlist);
end;
/
