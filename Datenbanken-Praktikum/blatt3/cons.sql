accept tabelle char prompt 'Tabelle: '

DELETE FROM &tabelle;
INSERT INTO &tabelle
(SELECT * FROM kneuman.&tabelle);
