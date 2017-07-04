create or replace function lakelength(lak VARCHAR2)
return number
is
lalen number := 0;
begin
	Select riverlength2(river) INTO lalen from lake where name=lak;
	return lalen;
end;
/
