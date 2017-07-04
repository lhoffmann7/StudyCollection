start a1.sql;

create or replace type ccc as object (
  c varchar2(50)
);
/

create or replace type t_nested_table as table of ccc;
/


CREATE TYPE Organization_Type AS OBJECT
(Name VARCHAR2(255),
Abbrev VARCHAR2(12),
Established DATE,
hasHqIn REF City_Type,
MEMBER FUNCTION set_member_type(Cou IN VARCHAR2, typ IN VARCHAR2) return number,
MEMBER FUNCTION get_member_type RETURN t_nested_table
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
END;
/

CREATE TABLE Organization_ObjTab OF Organization_Type
(PRIMARY KEY (Abbrev ),
SCOPE FOR (hasHqIn) IS City_ObjTab);

INSERT INTO Organization_ObjTab Select
Organization_Type(p.name, p.abbreviation,p.established,ref(c)) from organization p left outer join city_objtab c on p.city = c.name and p.country = c.country and p.province = c.province;
--Population aller Städte die Headquarter einer Org. sind
create or replace View popview as(select distinct c.name, c.population from Organization_ObjTab o, City_ObjTab c where o.hasHqIn.name = c.name and o.hasHqIn.province = c.province and o.hasHqIn.country = c.Country);

Select sum(population) from popview;


