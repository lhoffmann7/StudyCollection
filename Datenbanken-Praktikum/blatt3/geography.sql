CREATE OR REPLACE TYPE GeoCoord AS OBJECT
(Latitude NUMBER,
 Longitude NUMBER);
/


CREATE TABLE Mountain
(Name VARCHAR2(50) CONSTRAINT MountainKey PRIMARY KEY,
 Mountains VARCHAR2(50),
 Elevation NUMBER,
 Type VARCHAR2(10),
 Coordinates GeoCoord CONSTRAINT MountainCoord
     CHECK ((Coordinates.Latitude >= -90) AND 
            (Coordinates.Latitude <= 90) AND
            (Coordinates.Longitude > -180) AND
            (Coordinates.Longitude <= 180)));

CREATE TABLE Desert
(Name VARCHAR2(50) CONSTRAINT DesertKey PRIMARY KEY,
 Area NUMBER,
 Coordinates GeoCoord CONSTRAINT DesCoord
     CHECK ((Coordinates.Latitude >= -90) AND 
            (Coordinates.Latitude <= 90) AND
            (Coordinates.Longitude > -180) AND
            (Coordinates.Longitude <= 180)));

CREATE TABLE Island
(Name VARCHAR2(50) CONSTRAINT IslandKey PRIMARY KEY,
 Islands VARCHAR2(50),
 Area NUMBER CONSTRAINT IslandAr check (Area >= 0),
 Elevation NUMBER,
 Type VARCHAR2(10),
 Coordinates GeoCoord CONSTRAINT IslandCoord
     CHECK ((Coordinates.Latitude >= -90) AND 
            (Coordinates.Latitude <= 90) AND
            (Coordinates.Longitude > -180) AND
            (Coordinates.Longitude <= 180)));

CREATE TABLE Lake
(Name VARCHAR2(50) CONSTRAINT LakeKey PRIMARY KEY,
 Area NUMBER CONSTRAINT LakeAr CHECK (Area >= 0),
 Depth NUMBER CONSTRAINT LakeDpth CHECK (Depth >= 0),
 Elevation NUMBER,
 Type VARCHAR2(12),
 River VARCHAR2(50),
 Coordinates GeoCoord CONSTRAINT LakeCoord
     CHECK ((Coordinates.Latitude >= -90) AND 
            (Coordinates.Latitude <= 90) AND
            (Coordinates.Longitude > -180) AND
            (Coordinates.Longitude <= 180)));

CREATE TABLE Sea
(Name VARCHAR2(50) CONSTRAINT SeaKey PRIMARY KEY,
 Depth NUMBER CONSTRAINT SeaDepth CHECK (Depth >= 0));

CREATE TABLE River
(Name VARCHAR2(50) CONSTRAINT RiverKey PRIMARY KEY,
 River VARCHAR2(50),
 Lake VARCHAR2(50),
 Sea VARCHAR2(50),
 Length NUMBER CONSTRAINT RiverLength
   CHECK (Length >= 0),
 Source GeoCoord CONSTRAINT SourceCoord
     CHECK ((Source.Latitude >= -90) AND 
            (Source.Latitude <= 90) AND
            (Source.Longitude > -180) AND
            (Source.Longitude <= 180)),
 Mountains VARCHAR2(50),
 SourceElevation NUMBER,
 Estuary GeoCoord CONSTRAINT EstCoord
     CHECK ((Estuary.Latitude >= -90) AND 
            (Estuary.Latitude <= 90) AND
            (Estuary.Longitude > -180) AND
            (Estuary.Longitude <= 180)),
 CONSTRAINT RivFlowsInto 
     CHECK ((River IS NULL AND Lake IS NULL)
            OR (River IS NULL AND Sea IS NULL)
            OR (Lake IS NULL AND Sea is NULL)));
CREATE TABLE Continent
(Name VARCHAR2(20) CONSTRAINT ContinentKey PRIMARY KEY,
 Area NUMBER(10));

start mountain.sql;
start desert.sql;
start island.sql;
start lake.sql;
start sea.sql;
start river.sql;
start continent.sql;

grant references (name) on sea to kneuman;
grant select on sea to kneuman;
grant references (name) on river to kneuman;
grant references (name) on lake to kneuman;
grant references (name) on desert to kneuman;
grant references (name) on continent to kneuman;
grant references (name) on mountain to kneuman;
grant references (name) on island to kneuman;

grant execute on geocoord to martinheinemann;
grant select, insert on mountain to martinheinemann;
grant select, insert on desert to martinheinemann;
grant select, insert on island to martinheinemann;
grant select, insert on lake to martinheinemann;
grant select, insert on sea to martinheinemann;
grant select, insert on river to martinheinemann;
grant select, insert on continent to martinheinemann;
