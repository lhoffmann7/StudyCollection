create or replace type city_Type7
/
create or replace type province_Type7
/
CREATE OR REPLACE TYPE Country_Type7 AS OBJECT
(Name VARCHAR2(50),
Code VARCHAR2(4),
Capital REF City_Type7,
Province REF province_Type7,
Area NUMBER,
Population NUMBER);
/

CREATE OR REPLACE TYPE Province_Type7 AS OBJECT
(Name VARCHAR2(50),
Country VARCHAR2(4),
Capital REF City_Type7,
Capprov REF province_Type7,
Area NUMBER,
Population NUMBER,
MEMBER FUNCTION getName RETURN VARCHAR2(50));
/

CREATE OR REPLACE TYPE City_Type7 AS OBJECT
(Name VARCHAR2(50),
Province VARCHAR2(50),
Country VARCHAR2(4),
Population NUMBER,
Elevation NUMBER,
Coordinates GeoCoord,
MEMBER FUNCTION getName RETURN VARCHAR2(50));
/

-- Objekttabellen narf

CREATE OR REPLACE TABLE Country_ObjTab7 OF Country_Type7
(PRIMARY KEY (Code)
);
--FOREIGN KEY (Capital,Province) REFERENCES City(Name,Province),
--FOREIGN KEY (Province) REFERENCES Province(Name));

INSERT INTO Country_ObjTab7
SELECT Country_Type7(Name,Code,Capital,Province,Area,Population)
FROM Country;

CREATE TABLE City_ObjTab7 OF City_Type7
(PRIMARY KEY (Name, Province, Country),
scope for  (Country) is Country_ObjTab7
);
--FOREIGN KEY (Province) REFERENCES Province(Name));

INSERT INTO City_ObjTab7
SELECT City_Type7(Name,Province,Country,Population,Elevation,GeoCoord(Longitude,Latitude))
FROM City;



CREATE TABLE Province_ObjTab7 OF Province_Type7
(PRIMARY KEY (Name, Country)
);
--FOREIGN KEY (Country) REFERENCES Country(Code),
--FOREIGN KEY (capital) REFERENCES City(Name),
--FOREIGN KEY (capprov) REFERENCES City(Name));

INSERT INTO Province_ObjTab7
SELECT Province_Type7
(Name,Country,Capital,Capprov,area,Population)
FROM Province;
