start drop-types.sql;
start a4.sql;
start create.sql;
set serveroutput on;

CREATE or replace TYPE Lake_Type AS OBJECT
(Name VARCHAR2(50),
area NUMBER,
depth NUMBER,
elevation NUMBER,
river VARCHAR2(50),
type VARCHAR2(12),
coordinates Geocoord,
MEMBER FUNCTION getlength RETURN NUMBER
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
estuary Geocoord,
MEMBER FUNCTION getlength RETURN NUMBER
) NOT FINAL;
/

CREATE TABLE Lake_ObjTab OF Lake_type
(PRIMARY KEY (name)
);

CREATE TABLE River_ObjTab OF River_type
(PRIMARY KEY (name)
);



CREATE or replace TYPE BODY Lake_Type
AS
	MEMBER FUNCTION getlength RETURN NUMBER
	IS
	len number;
	lenadd number;
	BEGIN
		len := 0;
		for entry in (select * from River_objTab m where self.name = m.lake)
		loop
			select nvl(m.getlength(),0) into lenadd from River_ObjTab m where m.name = entry.name;
			len := len + lenadd;
			dbms_output.put_line(entry.name || ' ' || nvl(entry.length,0)|| ' ' || len);
			dbms_output.put_line('bkla');
		end loop;  
		--select sum(nvl(m.getlength(),0)) into len from River_ObjTab m where self.name = m.lake;	
		return len;
	END getlength;
END;
/

CREATE or replace TYPE BODY RIVER_TYPE
AS
	MEMBER FUNCTION getlength RETURN NUMBER
	IS
	len number;
	lenadd number;
	BEGIN
		len := nvl(self.length,0);
		for entry in (select * from River_objTab m where self.name = m.river)
		loop
			select nvl(m.getlength(),0) into lenadd from River_ObjTab m where m.name = entry.name;
			len := len + lenadd;
			dbms_output.put_line(entry.name || ' ' || nvl(entry.length,0) || ' ' || len);
		end loop;  
	
		for entry in (select * from Lake_objTab m where self.name = m.river)
		loop
			select nvl(m.getlength(),0) into lenadd from Lake_ObjTab m where m.name = entry.name;
			len := len + lenadd;
			dbms_output.put_line(entry.name || ' ' || 0 || ' ' || len);
		end loop;  
		--select sum(nvl(m.getlength(),0)) into len from River_ObjTab m where self.name = m.river;
		--select sum(nvl(m.getlength(),0)) into len2 from Lake_ObjTab m where self.name = m.river;
		return len;
	END getlength;
END;
/


INSERT INTO Lake_ObjTab
SELECT Lake_type
(l.name,l.area,l.depth,l.elevation,l.river,l.type,Geocoord(l.coordinates.longitude,l.coordinates.latitude))
FROM Lake l;

INSERT INTO River_ObjTab
SELECT River_type
(r.name,r.river,r.lake,r.sea,r.length,r.source,r.mountains,r.sourceelevation,Geocoord(r.estuary.longitude,r.estuary.latitude))
FROM river r;


 -- liste erstellen mit koplettem netzt und dann sum(netz) möglichkeit ... 
