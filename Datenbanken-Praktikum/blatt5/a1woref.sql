CREATE OR REPLACE TYPE City_wo_REF AS OBJECT
(Name VARCHAR2(50),
Province VARCHAR2(50),
Country VARCHAR2(4),
Population NUMBER,
Elevation NUMBER,
Longitude NUMBER,
Latitude NUMBER);
/

CREATE OR REPLACE TYPE Province_wo_REF AS OBJECT
(Name VARCHAR2(50),
Country VARCHAR2(4),
Capital VARCHAR2(50),
Capprov VARCHAR2(50),
Area NUMBER,
Population NUMBER);
/

CREATE OR REPLACE TYPE Country_wo_REF AS OBJECT
(Name VARCHAR2(50),
Code VARCHAR2(4),
Capital VARCHAR2(50),
Province VARCHAR2(50),
Area NUMBER,
Population NUMBER,
MEMBER FUNCTION pop_growth RETURN NUMBER);
/

CREATE OR REPLACE TYPE BODY Country_wo_REF
AS
	MEMBER FUNCTION pop_growth RETURN NUMBER
	IS
	temp number := 0;
	BEGIN
		select population_growth into temp from population where self.code=population.country;
		RETURN temp;
	END pop_growth;
END;
/

CREATE TABLE CountrywoREF_ObjTab OF Country_wo_REF
(PRIMARY KEY (Code));

CREATE TABLE ProvincewoREF_ObjTab OF Province_wo_REF
(PRIMARY KEY (Name, Country));

CREATE TABLE CitywoREF_ObjTab OF City_wo_REF
(PRIMARY KEY (Name, Country, Province));

INSERT INTO CountrywoREF_ObjTab
SELECT Country_wo_REF(Name,Code,Capital,Province,Area,Population)
FROM Country;

INSERT INTO CitywoREF_ObjTab
SELECT City_wo_REF(Name,Province,Country,Population,Elevation,Longitude,Latitude)
FROM City;

INSERT INTO ProvincewoREF_ObjTab
SELECT Province_wo_REF(Name,Country,Capital,Capprov,Area,Population)
FROM Province;
