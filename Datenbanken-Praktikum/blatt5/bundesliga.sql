CREATE OR REPLACE TYPE Team_Type AS OBJECT
 (Name      VARCHAR2(70),
  Ort       VARCHAR2(40),
  Punkte    NUMBER,
  Tore      NUMBER,
  Gegentore NUMBER,
  [TO BE FILLED]
 );
/

CREATE TABLE Bundesliga OF Team_type
 (Name PRIMARY KEY);

INSERT INTO Bundesliga VALUES (Team_Type(
           'Hertha BSC', 'Berlin', 43, 41, 53));
INSERT INTO Bundesliga VALUES (Team_Type(
           'Schalke 04', 'Gelsenkirchen', 52, 38, 32));
INSERT INTO Bundesliga VALUES(Team_Type(
           'VfL Bochum', 'Bochum', 41, 41, 49));
INSERT INTO Bundesliga VALUES(Team_Type(
           'Hansa Rostock', 'Rostock', 51, 54, 46));
INSERT INTO Bundesliga VALUES(Team_Type(
           'Borussia Moenchengladbach', 'Moenchengladbach', 38, 54, 59));
INSERT INTO Bundesliga VALUES(Team_Type(
           'VfL Wolfsburg', 'Wolfsburg', 39, 38, 54 ));
INSERT INTO Bundesliga VALUES(Team_Type(
           'Werder Bremen', 'Bremen', 50, 43, 47));
INSERT INTO Bundesliga VALUES(Team_Type(
           '1. FC Kaiserslautern', 'Kaiserslautern', 68, 63, 39));
INSERT INTO Bundesliga VALUES(Team_Type(
           'Karlsruher SC', 'Karlsruhe', 38, 48, 60));
INSERT INTO Bundesliga VALUES(Team_Type(
           'MSV Duisburg', 'Duisburg', 44, 43, 44));
INSERT INTO Bundesliga VALUES(Team_Type(
           'Arminia Bielefeld', 'Bielefeld', 32, 43, 56));
INSERT INTO Bundesliga VALUES(Team_Type(
           'Borussia Dortmund', 'Dortmund', 43, 57, 55));
INSERT INTO Bundesliga VALUES(Team_Type(
           '1. FC Koeln', 'Koeln', 36, 49, 64));
INSERT INTO Bundesliga VALUES(Team_Type(
           '1860 Muenchen', 'Muenchen', 41, 43, 54));
INSERT INTO Bundesliga VALUES(Team_Type(
           'Bayern Muenchen', 'Muenchen', 66, 69, 37));
INSERT INTO Bundesliga VALUES(Team_Type(
           'Bayern Leverkusen', 'Leverkusen', 55, 66, 39));
INSERT INTO Bundesliga VALUES(Team_Type(
           'Hamburger SV', 'Hamburg', 44, 38, 46));
INSERT INTO Bundesliga VALUES(Team_Type(
           'VfB Stuttgart', 'Stuttgart', 52, 55, 49));
