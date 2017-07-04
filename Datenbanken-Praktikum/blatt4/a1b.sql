create or replace view riverorlake as select name,river,0 as length from lake l union (select name,river,nvl(length,0) from river r where r.river is not null) union (select name,lake,nvl(length,0) from river where lake is not null and not (lake,name) in (select name,river from lake)) union (select name,river,nvl(length,0) from river where river is null and lake is null);

set serveroutput on;
create or replace function riverlength2 (riv VARCHAR2)
return number
is
   len number := 0;
   
begin
select nvl(length,0) into len from riverorlake where name=riv;
--dbms_output.put_line(len);
for entry in (select * from riverorlake where river=riv)
loop
					
		dbms_output.put_line(entry.name || ' ' || entry.length);
  	  	len:=len+riverlength2(entry.name);
	  	
--dbms_output.put_line(entry.river|| ' '  || entry.lake|| ' ' || entry.length);
end loop;
	
	--dbms_output.put_line('loopende');
	return len;
end;
/
