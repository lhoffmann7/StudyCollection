start drop-types.sql;
start a4.sql;

create or replace type city_type
/
create or replace type province_type
/
CREATE OR REPLACE TYPE Country_type AS OBJECT
(Name VARCHAR2(50),
Code VARCHAR2(4),
Capital REF City_type,
Province REF province_type,
Area NUMBER,
Population NUMBER, 
MEMBER FUNCTION pop_growth RETURN NUMBER) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY Country_type
AS
	MEMBER FUNCTION pop_growth RETURN NUMBER
	IS
	temp number := 0;
	BEGIN
		select nvl(population_growth,0) into temp from population where self.code=population.country;
		RETURN temp;
	END pop_growth;
END;
/
--cappprov fällt raus weil in referneziertem capital cappprov mit drin steht -> sonst zyklische referenz :) 
CREATE OR REPLACE TYPE Province_type AS OBJECT
(Name VARCHAR2(50),
Country VARCHAR2(4),
Capital REF City_type,
Area NUMBER,
Population NUMBER) NOT FINAL;
/


CREATE OR REPLACE TYPE City_type AS OBJECT
(Name VARCHAR2(50),
Province VARCHAR2(50),
Country VARCHAR2(4),
Population NUMBER,
Elevation NUMBER,
Coordinates GeoCoord) NOT FINAL;
/

-- Objekttabellen narf

CREATE TABLE Country_ObjTab OF Country_type
(PRIMARY KEY (Code)
);
--FOREIGN KEY (Capital,Province) REFERENCES City(Name,Province),
--FOREIGN KEY (Province) REFERENCES Province(Name));

CREATE TABLE City_ObjTab OF City_type
(PRIMARY KEY (Name, Province, Country)
);

CREATE TABLE Province_ObjTab OF Province_type
(PRIMARY KEY (Name, Country)
);
--FOREIGN KEY (Country) REFERENCES Country(Code),
--FOREIGN KEY (capital) REFERENCES City(Name),
--FOREIGN KEY (capprov) REFERENCES City(Name));

--FOREIGN KEY (Province) REFERENCES Province(Name));

INSERT INTO City_ObjTab
SELECT City_type(c.Name,c.Province,c.Country,c.Population,c.Elevation,GeoCoord(c.Longitude,c.Latitude))
FROM City c;

INSERT INTO Province_ObjTab
SELECT Province_type
(p.Name,p.Country,ref(cit),p.area,p.Population)
FROM Province p, City_ObjTab cit where cit.name = p.capital and cit.province = p.capprov and cit.country = p.country;

INSERT INTO Country_ObjTab
SELECT Country_type(con.Name,con.Code,ref(cit),ref(p),con.Area,con.Population)
FROM Country con, City_ObjTab cit, Province_ObjTab p where cit.province = con.province and cit.country = con.code and cit.name = con.capital and con.province = p.name and con.code = p.country;


-- Pfadausdruck zum Reinmouzen 
--select p.province.name, p.province.population from country_objtab p;

CREATE OR REPLACE VIEW symborders
(Country1, Country2)
AS
	(Select ref(a) as country1 , ref(b) as country2 from borders bord, country_objtab a, country_objtab b where bord.country1 = a.code and bord.country2 = b.code)
	union
	(Select ref(b) as country1 , ref(a) as country2 from borders bord, country_objtab a, country_objtab b where bord.country1 = a.code and bord.country2 = b.code)
;

-- reinmouzen für abfrage .... :D
--select s.country1.name, s.country2.name from symborders s;

--leider scheint das Konzept nicht absolut
--ausgereift zu sein: Will man ein Object View auf Basis von
--Organization_ObjTab
--definieren,
--stellt man fest, dass dieses offensichtlich weder die gescha
--chtelte Tabelle noch das Ergebnis
--einer funktionalen Methode der zugrundeliegenden Tabelle
--n enthalten darf:
