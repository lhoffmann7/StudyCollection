
ALTER SESSION SET NLS_DATE_FORMAT = 'DD MM SYYYY';
-- SYYYY means 4-digit-year, S prefixes BC years with "-"

CREATE TABLE Country
(Name VARCHAR2(50) NOT NULL UNIQUE,
 Code VARCHAR2(4) CONSTRAINT CountryKey PRIMARY KEY,
 Capital VARCHAR2(50),
 Province VARCHAR2(50),
 Area NUMBER CONSTRAINT CountryArea
   CHECK (Area >= 0),
 Population NUMBER CONSTRAINT CountryPop
   CHECK (Population >= 0)
   --CONSTRAINT cap FOREIGN KEY (Capital,code,province) REFERENCES City(Name,Country,Province) --DISABLE--ON DELETE set null,
);

--alter table country disable constraint cap;

CREATE TABLE City
(Name VARCHAR2(50),
 Country VARCHAR2(4),
 Province VARCHAR2(50),
 Population NUMBER CONSTRAINT CityPop
   CHECK (Population >= 0),
 Latitude NUMBER CONSTRAINT CityLat
   CHECK ((Latitude >= -90) AND (Latitude <= 90)) ,
 Longitude NUMBER CONSTRAINT CityLon
   CHECK ((Longitude >= -180) AND (Longitude <= 180)) ,
 Elevation NUMBER,
 CONSTRAINT CityKey PRIMARY KEY (Name, Country, Province)
);

alter table country add CONSTRAINT cap FOREIGN KEY (Capital,code,province) REFERENCES City(Name,Country,Province) ON DELETE;
alter table country disable constraint cap;
--alter table city disable constraint prov; 

CREATE TABLE Province
(Name VARCHAR2(50), --CONSTRAINT PrName NOT NULL,
 Country  VARCHAR2(4), --CONSTRAINT PrCountry, --NOT NULL ,
 Population NUMBER CONSTRAINT PrPop
   CHECK (Population >= 0),
 Area NUMBER CONSTRAINT PrAr
   CHECK (Area >= 0),
 Capital VARCHAR2(50),
 CapProv VARCHAR2(50),
 CONSTRAINT PrKey PRIMARY KEY (Name, Country),
 CONSTRAINT cunt FOREIGN KEY (Country) REFERENCES Country(Code) ON DELETE  cascade, --set null,
 CONSTRAINT PCap FOREIGN KEY (capital,capprov,country) references city(name,province,country) on delete set null
);

alter table city add constraint prov foreign key (province,country) references province(name,country) on delete cascade; 
alter table city disable constraint prov;
--alter table province disable constraint cunt;
--alter table province disable constraint PCap;

CREATE TABLE Economy
(Country VARCHAR2(4) references Country(Code) on delete cascade, --on delete not null,
 GDP NUMBER CONSTRAINT EconomyGDP
   CHECK (GDP >= 0),
 Agriculture NUMBER,
 Service NUMBER,
 Industry NUMBER,
 Inflation NUMBER,
 Unemployment NUMBER
);

CREATE TABLE Population
(Country VARCHAR2(4) references Country(Code) on delete cascade, -- on delete set null
 Population_Growth NUMBER,
 Infant_Mortality NUMBER
-- CONSTRAINT PrimKey PRIMARY KEY (Country,Population_Growth),
 --constraint pp foreign key (country) references country(code) --on delete set null
);

CREATE TABLE Politics
(Country VARCHAR2(4) references Country(Code) on delete cascade, -- on delete set null
 Independence DATE,
 WasDependent VARCHAR2(50),
 Dependent  VARCHAR2(4),
 Government VARCHAR2(120)
-- constraint PrimKey PRIMARY KEY (Country,Independence),
);

CREATE TABLE Language
(Country VARCHAR2(4) references Country(Code) on delete cascade,--on delete set null,
 Name VARCHAR2(50),
 Percentage NUMBER CONSTRAINT LanguagePercent 
   CHECK ((Percentage > 0) AND (Percentage <= 100)),
 CONSTRAINT LanguageKey PRIMARY KEY (Name, Country));

CREATE TABLE Religion
(Country VARCHAR2(4) references Country(Code) on delete cascade,
 Name VARCHAR2(50),
 Percentage NUMBER CONSTRAINT ReligionPercent 
   CHECK ((Percentage > 0) AND (Percentage <= 100)),
 CONSTRAINT ReligionKey PRIMARY KEY (Name, Country));

CREATE TABLE EthnicGroup
(Country VARCHAR2(4) references Country(Code) on delete cascade,
 Name VARCHAR2(50),
 Percentage NUMBER CONSTRAINT EthnicPercent 
   CHECK ((Percentage > 0) AND (Percentage <= 100)),
 CONSTRAINT EthnicKey PRIMARY KEY (Name, Country));

CREATE TABLE Countrypops
(Country VARCHAR2(4) references Country(Code) on delete cascade,
 Year NUMBER CONSTRAINT CountryPopsYear
   CHECK (Year >= 0),
 Population NUMBER CONSTRAINT CountryPopsPop
   CHECK (Population >= 0),
 CONSTRAINT CountryPopsKey PRIMARY KEY (Country, Year));

CREATE TABLE Provpops
(Province VARCHAR2(50),
 Country VARCHAR2(4), 
 Year NUMBER CONSTRAINT ProvPopsYear
   CHECK (Year >= 0),
 Population NUMBER CONSTRAINT ProvPopsPop
   CHECK (Population >= 0),
 CONSTRAINT ProvPopKey PRIMARY KEY (Country, Province, Year));

CREATE TABLE Citypops
(City VARCHAR2(50),
 Country VARCHAR2(4),
 Province VARCHAR2(50),
 Year NUMBER CONSTRAINT CityPopsYear
   CHECK (Year >= 0),
 Population NUMBER CONSTRAINT CityPopsPop
   CHECK (Population >= 0),
 CONSTRAINT ForEignKey1 FOREIGN key (City,Country,Province) references City(Name,Country,Province) on delete cascade,
 CONSTRAINT CityPopKey PRIMARY KEY (Country, Province, City, Year));

CREATE TABLE Continent
(Name VARCHAR2(20) CONSTRAINT ContinentKey PRIMARY KEY,
 Area NUMBER(10));

CREATE TABLE borders
(Country1 VARCHAR2(4) references Country(Code) on delete cascade,
 Country2 VARCHAR2(4) references Country(Code) on delete cascade,
 Length NUMBER 
   CHECK (Length > 0),
 CONSTRAINT BorderKey PRIMARY KEY (Country1,Country2) );

CREATE TABLE encompasses
(Country VARCHAR2(4) references Country(Code) on delete cascade,
 Continent VARCHAR2(20) references Continent(Name) on delete cascade,
 Percentage NUMBER,
   CHECK ((Percentage > 0) AND (Percentage <= 100)),
 CONSTRAINT EncompassesKey PRIMARY KEY (Country,Continent));

CREATE TABLE Organization
(Abbreviation VARCHAR2(12) Constraint OrgKey PRIMARY KEY,
 Name VARCHAR2(100) NOT NULL,
 City VARCHAR2(50) ,
 Country VARCHAR2(4) , 
 Province VARCHAR2(50) ,
 Established DATE,
 CONSTRAINT OrgNameUnique UNIQUE (Name),
 CONSTRAINT fcity FOREIGN KEY (City,Country,Province) references City(Name,Country,Province) on delete set null);
-- alternativ, wenn nicht will, dass Stadt geloescht wird, in der Organisation sich befindet: no action, dann gehen aber Loeschungen von Laendern zumeist nicht, wenn es nur eine Stadt gibt, die Sitz einer Orga ist. Muss diese dann zuerst Loeschen/veraendern.

alter table organization disable constraint fcity;

CREATE TABLE isMember
(Country VARCHAR2(4) references Country(Code) on delete cascade,
 Organization VARCHAR2(12),
 Type VARCHAR2(60) DEFAULT 'member',
 CONSTRAINT MemberKey PRIMARY KEY (Country,Organization),
 CONSTRAINT plzNoDel FOREIGN KEY (Organization) references organization(abbreviation));

alter table isMember disable constraint plznodel;

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

CREATE TABLE RiverThrough
(River VARCHAR2(50) references River(Name) on delete cascade,
 Lake  VARCHAR2(50) references Lake(Name) on delete cascade,
 CONSTRAINT RThroughKey PRIMARY KEY (River,Lake) );

CREATE TABLE geo_Mountain
(Mountain VARCHAR2(50) ,
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GMountainKey PRIMARY KEY (Province,Country,Mountain),
 constraint cuntMoun foreign key (country) references country(code) on delete cascade,
 CONSTRAINT delM foreign key (mountain) references mountain(name) on delete cascade);

alter table geo_mountain disable constraint delm;

CREATE TABLE geo_Desert
(Desert VARCHAR2(50) ,
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GDesertKey PRIMARY KEY (Province, Country, Desert),
 constraint cuntDes foreign key (country) references country(code) on delete cascade,
 constraint provDes foreign key (province,country) references province(name, country) on delete cascade,
 CONSTRAINT delD foreign key (desert) references desert(name) on delete cascade
 );

CREATE TABLE geo_Island
(Island VARCHAR2(50) , 
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GIslandKey PRIMARY KEY (Province, Country, Island),
 constraint cuntIsl foreign key (country) references country(code) on delete cascade,
 constraint provIsl foreign key (province,country) references province(name, country) on delete cascade,
 CONSTRAINT delI foreign key (island) references island(name) on delete cascade
 );

CREATE TABLE geo_River
(River VARCHAR2(50) , 
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GRiverKey PRIMARY KEY (Province ,Country, River) ,
 constraint cuntRiv foreign key (country) references country(code) on delete cascade,
 constraint provRiv foreign key (province,country) references province(name, country) on delete cascade,
 CONSTRAINT delR foreign key (river) references river(name) on delete cascade
);

CREATE TABLE geo_Sea
(Sea VARCHAR2(50) ,
 Country VARCHAR2(4)  ,
 Province VARCHAR2(50) ,
 CONSTRAINT GSeaKey PRIMARY KEY (Province, Country, Sea),
 constraint cuntSea foreign key (country) references country(code) on delete cascade,
 constraint provSea foreign key (province,country) references province(name, country) on delete cascade,
 CONSTRAINT delS foreign key (sea) references sea(name) on delete cascade
 );

CREATE TABLE geo_Lake
(Lake VARCHAR2(50) ,
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GLakeKey PRIMARY KEY (Province, Country, Lake),
 constraint cuntLake foreign key (country) references country(code) on delete cascade,
 constraint provLake foreign key (province,country) references province(name, country) on delete cascade,
 CONSTRAINT delL foreign key (lake) references lake(name) on delete cascade);
);

CREATE TABLE geo_Source
(River VARCHAR2(50) references river(name) on delete cascade,
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GSourceKey PRIMARY KEY (Province, Country, River),
 constraint cuntSrc foreign key (country) references country(code) on delete cascade,
 constraint provSrc foreign key (province,country) references province(name, country) on delete cascade
);

CREATE TABLE geo_Estuary
(River VARCHAR2(50) references river(name) on delete cascade ,
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GEstuaryKey PRIMARY KEY (Province, Country, River),
 constraint cuntEst foreign key (country) references country(code) on delete cascade,
 constraint provEst foreign key (province,country) references province(name, country) on delete cascade
 );

CREATE TABLE mergesWith
(Sea1 VARCHAR2(50) references sea(name) on delete cascade ,
 Sea2 VARCHAR2(50) references sea(name) on delete cascade ,
 CONSTRAINT MergesWithKey PRIMARY KEY (Sea1, Sea2) );

CREATE TABLE located
(City VARCHAR2(50) ,
 Province VARCHAR2(50) ,
 Country VARCHAR2(4) ,
 River VARCHAR2(50) references river(name) on delete set null,
 Lake VARCHAR2(50) references lake(name) on delete set null,
 Sea VARCHAR2(50) references sea(name) on delete set null,
 constraint cuntLoc foreign key (country) references country(code) on delete cascade,
 constraint provLoc foreign key (province,country) references province(name,country) on delete cascade,
 constraint citLoc foreign key (province, country, city) references city(province,country,name) on delete cascade
 );

CREATE TABLE locatedOn
(City VARCHAR2(50) ,
 Province VARCHAR2(50) ,
 Country VARCHAR2(4) ,
 Island VARCHAR2(50) references island(name) on delete cascade,
 CONSTRAINT locatedOnKey PRIMARY KEY (City, Province, Country, Island),
 constraint cuntLocOn foreign key (country) references country(code) on delete cascade,
 constraint provLocOn foreign key (province,country) references province(name,country) on delete cascade,
 constraint citLocOn foreign key (province, country, city) references city(province,country,name) on delete cascade
 );

CREATE TABLE islandIn
(Island VARCHAR2(50) references island(name) on delete cascade,
 Sea VARCHAR2(50) references sea(name) on delete cascade,
 Lake VARCHAR2(50) references lake(name) on delete set null,
 River VARCHAR2(50) references river(name) on delete set null);

CREATE TABLE MountainOnIsland
(Mountain VARCHAR2(50),
 Island  VARCHAR2(50) references island(name) on delete cascade,
 CONSTRAINT MntIslKey PRIMARY KEY (Mountain, Island),
 constraint mnt foreign key (mountain) references mountain(name) on delete cascade);

CREATE TABLE Airport
(IATACode VARCHAR(3) PRIMARY KEY,
 Name VARCHAR2(100) ,
 Country VARCHAR2(4) ,
 City VARCHAR2(50) ,
 Province VARCHAR2(50) ,
 Island VARCHAR2(50) ,
 Latitude NUMBER CONSTRAINT AirpLat
   CHECK ((Latitude >= -90) AND (Latitude <= 90)) ,
 Longitude NUMBER CONSTRAINT AirpLon
   CHECK ((Longitude >= -180) AND (Longitude <= 180)) ,
 Elevation NUMBER ,
 gmtOffset NUMBER );
