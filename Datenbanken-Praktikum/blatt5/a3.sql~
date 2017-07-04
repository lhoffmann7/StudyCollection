--create or replace view riverorlake as select name,river,0 as length from lake l union (select name,river,nvl(length,0) from river r where r.river is not null) union (select name,lake,nvl(length,0) from river where lake is not null and not (lake,name) in (select name,river from lake)) union (select name,river,nvl(length,0) from river where river is null and lake is null);

Create or replace type River_type
/

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

Create or replace type flowRiver as object
(source REF River_type,
directionRiv REF River_type,
directionLak REF Lake_type
);
/

Create or replace type flowLake as object
(source REF Lake_type,
direction REF River_type
);
/





CREATE TABLE Lake_ObjTab OF Lake_type
(PRIMARY KEY (name)
);

CREATE TABLE River_ObjTab OF River_type
(PRIMARY KEY (name)
);

CREATE TABLE flowRiver_ObjTab OF flowRiver;
CREATE TABLE flowLake_ObjTab OF flowLake;

INSERT INTO Lake_ObjTab
SELECT Lake_type
(l.name,l.area,l.depth,l.elevation,l.river,l.type,Geocoord(l.coordinates.latitude,l.coordinates.longitude))
FROM Lake l;

INSERT INTO River_ObjTab
SELECT River_type
(r.name,r.river,r.lake,r.sea,r.length,r.source,r.mountains,r.sourceelevation,Geocoord(r.estuary.latitude,r.estuary.longitude))
FROM river r;

INSERT INTO flowRiver_ObjTab
SELECT flowRiver
(ref(riv),ref(driv),NULL)
FROM River_ObjTab riv, River_ObjTab driv,river r where r.name = riv.name and r.river = driv.name and r.river is not null;

INSERT INTO flowRiver_ObjTab
SELECT flowRiver
(ref(riv),NULL,ref(dlak))
FROM River_ObjTab riv, Lake_ObjTab dlak, river r where r.name = riv.name and r.lake = dlak.name and r.lake is not null;

INSERT INTO flowLake_ObjTab
SELECT flowLake
(ref(lake),ref(riv))
FROM Lake l,Lake_ObjTab lake,River_ObjTab riv where l.name=lake.name and l.river = riv.name;

CREATE OR REPLACE FUNCTION getRivLength(rek flowRiver) RETURN NUMBER
	IS
	len number := 0;
	tempRiv flowriver;
	templake flowlake;
	BEGIN
		IF rek.directionRIV is not null THEN
			select value(m) into tempriv from flowriver_objtab m where m.source = rek.directionRiv;
			RETURN rek.source.length+getRivLength(tempriv);
		ElSIF rek.directionLAK is not null THEN
			select value(m) into templake from flowLake_objtab m where m.source = rek.directionlak;
			RETURN rek.source.length+getLakeLength();
		END IF;
	return len;
	END getRIVLength;
/



CREATE OR REPLACE FUNCTION getLakeLength(rek flowLake) RETURN NUMBER
IS
	len number := 0;
	temp flowriver;
	BEGIN
		IF rek.direction is not null THEN
			select value(m) into temp from flowriver_objtab m where m.source = rek.directionRiv;
			RETURN getRivLength(temp);
		END IF;
	return len;
END getLakeLength;
/
