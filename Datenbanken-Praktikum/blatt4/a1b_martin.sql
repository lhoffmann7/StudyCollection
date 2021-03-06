set serveroutput on;
create or replace function riverlength2_martin (riv VARCHAR2)
return number
is
   len number := 0;
   bla number :=0;
begin
--select sum(length) into len from river where name=riv group by name;
dbms_output.put_line(len);
for entry in (select name as r.river,r.length,r.lake from river,lake where river=riv or lake = riv)
loop
dbms_output.put_line(entry.river|| ' '  || entry.lake|| ' ' || entry.length);
			if entry.lake is not null then
				dbms_output.put_line('Lake');
				dbms_output.put_line(entry.lake);
				Select riverlength2(entry.lake) INTO bla from dual;
  	  	len:=len+bla;
			else
				dbms_output.put_line(entry.river);
  	  	len:=len+riverlength2(entry.river);
	  	end if;
--dbms_output.put_line(entry.river|| ' '  || entry.lake|| ' ' || entry.length);
end loop;
	return len;
end;
/

