create or replace synonym Country for lukashoffmann2.country;
create or replace synonym City for lukashoffmann2.city;
create or replace synonym Province for lukashoffmann2.province;
create or replace synonym Lake for stefansiemer.lake;
create or replace synonym Island for stefansiemer.island;
create or replace synonym Desert for stefansiemer.desert;
create or replace synonym Sea for stefansiemer.sea;
create or replace synonym continent for stefansiemer.continent;
create or replace synonym mountain for stefansiemer.mountain;
create or replace synonym river for stefansiemer.river;


CREATE TABLE Population
(Country VARCHAR2(4), -- on delete set null
 Population_Growth NUMBER,
 Infant_Mortality NUMBER
 --CONSTRAINT PrimKey PRIMARY KEY (Country,Population_Growth)
 --constraint pp foreign key (country) references country(code) --on delete set null
);

start population.sql;
CREATE TABLE Language
(Country VARCHAR2(4),--on delete set null,
 Name VARCHAR2(50),
 Percentage NUMBER CONSTRAINT LanguagePercent 
   CHECK ((Percentage > 0) AND (Percentage <= 100)),
 CONSTRAINT LanguageKey PRIMARY KEY (Name, Country));

start language.sql;

CREATE TABLE Religion
(Country VARCHAR2(4),
 Name VARCHAR2(50),
 Percentage NUMBER CONSTRAINT ReligionPercent 
   CHECK ((Percentage > 0) AND (Percentage <= 100)));
 --CONSTRAINT ReligionKey PRIMARY KEY (Name, Country));

start religion.sql;

CREATE TABLE EthnicGroup
(Country VARCHAR2(4),
 Name VARCHAR2(50),
 Percentage NUMBER CONSTRAINT EthnicPercent 
   CHECK ((Percentage > 0) AND (Percentage <= 100)),
 CONSTRAINT EthnicKey PRIMARY KEY (Name, Country));

start ethnicgroup.sql;


CREATE TABLE Countrypops
(Country VARCHAR2(4),
 Year NUMBER CONSTRAINT CountryPopsYear
   CHECK (Year >= 0),
 Population NUMBER CONSTRAINT CountryPopsPop
   CHECK (Population >= 0),
 CONSTRAINT CountryPopsKey PRIMARY KEY (Country, Year));

start countrypops.sql;

CREATE TABLE Provpops
(Province VARCHAR2(50),
 Country VARCHAR2(4), 
 Year NUMBER CONSTRAINT ProvPopsYear
   CHECK (Year >= 0),
 Population NUMBER CONSTRAINT ProvPopsPop
   CHECK (Population >= 0),
 CONSTRAINT ProvPopKey PRIMARY KEY (Country, Province, Year));

start provpops.sql;




CREATE TABLE RiverThrough
(River VARCHAR2(50) references River(Name) on delete cascade disable,
 Lake  VARCHAR2(50) references Lake(Name) on delete cascade disable,
 CONSTRAINT RThroughKey PRIMARY KEY (River,Lake) );

CREATE TABLE geo_Mountain
(Mountain VARCHAR2(50) ,
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GMountainKey PRIMARY KEY (Province,Country,Mountain),
 constraint cuntMoun foreign key (country) references country(code) on delete cascade disable,
 CONSTRAINT delM foreign key (mountain) references mountain(name) on delete cascade disable);

alter table geo_mountain disable constraint delm;

CREATE TABLE geo_Desert
(Desert VARCHAR2(50) ,
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GDesertKey PRIMARY KEY (Province, Country, Desert),
 constraint cuntDes foreign key (country) references country(code) on delete cascade disable,
 constraint provDes foreign key (province,country) references province(name, country) on delete cascade disable,
 CONSTRAINT delD foreign key (desert) references desert(name) on delete cascade disable
 );

CREATE TABLE geo_Island
(Island VARCHAR2(50) , 
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GIslandKey PRIMARY KEY (Province, Country, Island),
 constraint cuntIsl foreign key (country) references country(code) on delete cascade disable,
 constraint provIsl foreign key (province,country) references province(name, country) on delete cascade disable,
 CONSTRAINT delI foreign key (island) references island(name) on delete cascade disable
 );

CREATE TABLE geo_River
(River VARCHAR2(50) , 
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GRiverKey PRIMARY KEY (Province ,Country, River) ,
 constraint cuntRiv foreign key (country) references country(code) on delete cascade disable,
 constraint provRiv foreign key (province,country) references province(name, country) on delete cascade disable,
 CONSTRAINT delR foreign key (river) references river(name) on delete cascade disable
);

CREATE TABLE geo_Sea
(Sea VARCHAR2(50) ,
 Country VARCHAR2(4)  ,
 Province VARCHAR2(50) ,
 CONSTRAINT GSeaKey PRIMARY KEY (Province, Country, Sea),
 constraint cuntSea foreign key (country) references country(code) on delete cascade disable,
 constraint provSea foreign key (province,country) references province(name, country) on delete cascade disable,
 CONSTRAINT delS foreign key (sea) references sea(name) on delete cascade disable
 );

CREATE TABLE geo_Lake
(Lake VARCHAR2(50) ,
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GLakeKey PRIMARY KEY (Province, Country, Lake),
 constraint cuntLake foreign key (country) references country(code) on delete cascade disable,
 constraint provLake foreign key (province,country) references province(name, country) on delete cascade disable,
 CONSTRAINT delL foreign key (lake) references lake(name) on delete cascade disable);
);

CREATE TABLE geo_Source
(River VARCHAR2(50) references river(name) on delete cascade disable,
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GSourceKey PRIMARY KEY (Province, Country, River),
 constraint cuntSrc foreign key (country) references country(code) on delete cascade disable,
 constraint provSrc foreign key (province,country) references province(name, country) on delete cascade disable
);

CREATE TABLE geo_Estuary
(River VARCHAR2(50) references river(name) on delete cascade  disable,
 Country VARCHAR2(4) ,
 Province VARCHAR2(50) ,
 CONSTRAINT GEstuaryKey PRIMARY KEY (Province, Country, River),
 constraint cuntEst foreign key (country) references country(code) on delete cascade disable,
 constraint provEst foreign key (province,country) references province(name, country) on delete cascade disable
 );

CREATE TABLE mergesWith
(Sea1 VARCHAR2(50) references sea(name) on delete cascade disable,
 Sea2 VARCHAR2(50) references sea(name) on delete cascade disable,
 CONSTRAINT MergesWithKey PRIMARY KEY (Sea1, Sea2) );

CREATE TABLE located
(City VARCHAR2(50) ,
 Province VARCHAR2(50) ,
 Country VARCHAR2(4) ,
 River VARCHAR2(50) references river(name) on delete set null disable,
 Lake VARCHAR2(50) references lake(name) on delete set null disable,
 Sea VARCHAR2(50) references sea(name) on delete set null disable,
 constraint cuntLoc foreign key (country) references country(code) on delete cascade disable,
 constraint provLoc foreign key (province,country) references province(name,country) on delete cascade disable,
 constraint citLoc foreign key (province, country, city) references city(province,country,name) on delete cascade disable
 );

CREATE TABLE locatedOn
(City VARCHAR2(50) ,
 Province VARCHAR2(50) ,
 Country VARCHAR2(4) ,
 Island VARCHAR2(50) references island(name) on delete cascade disable,
 CONSTRAINT locatedOnKey PRIMARY KEY (City, Province, Country, Island),
 constraint cuntLocOn foreign key (country) references country(code) on delete cascade disable,
 constraint provLocOn foreign key (province,country) references province(name,country) on delete cascade disable,
 constraint citLocOn foreign key (province, country, city) references city(province,country,name) on delete cascade disable
 );

CREATE TABLE islandIn
(Island VARCHAR2(50) references island(name) on delete cascade disable,
 Sea VARCHAR2(50) references sea(name) on delete cascade disable,
 Lake VARCHAR2(50) references lake(name) on delete set null disable,
 River VARCHAR2(50) references river(name) on delete set null disable);

CREATE TABLE MountainOnIsland
(Mountain VARCHAR2(50),
 Island  VARCHAR2(50) references island(name) on delete cascade disable,
 CONSTRAINT MntIslKey PRIMARY KEY (Mountain, Island),
 constraint mnt foreign key (mountain) references mountain(name) on delete cascade disable);

CREATE TABLE encompasses
(Country VARCHAR2(4) references Country(Code) on delete cascade disable,
 Continent VARCHAR2(20) references Continent(Name) on delete cascade disable,
 Percentage NUMBER,
   CHECK ((Percentage > 0) AND (Percentage <= 100)),
 CONSTRAINT EncompassesKey PRIMARY KEY (Country,Continent));


alter table population add constraint popConst foreign key (country) references Country(Code) on delete cascade;
alter table language add constraint langConst foreign key (country) references Country(Code) on delete cascade;
alter table religion add constraint relConst foreign key (country) references Country(Code) on delete cascade;
alter table ethnicgroup add constraint ethConst foreign key (country) references Country(Code) on delete cascade;
alter table countrypops add constraint counpopConst foreign key (country) references Country(Code) on delete cascade;
--alter table population add constraint popConst foreign key (country) references Country(Code) on delete cascade;
--alter table population add constraint popConst foreign key (country) references Country(Code) on delete cascade;
--alter table population add constraint popConst foreign key (country) references Country(Code) on delete cascade;
--start citypops.sql;
grant select,insert on encompasses to martinheinemann;
grant select,insert on geo_desert to martinheinemann;
grant select,insert on geo_estuary to martinheinemann;
grant select,insert on geo_island to martinheinemann;
grant select,insert on geo_lake to martinheinemann;
grant select,insert on geo_mountain to martinheinemann;
grant select,insert on geo_river to martinheinemann;
grant select,insert on geo_sea to martinheinemann;
grant select,insert on geo_source to martinheinemann;
grant select,insert on islandin to martinheinemann;
grant select,insert on locatedon to martinheinemann;
grant select,insert on located to martinheinemann;
grant select,insert on mergeswith to martinheinemann;
grant select,insert on mountainonisland to martinheinemann;
grant select,insert on religion to martinheinemann;
grant select,insert on riverthrough to martinheinemann;
start encompasses.sql;
start geo_desert.sql;
start geo_estuary.sql;
start geo_island.sql;
start geo_lake.sql;
start geo_mountain.sql;
start geo_river.sql;
start geo_sea.sql;
start geo_source.sql;
start islandin.sql;
start locatedon.sql;
start located.sql;
start mergeswith.sql;
start mountainonisland.sql;
start religion.sql; 
start riverthrough.sql;
