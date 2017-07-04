--fertig
create or replace trigger delSea
after   delete
	on sea
begin
	delete from located where river is null and sea is null and lake is null;
end;
/


create or replace trigger delLake
after   delete
	on lake
	for each row
begin	
	update located set lake=null where lake=:old.name;
	delete from located where sea is null and river is null and lake is null;
end;
/

create or replace trigger delRiver
after   delete
	on river
	for each row
begin
	update located set river=null where river=:old.name;
	delete from located where sea is null and river is null and lake is null;
end;
/
