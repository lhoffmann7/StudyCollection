set serveroutput on;
create or replace procedure wuff
is 
halfBIP number:= 0;
addBIP number:= 0;
begin
	for entry in (select * from dbis.distances order by dist asc)	
	LOOP
		halfBIP:=addBIP;
	END LOOP;
end;
/
