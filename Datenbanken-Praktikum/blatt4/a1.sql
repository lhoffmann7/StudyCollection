create or replace view riverorlake as select name,river,0 as length from lake l union (select name,river,length from river r) union (select name,lake,length from river where not (lake,name) in (select name,river from lake));

set serveroutput on;
create or replace function riverlength (riv VARCHAR2)
return number
   
is
   len number := 0;
   temp number := 0;
begin

select nvl(length,0) into len from river where name=riv;

--dbms_output.put_line(len);
for entry in (select * from river where river=riv and length is not null)
loop
			--dbms_output.put_line(entry.name);
    	len:=len+riverlength(entry.name);
end loop;
	return len;
end;
/
