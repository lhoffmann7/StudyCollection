start a1.sql;

create or replace type ccc as object (
  c varchar2(50)
);
/

create or replace type t_nested_table as table of ccc;
/


CREATE TYPE Organization_Type AS OBJECT
(Name VARCHAR2(80),
Abbrev VARCHAR2(12),
Established DATE,
hasHqIn REF City_Type,
MEMBER FUNCTION set_member_type(Cou IN VARCHAR2, typ IN VARCHAR2) return number,
MEMBER FUNCTION get_member_type RETURN t_nested_table,
MEMBER FUNCTION getpop return number
) NOT FINAL;
/

-- ABFRAGE FUER get_member_type select * from table(select m.get_member_type() from Organization_ObjTab m where m.abbrev='EU');
-- select m.set_member_type('D','member') from Organization_ObjTab m where m.abbrev='AMF';

CREATE TYPE BODY Organization_Type
IS
	MEMBER FUNCTION get_member_type return t_nested_table
	IS
	ret t_nested_table;
	BEGIN
		ret := t_nested_table();
		for entry in (select country from isMember where Organization=self.abbrev)
		LOOP
			ret.extend;
			ret(ret.count) := ccc(entry.country);
		END LOOP;
		return ret;
	END get_member_type;
	MEMBER FUNCTION set_member_type (Cou IN VARCHAR2, typ IN VARCHAR2) return number
	IS
	PRAGMA AUTONOMOUS_TRANSACTION;
	bool number := 0;
	BEGIN
		for entry in (select * from ismember where country=Cou and Organization=self.abbrev)
		LOOP
			update ismember set type=typ where country=Cou and Organization=self.abbrev;
			commit;
			bool := 1;
		END LOOP;
		if bool = 0 THEN
			insert into ismember values (Cou,self.abbrev,typ);
			commit;
		END IF;
		return 1;
	END set_member_type;
	MEMBER FUNCTION getpop return number is
	ret number;
	begin
	select c.population into ret from City_ObjTab c where self.hasHQin.name=c.name and self.hasHQIN.province=c.province and self.hasHQIN.country=c.country;
	return ret;
	end getpop;
END;
/

CREATE TABLE Organization_ObjTab OF Organization_Type
(PRIMARY KEY (Abbrev ),
SCOPE FOR (hasHqIn) IS City_ObjTab);

INSERT INTO Organization_ObjTab Select
Organization_Type(p.name, p.abbreviation,p.established,ref(c)) from organization p, city_objtab c where p.city = c.name and p.country = c.country and p.province = c.province; 

