start a1.sql;


CREATE TYPE Member_Type AS OBJECT
(Country VARCHAR2(4),
Type VARCHAR2(30));
/
CREATE TYPE Member_List_Type AS
TABLE OF Member_Type;
/

CREATE TYPE Organization_Type AS OBJECT
(Name VARCHAR2(80),
Abbrev VARCHAR2(12),
Established DATE,
hasHqIn REF City_Type,
MEMBER FUNCTION set_organization_type(Countryin IN VARCHAR2, Typein IN VARCHAR2) RETURN NUMBER,
MEMBER FUNCTION get_organization_type RETURN Member_List_Type
) NOT FINAL;
/

--create or replace PROCEDURE del(Cti VARCHAR2) IS
--	PRAGMA AUTONOMOUS_TRANSACTION 
--	BEGIN
--		delete from ismember m where country = cti;
--		COMMIT;
--	END del;
--/

--create or replace PROCEDURE ins(ab VARCHAR2, Cti VARCHAR2, Ti VARCHAR2) IS
--	PRAGMA AUTONOMOUS_TRANSACTION
--	BEGIN
--		Insert into ismember values(ab, cti, ti);
--		COMMIT;
--	END ins;
--/
CREATE TYPE BODY Organization_Type
AS
	MEMBER FUNCTION set_organization_type(Countryin IN VARCHAR2, Typein in VARCHAR2) RETURN NUMBER 
	IS
	--	
	PROCEDURE del(Cti VARCHAR2) IS
	PRAGMA AUTONOMOUS_TRANSACTION 
	BEGIN
		delete from ismember m where country = cti;
		COMMIT;
	END del;
	PROCEDURE ins(ab VARCHAR2, Cti VARCHAR2, Ti VARCHAR2) IS
	PRAGMA AUTONOMOUS_TRANSACTION
	BEGIN
		Insert into ismember values(ab, cti, ti);
		COMMIT;
	END ins;
	--
	rueck number := 0;
	zahl number:= 0;
	temp VARCHAR2(50);
	BEGIN
		select count(*) into zahl from isMember m where m.country = countryin and m.organization = self.abbrev;
		if zahl > 0 then
			select name into temp from ismember m where m.country = countryin and m.organization = self.abbrev;
			del(name);
			rueck := 2;
		
		else	
			rueck := 1;
			
		END IF;
		ins(self.abbrev,countryin,typein);
		RETURN rueck;
	END set_organization_type;

	MEMBER FUNCTION get_organization_type RETURN Member_List_Type
	IS
	temp MEMBER_LIST_TYPE;
	BEGIN
		--Create or replace table temp as Table OF MEMBER_TYPE; 
		Select Member_list_type(MEMBER_TYPE(m.country, m.type)) into temp from ismember m where self.abbrev = m.organization;
		RETURN temp;
		
	END get_organization_type;
	
END;
/

CREATE TABLE Organization_ObjTab OF Organization_Type
(PRIMARY KEY (Abbrev ),
SCOPE FOR (hasHqIn) IS City_ObjTab);

INSERT INTO Organization_ObjTab Select
Organization_Type(p.name, p.abbreviation,p.established,ref(c)) from organization p, city_objtab c where p.city = c.name and p.country = c.country and p.province = c.province; 

