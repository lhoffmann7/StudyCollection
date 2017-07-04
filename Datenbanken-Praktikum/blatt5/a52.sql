--funktioniert. Aufruf muss lauten "SELECT * FROM bundesliga22 b ORDER BY value(b);"
--Es ändert sich, dass Schalke und Stuttgart den Platz tauschen!!!!
CREATE OR REPLACE TYPE Team_Type2 AS OBJECT
 (Name      VARCHAR2(70),
  Ort       VARCHAR2(40),
  Punkte    NUMBER,
  Tore      NUMBER,
  Gegentore NUMBER,
  ORDER MEMBER FUNCTION points2(pkt Team_Type2) RETURN NUMBER
 );
/

CREATE OR REPLACE TYPE BODY Team_Type2
AS
	ORDER MEMBER FUNCTION points2(pkt Team_Type2) RETURN NUMBER
	IS
	BEGIN
		IF (Punkte) > (pkt.Punkte) THEN
			RETURN -1;
		ELSIF (Punkte) < (pkt.Punkte) THEN
			RETURN 1;
		ELSE
			IF (Tore/Gegentore) > (pkt.Tore/pkt.Gegentore) THEN
				RETURN -1;
			ELSIF (Tore/Gegentore) < (pkt.Tore/pkt.Gegentore) THEN
				RETURN 1;
			ELSE
				IF (Tore) > (pkt.Tore) THEN
					RETURN -1;
				ELSIF (Tore) < (pkt.Tore) THEN
					RETURN 1;
				ELSE 
					RETURN 0;
				END IF;
			END IF;
		END IF;
	END points2;
END;
/

CREATE TABLE Bundesliga2 OF Team_type2
 (Name PRIMARY KEY);

INSERT INTO Bundesliga2 VALUES (Team_Type2(
           'Hertha BSC', 'Berlin', 43, 41, 53));
INSERT INTO Bundesliga2 VALUES (Team_Type2(
           'Schalke 04', 'Gelsenkirchen', 52, 38, 32));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'VfL Bochum', 'Bochum', 41, 41, 49));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'Hansa Rostock', 'Rostock', 51, 54, 46));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'Borussia Moenchengladbach', 'Moenchengladbach', 38, 54, 59));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'VfL Wolfsburg', 'Wolfsburg', 39, 38, 54 ));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'Werder Bremen', 'Bremen', 50, 43, 47));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           '1. FC Kaiserslautern', 'Kaiserslautern', 68, 63, 39));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'Karlsruher SC', 'Karlsruhe', 38, 48, 60));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'MSV Duisburg', 'Duisburg', 44, 43, 44));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'Arminia Bielefeld', 'Bielefeld', 32, 43, 56));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'Borussia Dortmund', 'Dortmund', 43, 57, 55));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           '1. FC Koeln', 'Koeln', 36, 49, 64));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           '1860 Muenchen', 'Muenchen', 41, 43, 54));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'Bayern Muenchen', 'Muenchen', 66, 69, 37));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'Bayern Leverkusen', 'Leverkusen', 55, 66, 39));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'Hamburger SV', 'Hamburg', 44, 38, 46));
INSERT INTO Bundesliga2 VALUES(Team_Type2(
           'VfB Stuttgart', 'Stuttgart', 52, 55, 49));
