set serveroutput on;
create or replace procedure halfGDP
is 
halfBIP number:= 0;
addBIP number:= 0;
begin
	select sum(gdp)/2 into halfBIP from economy;
	for entry in (select gdp as gdp,country  from economy, country  where code=country and gdp is not null order by gdp/population desc)	
	LOOP
		if addBIP + entry.gdp > halfBIP then
			addBIP := (halfBIP-addBIP)/entry.gdp;
		        dbms_output.put_line(to_char(entry.country) || ' ' || to_char(addBIP));
			exit;
		end if;
		addBIP := addBIP + entry.gdp;
		dbms_output.put_line(entry.country || ' 1');
	END LOOP;
end;
/


