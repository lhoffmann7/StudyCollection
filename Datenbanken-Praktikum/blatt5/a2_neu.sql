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
MEMBER FUNCTION set_organization_type RETURN NUMBER,
MEMBER FUNCTION get_organization_type RETURN NUMBER
) NOT FINAL;
/

CREATE TYPE ismember_type as Object
(organization ref organization_type,
country ref country_type,
type varchar2(100)
) NOT FINAL;
/

CREATE TABLE Organization_ObjTab OF Organization_Type
(PRIMARY KEY (Abbrev ),
SCOPE FOR (hasHqIn) IS City_ObjTab);

CREATE TABLE ismember_objtab of ismember_type;

CREATE TYPE BODY Organization_Type
AS
	MEMBER FUNCTION set_organization_type RETURN NUMBER 
	IS
	BEGIN
		return 0;
	END set_organization_type;

	MEMBER FUNCTION get_organization_type RETURN NUMBER
	IS
	BEGIN
		return 0;
	END get_organization_type;
	
END;
/


-- Es werden nicht alle organisationen erzeugt, da es organisationen gibt die kein country/city haben. dies haben wir versucht abzufangen, waren aber zu inkompetent!!!!!
Insert into city_objtab select city_type('Klaus','Klausprovince','Klau',0 ,0 ,Geocoord(NULL,NUll)) from dual;
INSERT INTO Organization_ObjTab Select
Organization_Type(nvl(p.name,'Klaus'), nvl(p.abbreviation,'Klaus'),nvl(p.established,'2015-1-20'),nvl(ref(c),ref(k))) from organization p, city_objtab c, city_objtab k where p.city = c.name and p.country = c.country and p.province = c.province and k.country = 'Klau'; 


Insert into ismember_objtab select ismember_type(ref(a), ref(b), m.type) from ismember m, country_objtab b, organization_objtab a where m.organization = a.abbrev and m.country = b.code; 


