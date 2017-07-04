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

alter table country add CONSTRAINT cap FOREIGN KEY (Capital,code,province) REFERENCES City(Name,Country,Province) ON DELETE set null;
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

CREATE TABLE Politics
(Country VARCHAR2(4) references Country(Code) on delete cascade, -- on delete set null
 Independence DATE,
 WasDependent VARCHAR2(50),
 Dependent  VARCHAR2(4),
 Government VARCHAR2(120)
-- constraint PrimKey PRIMARY KEY (Country,Independence),
);

CREATE TABLE borders
(Country1 VARCHAR2(4) references Country(Code) on delete cascade,
 Country2 VARCHAR2(4) references Country(Code) on delete cascade,
 Length NUMBER 
   CHECK (Length > 0),
 CONSTRAINT BorderKey PRIMARY KEY (Country1,Country2) );

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
grant select on Country to public;

Create View CountryView as (
Select c.name, c.code, c.population, c.area, c.capital, c.province, c.population/c.area as Density from country c);

grant select on CountryView to kneuman;
grant select on City to kneuman;
grant select on Province to kneuman;
--grant select on * to martin.heinemann;
grant select, insert on City to martinheinemann;
grant select, insert on Province to martinheinemann;
grant select, insert on Country to martinheinemann;
grant select, insert on Organization to martinheinemann;
grant select, insert on ismember to martinheinemann;
grant select, insert on economy to martinheinemann;
grant select, insert on politics to martinheinemann;
grant select, insert on borders to martinheinemann;

grant select on Province to kneuman;
grant select on Province to kneuman;
grant select on Province to kneuman;
grant references on Country to kneuman;
grant references on City to kneuman;
grant references on Province to kneuman;
--alter View CountryView add constraint primk primary key (code);

start country.sql;
start city.sql;
start province.sql;
start economy.sql;
start politics.sql;
start borders.sql;
start organization.sql;
start ismember.sql;
