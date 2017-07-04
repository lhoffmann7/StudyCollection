CREATE or replace TYPE Lake_Type AS OBJECT
(Name VARCHAR2(50),
area NUMBER,
depth NUMBER,
elevation NUMBER,
river VARCHAR2(50),
type VARCHAR2(12),
coordinates Geocoord
) NOT FINAL;
/

CREATE or replace TYPE River_Type AS OBJECT
(Name VARCHAR2(50),
river VARCHAR2(50),
lake VARCHAR2(50),
sea VARCHAR2(50),
length NUMBER,
source Geocoord,
mountains VARCHAR2(50),
elevation NUMBER,
estuary Geocoord
) NOT FINAL;
/

CREATE OR REPLACE	FUNCTION getlakelength(lak Lake_Type) RETURN NUMBER
IS
BEGIN
		RETURN getrivlength(select ref(A) from River_objtab A where lak.river = a.name);
END getlakelength;
/

CREATE OR REPLACe FUNCTION getrivlength(riv River_Type) RETURN NUMBER
IS
BEGIN	
	IF riv.river is not null then
		return getriverlength(select ref(A) from River_objtab A where riv.river = a.name);
	elsif riv.lake is not null then
		return getlakelength(SELECT REF(a) from lake_objtab A where riv.lake = a.name);
	else
		return 0;
	end if;
END getrivlength;
/

CREATE TABLE Lake_ObjTab OF Lake_type
(PRIMARY KEY (name)
);

CREATE TABLE River_ObjTab OF River_type
(PRIMARY KEY (name)
);


INSERT INTO Lake_ObjTab
SELECT Lake_type
(l.name,l.area,l.depth,l.elevation,l.river,l.type,Geocoord(l.coordinates.longitude,l.coordinates.latitude))
FROM Lake l;

INSERT INTO River_ObjTab
SELECT River_type
(r.name,r.river,r.lake,r.sea,r.length,r.source,r.mountains,r.sourceelevation,Geocoord(r.estuary.longitude,r.estuary.latitude))
FROM river r;

