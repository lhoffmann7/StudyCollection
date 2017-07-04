create or replace synonym distances for dbis.distances;
set serveroutput on;

create table banlist (Code VARCHAR(4), subtreeindex number, constraint bankey primary key (code,subtreeindex) );

create table mstlist (Code1 VARCHAR(4),Code2 VARCHAR(4), dist number);

create or replace procedure order66 
is
connectto1 number:=0;
connectto2 number:=0;
setsubtreeindex number:=1;
begin
	for entry in (select * from distances order by dist asc)
	loop
		connectto1:=0;
		connectto2:=0;
		for bentry in (select * from banlist)
		loop
			if bentry.code=entry.code1 then connectto1:=bentry.subtreeindex; end if;
			if bentry.code=entry.code2 then connectto2:=bentry.subtreeindex; end if;
		end loop;

		if (connectto1=0 and connectto2=0) then
			insert into banlist values (entry.code1, setsubtreeindex);
			insert into banlist values (entry.code2, setsubtreeindex);
			insert into mstlist values (entry.code1,entry.code2,entry.dist);
			setsubtreeindex:= setsubtreeindex + 1;			
		elsif (connectto1 = connectto2) then
			continue;
		elsif (connectto1 = 0) then
			insert into banlist values (entry.code1, connectto2);
			insert into mstlist values (entry.code1,entry.code2,entry.dist);			
		elsif (connectto2 = 0) then
			insert into banlist values (entry.code2, connectto1);
			insert into mstlist values (entry.code1,entry.code2,entry.dist);			
		else 
			for banentry in (select * from banlist)
			loop
				if banentry.subtreeindex = connectto2 then update banlist set banlist.subtreeindex = connectto1 where banlist.code = banentry.code and banlist.subtreeindex = banentry.subtreeindex;	 end if;
			end loop;
					
			insert into mstlist values (entry.code1,entry.code2,entry.dist);
			
		end if;


	end loop;
	--dbms_output.put_line(select max(dist) as maximum from mstlist);
end;
/
