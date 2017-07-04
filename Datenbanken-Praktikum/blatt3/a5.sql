--Teil 1

--1a) Commit von user2, isMember Tabelle mit allen Ländern die vorher in der EU waren sind jetzt in NATO
--1b) Durch consult ist die Originaltabelle wieder hergestellt und da user2 noch nicht committed hat, EU und NATO richtig angezeigt
--1c) Die vorher gemerkten werden zu EU verändert, 28 rows sollten verändert werden. 


--Teil 2

--1b) Commit von user2 wird nicht überschrieben, alle Länder die in der NATO waren sind jetzt in der EU
--1c) Commit von user1 wird ausgeführt, alle Länder die vorher in der EU waren, sind jetzt in der NATO, wenn user2 select ausführt.
 
--Teil 3

-- Serialisierbarkeit böse

